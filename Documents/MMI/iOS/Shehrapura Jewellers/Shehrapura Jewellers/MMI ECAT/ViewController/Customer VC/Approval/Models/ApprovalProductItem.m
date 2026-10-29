//
//  ApprovalProductItem.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 21/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "ApprovalProductItem.h"

@implementation ApprovalProductItem

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _imgUrl = dict[@"img"];
        _tgno = dict[@"tgno"];
        _tsno = dict[@"tsno"];
        _wt = dict[@"wt"];
        _gwt = dict[@"gwt"];
        _salemrp = dict[@"salemrp"];
        _select = dict[@"select"];
        // ✅ Set selected based on select string ("1" means selected)
        _selected = [_select isEqualToString:@"1"];
    }
    return self;
}

@end

