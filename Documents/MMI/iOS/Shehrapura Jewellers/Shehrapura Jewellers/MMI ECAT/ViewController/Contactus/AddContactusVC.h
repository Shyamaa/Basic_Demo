//
//  AddContactusVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 02/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@interface AddContactusVC : BaseViewController<UITextFieldDelegate>
{
    NSArray *categoriesList;
    
    IBOutlet UITextField *txtFirmName;
    IBOutlet UITextField *txtMobileNo;
    
    IBOutlet UITextField *txtHead1;
    IBOutlet UITextField *txtMobileNo1;
    
    IBOutlet UITextField *txtHead2;
    IBOutlet UITextField *txtMobileNo2;
    
    IBOutlet UITextField *txtHead3;
    IBOutlet UITextField *txtMobileNo3;
    
    IBOutlet UITextField *txtHead4;
    IBOutlet UITextField *txtMobileNo4;
    
    IBOutlet UITextView *txtAddress;
    IBOutlet UITextView *txtAddress1;
}
@property (nonatomic, copy) void (^onCloseTapped)(void);
@property (nonatomic, retain) NSDictionary *contactUsData;

@end
