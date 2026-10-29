//
//  ProductGallery.m
//  MMI ECAT
//
//  Created by mmsoft116 on 05/09/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "ProductGallery.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "UIImageView+WebCache.h"
#import "WalletVC.h"
#import "WalletHistoryVC.h"
#import "ItemListVC.h"
#import "CustomerVisit.h"
#import "CartList.h"
#import "StockVC.h"


@interface ProductGallery ()
{
    UIButton * btnAdd_Cart;
    BBBadgeBarButtonItem *barButton;
}
@end

@implementation ProductGallery
@synthesize str_activity,str_igroup,str_tsnolist,str_siteid;

#pragma mark - Class Method

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [self.str_igroup isEqualToString:@""] ? @"Product Gallery" : self.str_igroup;
    NSString *username = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
    lbl_welcome.text=[NSString stringWithFormat:@"Welcome %@",username];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    if ([ECAT_TYPE isEqualToString:@"3"]) {
        self.bottomView.hidden = false;
    }
//
//    [self.collectionView registerNib:[UINib nibWithNibName:@"MyCell_item_home" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
//
//    self.collectionView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0];
//    self.collectionView.alwaysBounceVertical = NO;
//    self.collectionView.bounces = NO;
//    [self.view addSubview:self.collectionView];
//    [self.collectionView reloadData];
    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
//    [self.collectionView registerClass:[CustomCell class] forCellWithReuseIdentifier:@"CELL"];
//    [self.view addSubview:self.collectionView];
    
    tsnolist=@"";
    arrayMasterProductList = [[NSMutableArray alloc]init];
    if ([str_activity isEqualToString:@"CDemand"]) {
        tsnolist=str_tsnolist;
    }
    [self scrollData_Category];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(userDidTakeScreenshot:)
                                                    name:UIApplicationUserDidTakeScreenshotNotification
                                                  object:nil];
    [self setUpNavigationButton];
    if (_openWithSidMenu) {
        [self setUpLeftMenuBtn];
    }
    barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:btnAdd_Cart];
    //barButton.badgeOriginX = 0;
    //barButton.badgeOriginY = 0;
}

-(void)viewWillAppear:(BOOL)animated{
    [self CHECK_COUNTER];
}

