//
//  Brochures.h
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 03/12/21.
//  Copyright © 2021 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
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

@interface Brochures : BaseViewController
{
    NSMutableArray *nsarray_brochuresid;
    NSMutableArray *nsarray_name;
    NSMutableArray *nsarray_imgurl;
}

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) BOOL openWithSidMenu;


@end

