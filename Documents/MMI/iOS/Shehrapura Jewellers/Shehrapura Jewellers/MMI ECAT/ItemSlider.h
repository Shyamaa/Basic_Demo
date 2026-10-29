//
//  ItemSlider.h
//  MU JEWELLERS
//
//  Created by MMI SOFTWARES PVT LTD on 18/08/22.
//  Copyright © 2022 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCell.h"
#import "SWRevealViewController.h"
#import "LoginVC.h"
#import "BBBadgeBarButtonItem.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "WalletVC.h"
#import "WalletHistoryVC.h"
#import "ItemListVC.h"
#import "ViewController/CartList/CartList.h"
#import "ItemDetail.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItemSlider : BaseViewController<UITextFieldDelegate,NSURLConnectionDelegate,UICollectionViewDataSource,UICollectionViewDataSource,UIGestureRecognizerDelegate>
{
    
    IBOutlet UILabel *lbl_welcome;
    NSString *category;
    UIView *transparentView;

    UIView* view1;
    UITextField* text_count;
    NSInteger index_cart;
    UITextField *text_remarks;
    NSString *tsnolist;
    NSInteger intscrollitem;

    __weak IBOutlet UIButton *btn_next;
    
    __weak IBOutlet UIButton *btn_prvs;
}

@property(strong,nonatomic) NSMutableArray *nsarray_product;
@property(strong,nonatomic) NSMutableArray *arrayMasterProductList;
@property(strong,nonatomic) NSMutableArray *nsarray_qty;

@property(strong,nonatomic)IBOutlet NSString *strindex;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSString *str_idesc;
@property (nonatomic, retain) NSString *str_designno;
@property (nonatomic, retain) NSString *str_gwt;
@property (nonatomic, retain) NSString *str_nwt;
@property (nonatomic, retain) NSString *str_dwt;
@property (nonatomic, retain) NSString *str_swt;
@property (nonatomic, retain) NSString *str_mrp;
@property (nonatomic, retain) NSString *str_activity;
@property (nonatomic, retain) NSString *str_tsnolist;

- (IBAction)btn_next:(id)sender;
- (IBAction)btn_prvs:(id)sender;

@end

NS_ASSUME_NONNULL_END
