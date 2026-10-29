//
//  AddDesign.h
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 29/10/22.
//  Copyright © 2022 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "webUrlconstant.h"
#import <Photos/Photos.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddItemActivity : BaseViewController<UIImagePickerControllerDelegate,UIPickerViewDelegate,UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate> 
{
    IBOutlet UIImageView *img_add;
    IBOutlet UIImageView *img_add2;
    IBOutlet UIImageView *img_add3;
    IBOutlet UIImageView *img_add4;
    IBOutlet UIImageView *img_add5;
    IBOutlet UIButton *btn_item;
    IBOutlet UIScrollView *scrollview;
    IBOutlet UIView *view_img;
    IBOutlet UILabel *lbl_tag;
    
    IBOutlet UIView *view_content;
    
    IBOutlet UITextField *txt_name;
    IBOutlet UITextField *txt_tgno;
    IBOutlet UITextField *txt_stamp;
    IBOutlet UITextField *txt_gwt;
    IBOutlet UITextField *txt_nwt;
    IBOutlet UITextField *txt_stonewt;
    IBOutlet UITextField *txt_diawt;
    IBOutlet UITextField *txt_mrp;
    IBOutlet UITextField *txt_gst;
    IBOutlet UITextField *txt_remark;
    IBOutlet UITextField *txt_youtube;
   
    IBOutlet UIStackView *itemDetailsView;
    
    NSMutableArray *array_idesc;
    NSMutableArray *array_tpre;

    UIImagePickerController *pickerControllerGallery;
    UIImagePickerController *pickerControllerCamera;
    
   // NSString *filename;
    
    UITableView *alertTableView;
    UIAlertController *alertController;
    
    NSString * str_tgno;
    NSString * str_tpre;
    UIImageView * img_item;
}

- (IBAction)txt_item:(id)sender;
@property (nonatomic, strong) IBOutlet UICollectionView *bannerCollectionView;

@property (strong, nonatomic) NSMutableArray *imagesArray;
@property (strong, nonatomic) UIImageView *selectedImageView;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong,nonatomic) NSString *str_tag;
@property (strong,nonatomic) NSString *str_imgurl;
@property (strong,nonatomic) NSString *str_activity;
@property (strong,nonatomic) NSString *str_imgurl2;
@property (strong,nonatomic) NSString *str_imgurl3;
@property (strong,nonatomic) NSString *str_imgurl4;
@property (strong,nonatomic) NSString *str_imgurl5;

@property (strong,nonatomic) NSString *str_min_stock;
@property(strong,nonatomic) NSString *str_tgno;
@property(strong,nonatomic) NSString *str_gwt;
@property(strong,nonatomic) NSString *str_wt;
@property(strong,nonatomic) NSString *str_sstnwt;
@property(strong,nonatomic) NSString *str_sdiawt;
@property(strong,nonatomic) NSString *str_mrp;
@property(strong,nonatomic) NSString *str_salemrp;

@property(strong,nonatomic) NSString *str_stamp;
@property(strong,nonatomic) NSString *str_gst;
@property(strong,nonatomic) NSString *str_idesc;

@property(strong,nonatomic) NSString *astr_ctivity;
@property(strong,nonatomic) NSString *str_remarks;
@property(strong,nonatomic) NSString *str_tgimage;
@property(strong,nonatomic) NSString *str_tpre;

- (IBAction)btn_item:(id)sender;

- (IBAction)btn_save:(id)sender;
@end

NS_ASSUME_NONNULL_END
