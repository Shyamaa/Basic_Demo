//
//  ConfigVC.h
//  Jwelly Customer
//
//  Created by MMI SOFTWARES PVT LTD on 09/11/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfigVC : BaseViewController
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *view_content;
    
    NSString *str_type;
    __weak IBOutlet UITextField *txt_url;
    __weak IBOutlet UITextField *txt_ip;
    __weak IBOutlet UITextField *txt_username;
    __weak IBOutlet UITextField *txt_password;
    __weak IBOutlet UITextField *txt_database;
    __weak IBOutlet UIButton *btn_local;
    __weak IBOutlet UIButton *btn_server;
}
- (IBAction)btn_save:(id)sender;
- (IBAction)btn_local:(id)sender;
- (IBAction)btn_server:(id)sender;

@end

NS_ASSUME_NONNULL_END
