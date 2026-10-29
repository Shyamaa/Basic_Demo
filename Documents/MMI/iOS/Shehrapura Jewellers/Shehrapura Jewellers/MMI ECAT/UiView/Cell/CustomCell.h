//
//  CustomCell.h
//  Jewel Desk
//
//  Created by App Dev on 18/09/24.
//  Copyright © 2024 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIView *backView;
@property (nonatomic, strong) IBOutlet UIImageView *imgeDataArray;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UIView *viewTitle;

@end

NS_ASSUME_NONNULL_END
