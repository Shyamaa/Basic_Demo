//
//  EditProfileVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 18/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Model_Userlist.h"

@interface EditProfileVC : BaseViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSArray *categoriesList;
}

@property (nonatomic, strong) IBOutlet UIImageView *imgProfile;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblMobile;
@property (nonatomic, strong) IBOutlet UITextField *txtFirmName;
@property (nonatomic, strong) IBOutlet UITextField *txtEmailID;
@property (nonatomic, strong) IBOutlet UITextField *txtAddress;
@property (nonatomic, strong) IBOutlet UITextField *txtCity;
@property (nonatomic, strong) IBOutlet UITextField *txtState;
@property (nonatomic, strong) IBOutlet UITextField *txtGstNo;
@property (nonatomic, strong) IBOutlet UITextField *txtHmNo;
@property (nonatomic, strong) IBOutlet UITextField *txtPanNo;
@property (nonatomic, strong) IBOutlet UIStackView *editProfileStackView;


@property (nonatomic, strong) IBOutlet UIStackView *editUserInfoStackView;
@property (nonatomic, strong) IBOutlet UITextField *txtInterested;
@property (nonatomic, strong) IBOutlet UITextField *txtCategory;

@property (nonatomic, strong)  Model_Userlist *userData;
@property (nonatomic, strong)  NSString *profileType;

@end
