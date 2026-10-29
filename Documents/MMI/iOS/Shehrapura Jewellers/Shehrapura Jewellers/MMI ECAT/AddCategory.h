//
//  AddCategory.h
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

@interface AddCategory : BaseViewController<UIImagePickerControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    IBOutlet UIStackView *categoryStackView;
    IBOutlet UIStackView *groupStackView;
    
    IBOutlet UIView *view_img;
    IBOutlet UIImageView *img_add;
    
    IBOutlet UITextField *txt_item;
    IBOutlet UITextField *txt_prefix;
    
    IBOutlet UIButton *btn_category;
    IBOutlet UIButton *btn_group;
    
    IBOutlet UILabel *lbl_group;
    IBOutlet UILabel *lbl_category;

    UIImagePickerController *pickerControllerGallery;
    UIImagePickerController *pickerControllerCamera;
    
    UIAlertController *alertController;
    UIAlertController *ac_group;
    
    UITableView *alertTableView;
    UITableView *tableview_group;
    
    NSMutableArray * array_category;
    NSMutableArray * array_group;
    
    NSString *filename;
    NSString * str_catedata;
}

@property (nonatomic, copy) void (^onValueSelected)(NSString *value);

@property(weak,nonatomic) NSDictionary *preCategoryData;

@property (strong, nonatomic) IBOutlet UIButton *btn_check;

- (IBAction)btn_category:(id)sender;
- (IBAction)btn_group:(id)sender;

- (IBAction)btn_save:(id)sender;
@end

NS_ASSUME_NONNULL_END
