//
//  CustomTodo.h
//  Jewel Desk
//
//  Created by App Dev on 18/11/23.
//  Copyright © 2023 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTodo : UIView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;

- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
