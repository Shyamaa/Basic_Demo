//
//  ApprovalDetailsVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 20/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPopUp.h"
#import "BaseViewController.h"
#import "ApprovalDetailItem.h"
#import "ApprovalItem.h"

@interface ApprovalDetailsVC : BaseViewController
{
    NSDictionary *userData;
    IBOutlet UITextField *txtCustomer;
    IBOutlet UITextField *txtItem;
    IBOutlet UITextField *txtCategory;
    IBOutlet UITextField *txtWeight_From;
    IBOutlet UITextField *txtWeight_To;
    IBOutlet UITextField *txtAmount_From;
    IBOutlet UITextField *txtAmount_To;
    IBOutlet UITextField *txtRemark;
    IBOutlet UITextField *txtDateFrom;
    IBOutlet UITextField *txtDateTo;
    IBOutlet UITextField *txtHours;
}

@property (nonatomic, strong) ApprovalItem *approvalItem;
@property (nonatomic, strong) ApprovalDetailItem *approvalDetail;


@end
