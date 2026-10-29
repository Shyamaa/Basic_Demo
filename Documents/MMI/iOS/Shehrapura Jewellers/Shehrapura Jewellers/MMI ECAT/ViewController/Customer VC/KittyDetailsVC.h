//
//  KittyDetailsVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 14/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Razorpay/Razorpay-Swift.h"

@interface KittyDetailsVC : BaseViewController<UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *arraytblListData;
}

@property (nonatomic, strong) RazorpayCheckout *razorpay;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *lblTotal;
@property (nonatomic, strong) IBOutlet UILabel *lblWt;

@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UITextField *txtAmount;
@property (weak, nonatomic) IBOutlet UITextField *txtWt;
@property (weak, nonatomic) IBOutlet UITextView *txtViewTodayRate;

@property (weak, nonatomic) IBOutlet UIStackView *wtStackView;
@property (weak, nonatomic) IBOutlet UIStackView *todayRateStackView;

@property (weak, nonatomic) IBOutlet UIStackView *payModeStackView;
@property (weak, nonatomic) IBOutlet UIButton *btnOnline;
@property (weak, nonatomic) IBOutlet UIButton *btnCash;

@property (nonatomic, strong) NSString *strId;
@property (nonatomic, strong) NSString *strStampid;
@property (nonatomic, strong) NSDictionary *selectData;

@property (weak, nonatomic) IBOutlet NSString * strKittyType;


@end

