//
//  UIAppearanceManager.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 23/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "UIAppearanceManager.h"
#import <UIKit/UIKit.h>

@implementation UIAppearanceManager

+ (void)setupAppearance {
    
    CGFloat baseSize = 16.0;
    switch ([UIDevice currentDevice].userInterfaceIdiom) {
        case UIUserInterfaceIdiomPad:
            baseSize = 24.0;
            break;
        case UIUserInterfaceIdiomPhone:
            baseSize = 18.0;
            break;
        default:
            baseSize = 18.0;
            break;
    }
    
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    [appearance configureWithOpaqueBackground];
    appearance.backgroundColor = [UIColor colorNamed:@"appRed_Color"];
    appearance.titleTextAttributes = @{
        NSForegroundColorAttributeName: [UIColor whiteColor],
        NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:baseSize]
    };

    [[UINavigationBar appearance] setStandardAppearance:appearance];
    [[UINavigationBar appearance] setScrollEdgeAppearance:appearance];
    [[UINavigationBar appearance] setCompactAppearance:appearance];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    // Similarly, you can add status bar style, tab bar, buttons, etc.
}

/*
 + (void)setupAppearance {
     [[UINavigationBar appearance] setBarTintColor:[UIColor colorNamed:@"appRed_Color"]];
     [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
     [[UINavigationBar appearance] setTitleTextAttributes:@{
         NSForegroundColorAttributeName: [UIColor whiteColor],
         NSFontAttributeName: [UIFont systemFontOfSize:18.0 weight:UIFontWeightSemibold]
     }];
 }
 */

@end


