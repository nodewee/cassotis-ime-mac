#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Single-tap judgement for the Chinese/English switch, supporting a bare Shift
// and a bare Ctrl.
//
// Why not CapsLock: macOS flips the uppercase lock state on every press and a
// third-party input method has no public API to prevent or reliably undo it, so
// it cannot offer "switch modes without touching the lock state".
//
// Why the raw HID layer: the signal comes from IOHIDManager (Shift 0xE1/0xE5,
// Ctrl 0xE0/0xE4), which sees every physical key. A tap is therefore rejected
// whenever another key is pressed in between, even a key the frontmost
// application swallows, so Shift+Enter or Ctrl+C can never be mistaken for a
// single tap. Mouse buttons and wheels count as "something else was pressed"
// the same way, so Shift+click (extend selection) and Ctrl+click (secondary
// click) are excluded too. Requires the Input Monitoring permission.
//
// Judgement: one modifier press-to-release (<= 0.30s) with no other key and no
// mouse button or wheel in between.
//
// The only trigger is recording the Chinese/English action as a bare Shift or
// Ctrl in the shortcut settings; there is no separate switch.
@interface CassotisInputModeSwitchGesture : NSObject

+ (instancetype)shared;

// Mirror the Chinese/English shortcut configuration; install the monitor when it
// is a bare Shift or Ctrl and uninstall it otherwise. Only recomputes when the
// configuration changes, so it is safe to call after every key event.
- (void)applyInputModeShortcutKey:(uint16_t)key modifiers:(uint8_t)modifiers disabled:(BOOL)disabled;

// Called on a successful tap (main thread).
@property(nonatomic, copy, nullable) void (^tapHandler)(void);

// Whether the Chinese/English action is a bare modifier (needs the monitor and
// the Input Monitoring permission).
@property(nonatomic, readonly) BOOL singleTapModifier;

// Virtual key code of that modifier: 16 = Shift, 17 = Ctrl; 0 when unset.
@property(nonatomic, readonly) uint16_t singleTapModifierKey;

// Whether the monitor is installed. A bare Shift still falls back to the event
// stream without permission; callers use this to decide whether to yield.
@property(nonatomic, readonly) BOOL monitoring;

+ (BOOL)hasInputMonitoringPermission;
+ (void)requestInputMonitoringPermission;

@end

NS_ASSUME_NONNULL_END
