//
//  AdminOrderListVC.h
//  Swiz Gold and Diamonds
//
//  Created by MMI Softwares Pvt Ltd on 21/05/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "BaseViewController.h"


@interface AdminOrderListVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrayTblOrderList;
    NSMutableArray *arrayMasterPendingOrderList;
    NSMutableArray *arrayMasterAllOrderList;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *btnPending;
@property (strong, nonatomic) IBOutlet UIButton *btnAll;

@end
