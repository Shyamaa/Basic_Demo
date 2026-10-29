//
//  CustomerInfoVc.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 15/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CustomerInfoVc : BaseViewController<UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate>
{}
@property (nonatomic, strong) ImagePickerHelper *imagePickerHelper;

@property (weak, nonatomic) IBOutlet UIView *listView;
@property (weak, nonatomic) IBOutlet UISearchBar *serachBarText;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UITextField *txtGroupNameList;
@property (nonatomic, strong) IBOutlet UITextField *txtStampList;
@property (nonatomic, strong) IBOutlet UITextField *txtMobile;
@property (nonatomic, strong) IBOutlet UITextField *txtName;
@property (nonatomic, strong) IBOutlet UITextField *txtEmail;
@property (nonatomic, strong) IBOutlet UITextField *txtDob;
@property (nonatomic, strong) IBOutlet UITextField *txtAddress;
@property (nonatomic, strong) IBOutlet UITextField *txtCity;
@property (nonatomic, strong) IBOutlet UITextField *txtPinCode;
@property (nonatomic, strong) IBOutlet UITextField *txtAdharNo;
@property (nonatomic, strong) IBOutlet UITextField *txtInstallmentList;

@property (nonatomic, strong) IBOutlet UILabel *lblAdharFront;
@property (nonatomic, strong) IBOutlet UILabel *lblAdharBack;

@property (nonatomic, strong) IBOutlet UIImageView *imgAdharFront;
@property (nonatomic, strong) IBOutlet UIImageView *imgAdharBack;

@property (nonatomic, strong) IBOutlet UIView *viewGroupList;
@property (nonatomic, strong) IBOutlet UIView *viewStampList;
@property (nonatomic, strong) IBOutlet UIView *viewCityList;
@property (nonatomic, strong) IBOutlet UIView *viewInstallList;

@end
