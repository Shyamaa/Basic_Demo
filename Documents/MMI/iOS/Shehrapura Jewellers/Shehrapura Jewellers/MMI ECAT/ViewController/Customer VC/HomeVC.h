//
//  HomeVC.h
//  AirMobileShop
//
//  Created by MMI SOFTWARE on 07/06/19.
//  Copyright © 2019 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "LoginVC.h"
#import "WebActivity.h"
#import "SubMenu.h"
#import "KIImagePager.h"
#import "Brochures.h"
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

@interface HomeVC : BaseViewController
{
    IBOutlet UILabel *lbl_welcome;
    NSMutableArray *nsarray_homeid;
    NSMutableArray *nsarray_image;
    NSMutableArray *nsarray_type;
    NSMutableArray *nsarray_caption;
    NSMutableArray *nsarray_apppassword;
    NSMutableArray *nsarray_subid;
    NSMutableArray *nsarray_menutype;
    NSMutableArray *nsarray_clickurl;
    NSMutableArray *array_bannerlist;

}
@property (strong, nonatomic) IBOutlet UICollectionView *bannerCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


@end



NS_ASSUME_NONNULL_END
