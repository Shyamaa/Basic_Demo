//
//  ApprovalProductListVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 21/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CustomPopUp.h"
#import "BaseViewController.h"
#import "ApprovalDetailItem.h"
#import "ApprovalProductItem.h"

@interface ApprovalProductListVC : BaseViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSDictionary *filterParams;
@end
