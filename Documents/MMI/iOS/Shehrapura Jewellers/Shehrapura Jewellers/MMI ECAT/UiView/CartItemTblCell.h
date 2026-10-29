//
//  CartItemTblCell.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 04/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartItemTblCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imgViewItem;
@property (nonatomic, strong) IBOutlet UILabel *lblItemName;
@property (nonatomic, strong) IBOutlet UILabel *lblItemTagNo;
@property (nonatomic, strong) IBOutlet UILabel *lblItemGrossWt;
@property (nonatomic, strong) IBOutlet UILabel *lblItemStamp;
@property (nonatomic, strong) IBOutlet UILabel *lblItemQuantity;
@property (nonatomic, strong) IBOutlet UILabel *lblItemItemWt;
@property (nonatomic, strong) IBOutlet UILabel *lblItemMrp;
@property (nonatomic, strong) IBOutlet UILabel *lblItemRemark;
@property (nonatomic, strong) IBOutlet UILabel *lblItemStatus;
@property (nonatomic, strong) IBOutlet UIButton *btnEdit;
@property (nonatomic, strong) IBOutlet UIButton *btnDelete;

@end

