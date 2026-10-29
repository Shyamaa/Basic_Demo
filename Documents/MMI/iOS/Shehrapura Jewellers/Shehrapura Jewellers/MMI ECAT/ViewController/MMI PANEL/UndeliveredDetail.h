//
//  UndeliveredDetail.h
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 24/07/23.
//  Copyright © 2023 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "MMIHOMEPanel.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UndeliveredDetail : BaseViewController
{
    NSMutableArray *array_itrnid;
    NSMutableArray *array_idesc;
    NSMutableArray *array_iwt;
    NSMutableArray *array_actualwt;
    NSMutableArray *array_unit;
    NSMutableArray *array_tno;

    NSMutableArray *array_additrn;

    IBOutlet UILabel *lbl_wt;
    IBOutlet UILabel *lbl_wt1;
    NSString *designparam;
}
@property (nonatomic, retain) NSString *str_trnid;
@property (nonatomic, retain) NSString *str_cname;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btn_save:(id)sender;

@end

NS_ASSUME_NONNULL_END
