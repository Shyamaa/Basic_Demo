//
//  ItemListActivity.h
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 29/08/22.
//  Copyright © 2022 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddItemActivity.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItemListActivity : BaseViewController
{
    NSMutableArray *array_item;
    NSMutableArray *array_tgno;
    NSMutableArray *array_idesc;
    NSMutableArray *array_image;
    NSMutableArray *array_imgurl;

    NSMutableArray *filter_tgno;
    NSMutableArray *filter_idesc;
    NSMutableArray *filter_image;
    NSMutableArray *filter_imgurl;
    NSMutableArray *filter_data;

    NSMutableArray *search_tgno;
    NSMutableArray *search_idesc;
    NSMutableArray *search_image;
    NSMutableArray *search_imgurl;
    NSMutableArray *search_data;
    
    NSMutableArray *arrayAllListData;
    NSMutableArray *arrayTblListData;
    NSMutableArray *arrayListImageData;
    NSMutableArray *arrayListNoImageData;

    BOOL isSearching;
    NSString * str_filter;
    NSString * str_search;
    IBOutlet UISegmentedControl *seg_control;
    
    NSArray *animalIndexTitles;
    NSMutableArray *filteredContentList;
    NSArray *memberid_array_a;
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView_Order;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSString *strIdesc;
@property (nonatomic, strong) IBOutlet UIButton *btnNext;
@property (nonatomic, strong) IBOutlet UIButton *btnPrevious;
@property (nonatomic, assign) BOOL openWithSidMenu;
@end

NS_ASSUME_NONNULL_END
