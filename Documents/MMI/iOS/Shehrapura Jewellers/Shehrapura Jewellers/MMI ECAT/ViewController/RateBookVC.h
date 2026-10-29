//
//  RateBookVC.h
//  Jewel Desk
//
//  Created by App Dev on 15/05/24.
//  Copyright © 2024 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RateBookVC : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *array_item;
    NSMutableArray *array_srno;
    NSMutableArray *array_tdate;
    NSMutableArray *array_months;
    
    NSMutableArray *array_AlertItemList;
    
    UITableView *alertTableView;
    UIAlertController *alertController;
    NSString * str_ktid;
}

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, retain) NSString *str_acno;
@property (nonatomic, retain) NSString *str_gname;

@end

NS_ASSUME_NONNULL_END
