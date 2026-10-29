//
//  DeviceUtils.m
//  Jwelly Ecat
//
//  Created by MMI Softwares Pvt Ltd on 16/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "DeviceUtils.h"
#import <sys/utsname.h>

@implementation DeviceUtils

+ (MMIDeviceType)deviceType {
    NSString *model = [self deviceModelIdentifier];
    
    if ([model containsString:@"iPhone"]) {
        return MMIDeviceTypeiPhone;
    } else if ([model containsString:@"iPad"]) {
        return MMIDeviceTypeiPad;
    } else if ([model containsString:@"iPod"]) {
        return MMIDeviceTypeiPod;
    }
    
    return MMIDeviceTypeUnknown;
}

+ (MMIDeviceSize)deviceSize {
    CGSize screenSize = [self screenSize];
    CGFloat screenHeight = MAX(screenSize.width, screenSize.height);
    
    if ([self isiPad]) {
        return MMIDeviceSizeiPad;
    }
    
    // iPhone size categories based on screen height
    if (screenHeight <= 667) {
        return MMIDeviceSizeSmall;      // iPhone SE, iPhone 8
    } else if (screenHeight <= 844) {
        return MMIDeviceSizeMedium;     // iPhone 12, iPhone 13
    } else {
        return MMIDeviceSizeLarge;      // iPhone 12 Pro Max, iPhone 13 Pro Max
    }
}

+ (BOOL)isiPhone {
    return [self deviceType] == MMIDeviceTypeiPhone;
}

+ (BOOL)isiPad {
    return [self deviceType] == MMIDeviceTypeiPad;
}

+ (BOOL)isiPod {
    return [self deviceType] == MMIDeviceTypeiPod;
}

+ (NSString *)deviceModelIdentifier {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSString *)deviceMarketingName {
    NSString *model = [self deviceModelIdentifier];
    
    // iPhone models
    if ([model isEqualToString:@"iPhone14,2"]) return @"iPhone 13 Pro";
    if ([model isEqualToString:@"iPhone14,3"]) return @"iPhone 13 Pro Max";
    if ([model isEqualToString:@"iPhone14,4"]) return @"iPhone 13 mini";
    if ([model isEqualToString:@"iPhone14,5"]) return @"iPhone 13";
    if ([model isEqualToString:@"iPhone14,6"]) return @"iPhone SE (3rd generation)";
    if ([model isEqualToString:@"iPhone14,7"]) return @"iPhone 14";
    if ([model isEqualToString:@"iPhone14,8"]) return @"iPhone 14 Plus";
    if ([model isEqualToString:@"iPhone15,2"]) return @"iPhone 14 Pro";
    if ([model isEqualToString:@"iPhone15,3"]) return @"iPhone 14 Pro Max";
    if ([model isEqualToString:@"iPhone15,4"]) return @"iPhone 15";
    if ([model isEqualToString:@"iPhone15,5"]) return @"iPhone 15 Plus";
    if ([model isEqualToString:@"iPhone16,1"]) return @"iPhone 15 Pro";
    if ([model isEqualToString:@"iPhone16,2"]) return @"iPhone 15 Pro Max";
    
    // iPad models
    if ([model isEqualToString:@"iPad13,1"]) return @"iPad Air (5th generation)";
    if ([model isEqualToString:@"iPad13,2"]) return @"iPad Air (5th generation)";
    if ([model isEqualToString:@"iPad13,4"]) return @"iPad Pro 11-inch (4th generation)";
    if ([model isEqualToString:@"iPad13,5"]) return @"iPad Pro 11-inch (4th generation)";
    if ([model isEqualToString:@"iPad13,6"]) return @"iPad Pro 12.9-inch (6th generation)";
    if ([model isEqualToString:@"iPad13,7"]) return @"iPad Pro 12.9-inch (6th generation)";
    if ([model isEqualToString:@"iPad13,8"]) return @"iPad Pro 12.9-inch (6th generation)";
    if ([model isEqualToString:@"iPad13,9"]) return @"iPad Pro 12.9-inch (6th generation)";
    if ([model isEqualToString:@"iPad13,10"]) return @"iPad Pro 12.9-inch (6th generation)";
    if ([model isEqualToString:@"iPad13,11"]) return @"iPad Pro 12.9-inch (6th generation)";
    if ([model isEqualToString:@"iPad14,1"]) return @"iPad mini (6th generation)";
    if ([model isEqualToString:@"iPad14,2"]) return @"iPad mini (6th generation)";
    if ([model isEqualToString:@"iPad14,3"]) return @"iPad Pro 11-inch (4th generation)";
    if ([model isEqualToString:@"iPad14,4"]) return @"iPad Pro 11-inch (4th generation)";
    if ([model isEqualToString:@"iPad14,5"]) return @"iPad Pro 12.9-inch (6th generation)";
    if ([model isEqualToString:@"iPad14,6"]) return @"iPad Pro 12.9-inch (6th generation)";
    
    return model; // Return the identifier if no match found
}

