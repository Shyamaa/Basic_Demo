//
//  StockFilterVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 06/10/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface StockFilterVC : BaseViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    NSMutableArray *arrayListData;
    NSMutableArray *selectedListData;
    NSMutableArray *selectedItems;
    
    NSMutableArray *siteListData;
    NSMutableArray *qualityListData;
    NSMutableArray *stampListData;
    
    NSMutableArray *selectedCategory;
    NSMutableArray *selectedGroup;
    NSMutableArray *selectedOther;
    
    NSMutableArray *categoryItemList;
    NSMutableArray *groupItemList;
    NSArray *otherItemList;
    
    IBOutlet UITextField *txtSite;
    IBOutlet UITextField *txtQuality;
    IBOutlet UITextField *txtStamp;
    IBOutlet UILabel *lblTotalPc;
    IBOutlet UIButton *btnCheckWithOrderRepair;
    IBOutlet UIButton *btnItem;
    IBOutlet UIButton *btnCategory;
    IBOutlet UIButton *btnGroup;
    IBOutlet UIButton *btnIOrder;
    IBOutlet UIButton *btnAllCheck;
    IBOutlet UITableView *tableView;
    IBOutlet UITableView *itemTableView;
    IBOutlet UIView *itemsView;
}
@property (nonatomic, copy) void (^completionHandler)(NSDictionary *filterData);
@end
