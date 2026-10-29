//
//  ItemDetail.m
//  Jwelly Customer
//
//  Created by mmsoft116 on 06/10/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "ItemDetail.h"
#import "BusyIndicator.h"
#import "ImageCache.h"
#import "webUrlconstant.h"
#import "BBBadgeBarButtonItem.h"
#import "CartList.h"


@interface ItemDetail ()
{
    UIButton * btnAdd_Cart;
}
@end

@implementation ItemDetail
@synthesize str_item1,str_qty,str_gwt,str_wt1,str_rlid,str_shpc,str_tpre,str_tsno,str_idesc,str_image,str_item2,str_item3,str_item4,str_stamp,str_tagno,str_design,str_image2,str_image3,str_image4,str_image5,str_status,str_remarks,str_tgimage;

#pragma mark: - Class Method

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    [self setUpNavigationButton];
    [self setUpView];
    [self scrollData_Category];
    [self scrollData_STUDD];
    //[self.view addSubview:scrollView];
}

-(void)viewWillAppear:(BOOL)animated{
    [self CHECK_COUNTER];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

#pragma mark:- Navigation Setup

- (void)setUpNavigationButton {
    btnAdd_Cart =  [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd_Cart.frame = CGRectMake(0,5,30,30);
    [btnAdd_Cart setImage:[UIImage imageNamed:@"cart_menu.png"] forState:UIControlStateNormal];
    [btnAdd_Cart addTarget:self action:@selector(btn_CartMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cartBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnAdd_Cart];
    cartBarButton.tintColor = [UIColor whiteColor];
    
    UIButton * btn_Share =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Share.frame = CGRectMake(0,8,35,35);
    [btn_Share setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    btn_Share.tintColor = [UIColor whiteColor];
    [btn_Share addTarget:self action:@selector(shareNavigationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [[btn_Share imageView] setContentMode: UIViewContentModeScaleAspectFit];
    UIBarButtonItem *barShareBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_Share];

    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 4;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:cartBarButton, barShareBtn, nil];
}

- (void)shareNavigationButtonAction {
    NSString *strData = [NSString stringWithFormat:@"Item Name - %@, PC - %@, TagNo - %@, GrossWt - %@, NetWt - %@, MRP - %@.",lbl_value1.text, lbl_value4.text, lbl_value2.text, lbl_value5.text, lbl_value7.text, lbl_value18.text];
    [self shareContent:strData imageUrl:str_image];
}

-(void)btn_CartMenu{
    CartList *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"CartList"];
    obj.str_tag = @"";
    obj.str_activity=@"Show Item";
    [self.navigationController pushViewController:obj animated:YES];
}

-(void)handleTap{
    [[BusyIndicator sharedInstance]startIndicator];
    imgfullVC *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"imgfullVC"];
    obj.imageUrlString = str_image;
    obj.str_img2 = str_image2;
    obj.str_img3 = str_image3;
    obj.str_img4 = str_image4;
    obj.str_img5 = str_image5;
    [self.navigationController pushViewController:obj animated:YES];
}

-(void)setUpView{
    NSLog(@"str_image : %@",str_image);
    NSLog(@"str_image2 : %@",str_image2);
    NSLog(@"str_image3 : %@",str_image3);
    /*
    [[ImageCache sharedInstance] downloadImageAtURL:[NSURL URLWithString:str_image]
                                  completionHandler:^(UIImage *image) {
                                      self->head_img.image = image;
                                      [[BusyIndicator sharedInstance]stopIndicator];
                                  }];
    */
    [self->head_img sd_setImageWithURL:[NSURL URLWithString:str_image]
                        placeholderImage:[UIImage imageNamed:@"1024.png"]
                                 options:SDWebImageRefreshCached];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    tapGesture.numberOfTapsRequired = 1;
    head_img.userInteractionEnabled = YES;
    [head_img addGestureRecognizer:tapGesture];
    //[self.view addSubview:head_img];
    str_item_width1 = @"0";
    str_item_width2 = @"0";
    str_item_width3 = @"0";
    str_item_width4 = @"0";
    str_item_width5 = @"0";
    str_item_width6 = @"0";
    str_item_width7 = @"0";
    str_item_width8 = @"0";
    str_item_width9 = @"0";
    str_item_width10 = @"0";
    str_item_width11 = @"0";
    str_item_width12 = @"0";
    str_item_width13 = @"0";
    str_item_width14 = @"0";
    str_item_width15 = @"0";
    str_item_width16 = @"0";
    str_item_width17 = @"0";
    str_item_width18 = @"0";
    str_item_width19 = @"0";
    str_item_width20 = @"0";
    
    str_item_name1 = @"";
    str_item_name2 = @"";
    str_item_name3 = @"";
    str_item_name4 = @"";
    str_item_name5 = @"";
    str_item_name6 = @"";
    str_item_name7 = @"";
    str_item_name8 = @"";
    str_item_name9 = @"";
    str_item_name10 = @"";
    str_item_name11 = @"";
    str_item_name12 = @"";
    str_item_name13 = @"";
    str_item_name14 = @"";
    str_item_name15 = @"";
    str_item_name16 = @"";
    str_item_name17 = @"";
    str_item_name18 = @"";
    str_item_name19 = @"";
    str_item_name20 = @"";
    
    CGFloat cellWidth = 200;
    CGFloat cellHeight = 40;
    NSInteger columnCount = nsarray_data.count;
    //NSInteger rowCount = self.rowValues.count + 1; // +1 for header

    CGFloat totalWidth = columnCount * cellWidth;
    //CGFloat totalHeight = rowCount * cellHeight;
    CGRect frame = self.tableView.frame;
    frame.size.width = totalWidth;
    self.tableView.frame = frame;
}

#pragma mark - Table View Data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return nsarray_datadata.count > 0 ? nsarray_datadata.count + 1 : 0;//[ns_item1 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *myIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:myIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    
    int xorigin = 5;
    
    if (indexPath.row == 0) {
        for (NSDictionary *item in nsarray_data) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xorigin, 5, 100, 40)];
            label.text = [NSString stringWithFormat:@"%@",[item valueForKey:@"caption"] ];
            label.textAlignment = NSTextAlignmentCenter;
            label.font=[UIFont systemFontOfSize:14];
            label.layer.cornerRadius = 5;
            label.layer.borderWidth = 1;
            label.layer.borderColor = [UIColor lightGrayColor].CGColor;
            //label.backgroundColor = [UIColor lightGrayColor];
            label.textColor = [UIColor blackColor];
            [cell addSubview:label];
            xorigin += 105;
        }
    }else{
        NSDictionary * arrayData = [nsarray_datadata objectAtIndex:indexPath.row-1];
        NSLog(@"Array data = %@", arrayData);
        for (int i = 0; i < arrayData.count; i++) {
            NSString *key = [NSString stringWithFormat:@"item%d", i];
            NSString *value = arrayData[key];
            NSLog(@"%@: %@", key, value);
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xorigin, 0, 100, 40)];
            label.text = value;
            label.textAlignment = NSTextAlignmentCenter;
            label.font=[UIFont systemFontOfSize:14];
            label.layer.cornerRadius = 5;
            label.layer.borderWidth = 1;
            label.layer.borderColor = [UIColor lightGrayColor].CGColor;
            //label.backgroundColor = [UIColor lightGrayColor];
            label.textColor = [UIColor blackColor];
            [cell addSubview:label];
            xorigin += 105;
        }
    }

    /*
    if (indexPath.row==0) {
        UILabel *lbl_1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, int_width1, 35)];
        lbl_1.numberOfLines = 0;
        lbl_1.textColor = [UIColor blueColor];
        lbl_1.backgroundColor = [UIColor lightGrayColor];
        lbl_1.textAlignment = NSTextAlignmentCenter;
        lbl_1.text = [NSString stringWithFormat:@"%@",str_item_name1];
        lbl_1.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_1];
        
        UILabel *lbl_2 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+10, 5, int_width2, 35)];
        lbl_2.numberOfLines = 0;
        lbl_2.textColor = [UIColor blueColor];
        lbl_2.backgroundColor = [UIColor lightGrayColor];
        lbl_2.textAlignment = NSTextAlignmentCenter;
        lbl_2.text = [NSString stringWithFormat:@"%@",str_item_name2];
        lbl_2.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_2];
        
        UILabel *lbl_3 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+20, 5, int_width3, 35)];
        lbl_3.numberOfLines = 0;
        lbl_3.textColor = [UIColor blueColor];
        lbl_3.backgroundColor = [UIColor lightGrayColor];
        lbl_3.textAlignment = NSTextAlignmentCenter;
        lbl_3.text = [NSString stringWithFormat:@"%@", str_item_name3];
        lbl_3.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_3];
        
        UILabel *lbl_4 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+30, 5, int_width4, 35)];
        lbl_4.numberOfLines = 0;
        lbl_4.textColor = [UIColor blueColor];
        lbl_4.backgroundColor = [UIColor lightGrayColor];
        lbl_4.textAlignment = NSTextAlignmentCenter;
        lbl_4.text = [NSString stringWithFormat:@"%@", str_item_name4];
        lbl_4.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_4];
        
        
        UILabel *lbl_5 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+40, 5, int_width5, 35)];
        lbl_5.numberOfLines = 0;
        lbl_5.textColor = [UIColor blueColor];
        lbl_5.backgroundColor = [UIColor lightGrayColor];
        lbl_5.textAlignment = NSTextAlignmentCenter;
        lbl_5.text = [NSString stringWithFormat:@"%@", str_item_name5];
        lbl_5.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_5];
        
        UILabel *lbl_6 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+50, 5, int_width6, 35)];
        lbl_6.numberOfLines = 0;
        lbl_6.textColor = [UIColor blueColor];
        lbl_6.backgroundColor = [UIColor lightGrayColor];
        lbl_6.textAlignment = NSTextAlignmentCenter;
        lbl_6.text = [NSString stringWithFormat:@"%@", str_item_name6];
        lbl_6.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_6];
        
        UILabel *lbl_7 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+60, 5, int_width7, 35)];
        lbl_7.numberOfLines = 0;
        lbl_7.textColor = [UIColor blueColor];
        lbl_7.backgroundColor = [UIColor lightGrayColor];
        lbl_7.textAlignment = NSTextAlignmentCenter;
        lbl_7.text = [NSString stringWithFormat:@"%@", str_item_name7];
        lbl_7.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_7];
        
        UILabel *lbl_8 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+70, 5, int_width8, 35)];
        lbl_8.numberOfLines = 0;
        lbl_8.textColor = [UIColor blueColor];
        lbl_8.backgroundColor = [UIColor lightGrayColor];
        lbl_8.textAlignment = NSTextAlignmentCenter;
        lbl_8.text = [NSString stringWithFormat:@"%@", str_item_name8];
        lbl_8.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_8];
        
        UILabel *lbl_9 = [[UILabel alloc]initWithFrame: CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+80, 5, int_width9, 35)];
        lbl_9.numberOfLines = 0;
        lbl_9.textColor = [UIColor blueColor];
        lbl_9.backgroundColor = [UIColor lightGrayColor];
        lbl_9.textAlignment = NSTextAlignmentCenter;
        lbl_9.text = [NSString stringWithFormat:@"%@", str_item_name9];
        lbl_9.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_9];
        
        UILabel *lbl_10 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+90, 5, int_width10, 35)];
        lbl_10.numberOfLines = 0;
        lbl_10.textColor = [UIColor blueColor];
        lbl_10.backgroundColor = [UIColor lightGrayColor];
        lbl_10.textAlignment = NSTextAlignmentCenter;
        lbl_10.text = [NSString stringWithFormat:@"%@", str_item_name10];
        lbl_10.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_10];
        
        UILabel *lbl_11 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+100, 5, int_width11, 35)];
        lbl_11.numberOfLines = 0;
        lbl_11.textColor = [UIColor blueColor];
        lbl_11.backgroundColor = [UIColor lightGrayColor];
        lbl_11.textAlignment = NSTextAlignmentCenter;
        lbl_11.text = [NSString stringWithFormat:@"%@", str_item_name11];
        lbl_11.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_11];
        
        
        UILabel *lbl_12 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+110, 5, int_width12, 35)];
        lbl_12.numberOfLines = 0;
        lbl_12.textColor = [UIColor blueColor];
        lbl_12.backgroundColor = [UIColor lightGrayColor];
        lbl_12.textAlignment = NSTextAlignmentCenter;
        lbl_12.text = [NSString stringWithFormat:@"%@", str_item_name12];
        lbl_12.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_12];
        
        UILabel *lbl_13 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+120, 5, int_width13, 35)];
        lbl_13.numberOfLines = 0;
        lbl_13.textColor = [UIColor blueColor];
        lbl_13.backgroundColor = [UIColor lightGrayColor];
        lbl_13.textAlignment = NSTextAlignmentCenter;
        lbl_13.text = [NSString stringWithFormat:@"%@", str_item_name13];
        lbl_13.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_13];
        
        UILabel *lbl_14 = [[UILabel alloc]initWithFrame: CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+130, 5, int_width14, 35)];
        lbl_14.numberOfLines = 0;
        lbl_14.textColor = [UIColor blueColor];
        lbl_14.backgroundColor = [UIColor lightGrayColor];
        lbl_14.textAlignment = NSTextAlignmentCenter;
        lbl_14.text = [NSString stringWithFormat:@"%@",str_item_name14];
        lbl_14.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_14];
        
        UILabel *lbl_15 = [[UILabel alloc]initWithFrame: CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+140, 5, int_width15, 35)];
        lbl_15.numberOfLines = 0;
        lbl_15.textColor = [UIColor blueColor];
        lbl_15.backgroundColor = [UIColor lightGrayColor];
        lbl_15.textAlignment = NSTextAlignmentCenter;
        lbl_15.text = [NSString stringWithFormat:@"%@", str_item_name15];
        lbl_15.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_15];
        
        UILabel *lbl_16 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+int_width15+150, 5, int_width16, 35)];
        lbl_16.numberOfLines = 0;
        lbl_16.textColor = [UIColor blueColor];
        lbl_16.backgroundColor = [UIColor lightGrayColor];
        lbl_16.textAlignment = NSTextAlignmentCenter;
        lbl_16.text = [NSString stringWithFormat:@"%@", str_item_name16];
        lbl_16.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_16];
        
        UILabel *lbl_17 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+int_width15+int_width16+160, 5, int_width17, 35)];
        lbl_17.numberOfLines = 0;
        lbl_17.textColor = [UIColor blueColor];
        lbl_17.backgroundColor = [UIColor lightGrayColor];
        lbl_17.textAlignment = NSTextAlignmentCenter;
        lbl_17.text = [NSString stringWithFormat:@"%@", str_item_name17];
        lbl_17.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_17];
        
        UILabel *lbl_18 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+int_width15+int_width16+int_width17+170, 5, int_width18, 35)];
        lbl_18.numberOfLines = 0;
        lbl_18.textColor = [UIColor blueColor];
        lbl_18.backgroundColor = [UIColor lightGrayColor];
        lbl_18.textAlignment = NSTextAlignmentCenter;
        lbl_18.text = [NSString stringWithFormat:@"%@", str_item_name18];
        lbl_18.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_18];
        
        UILabel *lbl_19 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+int_width15+int_width16+int_width17+int_width18+180, 5, int_width19, 35)];
        lbl_19.numberOfLines = 0;
        lbl_19.textColor = [UIColor blueColor];
        lbl_19.backgroundColor = [UIColor lightGrayColor];
        lbl_19.textAlignment = NSTextAlignmentCenter;
        lbl_19.text = [NSString stringWithFormat:@"%@", str_item_name19];
        lbl_19.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_19];
        
        UILabel *lbl_20 = [[UILabel alloc]initWithFrame: CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+int_width15+int_width16+int_width17+int_width18+int_width19+190, 5, int_width20, 35)];
        lbl_20.numberOfLines = 0;
        lbl_20.textColor = [UIColor blueColor];
        lbl_20.backgroundColor = [UIColor lightGrayColor];
        lbl_20.textAlignment = NSTextAlignmentCenter;
        lbl_20.text = [NSString stringWithFormat:@"%@", str_item_name20];
        lbl_20.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_20];
    }else{
        UILabel *lbl_1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, int_width1, 35)];
        lbl_1.numberOfLines = 0;
        lbl_1.textColor = [UIColor blueColor];
        lbl_1.backgroundColor = [UIColor lightGrayColor];
        lbl_1.textAlignment = NSTextAlignmentCenter;
        lbl_1.text = [NSString stringWithFormat:@"%@", [ns_item1 objectAtIndex:indexPath.row]];
        lbl_1.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_1];
        
        UILabel *lbl_2 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+10, 5, int_width2, 35)];
        lbl_2.numberOfLines = 0;
        lbl_2.textColor = [UIColor blueColor];
        lbl_2.backgroundColor = [UIColor lightGrayColor];
        lbl_2.textAlignment = NSTextAlignmentCenter;
        lbl_2.text = [NSString stringWithFormat:@"%@", [ns_item2 objectAtIndex:indexPath.row]];
        lbl_2.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_2];
        
        UILabel *lbl_3 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+20, 5, int_width3, 35)];
        lbl_3.numberOfLines = 0;
        lbl_3.textColor = [UIColor blueColor];
        lbl_3.backgroundColor = [UIColor lightGrayColor];
        lbl_3.textAlignment = NSTextAlignmentCenter;
        lbl_3.text = [NSString stringWithFormat:@"%@", [ns_item3 objectAtIndex:indexPath.row]];
        lbl_3.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_3];
        
        UILabel *lbl_4 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+30, 5, int_width4, 35)];
        lbl_4.numberOfLines = 0;
        lbl_4.textColor = [UIColor blueColor];
        lbl_4.backgroundColor = [UIColor lightGrayColor];
        lbl_4.textAlignment = NSTextAlignmentCenter;
        lbl_4.text = [NSString stringWithFormat:@"%@", [ns_item4 objectAtIndex:indexPath.row]];
        lbl_4.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_4];
        
        
        UILabel *lbl_5 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+40, 5, int_width5, 35)];
        lbl_5.numberOfLines = 0;
        lbl_5.textColor = [UIColor blueColor];
        lbl_5.backgroundColor = [UIColor lightGrayColor];
        lbl_5.textAlignment = NSTextAlignmentCenter;
        lbl_5.text = [NSString stringWithFormat:@"%@", [ns_item5 objectAtIndex:indexPath.row]];
        lbl_5.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_5];
        
        UILabel *lbl_6 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+50, 5, int_width6, 35)];
        lbl_6.numberOfLines = 0;
        lbl_6.textColor = [UIColor blueColor];
        lbl_6.backgroundColor = [UIColor lightGrayColor];
        lbl_6.textAlignment = NSTextAlignmentCenter;
        lbl_6.text = [NSString stringWithFormat:@"%@", [ns_item6 objectAtIndex:indexPath.row]];
        lbl_6.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_6];
        
        UILabel *lbl_7 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+60, 5, int_width7, 35)];
        lbl_7.numberOfLines = 0;
        lbl_7.textColor = [UIColor blueColor];
        lbl_7.backgroundColor = [UIColor lightGrayColor];
        lbl_7.textAlignment = NSTextAlignmentCenter;
        lbl_7.text = [NSString stringWithFormat:@"%@", [ns_item7 objectAtIndex:indexPath.row]];
        lbl_7.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_7];
        
        UILabel *lbl_8 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+70, 5, int_width8, 35)];
        lbl_8.numberOfLines = 0;
        lbl_8.textColor = [UIColor blueColor];
        lbl_8.backgroundColor = [UIColor lightGrayColor];
        lbl_8.textAlignment = NSTextAlignmentCenter;
        lbl_8.text = [NSString stringWithFormat:@"%@", [ns_item8 objectAtIndex:indexPath.row]];
        lbl_8.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_8];
        
        UILabel *lbl_9 = [[UILabel alloc]initWithFrame: CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+80, 5, int_width9, 35)];
        lbl_9.numberOfLines = 0;
        lbl_9.textColor = [UIColor blueColor];
        lbl_9.backgroundColor = [UIColor lightGrayColor];
        lbl_9.textAlignment = NSTextAlignmentCenter;
        lbl_9.text = [NSString stringWithFormat:@"%@", [ns_item9 objectAtIndex:indexPath.row]];
        lbl_9.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_9];
        
        UILabel *lbl_10 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+90, 5, int_width10, 35)];
        lbl_10.numberOfLines = 0;
        lbl_10.textColor = [UIColor blueColor];
        lbl_10.backgroundColor = [UIColor lightGrayColor];
        lbl_10.textAlignment = NSTextAlignmentCenter;
        lbl_10.text = [NSString stringWithFormat:@"%@", [ns_item10 objectAtIndex:indexPath.row]];
        lbl_10.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_10];
        
        UILabel *lbl_11 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+100, 5, int_width11, 35)];
        lbl_11.numberOfLines = 0;
        lbl_11.textColor = [UIColor blueColor];
        lbl_11.backgroundColor = [UIColor lightGrayColor];
        lbl_11.textAlignment = NSTextAlignmentCenter;
        lbl_11.text = [NSString stringWithFormat:@"%@", [ns_item11 objectAtIndex:indexPath.row]];
        lbl_11.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_11];
        
        
        UILabel *lbl_12 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+110, 5, int_width12, 35)];
        lbl_12.numberOfLines = 0;
        lbl_12.textColor = [UIColor blueColor];
        lbl_12.backgroundColor = [UIColor lightGrayColor];
        lbl_12.textAlignment = NSTextAlignmentCenter;
        lbl_12.text = [NSString stringWithFormat:@"%@", [ns_item12 objectAtIndex:indexPath.row]];
        lbl_12.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_12];
        
        UILabel *lbl_13 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+120, 5, int_width13, 35)];
        lbl_13.numberOfLines = 0;
        lbl_13.textColor = [UIColor blueColor];
        lbl_13.backgroundColor = [UIColor lightGrayColor];
        lbl_13.textAlignment = NSTextAlignmentCenter;
        lbl_13.text = [NSString stringWithFormat:@"%@", [ns_item13 objectAtIndex:indexPath.row]];
        lbl_13.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_13];
        
        UILabel *lbl_14 = [[UILabel alloc]initWithFrame: CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+130, 5, int_width14, 35)];
        lbl_14.numberOfLines = 0;
        lbl_14.textColor = [UIColor blueColor];
        lbl_14.backgroundColor = [UIColor lightGrayColor];
        lbl_14.textAlignment = NSTextAlignmentCenter;
        lbl_14.text = [NSString stringWithFormat:@"%@", [ns_item14 objectAtIndex:indexPath.row]];
        lbl_14.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_14];
        
        UILabel *lbl_15 = [[UILabel alloc]initWithFrame: CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+140, 5, int_width15, 35)];
        lbl_15.numberOfLines = 0;
        lbl_15.textColor = [UIColor blueColor];
        lbl_15.backgroundColor = [UIColor lightGrayColor];
        lbl_15.textAlignment = NSTextAlignmentCenter;
        lbl_15.text = [NSString stringWithFormat:@"%@", [ns_item15 objectAtIndex:indexPath.row]];
        lbl_15.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_15];
        
        UILabel *lbl_16 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+int_width15+150, 5, int_width16, 35)];
        lbl_16.numberOfLines = 0;
        lbl_16.textColor = [UIColor blueColor];
        lbl_16.backgroundColor = [UIColor lightGrayColor];
        lbl_16.textAlignment = NSTextAlignmentCenter;
        lbl_16.text = [NSString stringWithFormat:@"%@", [ns_item16 objectAtIndex:indexPath.row]];
        lbl_16.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_16];
        
        UILabel *lbl_17 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+int_width15+int_width16+160, 5, int_width17, 35)];
        lbl_17.numberOfLines = 0;
        lbl_17.textColor = [UIColor blueColor];
        lbl_17.backgroundColor = [UIColor lightGrayColor];
        lbl_17.textAlignment = NSTextAlignmentCenter;
        lbl_17.text = [NSString stringWithFormat:@"%@", [ns_item17 objectAtIndex:indexPath.row]];
        lbl_17.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_17];
        
        UILabel *lbl_18 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+int_width15+int_width16+int_width17+170, 5, int_width18, 35)];
        lbl_18.numberOfLines = 0;
        lbl_18.textColor = [UIColor blueColor];
        lbl_18.backgroundColor = [UIColor lightGrayColor];
        lbl_18.textAlignment = NSTextAlignmentCenter;
        lbl_18.text = [NSString stringWithFormat:@"%@", [ns_item18 objectAtIndex:indexPath.row]];
        lbl_18.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_18];
        
        UILabel *lbl_19 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+int_width15+int_width16+int_width17+int_width18+180, 5, int_width19, 35)];
        lbl_19.numberOfLines = 0;
        lbl_19.textColor = [UIColor blueColor];
        lbl_19.backgroundColor = [UIColor lightGrayColor];
        lbl_19.textAlignment = NSTextAlignmentCenter;
        lbl_19.text = [NSString stringWithFormat:@"%@", [ns_item19 objectAtIndex:indexPath.row]];
        lbl_19.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:lbl_19];
        
    
    }
 
    
    */
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.backgroundColor = UIColor.greenColor;
    return cell;
}


