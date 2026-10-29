//
//  CartList.h
//  MMI ECAT
//
//  Created by mmsoft116 on 29/09/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "HomeVC.h"
#import "CustomerVisitFormVC.h"
#import "BaseViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface CartList : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate, CutomerDataDelegate>
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
    NSString * cart_id;
    UIButton *btnAdd_Cart;
    
    NSMutableDictionary *dict_party_item;
    UIView * paintView;
    UITextField *mytext_contact;
    UITextField *mytext_partyname;
    UITextField *mytext_address;
    UITextField *mytext_address2;
    UITextField *mytext_address3;
    UITextField *mytext_location;
    UITextField *mytext_city;
    UITextField *mytext_email;
    UITextField *mytext_contact2;
    NSString *str_cpid;
    NSMutableArray * array_SalesNameList;
    
}
- (IBAction)btn_short:(id)sender;
- (IBAction)btn_details:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIView *bottomButtonView;
@property (strong, nonatomic) IBOutlet UILabel *lblEmptyOrder;

@property (nonatomic, retain) NSString *str_activity;
@property (nonatomic, retain) NSString *str_rlid;
@property (nonatomic, retain) NSString *str_idesc;
@property(nonatomic, retain) NSString *str_tag;


@end

NS_ASSUME_NONNULL_END
