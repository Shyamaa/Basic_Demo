//
//  CustomerVisitTblCell.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 05/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface CustomerVisitTblCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imgViewItem;

@property (nonatomic, strong) IBOutlet UILabel *lblItemTagNo;
@property (nonatomic, strong) IBOutlet UILabel *lblItemGrossWt;
@property (nonatomic, strong) IBOutlet UILabel *lblItemWt;
@property (nonatomic, strong) IBOutlet UILabel *lblItemSaleMrp;
@property (nonatomic, strong) IBOutlet UILabel *lblItemRate;
@property (nonatomic, strong) IBOutlet UILabel *lblItemGst;

@property (nonatomic, strong) IBOutlet UIButton *btnEdit;
@property (nonatomic, strong) IBOutlet UIButton *btnDelete;
@property (nonatomic, strong) IBOutlet UIButton *btnCheck;
@property (nonatomic, strong) IBOutlet UIStackView *infoStackView;

@end

