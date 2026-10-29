//
//  TabButton.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 11/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "TabButton.h"

@implementation TabButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (void)setupDefaults {
    self.spacing = 5.0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;

    self.normalTextColor = [UIColor grayColor];
    self.selectedTextColor = [UIColor blueColor];

    [self setTitleColor:self.normalTextColor forState:UIControlStateNormal];
    [self setTitleColor:self.selectedTextColor forState:UIControlStateSelected];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat imageHeight = self.imageView.image ? self.imageView.image.size.height : 0;
    CGFloat labelHeight = self.titleLabel.intrinsicContentSize.height;
    CGFloat totalHeight = imageHeight + (self.spacing * 3) + labelHeight;

    CGFloat imageOffsetY = self.spacing;//-(totalHeight - (imageHeight + labelHeight));
    CGFloat titleOffsetY = self.spacing;

    self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, 0, 0, -self.titleLabel.intrinsicContentSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(titleOffsetY + imageHeight, -self.imageView.image.size.width, 0, 0);
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];

    UIColor *titleColor = selected ? self.selectedTextColor : self.normalTextColor;
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

@end
