//
//  ObjectSiteModel.h
//  Jewel Desk
//
//  Created by App Dev on 24/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjectSiteModel : NSObject
@property (nonatomic, strong) NSString *sitename;
@property (nonatomic, strong) NSString *siteid;

- (instancetype)initWithName:(NSString *)name siteid:(NSString *)siteid;


@end

NS_ASSUME_NONNULL_END
