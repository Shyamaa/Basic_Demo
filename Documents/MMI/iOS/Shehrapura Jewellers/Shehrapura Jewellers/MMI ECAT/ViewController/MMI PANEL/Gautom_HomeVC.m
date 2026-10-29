//
//  Gautom_HomeVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 05/07/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "Gautom_HomeVC.h"
#import "SWRevealViewController.h"
#import "RearViewController.h"
#import "HomeBannerCell.h"
#import "CustomCell.h"
#import "CartList.h"
#import "AddDemand.h"
#import "LedgerVC.h"
#import "Showitem.h"
#import "imgfullVC.h"
#import "Aboutus.h"
#import "NotificationVC.h"

@interface Gautom_HomeVC ()
{
    UIBarButtonItem *rightButton;
    NSInteger currentIndex;
}
@end

@implementation Gautom_HomeVC

#pragma mark - Class Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title=@"Jewel Desk";
    [self setUpNavigation];
    /*
     NSString *username = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
     lbl_welcome.text = [NSString stringWithFormat:@"Welcome %@",username];
     rights = @"00000000000000";
     
     [[NSUserDefaults standardUserDefaults] setObject:rights forKey:@"rights"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     NSString *softid = [[NSUserDefaults standardUserDefaults]stringForKey:@"softid"];
     if (![softid isEqualToString:@"SQLECAT"] && ![softid isEqualToString:@"SQLQR"]) {
     [self GET_UserAi];
     rightButton = [[UIBarButtonItem alloc] initWithTitle:@"swid" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonTapped)];
     self.navigationItem.rightBarButtonItem = rightButton;
     [self GET_ECATID_API];
     
     }else{
     rightButton = [[UIBarButtonItem alloc] initWithTitle:softid style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonTapped)];
     self.navigationItem.rightBarButtonItem = rightButton;
     [self GET_COMPANYDETAIL];
     }
     */
    [self GET_ITEMSHOWApi];
    [self scrollData_HOME:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self->currentIndex = 0;
    [self startAutoScroll];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopAutoScroll];
}

- (void)setUpNavigation{
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    /*
    UIImage* image = [UIImage imageNamed:@"menu.png"];
    CGRect frameimg1 = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *someButton1 = [[UIButton alloc] initWithFrame:frameimg1];
    [someButton1 setBackgroundImage:image forState:UIControlStateNormal];
    [someButton1 addTarget:revealController action:@selector(revealToggle:)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithCustomView:someButton1];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    */
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"line.3.horizontal"]
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:revealController
                                                                        action:@selector(revealToggle:)];
    revealButtonItem.tintColor = UIColor.whiteColor;
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    [self setUpNavigationLogo];
    //    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor]; // Set your color
    //    self.navigationController.navigationBar.translucent = NO; // Optional, for solid color
    //       self.navigationController.navigationBar.tintColor = [UIColor whiteColor]; // Color of bar buttons
    //       self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]}; // Title color
}

- (void)startAutoScroll {
    if (autoScrollTimer == nil) {
        autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(autoScrollBanner) userInfo:nil repeats:YES];
    }
}

- (void)stopAutoScroll {
    [autoScrollTimer invalidate];
    if (autoScrollTimer) {
        [autoScrollTimer invalidate];
        autoScrollTimer = nil;
    }
    
}

- (void)autoScrollBanner {
    NSInteger numberOfItems = [self.bannerCollectionView numberOfItemsInSection:0];
    if (numberOfItems == 0) return;
    self->currentIndex = (self->currentIndex + 1) % numberOfItems;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self->currentIndex inSection:0];
        [self.bannerCollectionView scrollToItemAtIndexPath:indexPath
                                          atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                  animated:YES];
    });
}

#pragma mark:- IBAction Method

-(IBAction)productBtnAction:(UIButton *)sender{
    NSString *scategory = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
    if ([scategory isEqualToString:@"0"]){
        Aboutus *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Aboutus"];
        obj.str_type = @"About us";
        obj.isSideMenu = false;
        [self.navigationController pushViewController:obj animated:YES];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProductGroup *obj = [storyboard instantiateViewControllerWithIdentifier:@"ProductGroup"];
        [self.navigationController pushViewController:obj animated:YES];
    }
}

-(IBAction)aboutBtnAction:(UIButton *)sender{
    
    NSString *scategory = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
    NSLog(@"Category = %@", scategory);
    if ([scategory isEqualToString:@"0"]){
        Aboutus *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Aboutus"];
        obj.str_type = @"About us";
        obj.isSideMenu = false;
        [self.navigationController pushViewController:obj animated:YES];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProductGallery *obj = [storyboard instantiateViewControllerWithIdentifier:@"ProductGallery"];
        obj.str_igroup =@"";
        [self.navigationController pushViewController:obj animated:YES];
    }
}

