//
//  WalletHistoryVC.h
//  AirMobileShop
//
//  Created by MMI SOFTWARE on 11/06/19.
//  Copyright © 2019 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletHistoryVC : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
	NSMutableArray *nsarray_walletid_credit;
	NSMutableArray *nsarray_amount_credit;
	NSMutableArray *nsarray_type_credit;
	NSMutableArray *nsarray_created_date_credit;
	NSMutableArray *nsarray_type_status_credit;
	
	
	NSMutableArray *nsarray_walletid_debit;
	NSMutableArray *nsarray_amount_debit;
	NSMutableArray *nsarray_type_debit;
	NSMutableArray *nsarray_created_date_debit;
	NSMutableArray *nsarray_type_status_debit;
	
}

@property (strong, nonatomic) IBOutlet UITableView *tableView_credit;
@property (strong, nonatomic) IBOutlet UITableView *tableView_debit;

@end

NS_ASSUME_NONNULL_END
