//
//  CategoryListActivity.h
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 29/08/22.
//  Copyright © 2022 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryListActivity : BaseViewController{
    NSMutableArray *array_item;
    NSMutableArray *tblArray_item;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView_Order;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) BOOL openWithSidMenu;

@end

NS_ASSUME_NONNULL_END