-(IBAction)tapBarAction:(UIButton *)sender{
    if (sender.tag == 1) {
        NotificationVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationVC"];
        [self.navigationController pushViewController:obj animated:YES];
    } else if (sender.tag == 2) {
        AddDemand *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDemand"];
        [self.navigationController pushViewController:obj animated:YES];
    } else if (sender.tag == 3) {
        CartList *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"CartList"];
        obj.str_activity=@"Show Item";
        [self.navigationController pushViewController:obj animated:YES];
    } else if (sender.tag == 4) {
        LedgerVC *obj = [[LedgerVC alloc] init];
        obj.itemList = moreItemList;
        [self.navigationController pushViewController:obj animated:YES];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _bannerCollectionView){
        return  CGSizeMake(self.bannerCollectionView.frame.size.width-40, self.bannerCollectionView.frame.size.height-10);
    }else{
        CGFloat itemheight = (self.collectionView.frame.size.height);
        CGFloat itemWidth = itemheight * 0.72;// 130;//(self.collectionView.frame.size.width - 30) / 3;
        return CGSizeMake(itemWidth, itemheight);
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _bannerCollectionView){
        return [bannerList count];
    }else{
        return [itemList  count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _bannerCollectionView){
        HomeBannerCell *bannerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBannerCell" forIndexPath:indexPath];
        bannerCell.bannerImageView.image = [UIImage imageNamed:@"gautam_appicon"];
        NSString *str_url = [[bannerList valueForKey:@"imgurl"] objectAtIndex:indexPath.row];
        str_url = [str_url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [bannerCell.bannerImageView sd_setImageWithURL:[NSURL URLWithString:str_url]
                                      placeholderImage:[UIImage imageNamed:@"gautam_appicon"]
                                               options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
        
        bannerCell.bannerImageView.contentMode = UIViewContentModeScaleToFill;
        // Apply border radius and drop shadow to the cell content view
        bannerCell.contentView.layer.cornerRadius = 10;
        bannerCell.contentView.layer.masksToBounds = YES;
        // Set background color to white and add border
        bannerCell.contentView.backgroundColor = [UIColor whiteColor];
        bannerCell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        bannerCell.contentView.layer.borderWidth = 1.0;
        // Add shadow to the cell content view
        bannerCell.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        bannerCell.contentView.layer.shadowOpacity = 1.7;
        bannerCell.contentView.layer.shadowRadius = 10.0;
        bannerCell.contentView.layer.shadowOffset = CGSizeMake(3, 3);
        return bannerCell;
    }else{
        CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCell" forIndexPath:indexPath];
        
        cell.viewTitle.hidden = true;
        NSString *str_url = @"";
        NSString *scategory = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
        if ([scategory isEqualToString:@"0"]){
            str_url = [[itemList valueForKey:@"imgurl"] objectAtIndex:indexPath.row];
            cell.imgeDataArray.contentMode = UIViewContentModeScaleAspectFill;
        }else{
            cell.lblTitle.text = [[itemList valueForKey:@"idesc"] objectAtIndex:indexPath.row];
            cell.viewTitle.hidden = false;
            str_url = [[itemList valueForKey:@"imgname"] objectAtIndex:indexPath.row];
            str_url = [str_url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        }
        
        cell.imgeDataArray.tag = indexPath.row;
        [cell.imgeDataArray sd_setImageWithURL:[NSURL URLWithString:str_url]
                              placeholderImage:[UIImage imageNamed:@"gautam_appicon.png"]
                                       options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
        
        // Apply border radius and drop shadow to the cell content view
        cell.contentView.layer.cornerRadius = 10;
        cell.contentView.layer.masksToBounds = YES;
        // Set background color to white and add border
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.contentView.layer.borderWidth = 1.0;
        // Add shadow to the cell content view
        cell.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.contentView.layer.shadowOpacity = 1.7;
        cell.contentView.layer.shadowRadius = 10.0;
        cell.contentView.layer.shadowOffset = CGSizeMake(3, 3);
        
        return cell;
    }
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _bannerCollectionView){
        NSString *str_url = [[bannerList valueForKey:@"imgurl"] objectAtIndex:indexPath.row];
        str_url = [str_url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        imgfullVC *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"imgfullVC"];
        obj.imageUrlString = str_url;
        obj.str_img2 = @"";
        obj.str_img3 = @"";
        obj.str_img4 = @"";
        obj.str_img5 = @"";
        [self.navigationController pushViewController:obj animated:YES];
    }else{
        NSString *scategory = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
        NSLog(@"Category = %@", scategory);
        if (![scategory isEqualToString:@"0"]){
            Showitem *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Showitem"];
            obj.str_siteid = @"";
            obj.str_idesc = [[itemList valueForKey:@"idesc"] objectAtIndex:indexPath.row];
            obj.arrayCategoryList = itemList;
            obj.categoryId = [[itemList valueForKey:@"total_tag"] objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:obj animated:YES];
            
        }
    }
}
#pragma mark:- APi Method

- (void)scrollData_HOME:(BOOL)isBanner {
    [[BusyIndicator sharedInstance] startIndicator];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *mobile = [defaults stringForKey:@"mobile"];
    NSString *ECAT_TYPE_NEW = [defaults stringForKey:@"ECAT_TYPE_NEW"];
    NSString *ECAT_TYPE = [defaults stringForKey:@"ECAT_TYPE"];
    NSString *apptype = ECAT_TYPE;
    NSString *type = @"ios";
    
    NSString *loginRequest, *URL_API;
    
    if (isBanner) {
        URL_API = [WEB_URL URL_HOME];
    }else{
        URL_API = [WEB_URL URL_PRODUCT_GALLERY];
    }
    loginRequest = [NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&mobile=%@&ftppath=%@&type=%@", ECAT_TYPE_NEW, apptype, mobile, [defaults stringForKey:@"ftppath"], type];
    
    NSLog(@"URL_API: %@", URL_API);
    NSLog(@"Request: %@", loginRequest);
    
    NSURL *url = [NSURL URLWithString:URL_API];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *postData = [loginRequest dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setTimeoutInterval:60];
    [request setHTTPBody:postData];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[BusyIndicator sharedInstance] stopIndicator];
            if (data.length > 0 && !error) {
                [self parse_category1:data isFromBanner:isBanner];
            } else {
                NSLog(@"%@", error ? error.localizedDescription : @"Empty Response");
            }
        });
    }] resume];
}

