//
//  CustomCellBackgroundView.h
//

#import <UIKit/UIKit.h>

@interface CustomCellBackgroundView : UIView {
	UIColor *fillColor;
	UIColor *borderColor;
}
@property (nonatomic, retain) UIColor *fillColor;
@property (nonatomic, retain) UIColor *borderColor;

- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)theBackColor borderColor:(UIColor *)theBorderColor;

@end

