//
//  AlertManagementListCell.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 01/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertManagementListCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *subView;
@property (nonatomic, strong) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) IBOutlet UILabel *lblTitleName;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UILabel *lblCategory;

@end
