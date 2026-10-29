//
//  UserDefaultsManager.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 03/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "UserDefaultsManager.h"

@implementation UserDefaultsManager

+ (void)saveString:(NSString *)value forKey:(NSString *)key {
    if (value != nil && key != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize]; // Synchronize to persist the changes
    }
}

+ (NSString *)getStringForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

@end


//How to use This Class
/*
 #import "UserDefaultsManager.h"
 
 //This code use in method
 // Save user preferences
 [UserDefaultsManager saveString:@"John Doe" forKey:@"username"];
 
 // Retrieve the saved username
 NSString *username = [UserDefaultsManager getStringForKey:@"username"];
 NSLog(@"Username: %@", username);
 */
