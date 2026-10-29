//
//  HelpVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 16/07/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface HelpVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tblView;
    IBOutlet UIView *view_content;
}

@end
