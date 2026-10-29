//
//  ItemListVC.m
//  Aslomal Vijay Kumar
//
//  Created by Suresh Kumar on 20/07/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "ItemListVC.h"

#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "UIImageView+WebCache.h"
#import "WalletVC.h"
#import "WalletHistoryVC.h"


#define MENUEWIDTH   250
#define IS_iPhone4 ([[UIScreen mainScreen] bounds].size.height == 480)?TRUE:FALSE
#define IS_iPhone5 ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
#define IS_iPhone6 ([[UIScreen mainScreen] bounds].size.height == 667)?TRUE:FALSE
#define IS_iPhone6Plus ([[UIScreen mainScreen] bounds].size.height == 736)?TRUE:FALSE
#define IS_iPhoneiPad ([[UIScreen mainScreen] bounds].size.height == 1024)?TRUE:FALSE
#define IS_iPhoneX ([[UIScreen mainScreen] bounds].size.height == 812)?TRUE:FALSE
#define IS_iPhoneipad12 ([[UIScreen mainScreen] bounds].size.height == 1366)?TRUE:FALSE
#define IS_iPhoneipad10 ([[UIScreen mainScreen] bounds].size.height == 1112)?TRUE:FALSE
#define IS_iPhoneXsmax ([[UIScreen mainScreen] bounds].size.height == 896)?TRUE:FALSE

@interface ItemListVC ()
{
    NSString *catid;
}
@end

