//
//  OrderListCell.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 01/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *orderNoLabel;
@property (nonatomic, strong) IBOutlet UILabel *remarkLabel;
@property (nonatomic, strong) IBOutlet UILabel *wtLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UIButton *editButton;

@end
