//
//  AgentReportVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 02/09/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AgentReportVC : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *agentReportListData;
    
    IBOutlet UITableView *tblView;
    IBOutlet UIView *filterView;
    IBOutlet UITextField *txtDateFrom;
    IBOutlet UITextField *txtDateTo;
}

@property (nonatomic, copy) void (^onCloseTapped)(void);

@end
