//
//  MyCell.h
//  TestCollectionViewWithXIB
//
//  Created by Quy Sang Le on 2/3/13.
//  Copyright (c) 2013 Quy Sang Le. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;

@property (strong, nonatomic) UIActivityIndicatorView* activityIndicator;
@property(strong,nonatomic) NSString *labelText;

@property (strong, nonatomic) IBOutlet UILabel *lbl_counter;
@property (strong, nonatomic) IBOutlet UILabel *lbl_design;

@property (strong, nonatomic) IBOutlet UIButton *btn_zoomview;
@property (strong, nonatomic) IBOutlet UIView *back_view;
@property (strong, nonatomic) IBOutlet UIView *title_view;

@property (strong, nonatomic) IBOutlet UILabel *lblItemTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;

@property (strong, nonatomic) IBOutlet UILabel *lbl_data;
@property (strong, nonatomic) IBOutlet UILabel *lbl_tgno;
@property (strong, nonatomic) IBOutlet UIImageView *imgeDataArray;
@property (strong, nonatomic) IBOutlet UIButton *btn_check;
@property (strong, nonatomic) IBOutlet UIButton *btn_addcart;
@property (strong, nonatomic) IBOutlet UIButton *btn_whatsup;

@end
