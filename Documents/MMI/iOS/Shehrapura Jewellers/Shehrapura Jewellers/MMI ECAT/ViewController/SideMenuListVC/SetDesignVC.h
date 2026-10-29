//
//  SetDesignVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 26/06/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#ifndef SetDesignVC_h
#define SetDesignVC_h

@interface SetDesignVC : BaseViewController<UITextFieldDelegate>
{
    NSMutableArray *tblListData;
    NSMutableArray *selectDataList;
    
    IBOutlet UITableView *tblview;
}
@property (nonatomic, assign) BOOL openWithSidMenu;
@end
#endif /* SetDesignVC_h */