#pragma mark:- Api


-(void)scrollData_Category {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;

    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];

        loginRequest=[NSString stringWithFormat:@"apptype=%@&tgno=%@&mobile=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,str_tagno,mobile,ip,db,ipusername,pswd,ftppath];

        URL_API =[WEB_URL URL_SETDESIGNDATA];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_setdesigndata.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&tgno=%@&mobile=%@&ftppath=%@",apptype,str_tagno,mobile,ftppath];

    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&tgno=%@&mobile=%@",apptype,str_tagno,mobile];
        URL_API =[WEB_URL URL_SETDESIGNDATA];
    }
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];

    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:60.0];
    
    //Apply the data to
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        // handle response
        
        if ([data length] >0 && error == nil){
            //process the JSON response
            //use the main queue so that we can interact with the screen
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_category:data];
            });
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            [[BusyIndicator sharedInstance]stopIndicator];
        }
        else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
            [[BusyIndicator sharedInstance]stopIndicator];
        }
    }] resume];
}


- (void) parseResponse_category:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        [[BusyIndicator sharedInstance]stopIndicator];
        
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            
            //check if the country code was valid
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            NSMutableArray * rensarray_data =[[NSMutableArray alloc]init];
            rensarray_data = [pDict objectForKey:@"data"];
            NSLog(@"nsarray_data :: %@",rensarray_data);
            
            

            for (int i = 0; i < [rensarray_data count]; i++) {
                
                NSDictionary * dictObject = [rensarray_data objectAtIndex:i];
//                NSString *sdid = [dictObject objectForKey:@"sdid"];
                NSString *caption = [dictObject objectForKey:@"caption"];
//                NSString *srno = [dictObject objectForKey:@"srno"];
//                NSString *selected = [dictObject objectForKey:@"selected"];
                NSString *value = [dictObject objectForKey:@"value"];

                if (i==0) {
                    lbl_key1.text=[NSString stringWithFormat:@"%@",caption];
                    lbl_value1.text=[NSString stringWithFormat:@"%@",value];
                }
                
                if (i==1) {
                    lbl_key2.text=[NSString stringWithFormat:@"%@",caption];
                    lbl_value2.text=[NSString stringWithFormat:@"%@",value];
                }
                
                if (i==2) {
                    lbl_key3.text=[NSString stringWithFormat:@"%@",caption];
                    lbl_value3.text=[NSString stringWithFormat:@"%@",value];
                }
                
                if (i==3) {
                    lbl_key4.text=[NSString stringWithFormat:@"%@",caption];
                    lbl_value4.text=[NSString stringWithFormat:@"%@",value];
                }
                
                if (i==4) {
                    lbl_key5.text=[NSString stringWithFormat:@"%@",caption];
                    lbl_value5.text=[NSString stringWithFormat:@"%@",value];
                }
                
                if (i==5) {
                    lbl_key6.text=[NSString stringWithFormat:@"%@",caption];
                    lbl_value6.text=[NSString stringWithFormat:@"%@",value];
                }
                
                if (i==6) {
                    lbl_key7.text=[NSString stringWithFormat:@"%@",caption];
                    lbl_value7.text=[NSString stringWithFormat:@"%@",value];
                }
                
                if (i==7) {
                    lbl_key8.text=[NSString stringWithFormat:@"%@",caption];
                    lbl_value8.text=[NSString stringWithFormat:@"%@",value];
                }
                
                if (i==8) {
                    lbl_key9.text=[NSString stringWithFormat:@"%@",caption];
                    lbl_value9.text=[NSString stringWithFormat:@"%@",value];
                }
                if (i==9) {
                    lbl_key10.text=[NSString stringWithFormat:@"%@",caption];
                    lbl_value10.text=[NSString stringWithFormat:@"%@",value];
                }
                if (i==10) {
                    lbl_key11.text=[NSString stringWithFormat:@"%@",caption];
                    lbl_value11.text=[NSString stringWithFormat:@"%@",value];
                }
                if (i==11) {
                    lbl_key12.text=[NSString stringWithFormat:@"%@",caption];
                    lbl_value12.text=[NSString stringWithFormat:@"%@",value];
                }
                if (i==12) {
                    lbl_key13.text=[NSString stringWithFormat:@"%@",caption];
                    lbl_value13.text=[NSString stringWithFormat:@"%@",value];
                }
                if (i==13) {
                    lbl_key14.text=[NSString stringWithFormat:@"%@",caption];
                    lbl_value14.text=[NSString stringWithFormat:@"%@",value];
                }
                
                
                if (i==14) {
                    lbl_key15.text=[NSString stringWithFormat:@"%@",caption];
                    lbl_value15.text=[NSString stringWithFormat:@"%@",value];
                }
                
                if (i==15) {
                    lbl_key16.text=[NSString stringWithFormat:@"%@",caption];
                    lbl_value16.text=[NSString stringWithFormat:@"%@",value];
                }
                
                if (i==16) {
                    lbl_key17.text=[NSString stringWithFormat:@"%@",caption];
                    lbl_value17.text=[NSString stringWithFormat:@"%@",value];
                }
                
                if (i==17) {
                    lbl_key18.text=[NSString stringWithFormat:@"%@",caption];
                    lbl_value18.text=[NSString stringWithFormat:@"%@",value];
                }
                
                if (i==18) {
                    lbl_key19.text=[NSString stringWithFormat:@"%@",caption];
                    lbl_value19.text=[NSString stringWithFormat:@"%@",value];
                }
                
                if (i==19) {
                    lbl_key20.text=[NSString stringWithFormat:@"%@",caption];
                    lbl_value20.text=[NSString stringWithFormat:@"%@",value];
                }
                
                if (i==20) {
                    lbl_key21.text=[NSString stringWithFormat:@"%@",caption];
                    lbl_value21.text=[NSString stringWithFormat:@"%@",value];
                }
                
                
            
            }
            
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)scrollData_STUDD {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;

    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];

        loginRequest=[NSString stringWithFormat:@"apptype=%@&tsno=%@&mobile=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,str_tsno,mobile,ip,db,ipusername,pswd,ftppath];

        URL_API =[WEB_URL URL_STUDD];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_studddata.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&tsno=%@&mobile=%@&ftppath=%@",apptype,str_tsno,mobile,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&tsno=%@&mobile=%@",apptype,str_tsno,mobile];
        URL_API =[WEB_URL URL_STUDD];
    }
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:60.0];
    
    //Apply the data to
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        // handle response
        
        if ([data length] >0 && error == nil){
            //process the JSON response
            //use the main queue so that we can interact with the screen
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_datastudd:data];
            });
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            [[BusyIndicator sharedInstance]stopIndicator];
        }
        else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
            [[BusyIndicator sharedInstance]stopIndicator];
        }
    }] resume];
}


