//
//  UsersECAT.h
//  Jewel Desk
//
//  Created by App Dev on 19/02/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ObjectSiteModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface UsersECAT : BaseViewController
{
    NSMutableArray *array_item;
    NSString * mobile_edit;
}
@property (nonatomic, strong) NSMutableArray *checkboxButtons;
@property (nonatomic, strong) NSArray *checkboxTitles;

@property (nonatomic, strong) NSMutableArray<ObjectSiteModel *> *siteList;
@property (nonatomic, strong) NSMutableArray<NSString *> *selectedSiteNames;
@property (nonatomic, strong) NSMutableArray<NSString *> *selectedSiteIds;
@property (nonatomic, strong) NSMutableArray<NSString *> *items;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *selectedItems;
@property (nonatomic, strong) NSString *serverSiteIds;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
