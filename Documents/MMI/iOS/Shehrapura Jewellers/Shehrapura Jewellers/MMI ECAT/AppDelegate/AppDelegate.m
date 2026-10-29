//
//  AppDelegate.m
//  AirMobileShop
//
//  Created by MMI SOFTWARE on 06/06/19.
//  Copyright © 2019 MMI Softwares. All rights reserved.
//

#import "AppDelegate.h"
#import "NotificationManager.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[NotificationManager shared] didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[NotificationManager shared] didFailToRegisterForRemoteNotificationsWithError:error];
}

@end
