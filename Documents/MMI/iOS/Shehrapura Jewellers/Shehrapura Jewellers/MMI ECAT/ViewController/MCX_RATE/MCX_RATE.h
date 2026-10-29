//
//  MCX_RATE.h
//  Jwelly Customer
//
//  Created by MMI SOFTWARES PVT LTD on 13/01/22.
//  Copyright © 2022 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"
#import "NotificationVC.h"
#import "Brochures.h"
#import "Contactus.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCX_RATE : BaseViewController
{
    __weak IBOutlet UIView *view_live;
    __weak IBOutlet UIView *view_jewellery;
    __weak IBOutlet UIView *view_msg;
    __weak IBOutlet UIView *view_bank;
    __weak IBOutlet UIView *view_contact;
    
    __weak IBOutlet UIView *view_bottom;
    __weak IBOutlet UIView *view_marquee1;
    __weak IBOutlet UIView *view_marquee2;
    __weak IBOutlet UIView *view_head;
    __weak IBOutlet UIView *view_badla;
    __weak IBOutlet UIView *view_rate;
    __weak IBOutlet UILabel *lbl_bullion1;
    __weak IBOutlet UILabel *lbl_bullion2;
    __weak IBOutlet UILabel *lbl_bullion3;
    __weak IBOutlet UILabel *lbl_bullion4;
    __weak IBOutlet UILabel *lbl_sale1;
    __weak IBOutlet UILabel *lbl_sale2;
    __weak IBOutlet UILabel *lbl_sale3;
    __weak IBOutlet UILabel *lbl_sale4;
    __weak IBOutlet UILabel *lbl_sale_badla1;
    __weak IBOutlet UILabel *lbl_sale_badla2;
    __weak IBOutlet UILabel *lbl_sale_badla3;
    __weak IBOutlet UILabel *lbl_sale_badla4;
    
    
    __weak IBOutlet UILabel *lbl_gold_h;
    __weak IBOutlet UILabel *lbl_gold_l;
    __weak IBOutlet UILabel *lbl_silver_h;
    __weak IBOutlet UILabel *lbl_silver_l;
    __weak IBOutlet UILabel *lbl_gspot_h;
    __weak IBOutlet UILabel *lbl_gspot_l;
    __weak IBOutlet UILabel *lbl_sspot_h;
    __weak IBOutlet UILabel *lbl_sspot_l;
    __weak IBOutlet UILabel *lbl_inr_h;
    __weak IBOutlet UILabel *lbl_inr_l;
    __weak IBOutlet UILabel *lbl_gold_bid;
    __weak IBOutlet UILabel *lbl_gold_ask;
    __weak IBOutlet UILabel *lbl_silver_bid;
    __weak IBOutlet UILabel *lbl_silver_ask;
    __weak IBOutlet UILabel *lbl_gspot_bid;
    __weak IBOutlet UILabel *lbl_gspot_ask;
    __weak IBOutlet UILabel *lbl_sspot_bid;
    __weak IBOutlet UILabel *lbl_sspot_ask;
    __weak IBOutlet UILabel *lbl_inr_bid;
    __weak IBOutlet UILabel *lbl_inr_ask;
    
}
@property (weak, nonatomic) IBOutlet MarqueeLabel *lbl_marquee1;
@property (weak, nonatomic) IBOutlet MarqueeLabel *lbl_marquee2;
@property (strong, nonatomic) NSTimer *myTimer;


@end

NS_ASSUME_NONNULL_END
