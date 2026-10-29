//
//  ProductGroup.h
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 27/07/22.
//  Copyright © 2022 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCell.h"
#import "SWRevealViewController.h"
#import "LoginVC.h"
#import "Showitem.h"
#import "BaseViewController.h"


#define CELL_COUNT 30
#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"

#define LABEL_TAG 100001
#define LABEL_TAG_lblEventNarr 100001
#define LABEL_TAG_2 100001
#define LABEL_TAG_3 100001
#define LABEL_TAG_4 100001

@interface ProductGroup : BaseViewController<UITableViewDelegate, UITableViewDataSource>
{

    IBOutlet UILabel *lbl_welcome;
    NSMutableArray *nsarray_product;

    NSString *category;
    NSString *tsnolist;
    NSString *str_siteid;
    UIButton *btn_Filter;
    
    NSMutableArray *arrayFilterList;
    UITableView *filterTableView;
    UIAlertController *filterAlertType;
}

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) NSString *str_tsnolist;
@property (nonatomic, retain) NSString *str_activity;

@end