+ (CGSize)screenSize {
    return [UIScreen mainScreen].bounds.size;
}

+ (CGRect)screenBounds {
    return [UIScreen mainScreen].bounds;
}

+ (BOOL)hasNotch {
    if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (window) {
            return window.safeAreaInsets.top > 20;
        }
    }
    return NO;
}

+ (UIEdgeInsets)safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (window) {
            return window.safeAreaInsets;
        }
    }
    return UIEdgeInsetsZero;
}

+ (CGFloat)statusBarHeight {
    if (@available(iOS 13.0, *)) {
        UIWindowScene *windowScene = [UIApplication sharedApplication].connectedScenes.allObjects.firstObject;
        if ([windowScene isKindOfClass:[UIWindowScene class]]) {
            return windowScene.statusBarManager.statusBarFrame.size.height;
        }
    }
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

+ (CGFloat)navigationBarHeight {
    return 44.0; // Standard navigation bar height
}

+ (CGFloat)tabBarHeight {
    return 49.0; // Standard tab bar height
}

+ (BOOL)supportsHapticFeedback {
    if (@available(iOS 10.0, *)) {
        return [UIDevice currentDevice].valueForKey:@"_feedbackSupportLevel"] != nil;
    }
    return NO;
}

+ (void)generateHapticFeedback:(UIImpactFeedbackStyle)style {
    if (@available(iOS 10.0, *)) {
        if ([self supportsHapticFeedback]) {
            UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:style];
            [generator prepare];
            [generator impactOccurred];
        }
    }
}

+ (CGFloat)layoutConstantForKey:(NSString *)key {
    // Device-specific layout constants
    NSDictionary *constants = @{
        @"cellHeight": @([self isiPad] ? 80.0 : 60.0),
        @"buttonHeight": @([self isiPad] ? 50.0 : 44.0),
        @"textFieldHeight": @([self isiPad] ? 50.0 : 40.0),
        @"margin": @([self isiPad] ? 20.0 : 16.0),
        @"padding": @([self isiPad] ? 16.0 : 12.0),
        @"cornerRadius": @([self isiPad] ? 12.0 : 8.0),
        @"fontSize": @([self isiPad] ? 18.0 : 16.0)
    };
    
    NSNumber *value = constants[key];
    return value ? value.floatValue : 0.0;
}

+ (BOOL)isLandscape {
    UIInterfaceOrientation orientation = [self currentOrientation];
    return orientation == UIInterfaceOrientationLandscapeLeft || 
           orientation == UIInterfaceOrientationLandscapeRight;
}

+ (UIInterfaceOrientation)currentOrientation {
    if (@available(iOS 13.0, *)) {
        UIWindowScene *windowScene = [UIApplication sharedApplication].connectedScenes.allObjects.firstObject;
        if ([windowScene isKindOfClass:[UIWindowScene class]]) {
            return windowScene.interfaceOrientation;
        }
    }
    return [UIApplication sharedApplication].statusBarOrientation;
}

@end 