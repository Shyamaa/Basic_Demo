//
//  IARangeSliderThumbLayer.m
//  CustomSlider
//
//  Created by user on 31.12.16.
//  Copyright © 2016 I&N. All rights reserved.
//

#import "IARangeSliderThumbLayer.h"
#import "IARangeSlider.h"
@implementation IARangeSliderThumbLayer

-(void)drawInContext:(CGContextRef)ctx{
    IARangeSlider* slider = self.rangeSlider;
    
    if (slider) {
        CGRect thumbFrame = CGRectInset(self.bounds, 2.0, 2.0);
        CGFloat cornerRadius = thumbFrame.size.height * slider.curvaceousness / 2.0;
        UIBezierPath* thumbPath = [UIBezierPath bezierPathWithRoundedRect:thumbFrame cornerRadius:cornerRadius];
        
        // Fill - with a subtle shadow
        UIColor* shadowColor = [UIColor grayColor];
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 1.0, shadowColor.CGColor);
        CGContextSetFillColorWithColor(ctx, slider.thumbTintColor.CGColor);
        CGContextAddPath(ctx, thumbPath.CGPath);
        CGContextFillPath(ctx);
        
        // Outline
        CGContextSetStrokeColorWithColor(ctx, shadowColor.CGColor);
        CGContextSetLineWidth(ctx, 0.5);
        CGContextAddPath(ctx, thumbPath.CGPath);
        CGContextStrokePath(ctx);
        
        if (self.highlighted) {
            CGContextSetFillColorWithColor(ctx, self.rangeSlider.thumbHighlightedTintColor.CGColor);
            CGContextAddPath(ctx, thumbPath.CGPath);
            CGContextFillPath(ctx);
        }

 
    }
}

-(void)setHighlighted:(BOOL)highlighted{
    _highlighted = highlighted;
    [self setNeedsDisplay];
}



@end
