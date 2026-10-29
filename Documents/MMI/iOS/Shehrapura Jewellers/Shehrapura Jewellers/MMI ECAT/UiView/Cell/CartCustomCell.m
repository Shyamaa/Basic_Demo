//
//  CartCustomCell.m
//  Jewel Desk
//
//  Created by App Dev on 18/09/24.
//  Copyright © 2024 MMI Softwares. All rights reserved.
//

#import "CartCustomCell.h"

@implementation CartCustomCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCardView];
        [self setupViewsInsideCardView];
    }
    return self;
}

- (void)setupCardView {
    UIView *cardView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    cardView.backgroundColor = [UIColor whiteColor];
    
    cardView.layer.cornerRadius = 10.0f;
    cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    cardView.layer.shadowOpacity = 0.2f;
    cardView.layer.shadowOffset = CGSizeMake(0, 2);
    cardView.layer.shadowRadius = 4.0f;
    
    cardView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cardView.layer.borderWidth = 0.5f;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:cardView.bounds cornerRadius:cardView.layer.cornerRadius];
    cardView.layer.shadowPath = shadowPath.CGPath;
    
    [self.contentView addSubview:cardView];
}

- (void)setupViewsInsideCardView {
    
    // Add image to the card
    self.imgeDataArray = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.contentView.frame.size.width - 20, 100)];
    self.imgeDataArray.contentMode = UIViewContentModeScaleAspectFit;
    self.imgeDataArray.clipsToBounds = YES;
    [self.contentView addSubview:self.imgeDataArray];
    
    // Add title label to the card
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, self.contentView.frame.size.width - 20, 20)];
    self.lblTitle.font = [UIFont systemFontOfSize:14];
    self.lblTitle.textColor = [UIColor blackColor];
    self.lblTitle.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.lblTitle];
    
    self.checkboxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkboxButton.frame = CGRectMake(10, 150, 30, 30);
    [self.checkboxButton setImage:[UIImage imageNamed:@"uncheckcircle.png"] forState:UIControlStateNormal];
    [self.checkboxButton setImage:[UIImage imageNamed:@"checkcircle.png"] forState:UIControlStateSelected];
    [self.checkboxButton addTarget:self action:@selector(toggleCheckbox:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.checkboxButton];
    
    // Add "Add to Cart" button with image
    self.btn_addcart = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn_addcart.frame = CGRectMake(10, 150, self.contentView.frame.size.width - 20, 30);
    [self.btn_addcart setImage:[UIImage imageNamed:@"addtocart.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btn_addcart];
    
    // Add counter label to the card
    self.lbl_counter = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 50, 150, 30, 30)];
    self.lbl_counter.font = [UIFont boldSystemFontOfSize:12];
    self.lbl_counter.textColor = [UIColor whiteColor];
    self.lbl_counter.backgroundColor = [UIColor redColor];
    self.lbl_counter.textAlignment = NSTextAlignmentCenter;
    self.lbl_counter.layer.cornerRadius = 15;
    self.lbl_counter.clipsToBounds = YES;
    [self.contentView addSubview:self.lbl_counter];
}

- (void)toggleCheckbox:(UIButton *)sender {
    // Toggle checkbox state
    sender.selected = !sender.selected;
}

@end
