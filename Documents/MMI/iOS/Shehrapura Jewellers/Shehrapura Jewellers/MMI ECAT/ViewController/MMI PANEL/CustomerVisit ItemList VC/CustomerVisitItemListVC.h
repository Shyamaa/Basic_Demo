
//
//  CustomerVisitItemListVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 26/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CustomerVisitItemListVC :BaseViewController <UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate>
{
    NSMutableArray *tblMasterItemListData;
    NSMutableArray *tblItemListData;
    NSMutableArray *selectedItemListData;
}

@property (nonatomic, copy) void (^completionHandler)(NSMutableArray *listData);

@property (strong, nonatomic) NSString *str_cpid;
@property (strong, nonatomic) NSString *str_visid;

@property (strong, nonatomic) NSString *str_page_type;
@property (strong, nonatomic) NSMutableArray *listData;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *txtSearchBar;

@end
