//
//  ButtonTabBar.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 11/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabButton : UIButton

@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIColor *normalTextColor;

- (void)setSelected:(BOOL)selected;

@end
