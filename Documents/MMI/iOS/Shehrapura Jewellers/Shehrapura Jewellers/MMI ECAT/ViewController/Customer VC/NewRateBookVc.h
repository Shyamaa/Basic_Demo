//
//  NewRateBookVc.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 14/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface NewRateBookVc : BaseViewController<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, UITextDragDelegate>
{
    NSMutableArray *arrayListData;
    NSMutableArray *arraytblListData;
}

@property (weak, nonatomic) IBOutlet NSString * strKittyType;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UITextField *txtKNo;
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtStartDate;
@property (weak, nonatomic) IBOutlet UITextField *txtEndDate;

@property (strong, nonatomic) IBOutlet NSString *str_groupid;
@property (strong, nonatomic) IBOutlet NSString *str_mobile;
@property (strong, nonatomic) IBOutlet NSString *str_activity;
@property (strong, nonatomic) IBOutlet NSString *str_ktype;

@end
