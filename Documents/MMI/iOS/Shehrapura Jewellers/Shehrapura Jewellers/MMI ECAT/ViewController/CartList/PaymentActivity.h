//
//  PaymentActivity.h
//  Jewel Desk
//
//  Created by App Dev on 27/11/23.
//  Copyright © 2023 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaymentActivity : BaseViewController
{
    IBOutlet UILabel *lbl_mobile;
    IBOutlet UILabel *lbl_name;
    IBOutlet UILabel *lbl_orderno;
    
    IBOutlet UITextField *txt_emailid;
    IBOutlet UILabel *lbl_termcondition;
    
    NSString *checked;
    IBOutlet UIButton *btn_term;
    
    
}

@property (nonatomic, retain) NSString *str_orderno;
@property (nonatomic, retain) NSString *str_amount;
@property (nonatomic, retain) NSString *str_emailid;
- (IBAction)btn_termandcondition:(id)sender;
- (IBAction)btn_paynow:(id)sender;

@end

NS_ASSUME_NONNULL_END
