//
//  Showitem.h
//  MMI ECAT
//
//  Created by mmsoft116 on 14/09/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SupportFile/Cell/CartCustomCell.h"
#import "SWRevealViewController.h"
#import "LoginVC.h"
#import "BBBadgeBarButtonItem.h"
#import "BaseViewController.h"

#define CELL_COUNT 30
#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"


@interface Showitem : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource>
{

    IBOutlet UILabel *lbl_welcome;
    IBOutlet UIButton *btn_Short;
    IBOutlet UIButton *btn_SelectAllCheckMark;
    NSMutableArray *arrayMasterProductList;
    NSMutableArray *nsarray_product;
    NSMutableArray *nsarray_qty;
    NSMutableArray * ns_check;
    NSMutableArray * ns_tgno;
    NSMutableArray *selectedItems;
    
    NSString *category;
    UIView *transparentView;

    UIView* view1;
    UITextField* text_count;
    NSInteger index_cart;
    UITextField *text_remarks;
    NSString *tsnolist;
}

@property (strong, nonatomic) IBOutlet NSArray *arrayCategoryList;
@property (strong, nonatomic) IBOutlet NSString *categoryId;

@property (strong, nonatomic) IBOutlet UIView *categoryView;
@property (strong, nonatomic) IBOutlet UICollectionView *categoryCollectionView;
@property (strong, nonatomic) IBOutlet UILabel *lblCategoryName;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalItem;
@property (nonatomic, retain) NSString *str_idesc;
@property (nonatomic, retain) NSString *str_siteid;
@property (nonatomic, retain) NSString *str_designno;
@property (nonatomic, retain) NSString *str_gwt;
@property (nonatomic, retain) NSString *str_nwt;
@property (nonatomic, retain) NSString *str_dwt;
@property (nonatomic, retain) NSString *str_swt;
@property (nonatomic, retain) NSString *str_mrp;
@property (nonatomic, retain) NSString *str_activity;
@property (nonatomic, retain) NSString *str_tsnolist;

@property (nonatomic, retain) IBOutlet UIButton *btn_Share;
@property (nonatomic, retain) IBOutlet UIButton *btn_Type;
- (IBAction)btn_share:(id)sender;
@property (nonatomic, retain) IBOutlet UIButton *btn_Next;
@property (nonatomic, retain) IBOutlet UIButton *btn_Prev;

@end

