#import "InputModeSwitchGesture.h"
#import <IOKit/IOKitLib.h>
#import <IOKit/hid/IOHIDManager.h>
#import <IOKit/hid/IOHIDKeys.h>
#import <IOKit/hid/IOHIDUsageTables.h>

// IOHIDRequestAccess / IOHIDCheckAccess are not exported by the public SDK headers.
extern "C" {
int IOHIDCheckAccess(uint32_t requestType);
bool IOHIDRequestAccess(uint32_t requestType);
}

namespace {
const uint32_t kCassotisRequestListen = 1;  // kIOHIDRequestTypeListenEvent
const int kCassotisAccessGranted = 0;       // kIOHIDAccessTypeGranted
const uint32_t kCassotisUsageLeftShift = 0xE1;
const uint32_t kCassotisUsageRightShift = 0xE5;
const uint32_t kCassotisUsageLeftControl = 0xE0;
const uint32_t kCassotisUsageRightControl = 0xE4;
const uint16_t kCassotisVirtualKeyShift = 16;
const uint16_t kCassotisVirtualKeyControl = 17;
const NSTimeInterval kCassotisMaxTapDuration = 0.30;  // one modifier press-to-release

// Opt-in diagnostic log, off by default like the other diagnostics: CASSOTIS_TRACE_GESTURE=1
BOOL CassotisGestureTraceEnabled(void) { return getenv("CASSOTIS_TRACE_GESTURE") != NULL; }
}  // namespace

@interface CassotisInputModeSwitchGesture ()
- (void)handleValue:(IOHIDValueRef)value;
- (void)applyConfiguration;
- (BOOL)isWatchedModifierUsage:(uint32_t)usage;
+ (BOOL)isPointerInterferenceUsagePage:(uint32_t)page usage:(uint32_t)usage;
- (BOOL)openMonitorWithMatching:(NSArray *)matching;
@end

static void CassotisGestureValueCallback(void *context, IOReturn result, void *sender, IOHIDValueRef value) {
    (void)result;
    (void)sender;
    CassotisInputModeSwitchGesture *owner = (__bridge CassotisInputModeSwitchGesture *)context;
    if (!owner) return;
    CFRetain(value);
    dispatch_async(dispatch_get_main_queue(), ^{
        [owner handleValue:value];
        CFRelease(value);
    });
}

@implementation CassotisInputModeSwitchGesture {
    IOHIDManagerRef _manager;
    BOOL _modifierDown;
    CFAbsoluteTime _modifierDownAt;
    BOOL _tapInvalid;          // another key or click broke this press
    uint16_t _modifierKey;     // 16 = Shift, 17 = Ctrl; 0 = unset
    uint16_t _shortcutKey;
    uint8_t _shortcutModifiers;
    BOOL _shortcutDisabled;
    BOOL _shortcutKnown;
}

+ (instancetype)shared {
    static CassotisInputModeSwitchGesture *shared;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ shared = [[self alloc] init]; });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // The initial values force the first applyInputModeShortcutKey: to sync.
        _shortcutKey = 0xFFFF;
        _shortcutModifiers = 0xFF;
        _shortcutDisabled = YES;
    }
    return self;
}

- (void)dealloc { [self uninstallMonitor]; }

+ (BOOL)hasInputMonitoringPermission {
    return IOHIDCheckAccess(kCassotisRequestListen) == kCassotisAccessGranted;
}

+ (void)requestInputMonitoringPermission {
    if (![self hasInputMonitoringPermission]) IOHIDRequestAccess(kCassotisRequestListen);
}

- (BOOL)monitoring { return _manager != NULL; }

- (BOOL)singleTapModifier { return _modifierKey != 0; }

- (uint16_t)singleTapModifierKey { return _modifierKey; }

- (void)applyInputModeShortcutKey:(uint16_t)key modifiers:(uint8_t)modifiers disabled:(BOOL)disabled {
    if (_shortcutKnown && _shortcutKey == key && _shortcutModifiers == modifiers && _shortcutDisabled == disabled)
        return;
    _shortcutKnown = YES;
    _shortcutKey = key;
    _shortcutModifiers = modifiers;
    _shortcutDisabled = disabled;
    // A bare modifier is Shift or Ctrl in this context; the frontend normalizes
    // left and right.
    BOOL bare = !disabled && modifiers == 0 &&
        (key == kCassotisVirtualKeyShift || key == kCassotisVirtualKeyControl);
    _modifierKey = bare ? key : 0;
    if (CassotisGestureTraceEnabled())
        NSLog(@"Cassotis: bare %s switch %s", _modifierKey == kCassotisVirtualKeyShift ? "Shift" : "Ctrl",
            _modifierKey ? "configured" : "unset");
    [self applyConfiguration];
}

- (void)applyConfiguration {
    if (!self.singleTapModifier) { [self uninstallMonitor]; return; }
    if (!self.class.hasInputMonitoringPermission) {
        // A bare Ctrl has no acceptable fallback judgement, so ask for the
        // permission while recording. A bare Shift is the default shortcut and
        // must also work without it, so only upgrade when the permission is
        // already granted and never raise the request from the default setup.
        if (_modifierKey == kCassotisVirtualKeyControl) [self.class requestInputMonitoringPermission];
        return;
    }
    if (_manager) return;
    if (![self installMonitor])
        NSLog(@"Cassotis: bare-modifier mode switch is enabled but the monitor could not open (Input Monitoring permission missing)");
}

