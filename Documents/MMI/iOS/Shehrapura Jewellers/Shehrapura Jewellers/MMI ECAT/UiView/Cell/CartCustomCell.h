//
//  CartCustomCell.h
//  Jewel Desk
//
//  Created by App Dev on 18/09/24.
//  Copyright © 2024 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CartCustomCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imgeDataArray;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIButton *btn_addcart;
@property (nonatomic, strong) UILabel *lbl_counter;
@property (nonatomic, strong) UIButton *checkboxButton; // Add this for checkbox

@end

NS_ASSUME_NONNULL_END
