//
//  CustomTextField.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 02/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField{
    CALayer *bottomLine;
}

// Override the method to adjust the text rect (text area) with padding
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect inset = [super textRectForBounds:bounds];
    inset.origin.x += self.leftPadding;  // Apply left padding
    return inset;
}

// Override the method for editing rect (when text is being edited) with padding
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect inset = [super editingRectForBounds:bounds];
    inset.origin.x += self.leftPadding;  // Apply left padding
    return inset;
}

// Override the method to apply the placeholder rect with padding
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect inset = [super placeholderRectForBounds:bounds];
    inset.origin.x += self.leftPadding;  // Apply left padding
    return inset;
}


#pragma mark - IBInspectable Properties

// Setter for lineColor to update the bottom line color
- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self updateBottomLine];
}

// Setter for lineHeight to update the thickness of the bottom line
- (void)setLineHeight:(CGFloat)lineHeight {
    _lineHeight = lineHeight;
    [self updateBottomLine];
}

#pragma mark - Initialization

// Default initialization method
- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

// Initialization with frame
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

// Awaken from Nib
- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

// Prepare for Interface Builder rendering
- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    [self commonInit];
}

// Common initialization to set default values
- (void)commonInit {
    // Default bottom line color and height
    self.lineColor = [UIColor blackColor]; // Default to black
    self.lineHeight = 1.0;                 // Default to 1px height
    [self updateBottomLine];
}

#pragma mark - Update Bottom Line

// Updates or redraws the bottom line based on current properties
- (void)updateBottomLine {
    // Remove any existing bottom line if it exists
    [bottomLine removeFromSuperlayer];
    
    // Create a new CALayer for the bottom line
    bottomLine = [CALayer layer];
    
    // Set the frame of the bottom line to span the width of the text field
    bottomLine.frame = CGRectMake(0, self.frame.size.height - self.lineHeight, self.frame.size.width, self.lineHeight);
    
    // Set the background color of the bottom line
    bottomLine.backgroundColor = self.lineColor.CGColor;
    
    // Add the bottom line as a sublayer to the text field's layer
    [self.layer addSublayer:bottomLine];
}

#pragma mark - Layout


// Override layoutSubviews to apply custom placeholder color using NSAttributedString
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Apply the placeholder color using NSAttributedString
    if (self.placeholderColor) {
        // Set placeholder color by creating an attributed string
        NSDictionary *attributes = @{NSForegroundColorAttributeName: self.placeholderColor};
        NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder ?: @"" attributes:attributes];
        self.attributedPlaceholder = attributedPlaceholder;
    }
    [self updateBottomLine];
}

@end


//Custome TextField with Right image
/*
#import "CustomTextField.h"

@implementation CustomTextField

// Override the method to adjust the text rect (text area) with padding
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect inset = [super textRectForBounds:bounds];
    inset.origin.x += self.leftPadding;  // Apply left padding
    return inset;
}

// Override the method for editing rect (when text is being edited) with padding
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect inset = [super editingRectForBounds:bounds];
    inset.origin.x += self.leftPadding;  // Apply left padding
    return inset;
}

// Override the method to apply the placeholder rect with padding
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect inset = [super placeholderRectForBounds:bounds];
    inset.origin.x += self.leftPadding;  // Apply left padding
    return inset;
}

// Override layoutSubviews to apply custom placeholder color using NSAttributedString
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Apply the placeholder color using NSAttributedString
    if (self.placeholderColor) {
        // Set placeholder color by creating an attributed string
        NSDictionary *attributes = @{NSForegroundColorAttributeName: self.placeholderColor};
        NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder ?: @"" attributes:attributes];
        self.attributedPlaceholder = attributedPlaceholder;
    }
    
    // Add the right image as a clickable button
    if (self.rightImage) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setImage:self.rightImage forState:UIControlStateNormal];
        rightButton.frame = CGRectMake(0, 0, 24, 24);  // Adjust size as needed
        [rightButton addTarget:self action:@selector(rightButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        self.rightView = rightButton;
        self.rightViewMode = UITextFieldViewModeAlways;
    } else {
        self.rightView = nil;  // Remove the right view if no image is set
    }
}

// Action handler for the right button
- (void)rightButtonTapped:(UIButton *)sender {
    if (self.rightButtonAction) {
        SEL selector = NSSelectorFromString(self.rightButtonAction);
        
        // Check if the view controller or target responds to the selector
        if ([self.delegate respondsToSelector:selector]) {
            // Perform the action safely using the target (delegate) and selector
            [self.delegate performSelector:selector withObject:nil];
        } else {
            // Handle case where the delegate does not respond to the selector
            NSLog(@"Selector %@ not found on the delegate.", NSStringFromSelector(selector));
        }
    }
}

@end
*/
