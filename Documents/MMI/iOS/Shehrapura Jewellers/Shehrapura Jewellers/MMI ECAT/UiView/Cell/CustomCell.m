//
//  CustomCell.m
//  Jewel Desk
//
//  Created by App Dev on 18/09/24.
//  Copyright © 2024 MMI Softwares. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.imgeDataArray = [[UIImageView alloc] init];
    self.lblTitle = [[UILabel alloc] init];
    
    [self.contentView addSubview:self.imgeDataArray];
    [self.contentView addSubview:self.lblTitle];
    
    // Disable autoresizing mask translation into constraints
    self.imgeDataArray.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.imgeDataArray.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8],
        [self.imgeDataArray.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8],
        [self.imgeDataArray.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8],
        [self.imgeDataArray.heightAnchor constraintEqualToConstant:120],
        
        [self.lblTitle.topAnchor constraintEqualToAnchor:self.imgeDataArray.bottomAnchor constant:8],
        [self.lblTitle.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8],
        [self.lblTitle.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8],
        [self.lblTitle.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8]
    ]];
    
    // Customize appearance
    self.imgeDataArray.contentMode = UIViewContentModeScaleAspectFill;
    self.imgeDataArray.clipsToBounds = YES;
    self.lblTitle.textAlignment = NSTextAlignmentCenter;
    self.lblTitle.numberOfLines = 0; // Allows multiple lines if needed
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(0, 2);
    self.contentView.layer.shadowRadius = 4;
    self.contentView.layer.shadowOpacity = 0.2;
}

@end
