//
//  ApprovalCell.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 21/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ApprovalItem;

@interface ApprovalCell : UITableViewCell

- (void)configureWithItem:(ApprovalItem *)item;

@end
