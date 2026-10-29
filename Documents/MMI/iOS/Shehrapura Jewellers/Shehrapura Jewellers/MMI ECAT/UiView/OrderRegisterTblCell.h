//
//  OrderRegisterTblCell.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 09/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderRegisterTblCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imgViewItem;

@property (nonatomic, strong) IBOutlet UILabel *lblJobNo;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UILabel *lblStamp;
@property (nonatomic, strong) IBOutlet UILabel *lblCurrentWt;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblMobile;

@property (nonatomic, strong) IBOutlet UIButton *btnSMS;
@property (nonatomic, strong) IBOutlet UIButton *btnWhatsUp;
@property (nonatomic, strong) IBOutlet UIButton *btnCall;
@property (nonatomic, strong) IBOutlet UIButton *btnCheck;
@property (nonatomic, strong) IBOutlet UIButton *btnShowMore;
@end


