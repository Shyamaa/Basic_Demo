//
//  OutStanding.h
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 01/08/23.
//  Copyright © 2023 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTodo.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OutStanding : BaseViewController<UITableViewDelegate,UITableViewDataSource, UITextViewDelegate>
{
    IBOutlet UISearchBar *searchBar;
    IBOutlet UISegmentedControl *seg_control;
    IBOutlet UIView *filterView;
    IBOutlet UITextField *txtFilter;
    IBOutlet UIView *fromToView;
    IBOutlet UITextField *txtDateFrom;
    IBOutlet UITextField *txtDateTo;
    
    NSMutableArray *masterArray_item;
    NSMutableArray *array_item;
    NSMutableArray *array_todo;
    
    NSArray *array_FilterList;
    NSArray *arrayFilter;
    
    UITableView *alertTableView;
    UIAlertController *alertController;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView_outstanding;
@property (nonatomic, strong) CustomTodo *customView;

@property (nonatomic, strong) IBOutlet UIView *resonView;
@property (nonatomic, strong) IBOutlet UITextField *txtDate;
@property (nonatomic, strong) IBOutlet UITextField *txtTime;
@property (nonatomic, strong) IBOutlet UITextField *txtSelectReson;
@property (nonatomic, strong) IBOutlet UITextField *txtRemark;
@property (nonatomic, strong) IBOutlet UITextView *txtViewRemark;

@end

NS_ASSUME_NONNULL_END
