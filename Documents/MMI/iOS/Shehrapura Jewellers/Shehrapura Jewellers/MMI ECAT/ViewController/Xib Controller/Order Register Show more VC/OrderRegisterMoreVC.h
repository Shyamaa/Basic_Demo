//
//  OrderRegisterMoreVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 09/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIkit.h>
#import "BaseViewController.h"

@interface OrderRegisterMoreVC : BaseViewController

@property (nonatomic, strong)  NSMutableArray *arrayData;
// Add any properties or methods you need here
@property (nonatomic, strong) IBOutlet UIView *subView;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewItem;
@property (nonatomic, strong) IBOutlet UILabel *lblJobNo;
@property (nonatomic, strong) IBOutlet UILabel *lblStamp;
@property (nonatomic, strong) IBOutlet UILabel *lblCurrentWt;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblMobile;
@property (nonatomic, strong) IBOutlet UILabel *lblStatus;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UILabel *lblRemark;
@property (nonatomic, strong) IBOutlet UILabel *lblAdvance;
@property (nonatomic, strong) IBOutlet UILabel *lblKarigar;
@property (nonatomic, strong) IBOutlet UILabel *lblKDelivery;

@property (nonatomic, strong) IBOutlet UIButton *btnSaveImage;
@property (nonatomic, strong) IBOutlet UIButton *btnCancel;

@end
