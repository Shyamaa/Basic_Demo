//
//  OrderRegisterVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 09/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderRegisterFilterVC.h"
#import "BaseViewController.h"


@interface OrderRegisterVC : BaseViewController < UITableViewDataSource, UITableViewDelegate, FilterOrderRegisterDataDelegate>
{
    NSMutableArray * tblArrayDataItem;
    UIViewController *alertListViewController;
    CGRect alertListRect;
    UITableView *table_item;
    UIAlertController *ac_tyep;
}
// Add any properties or methods you need here

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) NSString *str_ViewType;

@end
