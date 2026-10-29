//
//  BusyIndicator.h
//  SectionProposal
//

#import <UIKit/UIKit.h>
#import "CustomCellBackgroundView.h"  // Assuming this is a custom view class.

@interface BusyIndicator : UIView {
    UIActivityIndicatorView *activityIndicator;
    CustomCellBackgroundView *roundedRectView;
}

+ (BusyIndicator *)sharedInstance;
- (void)startIndicator;
- (void)stopIndicator;

@end

