//
//  OrderList.h
//  MMI ECAT
//
//  Created by mmsoft116 on 29/09/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "HomeVC.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderList : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *nsarray_data;
    NSMutableArray *nsarray_DetailsOrderListdata;
    NSMutableArray *nsarray_qty;

    NSMutableArray *nsarray_orderno;
    NSMutableArray *nsarray_remarks;
    NSMutableArray *nsarray_wt;
    NSMutableArray *nsarray_date;
    NSMutableArray *nsarray_username;
    NSMutableArray *nsarray_mobile;

    UIView *view1;
    UIView *transparentView;
    UITextField *text_count;
    UITextField *text_remarks;
    NSInteger index_cart;
    
    UIButton *btnAdd_Cart;
    
    NSMutableDictionary *dict_party_item;
    IBOutlet UIButton *btn_short;
    IBOutlet UIButton *btn_details;
    IBOutlet UIStackView *headerStackView;
    IBOutlet NSLayoutConstraint *headerHight;
    IBOutlet UISegmentedControl *segmentControl;
    
    NSArray *array_FilterList;
    
    UITableView *filterTableView;
    UIAlertController *alertController;
    
}
- (IBAction)btn_short:(UIButton *)sender;
- (IBAction)btn_details:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *bottomDetailsView;
@property (strong, nonatomic) IBOutlet UILabel *lblPcValue;
@property (strong, nonatomic) IBOutlet UILabel *lblWtValue;

@property(weak,nonatomic)IBOutlet NSString *str_act;
@property (nonatomic, assign) BOOL isSideMenu;
@end

NS_ASSUME_NONNULL_END
