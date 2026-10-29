//
//  AppDelegate.h
//  AirMobileShop
//
//  Created by MMI SOFTWARE on 06/06/19.
//  Copyright © 2019 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class SWRevealViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SWRevealViewController *viewController;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@end