- (BOOL)installMonitor {
    if (_manager) return YES;
    if (!self.class.hasInputMonitoringPermission) return NO;
    // Keyboards carry the modifier itself; mouse and pointer devices carry
    // combinations such as Shift+click or Ctrl+wheel. A pointer device that is
    // exclusive or refuses to open must not take the whole monitor down, so fall
    // back to keyboard-only.
    NSArray *withPointer = @[
        @{@kIOHIDDeviceUsagePageKey: @(kHIDPage_GenericDesktop), @kIOHIDDeviceUsageKey: @(kHIDUsage_GD_Keyboard)},
        @{@kIOHIDDeviceUsagePageKey: @(kHIDPage_GenericDesktop), @kIOHIDDeviceUsageKey: @(kHIDUsage_GD_Mouse)},
        @{@kIOHIDDeviceUsagePageKey: @(kHIDPage_GenericDesktop), @kIOHIDDeviceUsageKey: @(kHIDUsage_GD_Pointer)},
    ];
    NSArray *keyboardOnly = @[
        @{@kIOHIDDeviceUsagePageKey: @(kHIDPage_GenericDesktop), @kIOHIDDeviceUsageKey: @(kHIDUsage_GD_Keyboard)},
    ];
    if ([self openMonitorWithMatching:withPointer]) return YES;
    NSLog(@"Cassotis: monitor with pointer devices failed to open; falling back to keyboard only (modifier+click counts as a tap)");
    return [self openMonitorWithMatching:keyboardOnly];
}

- (BOOL)openMonitorWithMatching:(NSArray *)matching {
    IOHIDManagerRef manager = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDOptionsTypeNone);
    if (!manager) return NO;
    IOHIDManagerSetDeviceMatchingMultiple(manager, (__bridge CFArrayRef)matching);
    IOHIDManagerRegisterInputValueCallback(manager, CassotisGestureValueCallback, (__bridge void *)self);
    IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    if (IOHIDManagerOpen(manager, kIOHIDOptionsTypeNone) != kIOReturnSuccess) {
        IOHIDManagerUnscheduleFromRunLoop(manager, CFRunLoopGetMain(), kCFRunLoopCommonModes);
        CFRelease(manager);
        return NO;
    }
    _manager = manager;
    return YES;
}

- (void)uninstallMonitor {
    if (!_manager) return;
    IOHIDManagerUnscheduleFromRunLoop(_manager, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    IOHIDManagerClose(_manager, kIOHIDOptionsTypeNone);
    CFRelease(_manager);
    _manager = NULL;
    _modifierDown = NO;
    _tapInvalid = NO;
}

- (BOOL)isWatchedModifierUsage:(uint32_t)usage {
    if (_modifierKey == kCassotisVirtualKeyShift)
        return usage == kCassotisUsageLeftShift || usage == kCassotisUsageRightShift;
    if (_modifierKey == kCassotisVirtualKeyControl)
        return usage == kCassotisUsageLeftControl || usage == kCassotisUsageRightControl;
    return NO;
}

// A mouse button or wheel combines with the modifier into Shift+click or
// Ctrl+wheel; whenever one arrives while the modifier is held this is no longer
// a bare tap. Only discrete events count: mouse movement (X/Y axes) must not
// invalidate the tap, or an idle device would disable the shortcut for good.
+ (BOOL)isPointerInterferenceUsagePage:(uint32_t)page usage:(uint32_t)usage {
    if (page == kHIDPage_Button) return YES;
    return page == kHIDPage_GenericDesktop && usage == kHIDUsage_GD_Wheel;
}

- (void)handleValue:(IOHIDValueRef)value {
    IOHIDElementRef element = IOHIDValueGetElement(value);
    if (!element) return;
    uint32_t page = IOHIDElementGetUsagePage(element);
    uint32_t usage = IOHIDElementGetUsage(element);
    if (page != kHIDPage_KeyboardOrKeypad) {
        if (_modifierDown && [self.class isPointerInterferenceUsagePage:page usage:usage]) _tapInvalid = YES;
        return;
    }
    BOOL down = IOHIDValueGetIntegerValue(value) != 0;
    BOOL watched = [self isWatchedModifierUsage:usage];

    if (down) {
        if (watched) {
            if (_modifierDown) return;  // duplicate reports for the same key
            _modifierDown = YES;
            _modifierDownAt = CFAbsoluteTimeGetCurrent();
            _tapInvalid = NO;
        } else if (_modifierDown) {
            // Any other key, modifiers included, removes the bare-tap identity of
            // the current press
            _tapInvalid = YES;
        }
        return;
    }

    if (!watched) return;
    if (!_modifierDown) return;
    _modifierDown = NO;
    if (_tapInvalid || CFAbsoluteTimeGetCurrent() - _modifierDownAt > kCassotisMaxTapDuration) return;
    if (CassotisGestureTraceEnabled())
        NSLog(@"Cassotis: single %s tap recognized", _modifierKey == kCassotisVirtualKeyShift ? "Shift" : "Ctrl");
    if (self.tapHandler) self.tapHandler();
}

@end
