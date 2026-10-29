//
//  OrderDetailsInfo.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 04/10/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "BaseViewController.h"

@interface OrderDetailsInfo : BaseViewController
{
    IBOutlet UIImageView *imgItemImage;
    IBOutlet UILabel *lblOrderId;
    IBOutlet UILabel *lblItemName;
    IBOutlet UILabel *lblQuantity;
    IBOutlet UILabel *lblOrderDate;
    IBOutlet UILabel *lblDueDate;
    IBOutlet UILabel *lblStatus;
}

@property (nonatomic, retain) NSDictionary *dicItemData;

@end

