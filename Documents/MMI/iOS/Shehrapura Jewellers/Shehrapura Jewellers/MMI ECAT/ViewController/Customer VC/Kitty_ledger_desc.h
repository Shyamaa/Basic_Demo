//
//  Kitty_ledger_desc.h
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 20/07/21.
//  Copyright © 2021 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Kitty_ledger_desc : BaseViewController
{
    NSMutableArray *array_item;
    
    NSMutableArray *array_srno;
    NSMutableArray *array_tdate;
    NSMutableArray *array_months;

}

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, retain) NSString *str_acno;
@property (nonatomic, retain) NSString *str_gname;

@end

NS_ASSUME_NONNULL_END
