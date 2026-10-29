//
//  CustomerEntry.h
//  Jwelly Customer
//
//  Created by MMI SOFTWARES PVT LTD on 20/11/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomerEntry : BaseViewController<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet UITextField *txtMobile;
    IBOutlet UITextField *txtPhone;
    IBOutlet UITextField *txtPrefix;
    IBOutlet UITextField *txtName;
    IBOutlet UITextField *txtAddress1;
    IBOutlet UITextField *txtAddress2;
    IBOutlet UITextField *txtAddress3;
    IBOutlet UITextField *txtLocation;
    IBOutlet UITextField *txtCity;
    IBOutlet UITextField *txtCountry;
    IBOutlet UITextField *txtPincode;
    
    IBOutlet UIStackView *personalDetailsView;
    
    UIImageView *imgSelecte;
    
    IBOutlet UIImageView *imgPhoto;
    IBOutlet UIImageView *imgPan;
    IBOutlet UIImageView *imgAdhar;
    IBOutlet UITextField *txtFirmName;
    IBOutlet UITextField *txtPancard;
    IBOutlet UITextField *txtAdharCardNo;
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtDob;
    IBOutlet UITextField *txtEducation;
    IBOutlet UITextField *txtPotential;
    IBOutlet UITextField *txtJewKnowlede;
    IBOutlet UITextField *txtRefrence;
    IBOutlet UITextField *txtRingSize;
    IBOutlet UITextField *txtBangleSize;
    IBOutlet UITextField *txtRemark;
    
    IBOutlet UIStackView *merriedDetailsView;
    
    IBOutlet UITextField *txtSpouseName;
    IBOutlet UITextField *txtSpouseEmail;
    IBOutlet UITextField *txtSpouseDob;
    IBOutlet UITextField *txtAnniversaryDate;
    IBOutlet UITextField *txtSpouseMobile;
    
    IBOutlet UIButton *btnMale;
    IBOutlet UIButton *btnFemale;
    IBOutlet UIButton *btnMarried;
    
}
@end

NS_ASSUME_NONNULL_END
