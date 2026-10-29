//
//  PopupLoose.h
//  Jewel Desk
//
//  Created by App Dev on 30/07/24.
//  Copyright © 2024 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PopupLoose : BaseViewController
{
    
}
@property (nonatomic, copy) void (^completionHandler)(NSString *amount,NSString *wt, NSString *text2, NSString *btnaction);
@property(strong,nonatomic)IBOutlet NSString *str_todayrate;

@end

NS_ASSUME_NONNULL_END
