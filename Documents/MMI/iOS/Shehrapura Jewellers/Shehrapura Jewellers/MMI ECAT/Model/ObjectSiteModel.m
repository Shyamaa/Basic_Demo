//
//  ObjectSiteModel.m
//  Jewel Desk
//
//  Created by App Dev on 24/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "ObjectSiteModel.h"

@implementation ObjectSiteModel

- (instancetype)initWithName:(NSString *)name siteid:(NSString *)siteid {
    self = [super init];
    if (self) {
        _sitename = name;
        _siteid = siteid;
    }
    return self;
}
@end
