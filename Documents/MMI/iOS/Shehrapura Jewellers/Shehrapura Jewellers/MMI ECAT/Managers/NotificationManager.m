//
//  NotificationManager.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 23/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

// NotificationManager.m

#import "NotificationManager.h"
#import <UIKit/UIKit.h>

@implementation NotificationManager

+ (instancetype)shared {
    static NotificationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NotificationManager alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Request Permission

- (void)requestPermissions {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;

    UNAuthorizationOptions options = UNAuthorizationOptionAlert |
                                     UNAuthorizationOptionSound |
                                     UNAuthorizationOptionBadge;

    [center requestAuthorizationWithOptions:options
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
        } else {
            NSLog(@"Push Notification permission denied: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - Device Token

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    const unsigned char *dataBuffer = (const unsigned char *)[deviceToken bytes];
    NSMutableString *tokenString = [NSMutableString stringWithCapacity:(deviceToken.length * 2)];
    
    for (int i = 0; i < deviceToken.length; ++i) {
        [tokenString appendFormat:@"%02x", dataBuffer[i]];
    }

    NSString *finalToken = [tokenString copy];
    NSLog(@"Device Token: %@", finalToken);

    // Save to user defaults (optional)
    [[NSUserDefaults standardUserDefaults] setObject:finalToken forKey:@"devicetoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to register for remote notifications: %@", error.localizedDescription);
}

#pragma mark - Handle Notification

- (void)handleNotification:(NSDictionary *)userInfo {
    NSLog(@"Received Notification: %@", userInfo);
    
    NSString *flag = [[userInfo valueForKeyPath:@"aps.flag"] description];
    NSString *cleanFlag = [[flag stringByTrimmingCharactersInSet:
                            [NSCharacterSet characterSetWithCharactersInString:@"() \n\""]] stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSLog(@"Notification Flag: %@", cleanFlag);
    
    if ([cleanFlag isEqualToString:@"3"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // Example: Navigate to specific screen (handled via Coordinator or NotificationRouter)
            NSLog(@"Redirecting user based on notification flag...");
            // Add screen navigation logic if needed
        });
    }
}

#pragma mark - Foreground Notification Handling

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {

    completionHandler(UNNotificationPresentationOptionList |
                      UNNotificationPresentationOptionBanner |
                      UNNotificationPresentationOptionSound);
}


@end
