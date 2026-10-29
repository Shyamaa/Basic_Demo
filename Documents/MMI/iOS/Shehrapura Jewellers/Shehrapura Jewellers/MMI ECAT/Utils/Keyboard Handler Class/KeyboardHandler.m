//
//  KeyboardHandler.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 17/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

// KeyboardHandler.m
#import "KeyboardHandler.h"

@interface KeyboardHandler ()
@property (nonatomic, weak) UIView *view;
@property (nonatomic, assign) CGFloat originalY;
@end

@implementation KeyboardHandler

- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if (self) {
        _view = view;
        _originalY = view.frame.origin.y;
    }
    return self;
}

- (void)startListening {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)stopListening {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    CGRect keyboardFrame = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    UIResponder *firstResponder = [self findFirstResponderInView:self.view];
    if (firstResponder && [firstResponder isKindOfClass:[UITextField class]]) {
        UIView *activeField = (UIView *)firstResponder;
        CGRect fieldFrame = [activeField convertRect:activeField.bounds toView:nil];
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat fieldBottom = CGRectGetMaxY(fieldFrame);
        CGFloat keyboardTop = screenHeight - keyboardFrame.size.height;
        
        if (fieldBottom > keyboardTop) {
            CGFloat offset = fieldBottom - keyboardTop + 10;
            [UIView animateWithDuration:duration animations:^{
                CGRect frame = self.view.frame;
                frame.origin.y = self.originalY - offset;
                self.view.frame = frame;
            }];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = self.originalY;
        self.view.frame = frame;
    }];
}

- (UIResponder *)findFirstResponderInView:(UIView *)view {
    for (UIView *subview in view.subviews) {
        if ([subview isFirstResponder]) {
            return subview;
        }
        UIResponder *responder = [self findFirstResponderInView:subview];
        if (responder) {
            return responder;
        }
    }
    return nil;
}

@end

