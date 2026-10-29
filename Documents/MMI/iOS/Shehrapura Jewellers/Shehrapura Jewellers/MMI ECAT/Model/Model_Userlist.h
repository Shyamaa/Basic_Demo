//
//  Model_Userlist.h
//  Jewel Desk
//
//  Created by App Dev on 18/07/24.
//  Copyright © 2024 MMI Softwares. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Model_Userlist : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *emailid;
@property (nonatomic, strong) NSString *imgurl;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *cdate;
@property (nonatomic, strong) NSString *interested;
@property (nonatomic, strong) NSString *mdob;

@end

NS_ASSUME_NONNULL_END
