//
//  SceneDelegate.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 25/09/26.
//  Copyright © 2026 MMI Softwares. All rights reserved.
//

#import "SceneDelegate.h"

#import "AppCoordinator.h"
#import "UIAppearanceManager.h"
#import "NotificationManager.h"

@interface SceneDelegate ()

@property (nonatomic, strong) AppCoordinator *appCoordinator;

@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene
willConnectToSession:(UISceneSession *)session
       options:(UISceneConnectionOptions *)connectionOptions {

    if (![scene isKindOfClass:[UIWindowScene class]]) {
        return;
    }

    [UIAppearanceManager setupAppearance];

    UIWindowScene *windowScene = (UIWindowScene *)scene;

    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];

    self.appCoordinator =
        [[AppCoordinator alloc] initWithWindow:self.window];

    [self.appCoordinator start];

    [[NotificationManager shared] requestPermissions];

    [self.window makeKeyAndVisible];
}

- (void)sceneDidBecomeActive:(UIScene *)scene {
}

- (void)sceneWillResignActive:(UIScene *)scene {
}

- (void)sceneWillEnterForeground:(UIScene *)scene {
}

- (void)sceneDidEnterBackground:(UIScene *)scene {
}

- (void)sceneDidDisconnect:(UIScene *)scene {
}

@end
