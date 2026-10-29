//
//  IARangeSlider.h
//  CustomSlider
//
//  Created by user on 31.12.16.
//  Copyright © 2016 I&N. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IARangeSlider : UIControl
@property (assign, nonatomic) CGFloat minimumValue;
@property (assign, nonatomic) CGFloat maximumValue;
@property (assign, nonatomic) CGFloat lowerValue;
@property (assign, nonatomic) CGFloat upperValue;

@property (assign, nonatomic) CGFloat curvaceousness;
@property (strong, nonatomic) UIColor* trackTintColor;
@property (strong, nonatomic) UIColor* trackHighlightTintColor;
@property (strong, nonatomic) UIColor* thumbTintColor;
@property (strong, nonatomic) UIColor* thumbHighlightedTintColor;

-(CGFloat)positionForValue:(CGFloat)value;

@end
