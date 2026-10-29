//
//  ApprovalProductItem.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 21/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApprovalProductItem : NSObject

@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *tgno;
@property (nonatomic, copy) NSString *tsno;
@property (nonatomic, copy) NSString *wt;
@property (nonatomic, copy) NSString *gwt;
@property (nonatomic, copy) NSString *salemrp;
@property (nonatomic, copy) NSString *select;
@property (nonatomic, assign) BOOL selected;

- (instancetype)initWithDictionary:(NSDictionary *)json;

@end


