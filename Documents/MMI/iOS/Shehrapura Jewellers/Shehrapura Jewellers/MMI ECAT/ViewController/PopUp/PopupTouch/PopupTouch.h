//
//  PopupTouch.h
//  Jewel Desk
//
//  Created by App Dev on 01/01/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "webUrlconstant.h"
#import "BusyIndicator.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PopupTouch : BaseViewController
{
    IBOutlet UIScrollView *scrollview;
    IBOutlet UITextField *txt_polishPer;
    IBOutlet UITextField *txt_polishwt;
    IBOutlet UITextField *txt_rate;
    IBOutlet UITextField *txt_csmamt;
    IBOutlet UITextField *txt_percent0;
    IBOutlet UITextField *txt_value0;
    IBOutlet UITextField *txt_othamt;
    IBOutlet UITextField *txt_dwt;
    
    IBOutlet UITextField *txt_saletotal;
    IBOutlet UITextField *txt_percent1;
    
    
    IBOutlet UITextField *spinner_on1;
    IBOutlet UITextField *txt_value1;
    IBOutlet UITextField *txt_percent2;
    IBOutlet UITextField *spinner_on2;
    IBOutlet UITextField *txt_value2;
    IBOutlet UITextField *txt_total;
    IBOutlet UITextField *txt_gstamt;
    IBOutlet UITextField *txt_gst;
    IBOutlet UITextField *edt_remark;
    
    IBOutlet UILabel *lbl_lbron;
    IBOutlet UITextField *txt_Stamp;
    IBOutlet UITextField *txt_lbron;
}

@property (nonatomic, copy) void (^completionHandler)(NSString *amount,NSString *wt, NSString *text2, NSString *btnaction);

@property(strong,nonatomic)IBOutlet NSString *str_spolish;
@property(strong,nonatomic)IBOutlet NSString *str_lbr;
@property(strong,nonatomic)IBOutlet NSString *str_slamt;
@property(strong,nonatomic)IBOutlet NSString *str_othamt;
@property(strong,nonatomic)IBOutlet NSString *str_pdis1;
@property(strong,nonatomic)IBOutlet NSString *str_pdis2;
@property(strong,nonatomic)IBOutlet NSString *str_remarks1;
@property(strong,nonatomic)IBOutlet NSString *str_dis1;
@property(strong,nonatomic)IBOutlet NSString *str_dis2;
@property(strong,nonatomic)IBOutlet NSString *str_polishwt;
@property(strong,nonatomic)IBOutlet NSString *str_polishper;
@property(strong,nonatomic)IBOutlet NSString *str_csmamt;
@property(strong,nonatomic)IBOutlet NSString *str_24karat;
@property(strong,nonatomic)IBOutlet NSString *str_lbr24k;
@property(strong,nonatomic)IBOutlet NSString *str_csamt;
@property(strong,nonatomic)IBOutlet NSString *str_itemwt;
@property(strong,nonatomic)IBOutlet NSString *str_bhav;
@property(strong,nonatomic)IBOutlet NSString *str_rate;
@property(strong,nonatomic)IBOutlet NSString *str_lbron;
@property(strong,nonatomic)IBOutlet NSString *str_dis1on;
@property(strong,nonatomic)IBOutlet NSString *str_dis2on;
@property(strong,nonatomic)IBOutlet NSString *str_stamp;
@property(strong,nonatomic)IBOutlet NSString *str_sdamt;
@property(strong,nonatomic)IBOutlet NSString *str_ssamt;
@property(strong,nonatomic)IBOutlet NSString *str_mrp;
@property(strong,nonatomic)IBOutlet NSString *str_cartid;

@property(strong,nonatomic)IBOutlet NSDictionary *dicData;

- (IBAction)btn_save:(id)sender;
- (IBAction)btn_cancel:(id)sender;

@end

NS_ASSUME_NONNULL_END
