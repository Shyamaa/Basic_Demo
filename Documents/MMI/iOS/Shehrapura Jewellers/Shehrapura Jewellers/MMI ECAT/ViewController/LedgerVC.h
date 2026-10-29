//
//  LedgerVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 02/07/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#ifndef LedgerVC_h
#define LedgerVC_h
@interface LedgerVC : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *tblList;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(weak,nonatomic) NSString *str_LedgerName;
@property (strong, nonatomic) IBOutlet NSArray *itemList;
@end

#endif /* LedgerVC_h */
