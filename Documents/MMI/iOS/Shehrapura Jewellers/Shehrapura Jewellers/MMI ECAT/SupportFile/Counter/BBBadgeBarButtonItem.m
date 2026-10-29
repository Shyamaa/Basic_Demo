//
//  BBBadgeBarButtonItem.m
//
//  Created by Tanguy Aladenise on 07/02/14.
//  Copyright (c) 2014 Riverie, Inc. All rights reserved.
//

#import "BBBadgeBarButtonItem.h"

@interface BBBadgeBarButtonItem()

// Dedicated background bubble to avoid clipping on newer navigation bars.
@property (nonatomic) UIView *badgeBackgroundView;
// Text displayed inside the badge bubble.
@property (nonatomic) UILabel *badgeLabel;

@end

@implementation BBBadgeBarButtonItem


#pragma mark - Init methods

- (BBBadgeBarButtonItem *)initWithCustomUIButton:(UIButton *)customButton
{
    self = [self initWithCustomView:customButton];
    if (self) {
        [self initializer];
    }

    return self;
}

- (void)initializer
{
    // Default design initialization
    self.badgeBGColor   = [UIColor redColor];
    self.badgeTextColor = [UIColor whiteColor];
    self.badgeFont      = [UIFont systemFontOfSize:12.0];
    self.badgePadding   = 5;
    self.badgeMinSize   = 18;
    self.badgeOriginX   = 2;
    self.badgeOriginY   = 0;
    self.shouldHideBadgeAtZero = YES;
    self.shouldAnimateBadge = YES;
    // Avoids badge to be clipped when animating its scale
    dispatch_async(dispatch_get_main_queue(), ^{
        self.customView.clipsToBounds = NO;
        self.customView.layer.masksToBounds = NO;
    });
}

#pragma mark - Utility methods

// Handle badge display when its properties have been changed (color, font, ...)
- (void)refreshBadge
{
    // Change new attributes
    self.badgeLabel.textColor = self.badgeTextColor;
    self.badgeLabel.font = self.badgeFont;
    self.badgeBackgroundView.backgroundColor = self.badgeBGColor;
}

- (void)updateBadgeFrame
{
    // When the value changes the badge could need to get bigger
    // Calculate expected size to fit new value
    // Use an intermediate label to get expected size thanks to sizeToFit
    // We don't call sizeToFit on the true label to avoid bad display
    UILabel *frameLabel = [self duplicateLabel:self.badgeLabel];
    [frameLabel sizeToFit];

    CGSize expectedLabelSize = frameLabel.frame.size;

    // Make sure that for small value, the badge will be big enough
    CGFloat minHeight = MAX(expectedLabelSize.height, self.badgeMinSize);
    CGFloat minWidth = MAX(expectedLabelSize.width, minHeight);
    CGFloat horizontalPadding = self.badgePadding;
    CGFloat verticalPadding = MAX(3.0, floor(self.badgePadding * 0.6));
    CGFloat badgeHeight = minHeight + verticalPadding;
    CGFloat badgeWidth = minWidth + horizontalPadding;

    self.badgeBackgroundView.frame = CGRectMake(self.badgeOriginX, self.badgeOriginY, badgeWidth, badgeHeight);
    self.badgeBackgroundView.layer.cornerRadius = badgeHeight / 2.0;
    self.badgeBackgroundView.layer.masksToBounds = YES;
    self.badgeLabel.frame = CGRectInset(self.badgeBackgroundView.bounds, horizontalPadding / 2.0, verticalPadding / 2.0);
}

