//
//  AppCoordinator.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 23/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "AppCoordinator.h"
#import "Constants.h"
#import "webUrlconstant.h"
#import "LoginVC.h"
#import "HomeVC.h"
#import "MMIHOMEPanel.h"
#import "MainActivity.h"
#import "Gautom_HomeVC.h"
#import "MCX_RATE.h"
#import "SWRevealViewController.h"
#import "RearViewController.h"


@implementation AppCoordinator {
    UIWindow *_window;
}

- (instancetype)initWithWindow:(UIWindow *)window {
    self = [super init];
    if (self) {
        _window = window;
    }
    return self;
}

- (void)start {
    UIViewController *frontVC = [self determineRootViewController];
    UINavigationController *frontNav = [[UINavigationController alloc] initWithRootViewController:frontVC];

    RearViewController *rearVC = [[RearViewController alloc] init];
    UINavigationController *rearNav = [[UINavigationController alloc] initWithRootViewController:rearVC];

    SWRevealViewController *revealVC = [[SWRevealViewController alloc] initWithRearViewController:rearNav frontViewController:frontNav];
    _window.rootViewController = revealVC;
    [_window makeKeyAndVisible];
    _window.backgroundColor = UIColor.whiteColor;
}

- (UIViewController *)determineRootViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardMain bundle:nil];
    webUrlconstant *webConst = [webUrlconstant sharedInstance];

    NSString *appType = [webConst APPTYPE];
    NSString *mcxRate = [webConst APPTYPE_MCX];
    NSString *mobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"mobile"];
    NSString *template = [[NSUserDefaults standardUserDefaults] stringForKey:@"template"];

    if ([appType isEqualToString:kAppTypeCustomer]) {
        if (!mobile) {
            return [storyboard instantiateViewControllerWithIdentifier:[mcxRate isEqualToString:@"1"] ? kVCLogin : kVCHome];
        } else {
            if ([mcxRate isEqualToString:@"1"]) {
                return [storyboard instantiateViewControllerWithIdentifier:kVCMCXRate];
            } else {
                //return [storyboard instantiateViewControllerWithIdentifier: [template isEqualToString:@"2"] ? kVCGautomHome : kVCMainActivity];
                return [storyboard instantiateViewControllerWithIdentifier: kVCGautomHome];
            }
        }
    } else {
        if (!mobile) {
            return [storyboard instantiateViewControllerWithIdentifier:kVCLogin];
        } else {
            return [storyboard instantiateViewControllerWithIdentifier:kVCMMIHome];
        }
    }
}

@end
