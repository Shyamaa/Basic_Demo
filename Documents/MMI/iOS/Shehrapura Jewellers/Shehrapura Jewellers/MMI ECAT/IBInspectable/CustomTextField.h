//
//  CustomTextField.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 02/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CustomTextField : UITextField

// Custom properties with IBInspectable
@property (nonatomic, assign) IBInspectable CGFloat leftPadding;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;
@property (nonatomic, strong) IBInspectable UIImage *rightImage; 
@property (nonatomic, copy) IBInspectable NSString *rightButtonAction;
@property (nonatomic, strong) IBInspectable UIColor *lineColor;
@property (nonatomic, assign) IBInspectable CGFloat lineHeight;

@end
