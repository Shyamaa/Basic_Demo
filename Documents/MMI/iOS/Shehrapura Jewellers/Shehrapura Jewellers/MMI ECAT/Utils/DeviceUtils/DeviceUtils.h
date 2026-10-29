//
//  DeviceUtils.h
//  Jwelly Ecat
//
//  Created by MMI Softwares Pvt Ltd on 16/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Device type enumeration
 */
typedef NS_ENUM(NSInteger, MMIDeviceType) {
    MMIDeviceTypeUnknown = 0,
    MMIDeviceTypeiPhone,
    MMIDeviceTypeiPad,
    MMIDeviceTypeiPod
};

/**
 * Device size category
 */
typedef NS_ENUM(NSInteger, MMIDeviceSize) {
    MMIDeviceSizeUnknown = 0,
    MMIDeviceSizeSmall,      // iPhone SE, iPhone 8
    MMIDeviceSizeMedium,     // iPhone 12, iPhone 13
    MMIDeviceSizeLarge,      // iPhone 12 Pro Max, iPhone 13 Pro Max
    MMIDeviceSizeiPad        // All iPad sizes
};

/**
 * DeviceUtils - Modern device detection and utilities
 * 
 * Replaces old device detection macros with:
 * - Modern device detection
 * - Safe area handling
 * - Dynamic type support
 * - Device-specific layouts
 * - Future-proof design
 */
@interface DeviceUtils : NSObject

/**
 * Get the current device type
 * @return The device type (iPhone, iPad, iPod)
 */
+ (MMIDeviceType)deviceType;

/**
 * Get the current device size category
 * @return The device size category
 */
+ (MMIDeviceSize)deviceSize;

/**
 * Check if the device is an iPhone
 * @return YES if iPhone, NO otherwise
 */
+ (BOOL)isiPhone;

/**
 * Check if the device is an iPad
 * @return YES if iPad, NO otherwise
 */
+ (BOOL)isiPad;

/**
 * Check if the device is an iPod
 * @return YES if iPod, NO otherwise
 */
+ (BOOL)isiPod;

/**
 * Get the device model identifier
 * @return The device model identifier (e.g., "iPhone14,2")
 */
+ (NSString *)deviceModelIdentifier;

/**
 * Get the device marketing name
 * @return The device marketing name (e.g., "iPhone 13 Pro")
 */
+ (NSString *)deviceMarketingName;

/**
 * Get the screen size
 * @return The screen size in points
 */
+ (CGSize)screenSize;

/**
 * Get the screen bounds
 * @return The screen bounds
 */
+ (CGRect)screenBounds;

/**
 * Check if the device has a notch
 * @return YES if device has notch, NO otherwise
 */
+ (BOOL)hasNotch;

/**
 * Get the safe area insets for the current window
 * @return The safe area insets
 */
+ (UIEdgeInsets)safeAreaInsets;

/**
 * Get the status bar height
 * @return The status bar height
 */
+ (CGFloat)statusBarHeight;

/**
 * Get the navigation bar height
 * @return The navigation bar height
 */
+ (CGFloat)navigationBarHeight;

/**
 * Get the tab bar height
 * @return The tab bar height
 */
+ (CGFloat)tabBarHeight;

/**
 * Check if the device supports haptic feedback
 * @return YES if haptic feedback is supported, NO otherwise
 */
+ (BOOL)supportsHapticFeedback;

/**
 * Generate haptic feedback
 * @param style The haptic feedback style
 */
+ (void)generateHapticFeedback:(UIImpactFeedbackStyle)style;

/**
 * Get device-specific layout constants
 * @param key The layout key
 * @return The layout value
 */
+ (CGFloat)layoutConstantForKey:(NSString *)key;

/**
 * Check if the device is in landscape orientation
 * @return YES if landscape, NO if portrait
 */
+ (BOOL)isLandscape;

/**
 * Get the current orientation
 * @return The current interface orientation
 */
+ (UIInterfaceOrientation)currentOrientation;

@end

NS_ASSUME_NONNULL_END 