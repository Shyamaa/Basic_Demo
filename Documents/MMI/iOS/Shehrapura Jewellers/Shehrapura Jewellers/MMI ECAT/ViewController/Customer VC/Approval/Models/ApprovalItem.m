//
//  ApprovalItem.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 21/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "ApprovalItem.h"

@implementation ApprovalItem

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _username = dict[@"username"];
        _mobile = dict[@"mobile"];
        _dateFrom = dict[@"dtimef"];
        _dateTo = dict[@"dtimet"];
        _hours = dict[@"hours"];
        _status = dict[@"STATUS"];
        _demid = dict[@"demid"];
    }
    return self;
}

@end
