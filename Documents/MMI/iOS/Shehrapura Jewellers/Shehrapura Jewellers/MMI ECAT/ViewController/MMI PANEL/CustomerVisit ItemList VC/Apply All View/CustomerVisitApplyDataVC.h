//
//  CustomerVisitApplyDataVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 26/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CustomerVisitApplyDataVC :BaseViewController <UITextFieldDelegate>
{
    NSMutableArray *selectedItemListData;
}

@property (nonatomic, copy) void (^completionHandler)(NSDictionary *dic_Data);
@property(strong,nonatomic) IBOutlet NSString *str_visid;
@property(strong,nonatomic)IBOutlet NSDictionary *dicData;


@property (strong, nonatomic) IBOutlet UITextField *txtItem;
@property (strong, nonatomic) IBOutlet UITextField *txtStamp;
@property (strong, nonatomic) IBOutlet UITextField *txtTunch;
@property (strong, nonatomic) IBOutlet UITextField *txtWstg;
@property (strong, nonatomic) IBOutlet UITextField *txtLbr;
@property (strong, nonatomic) IBOutlet UITextField *txtLbrOn;
@property (strong, nonatomic) IBOutlet UITextField *txtFine;
@property (strong, nonatomic) IBOutlet UITextField *txtQuantiy;
@property (strong, nonatomic) IBOutlet UITextField *txtAmount;

@end

