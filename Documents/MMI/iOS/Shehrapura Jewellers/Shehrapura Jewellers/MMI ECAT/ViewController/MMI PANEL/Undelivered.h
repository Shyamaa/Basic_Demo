//
//  Undelivered.h
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 24/07/23.
//  Copyright © 2023 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Undelivered : BaseViewController
{
    NSMutableArray *array_trnid;
    NSMutableArray *array_cname;
    NSMutableArray *array_refno;
    NSMutableArray *array_tdate;
    NSMutableArray *array_iwt;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

NS_ASSUME_NONNULL_END
