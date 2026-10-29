//
//  NotificationManager.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 23/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

// NotificationManager.h

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

@interface NotificationManager : NSObject <UNUserNotificationCenterDelegate>

+ (instancetype)shared;

/// Request notification permissions from the user
- (void)requestPermissions;

/// Handle incoming notification payload
- (void)handleNotification:(NSDictionary *)userInfo;

/// Called when device token is successfully received
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

/// Called when device token registration fails
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

@end


