//
//  CartItemTblCell.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 04/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "CartItemTblCell.h"

@implementation CartItemTblCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialize customLabel
        /*
        self.customLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.customLabel.font = [UIFont systemFontOfSize:16];
        self.customLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.customLabel];
        
        // Initialize customImageView
        self.customImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.customImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.customImageView];
        */
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            self.lblItemName.font = [UIFont systemFontOfSize:28.0];
            self.lblItemTagNo.font = [UIFont systemFontOfSize:24.0];
            self.lblItemGrossWt.font = [UIFont systemFontOfSize:24.0];
            self.lblItemStamp.font = [UIFont systemFontOfSize:24.0];
            self.lblItemQuantity.font = [UIFont systemFontOfSize:24.0];
            self.lblItemItemWt.font = [UIFont systemFontOfSize:24.0];
            self.lblItemMrp.font = [UIFont systemFontOfSize:24.0];
            self.lblItemMrp.font = [UIFont systemFontOfSize:24.0];
            
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Set the frame for customLabel and customImageView
    /*
    CGFloat padding = 10.0f;
    self.customImageView.frame = CGRectMake(padding, padding, 40, 40);
    self.customLabel.frame = CGRectMake(CGRectGetMaxX(self.customImageView.frame) + padding, padding, self.contentView.bounds.size.width - CGRectGetMaxX(self.customImageView.frame) - padding * 2, 40);
    */
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.lblItemName.font = [UIFont systemFontOfSize:28.0];
        self.lblItemTagNo.font = [UIFont systemFontOfSize:24.0];
        self.lblItemGrossWt.font = [UIFont systemFontOfSize:24.0];
        self.lblItemStamp.font = [UIFont systemFontOfSize:24.0];
        self.lblItemQuantity.font = [UIFont systemFontOfSize:24.0];
        self.lblItemItemWt.font = [UIFont systemFontOfSize:24.0];
        self.lblItemMrp.font = [UIFont systemFontOfSize:24.0];
        self.lblItemMrp.font = [UIFont systemFontOfSize:24.0];
        
    }
}

@end
