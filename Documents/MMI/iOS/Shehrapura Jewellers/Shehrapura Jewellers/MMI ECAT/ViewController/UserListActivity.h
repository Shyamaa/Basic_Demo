//
//  UserListActivity.h
//  Jewel Desk
//
//  Created by App Dev on 18/07/24.
//  Copyright © 2024 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_Userlist.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserListActivity : BaseViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSMutableArray *uniqueCategoriesList;
}
@property (nonatomic, strong) NSMutableArray<Model_Userlist *> *members;
@property (nonatomic, strong) NSMutableArray *filteredMembers;
@property (nonatomic, assign) BOOL isFiltering;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, strong) IBOutlet UISearchBar *searchBar;

@end

NS_ASSUME_NONNULL_END
