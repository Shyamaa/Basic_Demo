//
//  ForgetPasswordVC.h
//  AirMobileShop
//
//  Created by Suresh Soni on 10/06/19.
//  Copyright © 2019 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ForgetPasswordVC : BaseViewController
{
    IBOutlet UITextField *txt_email;
    IBOutlet UIButton *btn_reset_password;
    
}
- (IBAction)btn_reset:(id)sender;
@end

NS_ASSUME_NONNULL_END
