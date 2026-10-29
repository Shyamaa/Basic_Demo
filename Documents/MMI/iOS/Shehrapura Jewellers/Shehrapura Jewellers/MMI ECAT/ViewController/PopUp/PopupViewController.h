//
//  PopupViewController.h
//  Jewel Desk
//
//  Created by App Dev on 19/07/24.
//  Copyright © 2024 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PopupViewController : BaseViewController<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) NSArray *dropdownItems;
@property (nonatomic, strong) NSString *selectedItem;
@property (nonatomic, copy) void (^completionHandler)(NSString *selectedItem);

@end

NS_ASSUME_NONNULL_END