// Handle the badge changing value
- (void)updateBadgeValueAnimated:(BOOL)animated
{
    // Bounce animation on badge if value changed and if animation authorized
    if (animated && self.shouldAnimateBadge && ![self.badgeLabel.text isEqualToString:self.badgeValue]) {
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [animation setFromValue:[NSNumber numberWithFloat:1.5]];
        [animation setToValue:[NSNumber numberWithFloat:1]];
        [animation setDuration:0.2];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.4 :1.3 :1 :1]];
        [self.badgeBackgroundView.layer addAnimation:animation forKey:@"bounceAnimation"];
    }

    // Set the new value
    self.badgeLabel.text = self.badgeValue;

    // Animate the size modification if needed
    //NSTimeInterval duration = animated ? 0.2 : 0;
    //[UIView animateWithDuration:duration animations:^{
        [self updateBadgeFrame];
    //}]; // this animation breaks the rounded corners in iOS 9
}

- (UILabel *)duplicateLabel:(UILabel *)labelToCopy
{
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:labelToCopy.frame];
    duplicateLabel.text = labelToCopy.text;
    duplicateLabel.font = labelToCopy.font;

    return duplicateLabel;
}

- (void)removeBadge
{
    if (!self.badgeBackgroundView) {
        return;
    }

    // Animate badge removal
    [UIView animateWithDuration:0.2 animations:^{
        self.badgeBackgroundView.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [self.badgeBackgroundView removeFromSuperview];
        self.badgeBackgroundView = nil;
        self.badgeLabel = nil;
    }];
}

#pragma mark - Setters

- (void)setBadgeValue:(NSString *)badgeValue
{
    // Set new value
    _badgeValue = badgeValue;

    // When changing the badge value check if we need to remove the badge
    if (!badgeValue || [badgeValue isEqualToString:@""] || ([badgeValue isEqualToString:@"0"] && self.shouldHideBadgeAtZero)) {
        [self removeBadge];
    } else if (!self.badgeBackgroundView) {
        // Create a new badge because not existing
        dispatch_async(dispatch_get_main_queue(), ^{
            self.customView.clipsToBounds = NO;
            self.customView.layer.masksToBounds = NO;

            self.badgeBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(self.badgeOriginX, self.badgeOriginY, self.badgeMinSize, self.badgeMinSize)];
            self.badgeBackgroundView.userInteractionEnabled = NO;

            self.badgeLabel = [[UILabel alloc] initWithFrame:self.badgeBackgroundView.bounds];
            self.badgeLabel.textAlignment = NSTextAlignmentCenter;
            self.badgeLabel.adjustsFontSizeToFitWidth = YES;
            self.badgeLabel.minimumScaleFactor = 0.7;

            [self.badgeBackgroundView addSubview:self.badgeLabel];
            [self.customView addSubview:self.badgeBackgroundView];
            [self refreshBadge];
            [self updateBadgeValueAnimated:NO];
        });
    } else {
        [self updateBadgeValueAnimated:YES];
    }
}

- (void)setBadgeBGColor:(UIColor *)badgeBGColor
{
    _badgeBGColor = badgeBGColor;

    if (self.badgeBackgroundView) {
        [self refreshBadge];
    }
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    _badgeTextColor = badgeTextColor;

    if (self.badgeBackgroundView) {
        [self refreshBadge];
    }
}

- (void)setBadgeFont:(UIFont *)badgeFont
{
    _badgeFont = badgeFont;

    if (self.badgeBackgroundView) {
        [self refreshBadge];
    }
}

- (void)setBadgePadding:(CGFloat)badgePadding
{
    _badgePadding = badgePadding;

    if (self.badgeBackgroundView) {
        [self updateBadgeFrame];
    }
}

- (void)setBadgeMinSize:(CGFloat)badgeMinSize
{
    _badgeMinSize = badgeMinSize;

    if (self.badgeBackgroundView) {
        [self updateBadgeFrame];
    }
}

- (void)setBadgeOriginX:(CGFloat)badgeOriginX
{
    _badgeOriginX = badgeOriginX;

    if (self.badgeBackgroundView) {
        [self updateBadgeFrame];
    }
}

- (void)setBadgeOriginY:(CGFloat)badgeOriginY
{
    _badgeOriginY = badgeOriginY;

    if (self.badgeBackgroundView) {
        [self updateBadgeFrame];
    }
}

@end
