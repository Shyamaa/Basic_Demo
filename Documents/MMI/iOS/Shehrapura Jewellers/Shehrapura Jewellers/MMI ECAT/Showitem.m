//
//  Showitem.m
//  MMI ECAT
//
//  Created by mmsoft116 on 14/09/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "Showitem.h"
#import "SupportFile/BusyIndicator/BusyIndicator.h"
#import "SupportFile/WebClass/webUrlconstant.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "WalletVC.h"
#import "WalletHistoryVC.h"
#import "ItemListVC.h"
#import "ViewController/CartList/CartList.h"
#import "ItemDetail.h"
#import "ItemSlider.h"
#import <UIKit/UIKit.h>
#import "FilterView.h"

@interface Showitem ()
{
    NSString *item1;
    NSString *item2;
    NSString *item3;
    NSString *item4;
    NSString *item5;
    NSString *item6;
    UIButton * btnAdd_Cart;
    NSString *tagno;
    NSInteger galleryImageSelectedIndex;
    BBBadgeBarButtonItem *barButton;
}
@property (strong, nonatomic) FilterView *filterView;
@end

@implementation Showitem
@synthesize str_dwt,str_gwt,str_mrp,str_nwt,str_swt,str_idesc,str_activity,str_designno,str_tsnolist,str_siteid;
static int myCounter;

-(void)btn_CartMenu{
    CartList *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"CartList"];
    obj.str_tag = @"";
    obj.str_activity=@"Show Item";
    [self.navigationController pushViewController:obj animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = str_idesc;
    [self setUpNavigationButton];
    NSString *username = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
    lbl_welcome.text=[NSString stringWithFormat:@"Welcome %@",username];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyCell_item" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    
    //    self.collectionView.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0];
    //    self.collectionView.alwaysBounceVertical = NO;
    //    self.collectionView.bounces = NO;
    //    [self.view addSubview:self. collectionView];
    //    [self.collectionView reloadData];
    
    item1 = [[NSUserDefaults standardUserDefaults]stringForKey:@"item1"];
    item2 = [[NSUserDefaults standardUserDefaults]stringForKey:@"item2"];
    item3 = [[NSUserDefaults standardUserDefaults]stringForKey:@"item3"];
    item4 = [[NSUserDefaults standardUserDefaults]stringForKey:@"item4"];
    item5 = [[NSUserDefaults standardUserDefaults]stringForKey:@"item5"];
    item6 = [[NSUserDefaults standardUserDefaults]stringForKey:@"item6"];
    
    tsnolist=@"";
    if ([str_activity isEqualToString:@"CDemand"]) {
        tsnolist = str_tsnolist;
    }
    
    _lblTotalItem.text = @"0 Product";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidTakeScreenshot:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    selectedItems = [NSMutableArray array];
    [self loadShareConfig];
    self.categoryView.hidden = true;
    NSString *strTemplate = [[NSUserDefaults standardUserDefaults]stringForKey:@"template"];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    if([strTemplate isEqualToString:@"2"] && [ECAT_TYPE isEqualToString:@"3"]){
        self.categoryView.hidden = false;
    }
    self.categoryView.hidden = false;
    barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:btnAdd_Cart];
//    barButton.badgeOriginX = 8;
//    barButton.badgeOriginY = 0;
    [self scrollData_Category];
    NSString *category = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
    if ([category isEqualToString:@"Admin"] || ![category isEqualToString:@"0"]) {
        btn_SelectAllCheckMark.hidden = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self CHECK_COUNTER];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

