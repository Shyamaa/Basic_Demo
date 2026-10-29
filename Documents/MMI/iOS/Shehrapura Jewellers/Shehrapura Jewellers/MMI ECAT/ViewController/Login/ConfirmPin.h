//
//  ConfirmPin.h
//  MMI ECAT
//
//  Created by mmsoft116 on 04/09/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "ConfigVC.h"
#import "MMIHOMEPanel.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfirmPin : BaseViewController
{
    __weak IBOutlet UITextField *txt_otp;
    __weak IBOutlet UIButton *btn_confirm;
    IBOutlet UILabel *lbl_mobile;
}
@property (nonatomic, retain) NSString *str_mobile;
@property (nonatomic, retain) NSString *str_swid;
@property (nonatomic, retain) NSString *str_regmobile;
@property (nonatomic, retain) NSString *countrycode;

- (IBAction)btn_confirm:(id)sender;

@end

NS_ASSUME_NONNULL_END
