//
//  OrderDetail.h
//  MMI ECAT
//
//  Created by mmsoft116 on 01/10/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "HomeVC.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetail : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *nsarray_data;
    NSMutableArray *nsarray_qty;
    IBOutlet UILabel *lbl_wt;
    IBOutlet UILabel *lbl_pc;
    IBOutlet UILabel *lbl_mrp;
    
    UIView *view1;
    UIView *transparentView;
    UITextField *text_count;
    UITextField *text_remarks;
    NSInteger index_cart;
    
    UIButton *btnAdd_Cart;
    NSMutableDictionary *dict_party_item;
}

@property (nonatomic, retain) NSString *str_orderno;
@property (nonatomic, retain) NSString *str_odate;
@property (nonatomic, retain) NSString *str_wt;
@property (nonatomic, retain) NSString *str_qty;
@property (nonatomic, retain) NSString *str_mobile;
@property (nonatomic, retain) NSString *str_username;

@property (strong, nonatomic) IBOutlet UIStackView *phoneNumberView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderValue;
@property (strong, nonatomic) IBOutlet UILabel *lblDateValue;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;


@end

NS_ASSUME_NONNULL_END
