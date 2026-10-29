//
//  MMIHOMEPanel.h
//  Jwelly Customer
//
//  Created by Apple on 11/6/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCell.h"
#import "SWRevealViewController.h"
#import "LoginVC.h"
#import "ProductGroup.h"
#import "BaseViewController.h"
#import "Showitem.h"

@interface MMIHOMEPanel : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegate>
{
    IBOutlet UILabel *lbl_welcome;
    NSMutableArray *ns_banner;
    NSMutableArray *ns_item;
}

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UICollectionView *bannerCollectionView;
@property (nonatomic,strong) IBOutlet NSMutableArray *arrayAdapterEcatid;

@end
