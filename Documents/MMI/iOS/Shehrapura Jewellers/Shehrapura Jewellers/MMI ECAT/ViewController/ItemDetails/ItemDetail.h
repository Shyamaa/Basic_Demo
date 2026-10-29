//
//  ItemDetail.h
//  Jwelly Customer
//
//  Created by mmsoft116 on 06/10/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imgfullVC.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItemDetail : BaseViewController <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate>
{
    IBOutlet UIImageView *head_img;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIScrollView *scrollView_tableView;

    IBOutlet UILabel *lbl_key1;
    IBOutlet UILabel *lbl_key2;
    IBOutlet UILabel *lbl_key3;
    IBOutlet UILabel *lbl_key4;
    IBOutlet UILabel *lbl_key5;
    IBOutlet UILabel *lbl_key6;
    IBOutlet UILabel *lbl_key7;
    IBOutlet UILabel *lbl_key8;
    IBOutlet UILabel *lbl_key9;
    IBOutlet UILabel *lbl_key10;
    IBOutlet UILabel *lbl_key11;
    IBOutlet UILabel *lbl_key12;
    IBOutlet UILabel *lbl_key13;
    IBOutlet UILabel *lbl_key14;
    IBOutlet UILabel *lbl_key15;
    IBOutlet UILabel *lbl_key16;
    IBOutlet UILabel *lbl_key17;
    IBOutlet UILabel *lbl_key18;
    IBOutlet UILabel *lbl_key19;
    IBOutlet UILabel *lbl_key20;
    IBOutlet UILabel *lbl_key21;

    IBOutlet UILabel *lbl_value1;
    IBOutlet UILabel *lbl_value2;
    IBOutlet UILabel *lbl_value3;
    IBOutlet UILabel *lbl_value4;
    IBOutlet UILabel *lbl_value5;
    IBOutlet UILabel *lbl_value6;
    IBOutlet UILabel *lbl_value7;
    IBOutlet UILabel *lbl_value8;
    IBOutlet UILabel *lbl_value9;
    IBOutlet UILabel *lbl_value10;
    IBOutlet UILabel *lbl_value11;
    IBOutlet UILabel *lbl_value12;
    IBOutlet UILabel *lbl_value13;
    IBOutlet UILabel *lbl_value14;
    IBOutlet UILabel *lbl_value15;
    IBOutlet UILabel *lbl_value16;
    IBOutlet UILabel *lbl_value17;
    IBOutlet UILabel *lbl_value18;
    IBOutlet UILabel *lbl_value19;
    IBOutlet UILabel *lbl_value20;
    IBOutlet UILabel *lbl_value21;
    

    NSMutableArray * nsarray_data;
    NSMutableArray * nsarray_datadata;
    NSString *str_item_width1;
    NSString *str_item_width2;
    NSString *str_item_width3;
    NSString *str_item_width4;
    NSString *str_item_width5;
    NSString *str_item_width6;
    NSString *str_item_width7;
    NSString *str_item_width8;
    NSString *str_item_width9;
    NSString *str_item_width10;
    NSString *str_item_width11;
    NSString *str_item_width12;
    NSString *str_item_width13;
    NSString *str_item_width14;
    NSString *str_item_width15;
    NSString *str_item_width16;
    NSString *str_item_width17;
    NSString *str_item_width18;
    NSString *str_item_width19;
    NSString *str_item_width20;
    
    NSString *str_item_name1;
    NSString *str_item_name2;
    NSString *str_item_name3;
    NSString *str_item_name4;
    NSString *str_item_name5;
    NSString *str_item_name6;
    NSString *str_item_name7;
    NSString *str_item_name8;
    NSString *str_item_name9;
    NSString *str_item_name10;
    NSString *str_item_name11;
    NSString *str_item_name12;
    NSString *str_item_name13;
    NSString *str_item_name14;
    NSString *str_item_name15;
    NSString *str_item_name16;
    NSString *str_item_name17;
    NSString *str_item_name18;
    NSString *str_item_name19;
    NSString *str_item_name20;
  
    NSMutableArray * ns_item1;
    NSMutableArray * ns_item2;
    NSMutableArray * ns_item3;
    NSMutableArray * ns_item4;
    NSMutableArray * ns_item5;
    NSMutableArray * ns_item6;
    NSMutableArray * ns_item7;
    NSMutableArray * ns_item8;
    NSMutableArray * ns_item9;
    NSMutableArray * ns_item10;
    NSMutableArray * ns_item11;
    NSMutableArray * ns_item12;
    NSMutableArray * ns_item13;
    NSMutableArray * ns_item14;
    NSMutableArray * ns_item15;
    NSMutableArray * ns_item16;
    NSMutableArray * ns_item17;
    NSMutableArray * ns_item18;
    NSMutableArray * ns_item19;
    NSMutableArray * ns_item20;
    NSInteger int_width1;
    NSInteger int_width2;
    NSInteger int_width3;
    NSInteger int_width4;
    NSInteger int_width5;
    NSInteger int_width6;
    NSInteger int_width7;
    NSInteger int_width8;
    NSInteger int_width9;
    NSInteger int_width10;
    NSInteger int_width11;
    NSInteger int_width12;
    NSInteger int_width13;
    NSInteger int_width14;
    NSInteger int_width15;
    NSInteger int_width16;
    NSInteger int_width17;
    NSInteger int_width18;
    NSInteger int_width19;
    NSInteger int_width20;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewWidth;

@property (strong, nonatomic) NSString *str_idesc;
@property (strong, nonatomic) NSString *str_image;
@property (strong, nonatomic) NSString *str_image2;
@property (strong, nonatomic) NSString *str_image3;
@property (strong, nonatomic) NSString *str_image4;
@property (strong, nonatomic) NSString *str_image5;
@property (strong, nonatomic) NSString *str_tagno;
@property (strong, nonatomic) NSString *str_gwt;
@property (strong, nonatomic) NSString *str_qty;
@property (strong, nonatomic) NSString *str_tpre;
@property (strong, nonatomic) NSString *str_design;
@property (strong, nonatomic) NSString *str_tsno;
@property (strong, nonatomic) NSString *str_item1;
@property (strong, nonatomic) NSString *str_item2;
@property (strong, nonatomic) NSString *str_item3;
@property (strong, nonatomic) NSString *str_item4;
@property (strong, nonatomic) NSString *str_rlid;
@property (strong, nonatomic) NSString *str_remarks;
@property (strong, nonatomic) NSString *str_shpc;
@property (strong, nonatomic) NSString *str_stamp;
@property (strong, nonatomic) NSString *str_tgimage;
@property (strong, nonatomic) NSString *str_wt1;
@property (strong, nonatomic) NSString *str_status;


@end

NS_ASSUME_NONNULL_END
