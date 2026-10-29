//
//  ChangePasswordVC.h
//  AirMobileShop
//
//  Created by Suresh Soni on 10/06/19.
//  Copyright © 2019 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangePasswordVC : BaseViewController
{
    IBOutlet UITextField *txt_old_password;
    IBOutlet UITextField *txt_new_password;
    IBOutlet UITextField *txt_confirm_password;
    
    IBOutlet UIButton *btn_update;
    
    
}
- (IBAction)btn_update:(id)sender;



@end

NS_ASSUME_NONNULL_END