- (void) parse_category1:(NSData *) data isFromBanner:(BOOL)isBanner  {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSONDATA_HOME ===== %@", myData);
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            NSMutableDictionary *pDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (isBanner) {
                bannerList = [[NSMutableArray alloc]init];
                menuItemList = [[NSMutableArray alloc]init];
                moreItemList = [[NSMutableArray alloc]init];
                bannerList = [pDict objectForKey:@"bannerlist"];
                menuItemList = [pDict objectForKey:@"menuitem"];
                moreItemList = [pDict objectForKey:@"item"];
                [[NSUserDefaults standardUserDefaults] setObject:menuItemList forKey:@"MenuData"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MenuDataNotification" object:nil userInfo:@{@"menu": menuItemList}];
                [self scrollData_HOME:NO];
            }else{
                itemList = [pDict objectForKey:@"productgallery"];
                NSLog(@"tg_master ::::::::::: :: %@",itemList);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.bannerCollectionView reloadData];
                if (!(self->bannerList.count > 0)){
                    self.bannerCollectionView.hidden = true;
                }
                NSString *scategory = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
                if ([scategory isEqualToString:@"0"]){
                    //[self->itemList removeAllObjects];
                    [self scrollBrochuresData];
                    [self->btn_Title setTitle:@"A b o u t   u s" forState: UIControlStateNormal];
                }else{
                    //[self->btn_Title setTitle:@"Product Group" forState: UIControlStateNormal];
                    [self->btn_Title setTitle:@"P r o d u c t   g r o u p" forState: UIControlStateNormal];
                    [self.collectionView reloadData];
                }
            });
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)scrollBrochuresData {
   
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSString *scategory = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
    NSString *category=@"-1";
    NSString *loginRequest=[NSString stringWithFormat:@"category=%@",category];
    NSLog(@"response :: %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@", [WEB_URL URL_GET_BROCHURES]];
    
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:60.0];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_category:data];
            });
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
        }
        else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
        }
    }] resume];
}


- (void) parseResponse_category:(NSData *) data {
    @try {
        
        ////////////// End processs load view
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        
        NSError *error = nil;
        
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
           
            NSMutableArray* arrayResponse = [pDict objectForKey:@"item"];
            NSLog(@"tg_master :: %@",arrayResponse);
            
            itemList = [pDict objectForKey:@"item"];
            NSLog(@"tg_master ::::::::::: :: %@",itemList);
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

@end
