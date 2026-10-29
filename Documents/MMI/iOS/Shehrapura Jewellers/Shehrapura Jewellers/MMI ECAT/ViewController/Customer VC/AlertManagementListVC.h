//
//  AlertManagementListVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 31/07/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AlertManagementListVC : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *tblListData;
    IBOutlet UITableView *tblView;
}

@end
