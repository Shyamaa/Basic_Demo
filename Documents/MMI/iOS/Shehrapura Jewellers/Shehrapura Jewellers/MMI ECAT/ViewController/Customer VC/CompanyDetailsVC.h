//
//  CompanyDetailsVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 09/06/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CompanyDetailsVC : BaseViewController<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *txtName;
@property (nonatomic, strong) IBOutlet UITextField *txtAddress;
@property (nonatomic, strong) IBOutlet UITextField *txtMobile;
@property (nonatomic, strong) IBOutlet UITextField *txtEmail;
@property (nonatomic, strong) IBOutlet UITextField *txtGstNo;

@property (nonatomic, assign) BOOL isOpenFromHome;
@property (nonatomic, assign) BOOL isSideMenu;

@end
