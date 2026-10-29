//
//  PopupBankdetail.h
//  Jewel Desk
//
//  Created by App Dev on 20/07/24.
//  Copyright © 2024 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaddedTextField.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PopupBankdetail : BaseViewController

@property (nonatomic, copy) void (^completionHandler)(NSString *acname,NSString *acnumber,NSString *bankname,NSString *branch,NSString *ifsc,NSString *gstin,NSString *upi,NSString *acname2,NSString *acnumber2,NSString *bankname2,NSString *branch2,NSString *ifsc2);
@property (nonatomic, strong) NSMutableArray<PaddedTextField *> *textFields;

@property (nonatomic, strong) NSDictionary *dicBankData;

@end

NS_ASSUME_NONNULL_END
