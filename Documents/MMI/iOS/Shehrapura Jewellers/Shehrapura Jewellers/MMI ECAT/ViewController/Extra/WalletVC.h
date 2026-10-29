//
//  WalletVC.h
//  AirMobileShop
//
//  Created by Suresh Soni on 09/06/19.
//  Copyright © 2019 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletVC : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *nsarray_walletid;
    NSMutableArray *nsarray_amount;
    NSMutableArray *nsarray_type;
    NSMutableArray *nsarray_created_date;
    NSMutableArray *nsarray_type_status;
	NSMutableArray *nsarray_id;

    
}

@property (strong, nonatomic) IBOutlet UITableView *tableView_Order;


@end

NS_ASSUME_NONNULL_END
