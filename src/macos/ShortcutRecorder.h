#pragma once
#import <AppKit/AppKit.h>
#include "EngineClient.hpp"

NSString *CassotisShortcutDescription(const cassotis::Shortcut &shortcut);
// shortcutIndex is the action index of this recorder (0 = Chinese/English switch): a bare Ctrl is accepted only there.
NSString *CassotisShortcutValidationError(const cassotis::Shortcut &shortcut, NSInteger shortcutIndex);

@interface CassotisShortcutRecorder : NSControl
@property(nonatomic) cassotis::Shortcut shortcut;
// Action index (0 = Chinese/English switch); -1 when unset, which accepts no bare Ctrl.
@property(nonatomic) NSInteger shortcutIndex;
@property(nonatomic, readonly) NSString *displayString;
@property(nonatomic, readonly) BOOL recording;
@property(nonatomic, copy) void (^validationMessage)(NSString *message);
- (void)beginRecording;
- (void)cancelRecording;
@end
