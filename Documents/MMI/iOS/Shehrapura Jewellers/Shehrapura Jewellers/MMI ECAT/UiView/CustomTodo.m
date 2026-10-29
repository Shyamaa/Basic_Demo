//
//  CustomTodo.m
//  Jewel Desk
//
//  Created by App Dev on 18/11/23.
//  Copyright © 2023 MMI Softwares. All rights reserved.
//

#import "CustomTodo.h"


@interface CustomTodo()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation CustomTodo

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        // Customize the appearance of your alert view (e.g., background color, corner radius, etc.)
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        self.layer.cornerRadius = 8.0;
        self.clipsToBounds = YES;
        CGFloat centerX = CGRectGetWidth(self.bounds) / 2.0;
        CGFloat centerY = CGRectGetHeight(self.bounds) / 2.0;
            
        
        // Create and configure labels for title and message
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 200, 40)];
        self.titleLabel.text = title;
        // Customize titleLabel's appearance
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 200, 40)];
        self.messageLabel.text = message;
        // Customize messageLabel's appearance
        
        // Create and configure the cancel button
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        // Customize cancelButton's appearance
        
        // Add subviews to the alert view
        [self addSubview:self.titleLabel];
        [self addSubview:self.messageLabel];
        [self addSubview:self.cancelButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // Set frames for titleLabel, messageLabel, and cancelButton within the alert view
    // Use CGRects and positioning to place them within the view
    
    // Example:
    CGFloat padding = 20.0;
    self.titleLabel.frame = CGRectMake(padding, 20, CGRectGetWidth(self.bounds) - 2 * padding, 30);
    self.messageLabel.frame = CGRectMake(padding, CGRectGetMaxY(self.titleLabel.frame) + 10, CGRectGetWidth(self.bounds) - 2 * padding, 60);
    self.cancelButton.frame = CGRectMake(padding, CGRectGetMaxY(self.messageLabel.frame) + 20, CGRectGetWidth(self.bounds) - 2 * padding, 40);
}

- (void)show {
    // Show the alert view by adding it to the current window or view controller's view
//    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//    [keyWindow addSubview:self];
    
    UIWindow *targetWindow = nil;
    if (@available(iOS 13.0, *)) {
        // Get the window scene and use its window
        for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                UIWindow *window = windowScene.windows.firstObject;
                if (window) {
                    targetWindow = window;
                    break;
                }
            }
        }
    } else {
        // Use the key window for older iOS versions
        targetWindow = [UIApplication sharedApplication].keyWindow;
    }
    
    if (targetWindow) {
        [targetWindow addSubview:self];
    }
}

- (void)dismiss {
    // Dismiss the alert view by removing it from the superview
    [self removeFromSuperview];
}

- (void)cancelButtonTapped {
    // Handle cancel button tap action
    [self dismiss];
    // You can perform any other action related to cancel button tap here
}

@end