- (void)dealloc {
    // Remove observer when the view controller is deallocated
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationUserDidTakeScreenshotNotification
                                                  object:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

- (void)setUpNavigationButton {
    
    btnAdd_Cart =  [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd_Cart.frame = CGRectMake(0,5,30,30);
    [btnAdd_Cart setImage:[UIImage imageNamed:@"cart_menu.png"] forState:UIControlStateNormal];
    [btnAdd_Cart addTarget:self action:@selector(btn_CartMenu) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cartBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnAdd_Cart];
    cartBarButton.tintColor = [UIColor whiteColor];
    
    UIButton * btn_Search =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Search.frame = CGRectMake(0,8,35,35);
    [btn_Search setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [[btn_Search imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_Search.tintColor = [UIColor whiteColor];
    [btn_Search addTarget:self action:@selector(searchNavigationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barSearchBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_Search];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 4;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:cartBarButton, barSearchBtn, nil];
}

-(void)btn_CartMenu{
    CartList *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"CartList"];
    obj.str_tag = @"";
    obj.str_activity=@"Show Item";
    [self.navigationController pushViewController:obj animated:YES];
}

- (void)searchNavigationButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected){
        [self.searchBarView setHidden:false];
    }else{
        [self.searchBarView setHidden:true];
        [self.searchBarView resignFirstResponder];
    }
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        nsarray_product = arrayMasterProductList;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *item, NSDictionary *bindings) {
                   NSString *name = [item[@"idesc"] lowercaseString];
                   NSString *searchLower = [searchText lowercaseString];

                   return ([name containsString:searchLower]);
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


#pragma mark - APIs Methods

-(void)scrollData_Category {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *category = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    str_siteid = str_siteid.length > 0 ? str_siteid : @"";
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
  
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&tsnolist=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&igroup=%@&siteid=%@",apptype,category,tsnolist,ip,db,ipusername,pswd,ftppath,str_igroup,str_siteid];
        URL_API =[WEB_URL URL_PRODUCT_GALLERY];
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/getproductgallery.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&tsnolist=%@&ftppath=%@&igroup=%@&siteid=%@",apptype,category,tsnolist,ftppath,str_igroup,str_siteid];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&tsnolist=%@&igroup=%@&siteid=%@",apptype,category,tsnolist,str_igroup,str_siteid];
        
        NSString *status = [[NSUserDefaults standardUserDefaults]stringForKey:@"status"];
        if ([status isEqualToString:@"4"]) {
            URL_API =[WEB_URL URL_PRODUCT_GALLERY1];
        }else{
            URL_API =[WEB_URL URL_PRODUCT_GALLERY];
        }
    }
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
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
            arrayFilter = [[NSArray alloc]init];
            arrayMasterProductList = [[pDict objectForKey:@"productgallery"] mutableCopy];
            nsarray_product = arrayMasterProductList;
            NSMutableSet *uniqueNames = [NSMutableSet set];
            
            [uniqueNames addObject:@"ALL"];
            for (NSDictionary *dict in arrayMasterProductList) {
                NSString *status = dict[@"status"];
                if (status) {
                    [uniqueNames addObject:status];
                }
            }
            arrayFilter = [uniqueNames allObjects];;
            //arrayFilter = [arrayMasterProductList valueForKey:@"status"];
            NSLog(@"nsarray_product :: %@",nsarray_product);
            [self.collectionView reloadData];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return [nsarray_product count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCell" forIndexPath:indexPath];
    
    NSString *imageUrlString = [[nsarray_product valueForKey:@"imgname"] objectAtIndex:indexPath.row];
    [cell.imgeDataArray sd_setImageWithURL:[NSURL URLWithString:imageUrlString]
                          placeholderImage:[UIImage imageNamed:@"1024.png"]
                                   options:SDWebImageRefreshCached];
    cell.imgeDataArray.contentMode = UIViewContentModeScaleAspectFill;
    NSString *str_idesc = [[nsarray_product valueForKey:@"idesc"] objectAtIndex:indexPath.row];
    if (str_idesc == (id)[NSNull null] || str_idesc.length == 0) {
        str_idesc = @"No Description";
    }
    NSString *total_tag = [[nsarray_product valueForKey:@"total_tag"] objectAtIndex:indexPath.row];
    cell.lblTitle.text = [NSString stringWithFormat:@"%@ (%@)", str_idesc, total_tag];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        cell.lblTitle.font = [UIFont systemFontOfSize:24.0];
    }
    // Apply border radius and drop shadow to the cell content view
    
    cell.backView.layer.cornerRadius = 5;
    cell.backView.layer.masksToBounds = YES;
    // Set background color to white and add border
    cell.backView.backgroundColor = [UIColor whiteColor];
    cell.backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.backView.layer.borderWidth = 1.0;
    // Add shadow to the cell content view
    cell.backView.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.backView.layer.shadowOpacity = 1.7;
    cell.backView.layer.shadowRadius = 10.0;
    cell.backView.layer.shadowOffset = CGSizeMake(3, 3);
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
 
    CGFloat width = ((self.collectionView.frame.size.width-30)/2);
    return CGSizeMake(width, width*1.75);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
//    CGFloat padding = 10.0;
//    CGFloat itemWidth = (screenWidth - (3 * padding)) / 2;
//    CGFloat itemHeight = 200;
//    return CGSizeMake(itemWidth, itemHeight);
//}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section 
//{
//    return UIEdgeInsetsMake(2, 2, 2, 2);
//}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Showitem *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Showitem"];
    obj.str_idesc = [[nsarray_product valueForKey:@"idesc"] objectAtIndex:indexPath.row];
    obj.str_siteid = str_siteid.length > 0 ? str_siteid : @"";
    obj.arrayCategoryList = nsarray_product;
    obj.categoryId = [[nsarray_product valueForKey:@"total_tag"] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:obj animated:YES];
}

#pragma mark - Button Action Method

- (IBAction)btnAction_Filter:(id)sender{
    NSLog(@"Filter");
    [self setUpFilterView];
}

- (IBAction)btnAction_Catalogue:(id)sender{
    NSLog(@"Successfully btnAction_Catalogue...");
}

- (IBAction)btnAction_Visitor:(id)sender{
    CustomerVisit *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomerVisit"];
    obj.str_act = @"";
    [self.navigationController pushViewController:obj animated:YES];
    NSLog(@"Customer_Visitor...");
}

- (IBAction)btnAction_Estimate:(id)sender{
    NSLog(@"Cart");
    CartList *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"CartList"];
    obj.str_tag = @"";
    obj.str_activity=@"Show Item";
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)btnAction_Stock:(id)sender{
    NSLog(@"Stock...");
    StockVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"StockVC"];
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)okBtnAction_FilterView:(id)sender{
    NSString *searchLower = [self.txtFilter.text lowercaseString];
    if ([searchLower isEqualToString:@"all"]){
            self->nsarray_product = self->arrayMasterProductList;
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *item, NSDictionary *bindings) {
                   NSString *status = [item[@"status"] lowercaseString];
                   return ([status containsString:searchLower]);
               }];
        nsarray_product = [[arrayMasterProductList filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.filterView setHidden:YES];
        [self.txtFilter resignFirstResponder];
        [self.collectionView reloadData];
    });
}

- (IBAction)cancelBtnAction_FilterView:(id)sender{
    [self.filterView setHidden:YES];
    [self.txtFilter resignFirstResponder];
}

-(void)setUpFilterView{
    [self.filterView setHidden:NO];
    //NSArray *pickerData = @[@"ALL", @"APPROVAL", @"IN STOCK"];
    [self.txtFilter addPickerWithData:arrayFilter searchEnabled:NO];
}

#pragma mark - Screenshot Method

- (void)userDidTakeScreenshot:(NSNotification *)notification {
    // Create and display the alert
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                             message:@"Screenshot detected!"
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];

    // Optionally, you can blur or hide sensitive content here
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:blurEffectView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [blurEffectView removeFromSuperview];
    });
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

@end
