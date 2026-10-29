//
//  UserDefaultsManager.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 03/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsManager : NSObject

// Save a string value to user defaults
+ (void)saveString:(NSString *)value forKey:(NSString *)key;

// Retrieve a string value from user defaults
+ (NSString *)getStringForKey:(NSString *)key;

@end
