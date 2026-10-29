//
//  ApprovalDetailItem.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 21/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "ApprovalDetailItem.h"

@implementation ApprovalDetailItem

+ (instancetype)itemFromJSON:(NSDictionary *)json {
    ApprovalDetailItem *item = [[ApprovalDetailItem alloc] init];
    item.username = json[@"username"] ?: @"";
    item.ino = json[@"ino"] ?: @"";
    item.wtf = json[@"wtf"] ?: @"";
    item.wtt = json[@"wtt"] ?: @"";
    item.amtf = json[@"amtf"] ?: @"";
    item.amtt = json[@"amtt"] ?: @"";
    item.dtimef = json[@"dtimef"] ?: @"";
    item.dtimet = json[@"dtimet"] ?: @"";
    item.hours = json[@"hours"] ?: @"";
    item.status = json[@"STATUS"] ?: @"";
    return item;
}

@end
