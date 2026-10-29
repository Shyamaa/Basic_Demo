//
//  Kitty_ledger.h
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 20/07/21.
//  Copyright © 2021 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Kitty_ledger : BaseViewController
{
    NSMutableArray *array_item;
    
    NSMutableArray *array_acno;
    NSMutableArray *array_gname;
    NSMutableArray *array_duedate;
    NSMutableArray *array_month;

}

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@end

NS_ASSUME_NONNULL_END
