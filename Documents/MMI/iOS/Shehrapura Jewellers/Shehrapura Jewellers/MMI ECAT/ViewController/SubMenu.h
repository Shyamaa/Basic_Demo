//
//  SubMenu.h
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 25/02/22.
//  Copyright © 2022 MMI Softwares. All rights reserved.
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

@interface SubMenu : BaseViewController
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


}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) NSString *itemid;
@property (nonatomic, retain) NSString *activity;

@end