- (void)setUpNavigationButton {
    
    btnAdd_Cart =  [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd_Cart.frame = CGRectMake(0,0,30,30);
    //UIImage *image = [UIImage imageNamed:@"cart_menu.png"];
    //UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,8,20,20)];
    //[imageView setImage:image];
    //[btnAdd_Cart addSubview:imageView];
    [btnAdd_Cart setImage:[UIImage imageNamed:@"cart_menu.png"] forState:UIControlStateNormal];
    [btnAdd_Cart addTarget:self action:@selector(btn_CartMenu) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cartBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnAdd_Cart];
    cartBarButton.tintColor = [UIColor whiteColor];
    
    UIButton * btn_Search =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Search.frame = CGRectMake(0,5,30,30);
    [btn_Search setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [[btn_Search imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_Search.tintColor = [UIColor whiteColor];
    [btn_Search addTarget:self action:@selector(searchNavigationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barSearchBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_Search];
    
    UIButton * btn_Filter =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Filter.frame = CGRectMake(0,5,30,30);
    [btn_Filter setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [[btn_Filter imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_Filter.tintColor = [UIColor whiteColor];
    [btn_Filter addTarget:self action:@selector(filterNavigationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barFilterBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_Filter];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 4;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:barFilterBtn, cartBarButton, barSearchBtn, nil];
}

- (void)filterNavigationButtonAction {
    if (self.filterView == nil){
        //self.filterView = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGRect finalFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.filterView = [[FilterView alloc] initWithFrame:finalFrame];
        
        NSArray *uniqueTagNo = [[NSSet setWithArray:[arrayMasterProductList valueForKey:@"tgno"]] allObjects];
        NSArray *rawDesigns = [arrayMasterProductList valueForKey:@"design"];
        NSArray *filteredDesigns = [rawDesigns filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != %@", [NSNull null]]]; //remove null value 
        NSArray *uniqueDesignNo = [[NSSet setWithArray:filteredDesigns] allObjects];
        //NSArray *uniqueDesignNo = [[NSSet setWithArray:[arrayMasterProductList valueForKey:@"design"]] allObjects];
        NSArray *uniqueStatus = [[NSSet setWithArray:[arrayMasterProductList valueForKey:@"status"]] allObjects];
        NSArray *uniqueStamp = [[NSSet setWithArray:[arrayMasterProductList valueForKey:@"stamp"]] allObjects];
        
        NSArray *raw_karigar = [arrayMasterProductList valueForKey:@"karigar"];
        NSArray *filtered_karigar = [raw_karigar filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != %@", [NSNull null]]]; //remove null value
        NSArray *unique_karigar = [[NSSet setWithArray:filtered_karigar] allObjects];
        
        NSArray *raw_quality = [arrayMasterProductList valueForKey:@"quality"];
        NSArray *filtered_quality = [raw_quality filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != %@", [NSNull null]]]; //remove null value
        NSArray *unique_quality = [[NSSet setWithArray:filtered_quality] allObjects];
        
        NSArray *raw_site = [arrayMasterProductList valueForKey:@"site"];
        NSArray *filtered_site = [raw_site filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != %@", [NSNull null]]]; //remove null value
        NSArray *unique_site = [[NSSet setWithArray:filtered_site] allObjects];
        
        NSArray *raw_gcode = [arrayMasterProductList valueForKey:@"gcode"];
        NSArray *filtered_gcode = [raw_gcode filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != %@", [NSNull null]]]; //remove null value
        NSArray *unique_gcode = [[NSSet setWithArray:filtered_gcode] allObjects];
        
        NSArray *rawSize = [arrayMasterProductList valueForKey:@"size"];
        NSArray *filteredSize = [rawDesigns filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != %@", [NSNull null]]]; //remove null value
        NSArray *uniqueSize = [[NSSet setWithArray:filteredDesigns] allObjects];
        //NSArray *uniqueSize = [[NSSet setWithArray:[arrayMasterProductList valueForKey:@"size"]] allObjects];
        
        [self.filterView setupWithArray:[self filterData: uniqueTagNo] design:[self filterData: uniqueDesignNo] status:[self filterData: uniqueStatus] stamp:[self filterData: uniqueStamp] size:[self filterData: uniqueSize] listData: arrayMasterProductList karigarData:[self filterData: unique_karigar] qualityList:[self filterData: unique_quality] siteList:[self filterData: unique_site] gCodeList:[self filterData: unique_gcode]];
        
        [self.view addSubview:self.filterView];
        
        // Start with transform offscreen
        self.filterView.transform = CGAffineTransformMakeTranslation(-self.view.bounds.size.width, 0);
        
        [UIView animateWithDuration:0.2 animations:^{
            self.filterView.transform = CGAffineTransformIdentity;
        }];
        
        __weak typeof(self) weakSelf = self;
        self.filterView.onCloseTapped = ^(NSArray *arrayListdata,Boolean status){
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideCustomView];
            });
            if(status){
                self->nsarray_product = [arrayListdata mutableCopy];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.collectionView reloadData];
                    [weakSelf setUpData];
                });
            }
        };
    }
}

- (void)hideCustomView {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.filterView.frame = CGRectOffset(weakSelf.filterView.frame, -self.view.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [weakSelf.filterView removeFromSuperview];
        weakSelf.filterView = nil;
    }];
}

- (void)searchNavigationButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected){
        [self.searchBar setHidden:false];
    }else{
        [self.searchBar setHidden:true];
        [self.searchBar resignFirstResponder];
    }
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        nsarray_product = arrayMasterProductList;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *item, NSDictionary *bindings) {
            NSString *name = [item[@"idesc"] lowercaseString];
            NSString *stamp = [item[@"stamp"] lowercaseString];
            NSString *tgno = [item[@"tgno"] lowercaseString];
            NSString *searchLower = [searchText lowercaseString];
            
            return ([name containsString:searchLower] ||
                    [stamp containsString:searchLower] ||
                    [tgno containsString:searchLower]
                    );
        }];
        nsarray_product = [[arrayMasterProductList filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    //dispatch_async(dispatch_get_main_queue(), ^{
    [self.collectionView reloadData];
    // });
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [nsarray_product removeAllObjects];
    nsarray_product = arrayMasterProductList;
    [self.collectionView reloadData];
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)scrollData_Category {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *category = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE_NEW"];
    
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    str_siteid = str_siteid.length > 0 ? str_siteid : @"";
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults
                           standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&idesc=%@&mobile=%@&tsnolist=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&ECAT_TYPE_NEW=%@&wtf=%@&wtt=%@&activity=%@&branchid=%@&stamp=%@&quality=%@&remark=%@&tgno=%@&siteid=%@",apptype,str_idesc,mobile,tsnolist,ip,db,ipusername,pswd,ftppath,ECAT_TYPE_NEW,@"",@"",@"",@"",@"",@"",@"",tagno,str_siteid];
        
        URL_API =[WEB_URL URL_SINGLE_ITEM];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_items_android.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&idesc=%@&mobile=%@&tsnolist=%@&ftppath=%@&ECAT_TYPE_NEW=%@&siteid=%@",apptype,category,str_idesc,mobile,tsnolist,ftppath,ECAT_TYPE_NEW,str_siteid];
        
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&idesc=%@&mobile=%@&tsnolist=%@&ECAT_TYPE_NEW=%@&siteid=%@",apptype,category,str_idesc,mobile,tsnolist,ECAT_TYPE_NEW,str_siteid];
        URL_API =[WEB_URL URL_SINGLE_ITEM];
    }
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSLog(@"urlString ::::%@",urlString);
    
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSLog(@"api ::::%@",api);
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
        
        ////////////// End processs load view
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
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
            
            //check if the country code was valid
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            nsarray_product = [[NSMutableArray alloc]init];
            arrayMasterProductList = [[NSMutableArray alloc]init];
            nsarray_qty = [[NSMutableArray alloc]init];
            //            ns_check = [[NSMutableArray alloc]init];
            //            ns_tgno = [[NSMutableArray alloc]init];
            
            nsarray_product = [[pDict objectForKey:@"items"] mutableCopy];
            arrayMasterProductList = [nsarray_product mutableCopy];
            NSLog(@"nsarray_product :: %@",nsarray_product);
            
            [self setUpData];
            
            for (int i = 0; i < [nsarray_product count]; i++)
            {
                NSDictionary * dictObject = [nsarray_product objectAtIndex:i];
                NSString *qty = [dictObject objectForKey:@"qty"];
                [nsarray_qty addObject:qty];
                //[ns_check addObject:@"0"];
            }
            
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void) setUpData{
    [nsarray_product sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        double gwt1 = [obj1[@"gwt"] doubleValue];
        double gwt2 = [obj2[@"gwt"] doubleValue];
        return (gwt1 < gwt2) ? NSOrderedDescending : (gwt1 > gwt2) ? NSOrderedAscending : NSOrderedSame;
    }];
    [self.collectionView reloadData];
    NSInteger totalItem = [[nsarray_product valueForKey:@"item1"] count];
    NSString *strProduct = @"";
    if (totalItem > 1){
        strProduct = @"Products";
    }else if (totalItem == 1){
        strProduct = @"Product";
    }else{
        strProduct = @"";
    }
    self.lblTotalItem.text = [NSString stringWithFormat:@"%ld %@ (0-50)",(long)totalItem,strProduct];
    self.lblCategoryName.text = str_idesc;
    self.title = str_idesc;
    btn_Short.selected = false;
    //[self btnShortAction:btn_Short];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.lblTotalItem.font = [UIFont systemFontOfSize:24.0];
        self.lblCategoryName.font = [UIFont systemFontOfSize:24.0];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.categoryCollectionView) {
        return  _arrayCategoryList.count;
    } else {
        return [[nsarray_product valueForKey:@"item1"] count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.categoryCollectionView) {
        CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCell" forIndexPath:indexPath];
        cell.imgeDataArray.contentMode = UIViewContentModeScaleAspectFill;
        NSString *str_url = [[_arrayCategoryList valueForKey:@"imgname"] objectAtIndex:indexPath.row];
        str_url = [str_url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        cell.imgeDataArray.layer.cornerRadius = cell.imgeDataArray.frame.size.width/2;
        cell.imgeDataArray.contentMode = UIViewContentModeScaleAspectFill;
        cell.imgeDataArray.backgroundColor = [UIColor blackColor];
        cell.imgeDataArray.tag = indexPath.row;
        [cell.imgeDataArray sd_setImageWithURL:[NSURL URLWithString:str_url]
                              placeholderImage:[UIImage imageNamed:@"banner_Default.png"]
                                       options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
        cell.lblTitle.text = [[_arrayCategoryList valueForKey:@"idesc"] objectAtIndex:indexPath.row];
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            cell.lblTitle.font = [UIFont systemFontOfSize:18.0];
        }
        NSString *str_id = [[_arrayCategoryList valueForKey:@"total_tag"] objectAtIndex:indexPath.row];
        if([str_id isEqualToString:_categoryId]){
            cell.contentView.backgroundColor = UIColor.whiteColor;
        }else{
            cell.contentView.backgroundColor = UIColor.clearColor;
        }
        return  cell;
    }else{
        MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
        
        cell.imgeDataArray.tag = indexPath.row;
        cell.btn_check.tag=indexPath.row;
        cell.btn_addcart.tag=indexPath.row;
        
        [cell.imgeDataArray sd_setImageWithURL:[NSURL URLWithString:[[nsarray_product valueForKey:@"itemimage"] objectAtIndex:indexPath.row]]
                              placeholderImage:[UIImage imageNamed:@"1024.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached:YES];
        //[cell.imgeDataArray setUserInteractionEnabled:YES];
        cell.imgeDataArray.contentMode = UIViewContentModeScaleAspectFill;
        
        NSString *sitem3=[[nsarray_product valueForKey:@"item3"] objectAtIndex:indexPath.row];
        NSString *sitem4=[[nsarray_product valueForKey:@"item4"] objectAtIndex:indexPath.row];
        
        NSString *str_wt=[[nsarray_product valueForKey:@"wt"] objectAtIndex:indexPath.row];
        NSString *sitem5=[[nsarray_product valueForKey:@"item5"] objectAtIndex:indexPath.row];
        
        //NSString * str_NetWt = [NSString stringWithFormat:@"%@ %@",item4, sitem4];
        //NSString * str_NetWt = [NSString stringWithFormat:@"%@ - %@", item2, str_wt];
        NSString * str_NetWt = [NSString stringWithFormat:@"%@", str_wt];
        
        NSString * str_GrossWt = [NSString stringWithFormat:@"%@ %@",item3,sitem3];
        
        NSString * str_deta = [NSString stringWithFormat:@"%@\n%@", str_GrossWt, str_NetWt];
        NSString * str_TagNo = [[nsarray_product valueForKey:@"tgno"] objectAtIndex:indexPath.row];//sitem2;
        cell.lbl_tgno.text = str_TagNo.uppercaseString;
        //cell.lbl_data.text = str_deta;
        cell.lbl_data.text = str_NetWt;
        cell.lblTitle.text= [[nsarray_product valueForKey:@"idesc"] objectAtIndex:indexPath.row];//str_titleWt;
        NSString *status = [[nsarray_product valueForKey:@"status"] objectAtIndex:indexPath.row];
        //cell.lblStatus.text = status;
        NSString *tgstatus = [[NSUserDefaults standardUserDefaults]stringForKey:@"tgstatus"];
        NSString *aprval_stk = [[NSUserDefaults standardUserDefaults]stringForKey:@"aprval_stk"];
        NSString *instk = [[NSUserDefaults standardUserDefaults]stringForKey:@"instk"];
        NSString *outstk = [[NSUserDefaults standardUserDefaults]stringForKey:@"outstk"];
        
        if ([tgstatus isEqualToString:@"1"]) {
            cell.lblStatus.hidden = false;
            cell.lblStatus.textColor = UIColor.blackColor;
            if ([status isEqualToString:@"IN STOCK"]) {
                cell.lblStatus.text = instk;
            }else if ([status isEqualToString:@"APPROVAL"]) {
                cell.lblStatus.text = aprval_stk;
            }else{
                cell.lblStatus.text = outstk;
                cell.lblStatus.textColor = UIColor.redColor;
            }
        }else{
            cell.lblStatus.hidden = true;
        }
        cell.btn_addcart.selected = NO;
        NSString *str_qty=[nsarray_qty objectAtIndex:indexPath.row];
        
        if ([str_qty isEqualToString:@"0"]) {
            cell.lbl_counter.text=@"";
            cell.lbl_counter.hidden=YES;
            cell.btn_addcart.selected = NO;
        } else {
            cell.lbl_counter.hidden=NO;
            cell.lbl_counter.text=[NSString stringWithString:str_qty];
            cell.btn_addcart.selected = YES;
        }
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            cell.lblTitle.font = [UIFont systemFontOfSize:22.0];
            cell.lbl_data.font = [UIFont systemFontOfSize:22.0];
            cell.lbl_tgno.font = [UIFont systemFontOfSize:22.0]; //24
            cell.btn_addcart.titleLabel.font = [UIFont boldSystemFontOfSize:24];
        }
        
        /*
         NSString * str_check = [ns_check objectAtIndex:indexPath.row];
         
         if ([str_check isEqualToString:@"1"]) {
         //[cell.btn_check setImage:[UIImage imageNamed:@"checkcircle"] forState:UIControlStateNormal];
         cell.btn_check.selected = YES;
         [ns_tgno addObject:[[nsarray_product valueForKey:@"tgno"] objectAtIndex:indexPath.row]];
         }else{
         cell.btn_check.selected = false;
         //[cell.btn_check setImage:[UIImage imageNamed:@"uncheckcircle"] forState:UIControlStateNormal];
         }
         */
        NSString *cell_tgno = [[nsarray_product valueForKey:@"tgno"] objectAtIndex:indexPath.row];
        cell.btn_check.selected = false;
        if ([selectedItems count] > 0){
            for (NSDictionary *dict in selectedItems) {
                NSString *tgno = dict[@"tgno"];
                if ([cell_tgno isEqualToString: tgno]) {
                    cell.btn_check.selected = YES;
                }
            }
        }
        cell.lblStatus.hidden = YES;
        cell.btn_check.hidden=YES;
//        cell.btn_addcart.hidden=YES;
        cell.lbl_counter.hidden=YES;
        
        NSString *category = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
        if ([category isEqualToString:@"Admin"]) {
            cell.btn_check.hidden = NO;
        }
        
        [cell.btn_check addTarget:self action:@selector(btn_check:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn_addcart addTarget:self action:@selector(btn_addtocart:) forControlEvents:UIControlEventTouchUpInside];
        cell.lbl_counter.clipsToBounds = true;
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.categoryCollectionView) {
        str_siteid = str_siteid.length > 0 ? str_siteid : @"";
        str_idesc = [[self.arrayCategoryList valueForKey:@"idesc"] objectAtIndex:indexPath.row];
        _categoryId = [[self.arrayCategoryList valueForKey:@"total_tag"] objectAtIndex:indexPath.row];
        [self.categoryCollectionView reloadData];
        [self scrollData_Category];
    }else{
        NSString *strTemplate = [[NSUserDefaults standardUserDefaults]stringForKey:@"template"];
        NSString *itemlist = [[NSUserDefaults standardUserDefaults]stringForKey:@"itemlist"];
        if ([itemlist isEqualToString:@"1"] || [strTemplate isEqualToString:@"2"]) {
            NSString *strindex=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
            
            ItemSlider *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemSlider"];
            obj.str_idesc = [[nsarray_product valueForKey:@"idesc"] objectAtIndex:indexPath.row];
            obj.strindex=strindex;
            obj.nsarray_product = [nsarray_product mutableCopy];
            obj.nsarray_qty = [nsarray_qty mutableCopy];
            [self.navigationController pushViewController:obj animated:YES];
        }else{
            ItemDetail *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"ItemDetail"];
            obj.str_idesc=[[nsarray_product valueForKey:@"idesc"]objectAtIndex:indexPath.row];
            obj.str_image=[[nsarray_product valueForKey:@"itemimage"]objectAtIndex:indexPath.row];
            obj.str_image2=[[nsarray_product valueForKey:@"itemimage2"]objectAtIndex:indexPath.row];
            obj.str_image3=[[nsarray_product valueForKey:@"itemimage3"]objectAtIndex:indexPath.row];
            obj.str_image4=[[nsarray_product valueForKey:@"itemimage4"]objectAtIndex:indexPath.row];
            obj.str_image5=[[nsarray_product valueForKey:@"itemimage5"]objectAtIndex:indexPath.row];
            obj.str_tagno=[[nsarray_product valueForKey:@"tgno"]objectAtIndex:indexPath.row];
            obj.str_gwt=[[nsarray_product valueForKey:@"gwt"]objectAtIndex:indexPath.row];
            obj.str_qty=[[nsarray_product valueForKey:@"qty"]objectAtIndex:indexPath.row];
            obj.str_tpre=[[nsarray_product valueForKey:@"tpre"]objectAtIndex:indexPath.row];
            obj.str_design=[[nsarray_product valueForKey:@"design"]objectAtIndex:indexPath.row];
            obj.str_tsno=[[nsarray_product valueForKey:@"tsno"]objectAtIndex:indexPath.row];
            obj.str_item1=[[nsarray_product valueForKey:@"item1"]objectAtIndex:indexPath.row];
            obj.str_item2=[[nsarray_product valueForKey:@"item2"]objectAtIndex:indexPath.row];
            obj.str_item3=[[nsarray_product valueForKey:@"item3"]objectAtIndex:indexPath.row];
            obj.str_item4=[[nsarray_product valueForKey:@"item4"]objectAtIndex:indexPath.row];
            obj.str_rlid=@"0";
            obj.str_remarks=[[nsarray_product valueForKey:@"remarks"]objectAtIndex:indexPath.row];
            obj.str_shpc=@"0";
            obj.str_stamp=[[nsarray_product valueForKey:@"stamp"]objectAtIndex:indexPath.row];
            obj.str_tgimage=[[nsarray_product valueForKey:@"tgimage"]objectAtIndex:indexPath.row];
            obj.str_wt1=[[nsarray_product valueForKey:@"wt1"]objectAtIndex:indexPath.row];
            
            obj.str_status=[[nsarray_product valueForKey:@"status"]objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:obj animated:YES];
        }
    }
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.categoryCollectionView) {
        CGFloat itemWidth = 110;//(self.collectionView.frame.size.width - 30) / 3;
        CGFloat itemheight = (self.categoryCollectionView.frame.size.height);
        return CGSizeMake(itemWidth, itemheight);
    } else {
        CGFloat width = (self.collectionView.frame.size.width - 30) / 2;
        return CGSizeMake(width, width*1.75);
    }
}

-(void)btn_check:(UIButton*)sender{
    //    ns_tgno = [[NSMutableArray alloc]init];
    //    NSString *currentValue = [ns_check objectAtIndex:sender.tag];
    //    NSString *newValue = [currentValue isEqualToString:@"1"] ? @"0" : @"1";
    //    [ns_check replaceObjectAtIndex:sender.tag withObject:newValue];
    sender.selected = !sender.selected;
    NSDictionary *selectedItem = nsarray_product[sender.tag];
    // Add it to the selectedItems array if not already there
    if (![selectedItems containsObject:selectedItem]) {
        [selectedItems addObject:selectedItem];
    }else{
        [selectedItems removeObject:selectedItem];
    }
    NSString *str_Share = [NSString stringWithFormat:@"Share (%lu)", (unsigned long)[selectedItems count]];
    [self.btn_Share setTitle: str_Share forState: UIControlStateNormal];
    if([selectedItems count] > 0){
        self.btn_Share.hidden = false;
        self.btn_Type.hidden = false;
    }else{
        self.btn_Share.hidden = YES;
        self.btn_Type.hidden = true;
    }
    //[_collectionView reloadData];
}

-(void)btn_addtocart:(UIButton*)sender{
    NSString *chqty = [[NSUserDefaults standardUserDefaults]stringForKey:@"chqty"];
    if ([chqty isEqualToString:@"3"] || [chqty isEqualToString:@"2"]) {
        NSString *str_qty=[nsarray_qty objectAtIndex: sender.tag];
        index_cart = [sender tag];
        if ([str_qty isEqualToString:@"0"]) {
            [self scrollData_InsertItem:@"1"];
        }else{
            [self confirmDeleteAlert];
        }
    }else{
        transparentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
        transparentView.backgroundColor = [UIColor blackColor];
        transparentView.alpha = 0.5f;
        transparentView.clipsToBounds = NO;
        transparentView.layer.shadowColor = [UIColor blackColor].CGColor;
        transparentView.layer.shadowOpacity = 0.0;
        transparentView.layer.shadowRadius = 0.0;
        [self.view addSubview:transparentView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
        imageView.image = [UIImage imageNamed:@"transprant.png"];
        [transparentView addSubview:imageView];
        NSString *str_qty=[nsarray_qty objectAtIndex:sender.tag];
        [self Popup: str_qty];
        index_cart = [sender tag];
        [UIView transitionWithView:view1 duration:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self->view1.hidden = NO;
        } completion:NULL];
    }
}

-(void)confirmDeleteAlert{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                  message:@"Do you want delete item"
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action){
        
        [self URL_SINGLE_ITEM_DELETE];
    }];
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action){}];
    [alert addAction:noButton];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Pop View Method

-(void)Popup:(NSString *)strQuantity{
    view1 = [[UIView alloc] initWithFrame:CGRectMake(30.0f, 20.0f, 300.0f, 280.0f)];
    //view1.backgroundColor = [UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1.0];
    view1.backgroundColor = [UIColor colorNamed:@"border_Color"];
    view1.center = self.view.center;
    view1.layer.cornerRadius = 5;
    view1.layer.masksToBounds = true;
    [[self view] addSubview:view1];
    
    UIButton * btn_minus = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_minus.frame = CGRectMake(90.0f, 70.0f, 30.0f, 30.0f);
    //UIImage* image_minus = [UIImage imageNamed:@"minus.png"];
    //[btn_minus setBackgroundImage:image_minus forState:UIControlStateNormal];
    [btn_minus setBackgroundColor: [UIColor colorNamed:@"appRed_Color"]];
    [btn_minus setTitle:@"-" forState: UIControlStateNormal];
    [btn_minus setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [btn_minus setClipsToBounds:YES];
    btn_minus.layer.cornerRadius = 15;
    [btn_minus addTarget:self action:@selector(btn_minus:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn_minus];
    
    UIButton * btn_plus = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_plus.frame = CGRectMake(180.0f, 70.0f, 30.0f, 30.0f);
    //UIImage* image_plus = [UIImage imageNamed:@"plus.png"];
    //[btn_plus setBackgroundImage:image_plus forState:UIControlStateNormal];
    [btn_plus setBackgroundColor: [UIColor colorNamed:@"appRed_Color"]];
    [btn_plus setTitle:@"+" forState: UIControlStateNormal];
    [btn_plus setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [btn_plus setClipsToBounds:YES];
    btn_plus.layer.cornerRadius = 15;
    [btn_plus addTarget:self action:@selector(btn_plus:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn_plus];
    
    CGRect someRect = CGRectMake(125.0, 70.0, 50.0, 30.0);
    text_count = [[UITextField alloc] initWithFrame:someRect];
    //    UIView* view = [[UIView alloc] initWithFrame:someRect];
    text_count.text = (strQuantity.length == 0) ? @"1" : strQuantity;
    text_count.textAlignment=NSTextAlignmentCenter;
    [view1 addSubview:text_count];
    
    CGRect someRect_remarks = CGRectMake(50.0, 125.0, 200, 30.0);
    text_remarks = [[UITextField alloc] initWithFrame:someRect_remarks];
    text_remarks.placeholder = @"Remarks";
    text_remarks.textAlignment = NSTextAlignmentCenter;
    text_remarks.borderStyle = UITextBorderStyleRoundedRect;
    [view1 addSubview:text_remarks];
    
    UIButton * btn_save = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_save.frame = CGRectMake(155.0f, 180.0f, 90.0f, 30.0f);
    //UIImage* image_save = [UIImage imageNamed:@"ok.png"];
    //[btn_save setBackgroundImage:image_save forState:UIControlStateNormal];
    [btn_save setBackgroundColor: [UIColor colorNamed:@"appRed_Color"]];
    [btn_save setTitle:@"OK" forState: UIControlStateNormal];
    [btn_save setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    btn_save.layer.cornerRadius = 5;
    [btn_save addTarget:self action:@selector(btn_ok:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn_save];
    
    UIButton * btn_cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_cancel.frame = CGRectMake(55.0f, 180.0f, 90.0f, 30.0f);
    //UIImage *image_cancel = [UIImage imageNamed:@"cancel.png"];
    //[btn_cancel setBackgroundImage:image_cancel forState:UIControlStateNormal];
    [btn_cancel setBackgroundColor: [UIColor colorNamed:@"appRed_Color"]];
    [btn_cancel setTitle:@"Cancel" forState: UIControlStateNormal];
    [btn_cancel setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    btn_cancel.layer.cornerRadius = 5;
    [btn_cancel addTarget:self action:@selector(btn_cancel:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn_cancel];
}

-(void)PopupView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please enter Tagno" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Please enter Tagno";
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
        UITextField *txt_tagno = alertController.textFields.firstObject;
        if (![txt_tagno.text isEqualToString:@"Please enter Tagno"]) {
            [self filterDataWithTag:txt_tagno textDidChange:txt_tagno.text];
        }else{
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
        self->tagno=@"";
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)filterDataWithTag:(UITextField *)search textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        nsarray_product = arrayMasterProductList;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *item, NSDictionary *bindings) {
            NSString *name = [item[@"tgno"] lowercaseString];
            NSString *searchLower = [searchText lowercaseString];
            
            return ([name containsString:searchLower]);
        }];
        nsarray_product = [[arrayMasterProductList filteredArrayUsingPredicate:predicate] mutableCopy];
        if (nsarray_product.count < 1) {
            nsarray_product = arrayMasterProductList;
        }
    }
    //dispatch_async(dispatch_get_main_queue(), ^{
    [self.collectionView reloadData];
    [search resignFirstResponder];
    // });
}

#pragma mark - Pop Up view Button Action Method

-(void)btn_plus:(UIButton*)sender{
    NSString *str_total = text_count.text;
    int aValue = [[str_total stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
    NSLog(@"%d", aValue);
    aValue = aValue+1;
    NSString* myNewString = [NSString stringWithFormat:@"%i", aValue];
    text_count.text = myNewString;
    myCounter++;
    NSLog(@"myCounter =%d",myCounter);
}

-(void)btn_minus:(UIButton*)sender{
    NSString *str_total=text_count.text;
    if ([str_total isEqualToString:@"0"]){
        
    }else{
        int aValue = [[str_total stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
        NSLog(@"%d", aValue);
        aValue = aValue-1;
        NSString *myNewString = [NSString stringWithFormat:@"%i", aValue];
        text_count.text = myNewString;
        myCounter--;
        NSLog(@"myCounter = %d",myCounter);
    }
}


-(void)btn_ok:(UIButton*)sender{
    [self scrollData_InsertItem:text_count.text];
    [UIView transitionWithView:view1 duration:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self->view1.hidden = YES;
    }completion:NULL];
    transparentView.hidden = YES;
    [self.collectionView reloadData];
}

-(void)btn_cancel:(UIButton*)sender{
    [UIView transitionWithView:view1 duration:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self->view1.hidden = YES;
    } completion:NULL];
    transparentView.hidden=YES;
}

#pragma mark: - Api Method

-(void)scrollData_InsertItem:(NSString *)strQty {
    
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *category = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *firmname = [[NSUserDefaults standardUserDefaults]stringForKey:@"firmname"];
    NSString *name = [[NSUserDefaults standardUserDefaults]stringForKey:@"name"];
    
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
    
    NSString *str_idesc = [[nsarray_product valueForKey:@"idesc"] objectAtIndex:index_cart];
    NSString *str_tgno = [[nsarray_product valueForKey:@"tgno"] objectAtIndex:index_cart];
    NSString *str_tpre = [[nsarray_product valueForKey:@"tpre"] objectAtIndex:index_cart];
    NSString *str_gwt = [[nsarray_product valueForKey:@"gwt"] objectAtIndex:index_cart];
    NSString *str_design = [[nsarray_product valueForKey:@"design"] objectAtIndex:index_cart];
    NSString *salemrp = [[nsarray_product valueForKey:@"salemrp"] objectAtIndex:index_cart];
    NSString *tsno = [[nsarray_product valueForKey:@"tsno"] objectAtIndex:index_cart];
    NSString *stamp = [[nsarray_product valueForKey:@"stamp"] objectAtIndex:index_cart];
    NSString *remarks = text_remarks.text;
    
    NSString *str_qty = strQty; //text_count.text;
    NSString *wt = @"";
    NSString *rlid = @"0";
    NSString *branchid = @"0";
    
    [nsarray_qty replaceObjectAtIndex:index_cart withObject:str_qty];
    [self.collectionView reloadData];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    
    if ([ECAT_TYPE isEqualToString:@"1"])
    {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest = [NSString stringWithFormat:@"apptype=%@&category=%@&userid=%@&str_qty=%@&str_idesc=%@&str_tgno=%@&str_tpre=%@&str_gwt=%@&str_design=%@&mobile=%@&firmname=%@&name=%@&salemrp=%@&wt=%@&tsno=%@&stamp=%@&branchid=%@&rlid=%@&remarks=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,category,userid,str_qty,str_idesc,str_tgno,str_tpre,str_gwt,str_design,mobile,firmname,name,salemrp,wt,tsno,stamp,branchid,rlid,remarks,ip,db,ipusername,pswd,ftppath];
        
        URL_API =[WEB_URL URL_INSERT_ITEM];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/insert_singleitem_android.php",ip];
        
        loginRequest = [NSString stringWithFormat:@"apptype=%@&category=%@&userid=%@&str_qty=%@&str_idesc=%@&str_tgno=%@&str_tpre=%@&str_gwt=%@&str_design=%@&mobile=%@&firmname=%@&name=%@&salemrp=%@&wt=%@&tsno=%@&stamp=%@&branchid=%@&rlid=%@&remarks=%@&ftppath=%@",apptype,category,userid,str_qty,str_idesc,str_tgno,str_tpre,str_gwt,str_design,mobile,firmname,name,salemrp,wt,tsno,stamp,branchid,rlid,remarks,ftppath];
        
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&category=%@&userid=%@&str_qty=%@&str_idesc=%@&str_tgno=%@&str_tpre=%@&str_gwt=%@&str_design=%@&mobile=%@&firmname=%@&name=%@&salemrp=%@&wt=%@&tsno=%@&stamp=%@&branchid=%@&rlid=%@&remarks=%@",apptype,category,userid,str_qty,str_idesc,str_tgno,str_tpre,str_gwt,str_design,mobile,firmname,name,salemrp,wt,tsno,stamp,branchid,rlid,remarks];
        URL_API = [WEB_URL URL_INSERT_ITEM];
    }
    NSLog(@"Add cart Param = %@",loginRequest);
    NSLog(@"Add cart url = %@",URL_API);
    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
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
                [self parseResponse_Save:data];
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


- (void)parseResponse_Save:(NSData *) data {
    @try {
        
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
            NSMutableArray*nsarray_msg = [pDict objectForKey:@"message"];
            NSString *str_msg = [nsarray_msg description];
            
            if ([str_success isEqualToString:@"1"]) {
                
                [self CHECK_COUNTER];
            }else{
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                              message:str_msg
                                                                       preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                    //                                                NSLog(@"you pressed Yes, please button");
                }];
                [alert addAction:yesButton];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)URL_SINGLE_ITEM_DELETE {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    
    NSString * str_tgno = [[nsarray_product valueForKey:@"tgno"]objectAtIndex:index_cart];
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"mobile=%@&tgno=%@&apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",mobile,str_tgno,apptype,ip,db,ipusername,pswd,ftppath];
        
        URL_API =[WEB_URL URL_Delete_CART_Item];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/delete_cart_item.php",ip];
        loginRequest=[NSString stringWithFormat:@"mobile=%@&tgno=%@&apptype=%@&ftppath=%@",mobile,str_tgno,apptype,ftppath];
        
    }else{
        loginRequest=[NSString stringWithFormat:@"mobile=%@&tgno=%@&apptype=%@",mobile,str_tgno,apptype];
        URL_API =[WEB_URL URL_Delete_CART_Item];
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
    
    //Apply the data to the body
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        // handle response
        
        if ([data length] >0 && error == nil){
            //process the JSON response
            //use the main queue so that we can interact with the screen
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parse_SINGLE_ITEM:data];
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


- (void)parse_SINGLE_ITEM:(NSData *) data {
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
            NSMutableArray*nsarray_msg = [pDict objectForKey:@"message"];
            NSString *str_msg = [nsarray_msg description];
            
            [nsarray_qty replaceObjectAtIndex:index_cart withObject:@"0"];
            [self.collectionView reloadData];
            
            if ([str_success isEqualToString:@"1"]) {
                
                //[self scrollData_Category];
                [self CHECK_COUNTER];
                
            }else{
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                              message:str_msg
                                                                       preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                }];
                [alert addAction:yesButton];
                [self presentViewController:alert animated:YES completion:nil];
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
            barButton.badgeValue = str_counter;
            if ([str_counter isEqualToString:@"0"]) {
                
            }else{
               
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)userDidTakeScreenshot:(NSNotification *)notification {
    // Your code to handle the screenshot event
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                             message:@"Screenshot detected!"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    // Optionally, you can blur or hide sensitive content here
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:blurEffectView];
    
    // Remove blur effect after a delay (e.g., 3 seconds)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [blurEffectView removeFromSuperview];
    });
    
}

- (void)loadShareConfig {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    galleryImageSelectedIndex = [defaults integerForKey:@"galleryImage"];
    //str_msg = [defaults stringForKey:@"customMessage"];
}

- (void)shareWithIndex: (NSInteger )index {
    switch (index) {
        case 1:
            //with img
            break;
        case 2:
            //only img
            break;
        case 3:
            //seperate
            break;
        default:
            //without img
            break;
    }
}

#pragma mark: - IBAction Method

- (IBAction)btn_SelectAll:(UIButton *)sender{
    sender.selected = !sender.selected;
    [selectedItems removeAllObjects];
    if (sender.selected){
        selectedItems = [nsarray_product mutableCopy];
    }
    NSString *str_Share = [NSString stringWithFormat:@"Share (%lu)", (unsigned long)[selectedItems count]];
    [self.btn_Share setTitle: str_Share forState: UIControlStateNormal];
    if([selectedItems count] > 0){
        self.btn_Share.hidden = false;
        self.btn_Type.hidden = false;
    }else{
        self.btn_Share.hidden = YES;
        self.btn_Type.hidden = true;
    }
    [self.collectionView reloadData];
}

- (IBAction)btnShortAction:(UIButton *)sender{
    sender.selected = !sender.selected;

    if (!sender.selected) {
        // Descending order
        [nsarray_product sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
            double gwt1 = [obj1[@"gwt"] doubleValue];
            double gwt2 = [obj2[@"gwt"] doubleValue];
            return (gwt1 < gwt2) ? NSOrderedDescending : (gwt1 > gwt2) ? NSOrderedAscending : NSOrderedSame;
        }];
    } else {
        // Ascending order
        [nsarray_product sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
            double gwt1 = [obj1[@"gwt"] doubleValue];
            double gwt2 = [obj2[@"gwt"] doubleValue];
            return (gwt1 > gwt2) ? NSOrderedDescending : (gwt1 < gwt2) ? NSOrderedAscending : NSOrderedSame;
        }];
    }

    [self.collectionView reloadData];

}

- (IBAction)btn_tag:(id)sender{
    [self PopupView];
}

- (IBAction)btn_Type:(id)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose an Option for Pdf file"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];

    //NSArray *options = @[@"With Image", @"Only Image", @"Without Image", @"Seperate Page"];
    NSArray * options = @[ @{@"index": @0, @"name": @"Without Image"},
                 @{@"index": @1, @"name": @"With Image"},
                 @{@"index": @2, @"name": @"Only Image"},
                 @{@"index": @3, @"name": @"Seperate Page"}
    ];

    for (NSString *option in options) {
        
        int index = [[option valueForKey:@"index"] intValue];
        NSString *name = [option valueForKey:@"name"];
        
        // Add checkmark to currently selected option
        if (index == self->galleryImageSelectedIndex) {
            name = [NSString stringWithFormat:@"✓   %@", name];
        }
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:name
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Selected: %@, %d", [option valueForKey:@"name"] , [[option valueForKey:@"index"] intValue]);
            self->galleryImageSelectedIndex = [[option valueForKey:@"index"] intValue];
        }];
        [alert addAction:action];
    }

    // Cancel button
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btnNextAction:(id)sender{
    
}

- (IBAction)btnPreAction:(id)sender{
    
}

- (IBAction)btn_share:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger shareConfigSelectedIndex = [defaults integerForKey:@"galleryShare"];
    
    NSLog(@"ns_tgno - %@",ns_tgno);
    NSArray *tsnoArray = [selectedItems valueForKey:@"tsno"];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *item in selectedItems) {
        NSString *str_item1 = [item valueForKey:@"item1"];
        NSString *str_item2 = [item valueForKey:@"item2"];
        NSString *str_item3 = [item valueForKey:@"item3"];
        NSString *str_item4 = [item valueForKey:@"item4"];
        NSString *str_item5 = [item valueForKey:@"item5"];
        NSString *str_item6 = [item valueForKey:@"item6"];
        NSString *str_itemimage = [item valueForKey:@"itemimage"];
        [dataArray addObject:str_item1];
        [dataArray addObject:str_item2];
        [dataArray addObject:str_item3];
        [dataArray addObject:str_item4];
        [dataArray addObject:str_item5];
        [dataArray addObject:str_item6];
        [dataArray addObject:str_itemimage];
    }
    
    
    NSLog(@"%@", tsnoArray);  // Output: (31, 30)
    NSString *str_data = [tsnoArray componentsJoinedByString:@","]; // You can choose any separator
    NSLog(@"str_tgno - %@",str_data);
    if (galleryImageSelectedIndex == 3){
        //URL_Get_Separate_Pdf
        [self Share_SeparatePdf_API:str_data dataArray: dataArray];
    }else{
        if (shareConfigSelectedIndex == 1){
            [self SHARE_API:str_data];
        }else{
//            if (galleryImageSelectedIndex == 2){
//                [self SHARE_API:str_tsno];
//            }else{
                // Generate the PDF from the cart items
                NSURL *pdfURL = [self createPDFWithCartItems:selectedItems];
                // Share the PDF
                [self sharePDF1: pdfURL];
//            }
        }
    }
}

