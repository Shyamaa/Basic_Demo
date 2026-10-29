//
//  ProductGroup.m
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 27/07/22.
//  Copyright © 2022 MMI Softwares. All rights reserved.
//

#import "ProductGroup.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "UIImageView+WebCache.h"
#import "WalletVC.h"
#import "WalletHistoryVC.h"
#import "ItemListVC.h"
#import "ProductGallery.h"

@interface ProductGroup ()
@end

@implementation ProductGroup
@synthesize str_activity,str_tsnolist;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    self.title=@"Product Group";

    NSString *username = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
    lbl_welcome.text=[NSString stringWithFormat:@"Welcome %@",username];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyCell_item_home568" bundle:nil] forCellWithReuseIdentifier:@"MyCell"];
    [self scrollData_Category:@""];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDidTakeScreenshot:)
                                                     name:UIApplicationUserDidTakeScreenshotNotification
                                                object:nil];
    [self setUpNavigationButton];
    arrayFilterList = [[NSMutableArray alloc]init];
}


- (void)dealloc {
    // Remove observer when the view controller is deallocated
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationUserDidTakeScreenshotNotification
                                                  object:nil];
}

- (void)setUpNavigationButton {
    NSString *strTemplate = [[NSUserDefaults standardUserDefaults]stringForKey:@"template"];
    if (![strTemplate isEqualToString:@"2"]) {
        btn_Filter =  [UIButton buttonWithType:UIButtonTypeCustom];
        btn_Filter.frame = CGRectMake(0,8,35,35);
        //[btn_Filter setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
        //[[btn_Filter imageView] setContentMode: UIViewContentModeScaleAspectFit];
        [btn_Filter setTitle:@"Filter" forState:UIControlStateNormal];
        btn_Filter.tintColor = [UIColor whiteColor];
        [btn_Filter addTarget:self action:@selector(filterNavigationButtonAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barFilterBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_Filter];
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        space.width = 4;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:barFilterBtn, nil];
    }
}

- (void)filterNavigationButtonAction {
    [self setUpFilterAlertList];
}

-(void)setUpFilterAlertList {
    CGRect rect;
    UIViewController *filterController = [[UIViewController alloc]init];
    rect = CGRectMake(0, 0, 280, 40*[arrayFilterList count]);
    [filterController setPreferredContentSize:rect.size];
    
    filterTableView = [[UITableView alloc]initWithFrame:rect];
    filterTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [filterTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [filterTableView setTag:1000];
    [filterTableView setUserInteractionEnabled:YES];
    [filterTableView setAllowsSelection:YES];
    [filterController.view addSubview:filterTableView];
    [filterController.view bringSubviewToFront:filterTableView];
    [filterController.view setUserInteractionEnabled:YES];
    filterTableView.delegate = self;
    filterTableView.dataSource = self;
    [filterTableView reloadData];
    
    filterAlertType = [UIAlertController alertControllerWithTitle:NULL message:nil preferredStyle:UIAlertControllerStyleAlert];
    [filterAlertType setValue:filterController forKey:@"contentViewController"];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"not select data");
    }];
    
    [filterAlertType addAction:cancelAction];
    [self presentViewController:filterAlertType animated:YES completion:nil];
}

#pragma mark:- Api Method

-(void)scrollData_Category:(NSString *)siteID {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *category = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
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

        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&tsnolist=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&siteid=%@",apptype,category,tsnolist,ip,db,ipusername,pswd,ftppath,siteID];
        URL_API =[WEB_URL URL_PRODUCT_GROUP];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/getpoductgroup.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&tsnolist=%@&ftppath=%@&siteid=%@",apptype,category,tsnolist,ftppath,siteID];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&tsnolist=%@&siteid=%@",apptype,category,tsnolist,siteID];
        URL_API =[WEB_URL URL_PRODUCT_GROUP];
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
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        [self getFilterItemAPI];
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
            
            nsarray_product =[[NSMutableArray alloc]init];
            nsarray_product = [pDict objectForKey:@"grouplist"];
            NSLog(@"nsarray_product :: %@",nsarray_product);
            
            [self.collectionView reloadData];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

