//
//  CustomAlertView.h
//  Jewel Desk
//
//  Created by App Dev on 18/01/24.
//  Copyright © 2024 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CustomAlertDelegate <NSObject>
- (void)didSelectValue:(NSString *)selectedValue;
@end

@interface CustomAlertView : BaseViewController
{
    IBOutlet UIView *contentview;
    IBOutlet UIScrollView *scrollview;
    IBOutlet UITextField *txt_mobile;
    IBOutlet UITextField *txt_mobile2;
    IBOutlet UITextField *txt_partyname;
    IBOutlet UITextField *txt_address;
    IBOutlet UITextField *txt_address2;
    IBOutlet UITextField *txt_address3;
    IBOutlet UITextField *txt_location;
    IBOutlet UITextField *txt_city;
    IBOutlet UITextField *txt_emailid;
}
@property (nonatomic, copy) void (^completionHandler)(NSString *acno,NSString *text1, NSString *text2, NSString *visid);

@property (nonatomic, weak) id<CustomAlertDelegate> delegate;

- (IBAction)btn_cancel:(id)sender;
- (IBAction)btn_unknown:(id)sender;
- (IBAction)btn_save:(id)sender;

@end

NS_ASSUME_NONNULL_END
