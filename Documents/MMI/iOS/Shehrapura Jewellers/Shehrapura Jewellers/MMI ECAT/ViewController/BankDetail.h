//
//  BankDetail.h
//  Jewel Desk
//
//  Created by Apple on 2/6/22.
//  Copyright © 2022 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imgfullVC.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BankDetail : BaseViewController
{
    __weak IBOutlet UIView *view_bank2;
    __weak IBOutlet UIView *view_bank1;
    __weak IBOutlet UILabel *lbl_firmname1;
    __weak IBOutlet UILabel *lbl_accno1;
    __weak IBOutlet UILabel *lbl_bankname1;
    __weak IBOutlet UILabel *lbl_branchname;
    __weak IBOutlet UILabel *lbl_ifsc;
    __weak IBOutlet UILabel *lbl_firmname2;
    __weak IBOutlet UILabel *lbl_accno2;
    __weak IBOutlet UILabel *lbl_bankname2;
    __weak IBOutlet UILabel *lbl_branchname2;
    __weak IBOutlet UILabel *lbl_ifsc2;
    __weak IBOutlet UIButton *btn_qrcode2;
    __weak IBOutlet UIButton *btn_qrcode1;
    NSString *str_qrcode;
    NSString *str_qrcode2;
    NSDictionary *bankDetailsData;
    IBOutlet UIView *view_upi;
    IBOutlet UILabel *lbl_gst1;
    IBOutlet UILabel *lbl_upi1;
    
}
- (IBAction)btn_qrcode1:(id)sender;
- (IBAction)btn_qrcode2:(id)sender;
@property (nonatomic, assign) BOOL isSideMenu;

@end

NS_ASSUME_NONNULL_END
