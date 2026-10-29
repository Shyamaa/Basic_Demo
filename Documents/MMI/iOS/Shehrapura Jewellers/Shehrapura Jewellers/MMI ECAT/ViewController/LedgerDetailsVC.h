//
//  LedgerDetailsVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 02/07/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


#ifndef LedgerDetailsVC_h
#define LedgerDetailsVC_h

@interface LedgerDetailsVC : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *tblList;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *lblOpenBal;
@property (strong, nonatomic) IBOutlet UILabel *lblCloseBal;

@property (strong, nonatomic) NSDictionary *selectDicData;
@property (strong, nonatomic) NSString *str_LedgerName;

@end

#endif /* LedgerDetailsVC_h */
