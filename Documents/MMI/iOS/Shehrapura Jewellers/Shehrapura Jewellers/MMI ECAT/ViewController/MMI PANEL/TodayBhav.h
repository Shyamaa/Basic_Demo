//
//  TodayBhav.h
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 19/07/23.
//  Copyright © 2023 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TodayBhav : BaseViewController
{
    NSMutableArray *array_item;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
