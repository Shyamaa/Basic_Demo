//
//  ItemListVC.h
//  Aslomal Vijay Kumar
//
//  Created by Suresh Kumar on 20/07/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCell.h"
#import "KIImagePager.h"
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

@interface ItemListVC : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UILabel *lbl_welcome;

    NSMutableArray *nsarray_slider1;
    NSMutableArray *array_item;
    NSMutableArray *array_qty;

    NSInteger index_cart;
    NSString *str_price;
    NSString *product_id;
}

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView_slider;
@property (strong, nonatomic) IBOutlet UITableView *tableView_Order;
@property (nonatomic, retain) NSString *str_categoryid;
@property (nonatomic, retain) NSString *str_name;


@end

NS_ASSUME_NONNULL_END
