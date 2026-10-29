//
//  PopupLoosebill.h
//  Jewel Desk
//
//  Created by App Dev on 06/08/24.
//  Copyright © 2024 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "webUrlconstant.h"
#import "BusyIndicator.h"
#import "BaseViewController.h"

@interface PopupLoosebill : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UIView *view_sale;
    IBOutlet UIView *view_remark;
    
    IBOutlet UIView *view_gwt;
    IBOutlet UIView *view_nwt;
    IBOutlet UIView *view_tunch;
    IBOutlet UIView *view_lbr;
    IBOutlet UIView *view_fine;
    IBOutlet UIView *view_rate;
    IBOutlet UIView *view_payment;
    UITableView *table_acname;
    UIAlertController *ac_acname;
    UIViewController *controller_acname;

    IBOutlet UILabel *lbl_pc;
    
    IBOutlet UIScrollView *scrollview;
    IBOutlet UIView *contentview;
    UITableView *table_type;
    UIAlertController *ac_tyep;
    IBOutlet UIButton *btn_type;
    IBOutlet UIButton *btn_item;
    IBOutlet UIButton *btn_stamp;
    IBOutlet UIButton *btn_lbron;
    IBOutlet UILabel *lbl_wstg;
    IBOutlet UILabel *lbl_mrate;
    
    IBOutlet UILabel *lbl_lwt;
    NSMutableArray * array_type;
    NSMutableArray * array_item;
    NSMutableArray * array_stamp;
    NSMutableArray * array_lbron;
    NSMutableArray * array_acclist;

    UITableView *table_stamp;
    UITableView *table_item;
    UITableView *table_lbron;
    
    IBOutlet UITextField *txt_remark;
    IBOutlet UITextField *txt_pc;
    IBOutlet UITextField *txt_gwt;
    IBOutlet UITextField *txt_lwt;
    IBOutlet UITextField *txt_nwt;
    IBOutlet UITextField *txt_tunch;
    IBOutlet UITextField *txt_wstg;
    IBOutlet UITextField *txt_mrate;
    IBOutlet UITextField *txt_lbr;
    IBOutlet UITextField *txt_fine;
    IBOutlet UITextField *txt_amt;
    IBOutlet UITextField *txt_gstamt;
    IBOutlet UITextField *txt_gstvalue;
    IBOutlet UITextField *txt_rate;
    IBOutlet UITextField *txt_rtunch;
    IBOutlet UITextField *txt_tagNo;
    
    UIViewController *controller_type;
    UIViewController *controller_stamp;
    UIViewController *controller_item;
    UIViewController *controller_lbron;
    IBOutlet UIView *view_gst;
    
    IBOutlet UILabel *lbl_s_stamp;
    IBOutlet UILabel *lbl_s_item;
    
    NSString *str_gwt;
    NSString *str_lwt;
    NSString *str_tunch;
    NSString *str_wstg;
    NSString *str_mrate;
    NSString *str_lbr;
    
    NSInteger checkgst;
    IBOutlet UIButton *btn_checkgst;
    NSString *str_pay_type;
    NSString *str_pay_acno;

}

- (IBAction)btn_checkgst:(id)sender;

@property (nonatomic, copy) void (^completionHandler)(NSString *amount,NSString *wt, NSString *text2, NSString *btnaction);

@property(strong,nonatomic) IBOutlet NSString *str_todayrate;
@property(strong,nonatomic) IBOutlet NSString *visid;

- (IBAction)btn_type:(id)sender;
- (IBAction)btn_item:(id)sender;
- (IBAction)btn_stamp:(id)sender;
- (IBAction)btn_save:(id)sender;
- (IBAction)btn_cancel:(id)sender;
- (IBAction)btn_lbron:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btn_gstinclude;

@end