- (void)getFilterItemAPI{
    
    [[BusyIndicator sharedInstance] startIndicator];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults] stringForKey:@"ECAT_TYPE"];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    NSString *urlStr;
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        urlStr = [WEB_URL URL_GET_SITE];
    } else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:@"ip"];
        urlStr = [NSString stringWithFormat:@"http://%@/jwellyecat/get_site.php", ip];
    } else {
        urlStr = [WEB_URL URL_GET_SITE];
    }

    NSLog(@"urlStr :::::::::: %@",urlStr);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setHTTPMethod:@"POST"];
    
    NSString *mobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"mobile"];
    NSString *regmobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"regmobile"];
    NSMutableString *postBody = [NSMutableString stringWithFormat:@"apptype=%@&mobile=%@", ECAT_TYPE, regmobile];

    if ([regmobile isEqualToString:mobile]) {
        [postBody appendString:@"&is_register=1"];
    } else {
        [postBody appendString:@"&is_register=0"];
    }

    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults] stringForKey:@"db"];
        NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"ipusername"];
        NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults] stringForKey:@"ftppath"];

        [postBody appendFormat:@"&ip=%@&ipusername=%@&password=%@&dbname=%@&ftppath=%@", ip, username, password, db, ftppath];
    }
    NSLog(@"postBody :::::::::: %@",postBody);

    [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
        dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }

        NSError *jsonError;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        [[BusyIndicator sharedInstance] stopIndicator];

        if (!jsonError) {
            NSLog(@"responseDict :::::::::: %@",responseDict);
            self->arrayFilterList = [responseDict[@"sitelist"] mutableCopy];
            NSDictionary *dict = @{
                @"site": @"ALL",
                @"site_idds": @"",
                @"siteid": @""
            };
            [self->arrayFilterList insertObject:dict atIndex:0];
            
            //[self->arrayFilterList addObject:@"ALL"];
            /*
            NSArray *sitelist = responseDict[@"sitelist"];
            if (isFirst) {
                [self.siteList removeAllObjects];
                [self.items removeAllObjects];
                [self.selectedItems removeAllObjects];
            }

            for (NSDictionary *siteDict in sitelist) {
                ObjectSiteModel *model = [[ObjectSiteModel alloc] initWithName:siteDict[@"site"] siteid:siteDict[@"siteid"]];
                [self.siteList addObject:model];
                [self.items addObject:model.sitename];
                [self.selectedItems addObject:@(NO)];
                self.serverSiteIds = siteDict[@"site_idds"];
            }
            
            if (isFirst) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showDialog:mobile];
                });
            }
             */
        }
        
    }];
    [task resume];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[nsarray_product valueForKey:@"igroup"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell" forIndexPath:indexPath];
    
    [cell.imgeDataArray sd_setImageWithURL:[NSURL URLWithString:[[nsarray_product valueForKey:@"imgname"] objectAtIndex:indexPath.row]]
                                 placeholderImage:[UIImage imageNamed:@"1024.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached:YES];
   cell.imgeDataArray.tag = indexPath.row;
    cell.imgeDataArray.contentMode = UIViewContentModeScaleAspectFill;
   
    NSString *str_idesc =[[nsarray_product valueForKey:@"igroup"] objectAtIndex:indexPath.row];
    if (str_idesc == (id)[NSNull null] || str_idesc.length == 0 ) str_idesc = @"";
    cell.lblTitle.text=str_idesc;
    cell.back_view.layer.borderColor = [UIColor colorNamed:@"border_Color"].CGColor;
    cell.back_view.layer.borderWidth = 1;
    cell.back_view.layer.cornerRadius = 10;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        cell.lblTitle.font = [UIFont systemFontOfSize:24.0];
    }
    
//    cell.lblTitle.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
//    cell.lblTitle.adjustsFontForContentSizeCategory = YES;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductGallery *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"ProductGallery"];
    obj.str_igroup=[[nsarray_product valueForKey:@"igroup"] objectAtIndex:indexPath.row];
    obj.str_siteid = str_siteid.length > 0 ? str_siteid : @"";
    [self.navigationController pushViewController:obj animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat width = ((self.collectionView.frame.size.width-10)/2);
    return CGSizeMake(width, width*1.5);
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(0, 2, 0,2);
//}

#pragma mark: Screenshot Notification Method

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

#pragma mark - TableView DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return [arrayFilterList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AlertCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
//    if (indexPath.row == 0){
//        cell.textLabel.text = arrayFilterList[indexPath.row];
//    }else{
        cell.textLabel.text = [[arrayFilterList valueForKey:@"site"] objectAtIndex:indexPath.row];
//    }
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [filterAlertType dismissViewControllerAnimated:YES completion:nil];
    str_siteid = [[arrayFilterList valueForKey:@"siteid"] objectAtIndex:indexPath.row];
    NSString *siteName = [[arrayFilterList valueForKey:@"site"] objectAtIndex:indexPath.row];
    NSLog(@"Selected item: name - %@ and id - %@",siteName, str_siteid);
    [self scrollData_Category: str_siteid];
//    if (indexPath.row == 0) {
//        [btn_Filter setTitle:@"Filter" forState:UIControlStateNormal];
//    }else{
//        [btn_Filter setTitle:siteName forState:UIControlStateNormal];
//    }
}

@end
