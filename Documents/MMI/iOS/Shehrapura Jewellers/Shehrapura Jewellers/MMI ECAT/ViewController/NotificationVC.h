//
//  NotificationVC.h
//  Dia Jewels
//
//  Created by MMI SOFTWARES PVT LTD on 12/11/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotificationVC : BaseViewController
{
    NSMutableArray *array_item;

}

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end

NS_ASSUME_NONNULL_END
