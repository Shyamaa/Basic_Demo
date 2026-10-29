//
//  SetStuddVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 26/06/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#ifndef SetStuddVC_h
#define SetStuddVC_h

@interface SetStuddVC : BaseViewController
{
    NSMutableArray *tblListData;
    IBOutlet UITableView *tblview;
}
@property (nonatomic, assign) BOOL openWithSidMenu;
@end
#endif /* SetStuddVC_h */