- (void) parseResponse_datastudd:(NSData *) data {
    @try {
        
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        [[BusyIndicator sharedInstance]stopIndicator];
        
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            
            //check if the country code was valid
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            nsarray_data =[[NSMutableArray alloc]init];
            nsarray_datadata =[[NSMutableArray alloc]init];
            nsarray_data = [pDict objectForKey:@"data"];
            nsarray_datadata = [pDict objectForKey:@"datadata"];
           
            ns_item1 =[[NSMutableArray alloc]init];
            ns_item2 =[[NSMutableArray alloc]init];
            ns_item3 =[[NSMutableArray alloc]init];
            ns_item4 =[[NSMutableArray alloc]init];
            ns_item5 =[[NSMutableArray alloc]init];
            ns_item6 =[[NSMutableArray alloc]init];
            ns_item7 =[[NSMutableArray alloc]init];
            ns_item8 =[[NSMutableArray alloc]init];
            ns_item9 =[[NSMutableArray alloc]init];
            ns_item10 =[[NSMutableArray alloc]init];

            ns_item11 =[[NSMutableArray alloc]init];
            ns_item12 =[[NSMutableArray alloc]init];
            ns_item13 =[[NSMutableArray alloc]init];
            ns_item14 =[[NSMutableArray alloc]init];
            ns_item15 =[[NSMutableArray alloc]init];
            ns_item16 =[[NSMutableArray alloc]init];
            ns_item17 =[[NSMutableArray alloc]init];
            ns_item18 =[[NSMutableArray alloc]init];
            ns_item19 =[[NSMutableArray alloc]init];
            ns_item20 =[[NSMutableArray alloc]init];

            [ns_item1 addObject:@""];
            [ns_item2 addObject:@""];
            [ns_item3 addObject:@""];
            [ns_item4 addObject:@""];
            [ns_item5 addObject:@""];
            [ns_item6 addObject:@""];
            [ns_item7 addObject:@""];
            [ns_item8 addObject:@""];
            [ns_item9 addObject:@""];
            [ns_item10 addObject:@""];
            [ns_item11 addObject:@""];
            [ns_item12 addObject:@""];
            [ns_item13 addObject:@""];
            [ns_item14 addObject:@""];
            [ns_item15 addObject:@""];
            [ns_item16 addObject:@""];
            [ns_item17 addObject:@""];
            [ns_item18 addObject:@""];
            [ns_item19 addObject:@""];
            [ns_item20 addObject:@""];

           
            NSInteger int_total;
            for (int i = 0; i < [nsarray_data count]; i++) {
                NSDictionary * dictObject = [nsarray_data objectAtIndex:i];
                NSString *width = [dictObject objectForKey:@"width"];
                NSInteger int_width = [width intValue];
                int_total =int_total+int_width;
            }
            

            
            if ([nsarray_data count]==1) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_name1=[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
            }
            
            if ([nsarray_data count]==2) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                
                str_item_name1=[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2=[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];

            }
            
            if ([nsarray_data count]==3) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                
                str_item_name1=[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2=[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3=[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];

            }

            if ([nsarray_data count]==4) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                
                str_item_name1=[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2=[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3=[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4=[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];

                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
            }
           
            if ([nsarray_data count]==5) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
            
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
            }
            
            if ([nsarray_data count]==6) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6=[[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
        
                
            }
            
            if ([nsarray_data count]==7) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6=[[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7=[[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
               
            }
            
            if ([nsarray_data count]==8) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6=[[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7=[[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8=[[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
            }
            
            if ([nsarray_data count]==9) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6=[[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7=[[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8=[[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9=[[nsarray_data valueForKey:@"width"] objectAtIndex:8];

                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                
            }
            
            if ([nsarray_data count]==10) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6=[[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7=[[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8=[[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9=[[nsarray_data valueForKey:@"width"] objectAtIndex:8];
                str_item_width10 =[[nsarray_data valueForKey:@"width"] objectAtIndex:9];
               
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                str_item_name10 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:9];
            }
            
            if ([nsarray_data count]==11) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6=[[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7=[[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8=[[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9=[[nsarray_data valueForKey:@"width"] objectAtIndex:8];
                str_item_width10 =[[nsarray_data valueForKey:@"width"] objectAtIndex:9];
                str_item_width11 =[[nsarray_data valueForKey:@"width"] objectAtIndex:10];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                str_item_name10 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:9];
                str_item_name11 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:10];
                
            }
            
            if ([nsarray_data count]==12) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6=[[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7=[[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8=[[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9=[[nsarray_data valueForKey:@"width"] objectAtIndex:8];
                str_item_width10 =[[nsarray_data valueForKey:@"width"] objectAtIndex:9];
                str_item_width11 =[[nsarray_data valueForKey:@"width"] objectAtIndex:10];
                str_item_width12 =[[nsarray_data valueForKey:@"width"] objectAtIndex:11];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                str_item_name10 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:9];
                str_item_name11 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:10];
                str_item_name12 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:11];
            }
            
            if ([nsarray_data count]==13) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6=[[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7=[[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8=[[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9=[[nsarray_data valueForKey:@"width"] objectAtIndex:8];
                str_item_width10 =[[nsarray_data valueForKey:@"width"] objectAtIndex:9];
                str_item_width11 =[[nsarray_data valueForKey:@"width"] objectAtIndex:10];
                str_item_width12 =[[nsarray_data valueForKey:@"width"] objectAtIndex:11];
                str_item_width13 =[[nsarray_data valueForKey:@"width"] objectAtIndex:12];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                str_item_name10 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:9];
                str_item_name11 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:10];
                str_item_name12 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:11];
                str_item_name13 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:12];
            }
            
            if ([nsarray_data count]==14) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6=[[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7=[[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8=[[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9=[[nsarray_data valueForKey:@"width"] objectAtIndex:8];
                str_item_width10 =[[nsarray_data valueForKey:@"width"] objectAtIndex:9];
                str_item_width11 =[[nsarray_data valueForKey:@"width"] objectAtIndex:10];
                str_item_width12 =[[nsarray_data valueForKey:@"width"] objectAtIndex:11];
                str_item_width13 =[[nsarray_data valueForKey:@"width"] objectAtIndex:12];
                str_item_width14 =[[nsarray_data valueForKey:@"width"] objectAtIndex:13];

                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                str_item_name10 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:9];
                str_item_name11 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:10];
                str_item_name12 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:11];
                str_item_name13 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:12];
                str_item_name14 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:13];
            }
            
            if ([nsarray_data count]==15) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6=[[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7=[[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8=[[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9=[[nsarray_data valueForKey:@"width"] objectAtIndex:8];
                str_item_width10 =[[nsarray_data valueForKey:@"width"] objectAtIndex:9];
                str_item_width11 =[[nsarray_data valueForKey:@"width"] objectAtIndex:10];
                str_item_width12 =[[nsarray_data valueForKey:@"width"] objectAtIndex:11];
                str_item_width13 =[[nsarray_data valueForKey:@"width"] objectAtIndex:12];
                str_item_width14 =[[nsarray_data valueForKey:@"width"] objectAtIndex:13];
                str_item_width15 =[[nsarray_data valueForKey:@"width"] objectAtIndex:14];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                str_item_name10 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:9];
                str_item_name11 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:10];
                str_item_name12 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:11];
                str_item_name13 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:12];
                str_item_name14 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:13];
                str_item_name15 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:14];
               
            }
            if ([nsarray_data count] == 16) {
                str_item_width1 = [[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2 = [[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3 = [[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4 = [[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5 = [[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6 = [[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7 = [[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8 = [[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9 = [[nsarray_data valueForKey:@"width"] objectAtIndex:8];
                str_item_width10 = [[nsarray_data valueForKey:@"width"] objectAtIndex:9];
                str_item_width11 = [[nsarray_data valueForKey:@"width"] objectAtIndex:10];
                str_item_width12 = [[nsarray_data valueForKey:@"width"] objectAtIndex:11];
                str_item_width13 = [[nsarray_data valueForKey:@"width"] objectAtIndex:12];
                str_item_width14 = [[nsarray_data valueForKey:@"width"] objectAtIndex:13];
                str_item_width15 = [[nsarray_data valueForKey:@"width"] objectAtIndex:14];
                str_item_width16 = [[nsarray_data valueForKey:@"width"] objectAtIndex:15];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                str_item_name10 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:9];
                str_item_name11 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:10];
                str_item_name12 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:11];
                str_item_name13 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:12];
                str_item_name14 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:13];
                str_item_name15 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:14];
                str_item_name16 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:15];
            }
            
            if ([nsarray_data count] == 17) {
                str_item_width1 = [[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2 = [[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3 = [[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4 = [[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5 = [[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6 = [[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7 = [[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8 = [[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9 = [[nsarray_data valueForKey:@"width"] objectAtIndex:8];
                str_item_width10 = [[nsarray_data valueForKey:@"width"] objectAtIndex:9];
                str_item_width11 = [[nsarray_data valueForKey:@"width"] objectAtIndex:10];
                str_item_width12 = [[nsarray_data valueForKey:@"width"] objectAtIndex:11];
                str_item_width13 = [[nsarray_data valueForKey:@"width"] objectAtIndex:12];
                str_item_width14 = [[nsarray_data valueForKey:@"width"] objectAtIndex:13];
                str_item_width15 = [[nsarray_data valueForKey:@"width"] objectAtIndex:14];
                str_item_width16 = [[nsarray_data valueForKey:@"width"] objectAtIndex:15];
                str_item_width17 = [[nsarray_data valueForKey:@"width"] objectAtIndex:16];

                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                str_item_name10 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:9];
                str_item_name11 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:10];
                str_item_name12 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:11];
                str_item_name13 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:12];
                str_item_name14 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:13];
                str_item_name15 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:14];
                str_item_name16 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:15];
                str_item_name17 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:16];

            }
            
            if ([nsarray_data count] == 18) {
                str_item_width1 = [[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2 = [[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3 = [[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4 = [[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5 = [[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6 = [[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7 = [[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8 = [[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9 = [[nsarray_data valueForKey:@"width"] objectAtIndex:8];
                str_item_width10 = [[nsarray_data valueForKey:@"width"] objectAtIndex:9];
                str_item_width11 = [[nsarray_data valueForKey:@"width"] objectAtIndex:10];
                str_item_width12 = [[nsarray_data valueForKey:@"width"] objectAtIndex:11];
                str_item_width13 = [[nsarray_data valueForKey:@"width"] objectAtIndex:12];
                str_item_width14 = [[nsarray_data valueForKey:@"width"] objectAtIndex:13];
                str_item_width15 = [[nsarray_data valueForKey:@"width"] objectAtIndex:14];
                str_item_width16 = [[nsarray_data valueForKey:@"width"] objectAtIndex:15];
                str_item_width17 = [[nsarray_data valueForKey:@"width"] objectAtIndex:16];
                str_item_width18 = [[nsarray_data valueForKey:@"width"] objectAtIndex:17];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                str_item_name10 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:9];
                str_item_name11 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:10];
                str_item_name12 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:11];
                str_item_name13 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:12];
                str_item_name14 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:13];
                str_item_name15 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:14];
                str_item_name16 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:15];
                str_item_name17 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:16];
                str_item_name18 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:17];

            }
            
            if ([nsarray_data count] == 19) {
                str_item_width1 = [[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2 = [[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3 = [[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4 = [[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5 = [[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6 = [[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7 = [[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8 = [[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9 = [[nsarray_data valueForKey:@"width"] objectAtIndex:8];
                str_item_width10 = [[nsarray_data valueForKey:@"width"] objectAtIndex:9];
                str_item_width11 = [[nsarray_data valueForKey:@"width"] objectAtIndex:10];
                str_item_width12 = [[nsarray_data valueForKey:@"width"] objectAtIndex:11];
                str_item_width13 = [[nsarray_data valueForKey:@"width"] objectAtIndex:12];
                str_item_width14 = [[nsarray_data valueForKey:@"width"] objectAtIndex:13];
                str_item_width15 = [[nsarray_data valueForKey:@"width"] objectAtIndex:14];
                str_item_width16 = [[nsarray_data valueForKey:@"width"] objectAtIndex:15];
                str_item_width17 = [[nsarray_data valueForKey:@"width"] objectAtIndex:16];
                str_item_width18 = [[nsarray_data valueForKey:@"width"] objectAtIndex:17];
                str_item_width19 = [[nsarray_data valueForKey:@"width"] objectAtIndex:18];
            
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                str_item_name10 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:9];
                str_item_name11 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:10];
                str_item_name12 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:11];
                str_item_name13 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:12];
                str_item_name14 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:13];
                str_item_name15 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:14];
                str_item_name16 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:15];
                str_item_name17 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:16];
                str_item_name18 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:17];
                str_item_name19 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:18];

            }
            
            int_width1 = [str_item_width1 intValue];
            int_width2 = [str_item_width2 intValue];
            int_width3 = [str_item_width3 intValue];
            int_width4 = [str_item_width4 intValue];
            int_width5 = [str_item_width5 intValue];
            int_width6 = [str_item_width6 intValue];
            int_width7 = [str_item_width7 intValue];
            int_width8 = [str_item_width8 intValue];
            int_width9 = [str_item_width9 intValue];
            int_width10 = [str_item_width10 intValue];
            int_width11 = [str_item_width11 intValue];
            int_width12 = [str_item_width12 intValue];
            int_width13 = [str_item_width13 intValue];
            int_width14 = [str_item_width14 intValue];
            int_width15 = [str_item_width15 intValue];
            int_width16 = [str_item_width16 intValue];
            int_width17 = [str_item_width17  intValue];
            int_width18 = [str_item_width18  intValue];
            int_width19 = [str_item_width19 intValue];
            int_width20 = [str_item_width20 intValue];
            
            int x = 0;
            for (int i = 0; i < 1; i++) {
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, int_total, 100)];
                [button setTitle:[NSString stringWithFormat:@"Button %d", i] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                [scrollView addSubview:button];
                [scrollView_tableView addSubview:button];

                x += button.frame.size.width;
            }
            scrollView.contentSize = CGSizeMake(x, scrollView.frame.size.height);
            scrollView.backgroundColor = [UIColor clearColor];
            //[self.view addSubview:scrollView];
            scrollView_tableView.contentSize = CGSizeMake(x, scrollView_tableView.frame.size.height);
            // scrollView_tableView.backgroundColor = [UIColor clearColor];
            //[self.view addSubview:scrollView_tableView];
            self.tableView.frame=CGRectMake(0, 0, self.view.frame.size.width+int_total, 255);
            //scrollView_tableView.contentSize = CGSizeMake(x, self.view.frame.size.width+int_total);
            //CGFloat totalWidth = columnCount * cellWidth;
            //CGFloat totalHeight = rowCount * cellHeight;
            CGRect frame = self.tableView.frame;
            frame.size.width = self.view.frame.size.width+int_total;
            self.tableView.frame = frame;
            self.tableViewWidth.constant = (105 * nsarray_data.count);
            [self.tableView reloadData];
            [scrollView_tableView reloadInputViews];
            NSLog(@" data data ::::::::::: %@",nsarray_datadata);
            for (int i = 0; i < [nsarray_datadata count]; i++) {
                    NSDictionary * dictObject1 = [nsarray_datadata objectAtIndex:i];
                    NSString *item1 = [dictObject1 objectForKey:@"item0"];
                    NSString *item2 = [dictObject1 objectForKey:@"item1"];
                    NSString *item3 = [dictObject1 objectForKey:@"item2"];
                    NSString *item4 = [dictObject1 objectForKey:@"item3"];
                    NSString *item5 = [dictObject1 objectForKey:@"item4"];
                    NSString *item6 = [dictObject1 objectForKey:@"item5"];
                    NSString *item7 = [dictObject1 objectForKey:@"item6"];
                    NSString *item8 = [dictObject1 objectForKey:@"item7"];
                    NSString *item9 = [dictObject1 objectForKey:@"item8"];
                    NSString *item10 = [dictObject1 objectForKey:@"item9"];
                    NSString *item11 = [dictObject1 objectForKey:@"item10"];
                    NSString *item12 = [dictObject1 objectForKey:@"item11"];
                    NSString *item13 = [dictObject1 objectForKey:@"item12"];
                    NSString *item14 = [dictObject1 objectForKey:@"item13"];
                    NSString *item15 = [dictObject1 objectForKey:@"item14"];
                    NSString *item16 = [dictObject1 objectForKey:@"item15"];
                    NSString *item17 = [dictObject1 objectForKey:@"item16"];
                    NSString *item18 = [dictObject1 objectForKey:@"item17"];
                    NSString *item19 = [dictObject1 objectForKey:@"item18"];
                    NSString *item20 = [dictObject1 objectForKey:@"item19"];
                    if (item1 ==nil) {
                        [ns_item1 addObject:@""];
                    }else{
                        [ns_item1 addObject:item1];
                    }
                    if (item2 ==nil) {
                        [ns_item2 addObject:@""];
                    }else{
                        [ns_item2 addObject:item2];
                    }
                    if (item3 ==nil) {
                        [ns_item3 addObject:@""];
                    }else{
                        [ns_item3 addObject:item3];
                    }
                    
                    if (item4 ==nil) {
                        [ns_item4 addObject:@""];
                    }else{
                        [ns_item4 addObject:item4];
                    }
                    if (item5 ==nil) {
                        [ns_item5 addObject:@""];
                    }else{
                        [ns_item5 addObject:item5];
                    }
                    
                    if (item6 ==nil) {
                        [ns_item6 addObject:@""];
                    }else{
                        [ns_item6 addObject:item6];
                    }
                    if (item7 ==nil) {
                        [ns_item7 addObject:@""];
                    }else{
                        [ns_item7 addObject:item7];
                    }
                    
                    if (item8 ==nil) {
                        [ns_item8 addObject:@""];
                    }else{
                        [ns_item8 addObject:item8];
                    }
                    
                    if (item9 ==nil) {
                        [ns_item9 addObject:@""];
                    }else{
                        [ns_item9 addObject:item9];
                    }
                    
                    if (item10 ==nil) {
                        [ns_item10 addObject:@""];
                    }else{
                        [ns_item10 addObject:item10];
                    }
                    
                    
                    if (item11 ==nil) {
                        [ns_item11 addObject:@""];
                    }else{
                        [ns_item11 addObject:item11];
                    }
                    
                    if (item12 ==nil) {
                        [ns_item12 addObject:@""];
                    }else{
                        [ns_item12 addObject:item12];
                    }
                    if (item13 ==nil) {
                        [ns_item13 addObject:@""];
                    }else{
                        [ns_item13 addObject:item13];
                    }
                    if (item14 ==nil) {
                        [ns_item14 addObject:@""];
                    }else{
                        [ns_item14 addObject:item14];
                    }
                    
                    if (item15 ==nil) {
                        [ns_item15 addObject:@""];
                    }else{
                        [ns_item15 addObject:item15];
                    }
                    
                    if (item16 ==nil) {
                        [ns_item16 addObject:@""];
                    }else{
                        [ns_item16 addObject:item16];
                    }
                    
                    
                    if (item17 ==nil) {
                        [ns_item17 addObject:@""];
                    }else{
                        [ns_item17 addObject:item17];
                    }
                    
                    
                    if (item18 ==nil) {
                        [ns_item18 addObject:@""];
                    }else{
                        [ns_item18 addObject:item18];
                    }
                    
                    if (item19 ==nil) {
                        [ns_item19 addObject:@""];
                    }else{
                        [ns_item19 addObject:item19];
                    }
                    
                    if (item20 ==nil) {
                        [ns_item20 addObject:@""];
                    }else{
                        [ns_item20 addObject:item20];
                    }
                    
                   
                    
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }

        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}


-(void)CHECK_COUNTER {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"mobile=%@&apptype=%@&userid=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",mobile,apptype,userid,ip,db,ipusername,pswd,ftppath];
        
        URL_API =[WEB_URL URL_COUNTER];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/counter.php",ip];
        loginRequest=[NSString stringWithFormat:@"mobile=%@&apptype=%@&userid=%@&ftppath=%@",mobile,apptype,userid,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"mobile=%@&apptype=%@&userid=%@",mobile,apptype,userid];
        URL_API = [WEB_URL URL_COUNTER];
    }
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseCounter_Api:data];
            });
        }else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            [[BusyIndicator sharedInstance]stopIndicator];
            
        }else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
            [[BusyIndicator sharedInstance]stopIndicator];
            
        }
    }] resume];
}


- (void)parseCounter_Api:(NSData *) data {
    @try {
        
        ////////////// End processs load view
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data counter = %@", myData);
        NSError *error = nil;
        [[BusyIndicator sharedInstance]stopIndicator];
        
        //parsing the JSON response
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            NSMutableArray *array_counter = [pDict objectForKey:@"counter"];
            NSString *str_counter = [array_counter description];
            
            NSLog(@"str_counter ::::::: %@",str_counter);
            
            if ([str_counter isEqualToString:@"0"]) {
                
            }else{
                BBBadgeBarButtonItem *barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:btnAdd_Cart];
                barButton.badgeValue = str_counter;
                //barButton.badgeOriginX = 0;
                //barButton.badgeOriginY = 0;
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}


@end
