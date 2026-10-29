//
//  FeedbackVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 23/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface FeedbackVC : BaseViewController<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
{
    NSMutableArray *arraytblListData;
    NSMutableArray *arrayMasterListData;
    
    IBOutlet UITableView *tableview;
    IBOutlet UISearchBar *searchBar;
    
    IBOutlet UIView *replyView;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblMsg;
    IBOutlet UITextView *txtViewMsg;
    
}

@end