- (void)Share_SeparatePdf_API:(NSString *)str_tsno dataArray:(NSArray *)dataArray{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    
    NSString *selectId = [NSString stringWithFormat:@"%li", (long)galleryImageSelectedIndex];
    NSString *paramRequest = [NSString stringWithFormat:@"item1=%@&item2=%@&item3=%@&item4=%@&item5=%@&item6=%@&with_images=%@&data=[%@]",item1,item2,item3,item4,item5,item6,selectId,str_tsno];
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,ip,db,ipusername,pswd,ftppath];
        URL_API =[WEB_URL URL_Get_Separate_Pdf];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_separate_pdf.php",ip];
        loginRequest=[NSString stringWithFormat:@"mobile=%@&apptype=%@&userid=%@&ftppath=%@",mobile,apptype,userid,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"mobile=%@&apptype=%@&userid=%@",mobile,apptype,userid];
        URL_API =[WEB_URL URL_Get_Separate_Pdf];
    }
    
    loginRequest = [NSString stringWithFormat:@"%@&%@",loginRequest, paramRequest];
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSURL *url = [NSURL URLWithString:api];
    
    NSLog(@"Separate Param request = %@", loginRequest);
    NSLog(@"Separate url request = %@", url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        // handle response
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parse_SeparatePdf:data];
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

