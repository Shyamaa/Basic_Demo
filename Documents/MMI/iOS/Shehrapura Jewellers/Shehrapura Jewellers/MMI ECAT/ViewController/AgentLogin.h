//
//  AgentLogin.h
//  Jwelly Customer
//
//  Created by mmsoft116 on 10/10/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AgentLogin : BaseViewController<UITextFieldDelegate>
{
    
    __weak IBOutlet UIImageView *img;
    __weak IBOutlet UITextField *txt_userid;
    __weak IBOutlet UITextField *txt_password;
}
- (IBAction)btn_login:(id)sender;


@end

NS_ASSUME_NONNULL_END
