//
//  OutstandingTblCell.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 17/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutstandingTblCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *subContainView;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblGrWt;
@property (nonatomic, strong) IBOutlet UILabel *lblRemark;
@property (nonatomic, strong) IBOutlet UILabel *lblSilver;
@property (nonatomic, strong) IBOutlet UILabel *lblGold;
@property (nonatomic, strong) IBOutlet UILabel *lblAmount;
@property (nonatomic, strong) IBOutlet UILabel *lblStatus;
@property (nonatomic, strong) IBOutlet UILabel *lblPayDate;
@property (nonatomic, strong) IBOutlet UILabel *lblLastDate;

@property (nonatomic, strong) IBOutlet UIButton *btnSMS;
@property (nonatomic, strong) IBOutlet UIButton *btnWhatsUp;
@property (nonatomic, strong) IBOutlet UIButton *btnCall;
@property (nonatomic, strong) IBOutlet UIButton *btnEndCall;
@property (nonatomic, strong) IBOutlet UIButton *btnHistory;

@end