@implementation ItemListVC
@synthesize str_categoryid,str_name;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = str_name;
    
      if(IS_iPhone6Plus){
          [self.collectionView_slider registerNib:[UINib nibWithNibName:@"MyCell_itemcat736" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
      }else if (IS_iPhone6){
          [self.collectionView_slider registerNib:[UINib nibWithNibName:@"MyCell_itemcat" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
      }else if(IS_iPhone5){
          [self.collectionView_slider registerNib:[UINib nibWithNibName:@"MyCell_itemcat568" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
      }else if (IS_iPhone4){
          [self.collectionView_slider registerNib:[UINib nibWithNibName:@"MyCell_itemcat568" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
      }
      else if (IS_iPhoneX){
          [self.collectionView_slider registerNib:[UINib nibWithNibName:@"MyCell_itemcat_xmax" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
      } else if (IS_iPhoneipad12){
          [self.collectionView_slider registerNib:[UINib nibWithNibName:@"MyCell_itemcat_iPad12" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
      }else if (IS_iPhoneipad10){
          [self.collectionView_slider registerNib:[UINib nibWithNibName:@"MyCell_itemcat_iPad10" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
      }else if (IS_iPhoneXsmax){
          [self.collectionView_slider registerNib:[UINib nibWithNibName:@"MyCell_itemcat_xmax" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
      }else{
          [self.collectionView_slider registerNib:[UINib nibWithNibName:@"MyCell_itemcat_iPad" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
      }
      self.collectionView_slider.backgroundColor=[UIColor grayColor];
      self.collectionView_slider.alwaysBounceVertical = NO;
      self.collectionView_slider.bounces = NO;
      [self.collectionView_slider reloadData];
      
      [self scrollData_slider];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)scrollData_slider {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile=@"";
    NSString *loginRequest=[NSString stringWithFormat:@"catid=%@&mobile=%@",str_categoryid,mobile];
    
    NSLog(@"response :: %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    
    NSString *api = [NSString stringWithFormat:@"%@",[WEB_URL URL_GET_ITEM]];
    
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:60.0];
    
    //Apply the data to the body
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        // handle response
        
        if ([data length] >0 && error == nil){
            //process the JSON response
            //use the main queue so that we can interact with the screen
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_slider:data];
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


- (void) parseResponse_slider:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        [[BusyIndicator sharedInstance]stopIndicator];
        NSError *error = nil;
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
            
            nsarray_slider1 = [[NSMutableArray alloc]init];
            array_item = [[NSMutableArray alloc]init];

            nsarray_slider1 = [pDict objectForKey:@"subitem"];
            array_item = [pDict objectForKey:@"itemlist"];

            [self.collectionView_slider reloadData];
            [self.tableView_Order reloadData];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[nsarray_slider1 valueForKey:@"category_id"] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    [cell.imgeDataArray sd_setImageWithURL:[NSURL URLWithString:[[nsarray_slider1 valueForKey:@"imgname"] objectAtIndex:indexPath.row]]placeholderImage:[UIImage imageNamed:@"1024.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached:YES];
    
    [cell.imgeDataArray setUserInteractionEnabled:YES];
    cell.imgeDataArray.tag = indexPath.row;
    cell.imgeDataArray.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.lbl_counter.hidden = YES;
    cell.btn_addcart.hidden = YES;
    cell.lblTitle.text = [[nsarray_slider1 valueForKey:@"name"] objectAtIndex:indexPath.row];
    cell.lblTitle.textAlignment = NSTextAlignmentCenter;
    cell.lbl_data.hidden = YES;
    cell.lblTitle.hidden = NO;

    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   catid = [[nsarray_slider1 valueForKey:@"category_id"]objectAtIndex:indexPath.row];
   [self scrollData_item];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat width = self.collectionView_slider.frame.size.width/2-3;
    if(IS_iPhoneX){
        return CGSizeMake(width, 210);
    }else if(IS_iPhone6Plus){
        return CGSizeMake(width, 180);
    }else if (IS_iPhone6){
        return CGSizeMake(width, 150);
    }else if(IS_iPhone5){
        return CGSizeMake(width, 136);
    }else if (IS_iPhone4){
        return CGSizeMake(width, 136);
    }else if (IS_iPhoneipad12){
        return CGSizeMake(width, 380);
    }else if (IS_iPhoneipad10){
        return CGSizeMake(width, 370);
    }else if(IS_iPhoneXsmax){
        return CGSizeMake(width, 210);
    }else if(IS_iPhoneiPad){
        return CGSizeMake(width, 270);
    }else{
        return CGSizeMake(width, 270);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 2, 0,2);
}


-(void)scrollData_item {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *loginRequest = [NSString stringWithFormat:@"catid=%@&category_id=%@&mobile=%@",catid,catid,mobile];
    NSLog(@"response  %@",loginRequest);
    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",[WEB_URL URL_ITEMLIST]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if ([data length] >0 && error == nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_itemcat:data];
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

- (void) parseResponse_itemcat:(NSData *) data {
    @try {
        array_item = [[NSMutableArray alloc]init];
        array_qty = [[NSMutableArray alloc]init];
        [[BusyIndicator sharedInstance]stopIndicator];
        
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView_Order reloadData];
        });
        
        NSError *error = nil;
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
            
            array_item = [pDict objectForKey:@"itemlist"];
            [self.tableView_Order reloadData];

            for (int i = 0; i < [array_item count]; i++)
            {
               NSDictionary * dictObject = [array_item objectAtIndex:i];
               NSString *qty = [dictObject objectForKey:@"qty"];
               [array_qty addObject:qty];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[array_item valueForKey:@"product_id"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [self.tableView_Order dequeueReusableCellWithIdentifier:myIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *imgView;
    imgView=[[UIImageView alloc] initWithFrame:CGRectMake(5,10, 100, 100)];
    [imgView.layer setCornerRadius:8.0f];
    [imgView.layer setMasksToBounds:YES];
    [imgView.layer setBorderColor:[UIColor grayColor].CGColor];
    [imgView.layer setBorderWidth:2.0f];
    
    [imgView setShowActivityIndicatorView:YES];
    [imgView setIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    NSURL *URL;
    URL = [NSURL URLWithString:[[array_item valueForKey:@"imgname"] objectAtIndex:indexPath.row]];
    NSString *myString = [URL absoluteString];
    [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:myString]
               placeholderImage:[UIImage imageNamed:@"1024.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:imgView];
    
    UILabel *lbl_itemname = [[UILabel alloc] init];
    lbl_itemname.frame = CGRectMake(130,10, 210, 60);
    [lbl_itemname setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    lbl_itemname.text = [NSString stringWithFormat:@"%@",[[array_item valueForKey:@"name"] objectAtIndex:indexPath.row]];
    lbl_itemname.textAlignment = NSTextAlignmentLeft;
    lbl_itemname.textColor = [UIColor blackColor];
//    lbl_itemname.adjustsFontSizeToFitWidth=YES;
    lbl_itemname.numberOfLines = 4;
    [cell.contentView addSubview:lbl_itemname];
    
    UILabel *lbl_item1 = [[UILabel alloc] init];
    lbl_item1.frame = CGRectMake(130,75, 210, 20);
    [lbl_item1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    lbl_item1.text = [NSString stringWithFormat:@"Model Np. : %@",[[array_item valueForKey:@"model"] objectAtIndex:indexPath.row]];
    lbl_item1.textAlignment = NSTextAlignmentLeft;
    lbl_item1.textColor = [UIColor redColor];
    lbl_item1.adjustsFontSizeToFitWidth = YES;
    [cell.contentView addSubview:lbl_item1];
    
   UIImageView *imgViewrating;
   imgViewrating = [[UIImageView alloc] initWithFrame:CGRectMake(130,95, 100, 30)];
   [imgViewrating setShowActivityIndicatorView:YES];
   [imgViewrating setIndicatorStyle:UIActivityIndicatorViewStyleMedium];

   [imgViewrating sd_setImageWithURL:[NSURL URLWithString:@""]
              placeholderImage:[UIImage imageNamed:@"rating.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
   imgViewrating.contentMode = UIViewContentModeScaleAspectFit;
   [cell.contentView addSubview:imgViewrating];
    
//    NSString *qty = [[array_item valueForKey:@"qty"] objectAtIndex:indexPath.row];
//    NSString *category_id = [[array_item valueForKey:@"category_id"] objectAtIndex:indexPath.row];
   
    NSString *qty = [array_qty objectAtIndex:indexPath.row];
    
    UIImage *image_minus;
    UIButton *btn_delete = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_delete.frame = CGRectMake(self.view.frame.size.width-70, 110.0f, 35, 35);
    btn_delete.titleLabel.font = [UIFont systemFontOfSize:15.0];
    if ([qty isEqualToString:@"1"]) {
        image_minus = [UIImage imageNamed:@"select.png"];
    }else{
        image_minus = [UIImage imageNamed:@"unselect.png"];
        [btn_delete addTarget:self action:@selector(btn_select:) forControlEvents:UIControlEventTouchUpInside];
    }
    [btn_delete setBackgroundImage:image_minus forState:UIControlStateNormal];
    btn_delete.tag = indexPath.row;
    [cell.contentView addSubview:btn_delete];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NewsDetailsVC *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"NewsDetailsVC"];
    //    obj.str_news_img=[nsarray_image objectAtIndex:indexPath.row];
    //    obj.str_news_heading=[nsarray_title objectAtIndex:indexPath.row];
    //    obj.str_news_narr=[nsarray_rem2 objectAtIndex:indexPath.row];
    //    obj.str_news_narr2=[nsarray_story objectAtIndex:indexPath.row];
    //    obj.str_news_date=[nsarray_rem1 objectAtIndex:indexPath.row];
    //    [self.navigationController pushViewController:obj animated:YES];
}

-(void)btn_select:(UIButton*)sender{
//  index_cart = [sender tag];
    NSLog(@"index_cart %ld",[sender tag]);
    str_price = [[array_item valueForKey:@"price"] objectAtIndex:[sender tag]];
    product_id = [[array_item valueForKey:@"product_id"] objectAtIndex:[sender tag]];

    [self INSERT_CART];
}

-(void)INSERT_CART {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *category_id=str_categoryid;
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *qty = @"1";
    NSString *price = str_price;
    NSString *wt = @"";
    NSString *option_value_id = @"";
    NSString *option_id = @"";
    NSString *name = @"";

    NSString *loginRequest=[NSString stringWithFormat:@"category_id=%@&product_id=%@&mobile=%@&qty=%@&price=%@&wt=%@&option_value_id=%@&option_id=%@&name=%@",category_id,product_id,mobile,qty,price,wt,option_value_id,option_id,name];
    //    NSLog(@"response  %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@"%@",[WEB_URL URL_INSERT_CART]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //Apply the data to the body
    [request setHTTPBody:data1];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseInsert_Cart:data];
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


- (void)parseInsert_Cart:(NSData *) data {
    @try {
        
        ////////////// End processs load view
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        NSError *error = nil;
        [[BusyIndicator sharedInstance]stopIndicator];
        
        //parsing the JSON response
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
            
            
            NSMutableArray *arrayResponse_success = [pDict objectForKey:@"success"];
            NSString *str_success = [arrayResponse_success description];
//            NSMutableArray*nsarray_msg = [pDict objectForKey:@"message"];
//            NSString *str_msg = [nsarray_msg description];
    
            if ([str_success isEqualToString:@"1"]) {
            
            }else{
               
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}


@end
