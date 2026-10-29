//
//  Suggestion.h
//  Jwelly Customer
//
//  Created by mmsoft116 on 05/10/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Suggestion : BaseViewController<UITextViewDelegate>
{
    IBOutlet UITextView *txt_feedback;
    IBOutlet UIView *dock;
    IBOutlet UIButton *sendButton;

    CGRect previousRect;

}
- (IBAction)btn_send:(id)sender;
@property (nonatomic, copy) void (^onCloseTapped)(void);
@property (nonatomic, retain) NSString *str_type;
@property (nonatomic, assign) BOOL openWithSidMenu;
@end

NS_ASSUME_NONNULL_END
