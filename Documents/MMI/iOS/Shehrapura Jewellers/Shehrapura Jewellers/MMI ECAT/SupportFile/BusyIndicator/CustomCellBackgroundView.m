#import "CustomCellBackgroundView.h"

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight);

@implementation CustomCellBackgroundView

@synthesize fillColor, borderColor;

- (BOOL)isOpaque {
    return NO;
}

- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)theBackColor borderColor:(UIColor *)theBorderColor {
    if (self = [super initWithFrame:frame]) {
        self.fillColor = theBackColor;
        self.borderColor = theBorderColor;
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    // Set the fill and stroke color
    CGContextSetFillColorWithColor(c, self.fillColor.CGColor);
    CGContextSetStrokeColorWithColor(c, self.borderColor.CGColor);
    
    // Create rounded rectangle path
    CGContextBeginPath(c);
    addRoundedRectToPath(c, rect, 10.0f, 10.0f);  // Use a fixed corner radius of 10.0f
    
    // Fill the path with the fill color
    CGContextFillPath(c);
    
    // Set stroke line width before stroking the path
    CGContextSetLineWidth(c, 1);
    
    // Stroke the path
    CGContextBeginPath(c);
    addRoundedRectToPath(c, rect, 10.0f, 10.0f);
    CGContextStrokePath(c);
}

@end

// This function adds a rounded rectangle path to the CGContext.
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight) {
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context); // Save the current graphics state
    
    // Translate and scale context for oval corner radii
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    
    float fw = CGRectGetWidth(rect) / ovalWidth; // Calculate scaling factor for width
    float fh = CGRectGetHeight(rect) / ovalHeight; // Calculate scaling factor for height
    
    // Move to starting point
    CGContextMoveToPoint(context, fw, fh / 2);
    
    // Add the rounded corners
    CGContextAddArcToPoint(context, fw, fh, fw / 2, fh, 1); // top-right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh / 2, 1); // bottom-right corner
    CGContextAddArcToPoint(context, 0, 0, fw / 2, 0, 1); // bottom-left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh / 2, 1); // top-left corner
    
    CGContextClosePath(context); // Close the path
    
    CGContextRestoreGState(context); // Restore the graphics state
}
