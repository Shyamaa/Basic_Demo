//
//  Gautom_HomeVC.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 05/07/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface Gautom_HomeVC : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegate>
{
    IBOutlet UILabel *lbl_Category;
    IBOutlet UILabel *lbl_B;
    IBOutlet UIButton *btn_Title;
    NSMutableArray *menuItemList;
    NSMutableArray *moreItemList;
    NSMutableArray *bannerList;
    NSMutableArray *itemList;
    NSTimer *autoScrollTimer;
}

@property (nonatomic, strong) IBOutlet UICollectionView *bannerCollectionView;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end
