//
//  ApprovalDetailItem.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 21/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApprovalDetailItem : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *ino;
@property (nonatomic, copy) NSString *wtf;
@property (nonatomic, copy) NSString *wtt;
@property (nonatomic, copy) NSString *amtf;
@property (nonatomic, copy) NSString *amtt;
@property (nonatomic, copy) NSString *dtimef;
@property (nonatomic, copy) NSString *dtimet;
@property (nonatomic, copy) NSString *hours;
@property (nonatomic, copy) NSString *status;

+ (instancetype)itemFromJSON:(NSDictionary *)json;

@end