- (void)parse_SeparatePdf:(NSData *) data {
    @try {
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
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            NSMutableArray *arrayResponse_success = [pDict objectForKey:@"success"];
            NSString *str_success = [arrayResponse_success description];
            NSMutableArray*nsarray_msg = [pDict objectForKey:@"message"];
            NSString *str_msg = [nsarray_msg description];
            NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
            
            if ([str_success isEqualToString:@"1"]){
                NSMutableArray *nsarray_url = [pDict objectForKey:@"url"];
                NSString *url = [nsarray_url description];
                NSLog(@"url ...::::  %@",url);
                NSString *pdfUrl = [NSString stringWithFormat:@"%@%@",ftppath, url];
                [self sharePDF:pdfUrl];
            }else{
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                              message:str_msg
                                                                       preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {}];
                [alert addAction:yesButton];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

- (void)SHARE_API:(NSString *)str_tsno{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    NSString *selectId = [NSString stringWithFormat:@"%li", (long)galleryImageSelectedIndex];
    NSString *paramRequest = [NSString stringWithFormat:@"item1=%@&item2=%@&item3=%@&item4=%@&item5=%@&item6=%@&with_images=%@&data=[%@]",item1,item2,item3,item4,item5,item6,selectId,str_tsno];
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,ip,db,ipusername,pswd,ftppath];
        URL_API =[WEB_URL URL_SHARE_PDF];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_pdfnew.php",ip];
        loginRequest=[NSString stringWithFormat:@"mobile=%@&apptype=%@&ftppath=%@",mobile,apptype,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"mobile=%@&apptype=%@",mobile,apptype];
        URL_API =[WEB_URL URL_SHARE_PDF];
    }
    
    loginRequest = [NSString stringWithFormat:@"%@&%@",loginRequest, paramRequest];
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSURL *url = [NSURL URLWithString:api];
    
    NSLog(@"pdf Param request = %@", loginRequest);
    NSLog(@"pdf url request = %@", url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        // handle response
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parse_share:data];
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

- (void)parse_share:(NSData *) data {
    @try {
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
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            NSMutableArray *arrayResponse_success = [pDict objectForKey:@"success"];
            NSString *str_success = [arrayResponse_success description];
            NSMutableArray*nsarray_msg = [pDict objectForKey:@"message"];
            NSString *str_msg = [nsarray_msg description];
            NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
            if ([str_success isEqualToString:@"1"]){
                NSMutableArray *nsarray_url = [pDict objectForKey:@"url"];
                NSString *url = [nsarray_url description];
                NSLog(@"url ...::::  %@",url);
                NSString *pdfUrl = [NSString stringWithFormat:@"%@%@",ftppath, url];
                [self sharePDF:pdfUrl];
            }else{
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                              message:str_msg
                                                                       preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {}];
                [alert addAction:yesButton];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

//- (void)sharePDF:(NSString *)pdfURL
//{
//    // Create a URL session to download the PDF
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *downloadTask = [session dataTaskWithURL:pdfURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (error) {
//            NSLog(@"Error downloading PDF: %@", error.localizedDescription);
//            return;
//        }
//
//        // Save PDF data to a temporary file
//        NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"shared.pdf"];
//        [data writeToFile:tempPath atomically:YES];
//
//        // Prepare the file URL for sharing
//        NSURL *fileURL = [NSURL fileURLWithPath:tempPath];
//
//        // Create the activity view controller
//        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[fileURL] applicationActivities:nil];
//
//        // Present the activity view controller on the main thread
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self presentViewController:activityVC animated:YES completion:nil];
//        });
//    }];
//
//    // Start the download task
//    [downloadTask resume];
//}

- (NSURL *)createPDFWithCartItems:(NSArray *)cartItems {
    // Get the PDF file URL (temporary directory)
    NSString *fileName = [NSString stringWithFormat:@"%@ item.pdf", cartItems[0][@"idesc"]];
    //NSString *pdfPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Items.pdf"];
    NSString *pdfPath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    NSURL *pdfURL = [NSURL fileURLWithPath:pdfPath];
    
    // Start the PDF context
    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil);
    
    // Set font and other properties
    UIFont *font = [UIFont systemFontOfSize:14.0];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:16.0];
    CGFloat yPosition = 20; // Start at the top of the page
    CGFloat pageHeight = 800; // Standard page height (for A4 paper)
    //CGFloat pageWidth = 600; // Standard page width
    CGFloat maxYPosition = pageHeight - 20; // Allow some space at the bottom
    int currentItemCount = 0; // Track how many items have been added to the current page
    
    // Start a new page in the PDF
    UIGraphicsBeginPDFPage();
    
    // Loop through cart items and draw them into the PDF
    for (NSDictionary *item in cartItems) {
        CGFloat imageHeight = galleryImageSelectedIndex == 2 ? 740 : 80;
        CGFloat imageWidth = 0;
        if (galleryImageSelectedIndex != 0){
            imageWidth = galleryImageSelectedIndex == 2 ? 580 : 80;
            NSURL *URL;
            URL = [NSURL URLWithString: item[@"itemimage"]];
            NSString *myString = [URL absoluteString];
            [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
            UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(20, yPosition, imageHeight, imageHeight)];
            [imgView sd_setImageWithURL:[NSURL URLWithString:myString]
                       placeholderImage:[UIImage imageNamed:@"1024.png"] options: 0];
            UIImage *image = imgView.image;
            if (image) {
                [image drawInRect:CGRectMake(20, yPosition, imageWidth, imageHeight)];
            }
            
        }
        if (galleryImageSelectedIndex != 2){
            NSString *itemName = [NSString stringWithFormat:@"%@", item[@"idesc"]];
            NSString *tagNo= [NSString stringWithFormat:@"Tag No - %@, Gross Wt. - %@, Wt. - %@, Stamp - %@", item[@"tgno"],item[@"gwt"],item[@"wt"], item[@"stamp"]];
            NSString *itemQty = [NSString stringWithFormat:@"Salemrp - %@",item[@"salemrp"]];
            [itemName drawAtPoint:CGPointMake(imageWidth + 20, yPosition + 15) withAttributes:@{NSFontAttributeName: boldFont}];
            [tagNo drawAtPoint:CGPointMake(imageWidth + 20, yPosition + 40) withAttributes:@{NSFontAttributeName: font}];
            [itemQty drawAtPoint:CGPointMake(imageWidth + 20, yPosition + 60) withAttributes:@{NSFontAttributeName: font}];
        }
        yPosition += imageHeight + 20;  // Move down for the next item
        
        // Increment the item count on the page
        currentItemCount++;
        // Check if the content is overflowing, if yes, start a new page
        if (yPosition > maxYPosition) {
            // Start a new page if content overflows
            UIGraphicsBeginPDFPage();
            yPosition = 20; // Reset yPosition for the new page
            currentItemCount = 0;  // Reset item count for the new page
        }
    }
    // End the PDF context
    UIGraphicsEndPDFContext();
    return pdfURL;
}

- (void)sharePDF1:(NSURL *)pdfURL {
    // Create a UIActivityViewController to share the PDF
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[pdfURL] applicationActivities:nil];
    // Exclude irrelevant activity types (optional)
    activityVC.excludedActivityTypes = @[UIActivityTypeAddToReadingList, UIActivityTypePostToFacebook];
    // Present the activity view controller
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)sharePDF:(NSString *)pdfURL1
{
    NSURL *pdfURL = [NSURL URLWithString:pdfURL1];
    [self sharePDF1:pdfURL];
    return;
    // Create a URL session to download the PDF
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *downloadTask = [session dataTaskWithURL:pdfURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error downloading PDF: %@", error.localizedDescription);
            return; // Early return if there's an error
        }
        
        // Check if the response is valid
        if (data == nil || response == nil) {
            NSLog(@"Invalid response or data");
            return;
        }
        
        // Save PDF data to a temporary file
        NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"shared.pdf"];
        BOOL success = [data writeToFile:tempPath atomically:YES];
        
        if (!success) {
            NSLog(@"Error saving PDF file");
            return; // Early return if there's an error saving
        }
        
        // Prepare the file URL for sharing
        NSURL *fileURL = [NSURL fileURLWithPath:tempPath];
        
        // Check if fileURL is valid
        if (![fileURL isKindOfClass:[NSURL class]]) {
            NSLog(@"Invalid file URL");
            return; // Early return if the URL is invalid
        }
        
        // Create the activity view controller
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[fileURL] applicationActivities:nil];
        
        // Present the activity view controller on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:activityVC animated:YES completion:nil];
        });
    }];
    
    // Start the download task
    [downloadTask resume];
}


@end
