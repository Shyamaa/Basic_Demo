//
//  ScreenCaptureProtector.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 07/06/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScreenCaptureProtector.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@interface ScreenCaptureProtector ()
@property (nonatomic, strong) UIVisualEffectView *blurOverlayView;
@property (nonatomic, weak) UIView *protectedView;
@end

@implementation ScreenCaptureProtector

+ (instancetype)sharedProtector {
    static ScreenCaptureProtector *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ScreenCaptureProtector alloc] init];
    });
    return sharedInstance;
}

- (void)startProtectionInView:(UIView *)view {
    self.protectedView = view;
    [self addScreenCaptureObserver];
    [self updateProtectionState];
}

- (void)stopProtection {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.blurOverlayView removeFromSuperview];
    self.blurOverlayView = nil;
    self.protectedView = nil;
}

#pragma mark - Observer

- (void)addScreenCaptureObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(screenCaptureStatusChanged)
                                                 name:UIScreenCapturedDidChangeNotification
                                               object:nil];
}

- (void)screenCaptureStatusChanged {
    [self updateProtectionState];
}

#pragma mark - UI Updates

- (void)updateProtectionState {
    if ([UIScreen mainScreen].isCaptured) {
        [self showBlurOverlay];
    } else {
        [self hideBlurOverlay];
    }
}

- (void)showBlurOverlay {
    if (!self.protectedView || self.blurOverlayView) return;

    // Create blur effect
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurOverlayView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.blurOverlayView.frame = self.protectedView.bounds;
    self.blurOverlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // Optional message
    UILabel *label = [[UILabel alloc] initWithFrame:self.blurOverlayView.bounds];
    label.text = @"📵 Screen recording is not allowed.";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:18];
    label.numberOfLines = 0;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.blurOverlayView.contentView addSubview:label];
    [self.protectedView addSubview:self.blurOverlayView];
}

- (void)hideBlurOverlay {
    [self.blurOverlayView removeFromSuperview];
    self.blurOverlayView = nil;
}

@end
