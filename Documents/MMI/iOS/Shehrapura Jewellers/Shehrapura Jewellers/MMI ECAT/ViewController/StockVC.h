//
//  StockVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 29/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface StockVC : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    
    NSMutableArray *stockListData;
    NSMutableArray *scannedListData;
    NSMutableArray *conflictListData;
    NSMutableArray *unknownListData;
    NSMutableArray *scanIdListData;
    
    IBOutlet UIButton *btnTitleDetails;
    
    IBOutlet UILabel *lblStock;
    IBOutlet UILabel *lblScanned;
    IBOutlet UILabel *lblConflict;
    IBOutlet UILabel *lblUnknow;
    
    IBOutlet UITableView *stockTblView;
    IBOutlet UITableView *scannedTblView;
    IBOutlet UITableView *conflictTblView;
    IBOutlet UITableView *unknownTblView;
    
    IBOutlet UILabel *lblInfo;
    
    IBOutlet UIView *scanIdListView;
    IBOutlet UITableView *scanIdListTblView;
}

@end
