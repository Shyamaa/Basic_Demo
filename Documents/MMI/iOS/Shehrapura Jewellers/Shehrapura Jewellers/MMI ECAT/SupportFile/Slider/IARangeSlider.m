//
//  IARangeSlider.m
//  CustomSlider
//
//  Created by user on 31.12.16.
//  Copyright © 2016 I&N. All rights reserved.
//

#import "IARangeSlider.h"
#import <QuartzCore/QuartzCore.h>
#import "IARangeSliderThumbLayer.h"
#import "IARangeSliderTrackLayer.h"

@interface IARangeSlider ()
@property (strong, nonatomic) IARangeSliderTrackLayer* trackLayer;
@property (strong, nonatomic) IARangeSliderThumbLayer* lowerThumbLayer;
@property (strong, nonatomic) IARangeSliderThumbLayer* upperThumbLayer;
@property (assign, nonatomic) CGFloat thumbWidth;

@property (assign, nonatomic) CGPoint previousPoint;
@end



@implementation IARangeSlider

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeComponents];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeComponents];
    }
    return self;
}


-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self updateLayerFrames];
}


-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    self.previousPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.lowerThumbLayer.frame, self.previousPoint)){
        self.lowerThumbLayer.highlighted = YES;
    }else if (CGRectContainsPoint(self.upperThumbLayer.frame, self.previousPoint)){
        self.upperThumbLayer.highlighted = YES;
    }
    
    return self.lowerThumbLayer.highlighted || self.upperThumbLayer.highlighted;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:self];
    
    CGFloat delta = location.x - self.previousPoint.x;

    CGFloat deltaValue = (self.maximumValue-self.minimumValue)*delta/(self.bounds.size.width-self.thumbWidth);
    self.previousPoint = location;

    if (self.lowerThumbLayer.highlighted) {
            self.lowerValue += deltaValue;
        self.lowerValue = [self boundValue:self.lowerValue toLowerValue:self.minimumValue upperValue:self.upperValue];
    }else if (self.upperThumbLayer.highlighted){
        self.upperValue += deltaValue;
        self.upperValue = [self boundValue:self.upperValue toLowerValue:self.lowerValue upperValue:self.maximumValue];
    }
    
    
    [self updateLayerFrames];

    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return true;
}

-(void)setLowerValue:(CGFloat)lowerValue{
    _lowerValue = lowerValue;
    [self updateLayerFrames];
}

-(void)setUpperValue:(CGFloat)upperValue{
    _upperValue = upperValue;
    [self updateLayerFrames];
}

-(void)setMinimumValue:(CGFloat)minimumValue{
    _minimumValue = minimumValue;
    [self updateLayerFrames];
}

-(void)setMaximumValue:(CGFloat)maximumValue{
    _maximumValue = maximumValue;
    [self updateLayerFrames];
}

-(void)setThumbTintColor:(UIColor *)thumbTintColor{
    _thumbTintColor = thumbTintColor;
    [self.lowerThumbLayer setNeedsDisplay];
    [self.upperThumbLayer setNeedsDisplay];
}

-(void)setTrackTintColor:(UIColor *)trackTintColor{
    _trackTintColor = trackTintColor;
    [self.trackLayer setNeedsDisplay];
}

-(void)setTrackHighlightTintColor:(UIColor *)trackHighlightTintColor{
    _trackHighlightTintColor = trackHighlightTintColor;
    [self.trackLayer setNeedsDisplay];
}

-(void)setCurvaceousness:(CGFloat)curvaceousness{
    _curvaceousness = curvaceousness;
    [self.lowerThumbLayer setNeedsDisplay];
    [self.upperThumbLayer setNeedsDisplay];
    [self.trackLayer setNeedsDisplay];
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    self.upperThumbLayer.highlighted = false;
    self.lowerThumbLayer.highlighted = false;
}

-(void)updateLayerFrames{
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    [self.trackLayer setFrame:CGRectInset(self.bounds, 0, self.bounds.size.height/3)];
    [self.trackLayer setNeedsDisplay];
    
    CGFloat lowerThumbCenter = [self positionForValue:self.lowerValue];
    
    [self.lowerThumbLayer setFrame:CGRectMake(lowerThumbCenter-self.thumbWidth/2.f, 0,
                                              self.thumbWidth
                                              , self.thumbWidth)];
    [self.lowerThumbLayer setNeedsDisplay];
    
    CGFloat upperThumbCenter = [self positionForValue:self.upperValue];
    
    [self.upperThumbLayer setFrame:CGRectMake(upperThumbCenter-self.thumbWidth/2.f, 0,
                                              self.thumbWidth
                                              , self.thumbWidth)];
    [self.upperThumbLayer setNeedsDisplay];
    
    [CATransaction commit];
}

-(void)initializeComponents{
    self.minimumValue = 0;
    self.maximumValue = 1;
    self.upperValue = 0.8;
    self.lowerValue = 0.2;
    
    
    self.trackLayer = [IARangeSliderTrackLayer layer];
    self.lowerThumbLayer = [IARangeSliderThumbLayer layer];
    self.upperThumbLayer = [IARangeSliderThumbLayer layer];
    
    self.trackLayer.contentsScale = [UIScreen mainScreen].scale;
    self.lowerThumbLayer.contentsScale = [UIScreen mainScreen].scale;
    self.upperThumbLayer.contentsScale = [UIScreen mainScreen].scale;
    
    self.lowerThumbLayer.rangeSlider = self;
    self.upperThumbLayer.rangeSlider = self;
    self.trackLayer.rangeSlider = self;
    
    //self.trackTintColor = [UIColor colorWithWhite:0.9 alpha:1];
    //self.trackHighlightTintColor = [UIColor colorWithRed:0.0 green:0.45 blue:0.94 alpha:1.0];
    self.thumbTintColor = [UIColor whiteColor];
    self.thumbHighlightedTintColor = [UIColor blackColor];
    
    self.trackTintColor = [UIColor lightGrayColor];
    self.trackHighlightTintColor = [UIColor colorNamed:@"appRed_Color"];
    
    self.curvaceousness = 1.0;
    
    
    [self.layer addSublayer:_trackLayer];
    [self.layer addSublayer:_lowerThumbLayer];
    [self.layer addSublayer:_upperThumbLayer];
    
    [self updateLayerFrames];

}


-(CGFloat)boundValue:(CGFloat)value toLowerValue:(CGFloat)lowerValue upperValue:(CGFloat)upperVlaue{
    
    return MIN(MAX(value, lowerValue), upperVlaue);
}

-(CGFloat)positionForValue:(CGFloat)value{
    return (self.bounds.size.width - self.thumbWidth) * (value - self.minimumValue) /
    (self.maximumValue - self.minimumValue) + self.thumbWidth / 2.0;
}

-(CGFloat)thumbWidth{
    return self.bounds.size.height;
}

@end
