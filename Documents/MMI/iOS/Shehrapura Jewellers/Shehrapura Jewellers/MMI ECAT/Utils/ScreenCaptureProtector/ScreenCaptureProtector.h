//
//  ScreenCaptureProtector.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 07/06/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScreenCaptureProtector : NSObject

+ (instancetype)sharedProtector;

- (void)startProtectionInView:(UIView *)view;
- (void)stopProtection;

@end

