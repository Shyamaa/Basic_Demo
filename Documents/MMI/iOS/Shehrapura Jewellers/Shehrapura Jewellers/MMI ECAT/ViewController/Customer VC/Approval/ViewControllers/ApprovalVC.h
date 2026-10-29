//
//  ApprovalVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 20/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPopUp.h"
#import "BaseViewController.h"

@interface ApprovalVC : BaseViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    IBOutlet UIView *viewAddApproval;
    IBOutlet UITextField *txtCustomer;
    IBOutlet UITextField *txtItem;
    IBOutlet UITextField *txtCategory;
    IBOutlet UITextField *txtRemark;
    IBOutlet UITextField *txtDateFrom;
    IBOutlet UITextField *txtDateTo;
    IBOutlet UITextField *txtHours;
}

@end
