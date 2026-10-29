//
//  OrderSoftware.h
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 20/07/21.
//  Copyright © 2021 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderSoftware : BaseViewController
{
    NSMutableArray *array_item;

}

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@end

NS_ASSUME_NONNULL_END
