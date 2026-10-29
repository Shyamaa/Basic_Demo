//
//  SendAlertManagementVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 31/07/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SendAlertManagementVC : BaseViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
{
    NSMutableArray *filterUserListData;
    NSMutableArray *areaListData;
    NSMutableArray *categoryListData;
    
    IBOutlet UITextView *txtView;
    IBOutlet UITableView *tblView;
    
    IBOutlet UIView *filterView;
    IBOutlet UITextField *txtSearchArea;
    IBOutlet UITextField *txtClosingDay;
    IBOutlet UITextField *txtCategory;
}

@property (nonatomic, copy) void (^onCloseTapped)(void);

@end
