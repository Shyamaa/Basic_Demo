//
//  IARangeSliderTrackLayer.m
//  CustomSlider
//
//  Created by user on 31.12.16.
//  Copyright © 2016 I&N. All rights reserved.
//

#import "IARangeSliderTrackLayer.h"
#import "IARangeSlider.h"
@implementation IARangeSliderTrackLayer



-(void)drawInContext:(CGContextRef)ctx{
 
    if (self.rangeSlider) {
        CGFloat cornerRadius = self.bounds.size.height*self.rangeSlider.curvaceousness/2.0;
        UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                        cornerRadius:cornerRadius];
     //   CGContextAddPath(ctx, path.CGPath);
        
        CGContextSetFillColorWithColor(ctx, self.rangeSlider.trackTintColor.CGColor);
        CGContextAddPath(ctx, path.CGPath);
        CGContextFillPath(ctx);
        
        
        CGContextSetFillColorWithColor(ctx, self.rangeSlider.trackHighlightTintColor.CGColor);
        CGFloat lowerValuePosition = [self.rangeSlider positionForValue:self.rangeSlider.lowerValue];
        CGFloat upperValuePosition = [self.rangeSlider positionForValue:self.rangeSlider.upperValue];
        
        CGRect rect =CGRectMake(lowerValuePosition, 0, upperValuePosition - lowerValuePosition, self.bounds.size.height);

        CGContextFillRect(ctx, rect);
    }
    

    
}

@end
