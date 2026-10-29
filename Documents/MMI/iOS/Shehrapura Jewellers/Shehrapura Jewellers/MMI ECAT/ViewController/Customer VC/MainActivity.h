//
//  MainActivity.h
//  MMI ECAT
//
//  Created by mmsoft116 on 04/09/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCell.h"
#import "SWRevealViewController.h"
#import "LoginVC.h"
#import "ProductGallery.h"
#import "Contactus.h"
#import "Reference.h"
#import "NotificationVC.h"
#import "WebActivity.h"
#import "SubMenu.h"
#import "BankDetail.h"
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


@interface MainActivity : BaseViewController<UINavigationControllerDelegate>
{

    IBOutlet UILabel *lbl_welcome;
    NSMutableArray *nsarray_homeid;
    NSMutableArray *nsarray_image;
    NSMutableArray *nsarray_type;
    NSMutableArray *nsarray_caption;
    NSString *category;
    
    NSMutableArray *nsarray_subid;
    NSMutableArray *nsarray_menutype;
    NSMutableArray *nsarray_clickurl;
    NSMutableArray *array_bannerlist;
    NSMutableArray *array_groupid;

}

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
