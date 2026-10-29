//
//  ProductGallery.h
//  MMI ECAT
//
//  Created by mmsoft116 on 05/09/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
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



NS_ASSUME_NONNULL_BEGIN


@interface ProductGallery : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource>
{

    IBOutlet UILabel *lbl_welcome;
    NSMutableArray *arrayMasterProductList;
    NSMutableArray *nsarray_product;
    NSArray *arrayFilter;
    NSString *category;
    NSString *tsnolist;
}

@property (strong, nonatomic) IBOutlet UISearchBar *searchBarView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIView *filterView;
@property (strong, nonatomic) IBOutlet UITextField *txtFilter;

@property (nonatomic, retain) NSString *str_igroup;
@property (nonatomic, retain) NSString *str_activity;
@property (nonatomic, retain) NSString *str_tsnolist;
@property (nonatomic, retain) NSString *str_siteid;

@property (nonatomic, assign) BOOL openWithSidMenu;

- (IBAction)btnAction_Catalogue:(id)sender;
- (IBAction)btnAction_Visitor:(id)sender;
- (IBAction)btnAction_Estimate:(id)sender;
- (IBAction)btnAction_Stock:(id)sender;

@end

NS_ASSUME_NONNULL_END
