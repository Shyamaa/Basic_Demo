//
//  ApprovalItem.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 21/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface ApprovalItem : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *dateFrom;
@property (nonatomic, strong) NSString *dateTo;
@property (nonatomic, strong) NSString *hours;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *demid;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

