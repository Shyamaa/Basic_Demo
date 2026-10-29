//
//  NewRateBookDetailVc.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 14/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Razorpay/Razorpay-Swift.h"

@interface NewRateBookDetailVc : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *arraytblListData;
}

@property (nonatomic, strong) RazorpayCheckout *razorpay;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *lblRow;
@property (nonatomic, strong) IBOutlet UILabel *lblRec;
@property (nonatomic, strong) IBOutlet UILabel *lblDue;

@property (nonatomic, strong) NSString *kittId;
@property (weak, nonatomic) IBOutlet NSString * strKittyType;

@end
