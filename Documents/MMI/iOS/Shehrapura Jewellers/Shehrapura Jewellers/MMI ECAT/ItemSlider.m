//
//  ItemSlider.m
//  MU JEWELLERS
//
//  Created by MMI SOFTWARES PVT LTD on 18/08/22.
//  Copyright © 2022 MMI Softwares. All rights reserved.
//

#import "ItemSlider.h"
#import "CartList.h"

@interface ItemSlider ()
{
    NSString *item1;
    NSString *item2;
    NSString *item3;
    NSString *item4;
    UIButton * btnAdd_Cart;
    BBBadgeBarButtonItem *barButton;
}
@end

@implementation ItemSlider
@synthesize str_dwt,str_gwt,str_mrp,str_nwt,str_swt,str_idesc,str_activity,str_designno,str_tsnolist,strindex;
static int myCounter;

#pragma mark: - Class Method

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = str_idesc;

    [self setUpRightNavigationBarItems];

    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];

    lbl_welcome.text = [NSString stringWithFormat:@"Welcome %@",username];

    NSInteger intscroll = [strindex intValue];

    NSLog(@"intscroll == %ld",(long)intscroll);

    intscrollitem = intscroll;

    item1 = [[NSUserDefaults standardUserDefaults]stringForKey:@"item1"];
    item2 = [[NSUserDefaults standardUserDefaults]stringForKey:@"item2"];
    item3 = [[NSUserDefaults standardUserDefaults]stringForKey:@"item3"];
    item4 = [[NSUserDefaults standardUserDefaults]stringForKey:@"item4"];

    tsnolist = @"";

    if ([str_activity isEqualToString:@"CDemand"]) {
        tsnolist = str_tsnolist;
    }

    // COLLECTION VIEW SETUP

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    UICollectionViewFlowLayout *layout =
    (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;

    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;

    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidTakeScreenshot:)
                                                 name:UIApplicationUserDidTakeScreenshotNotification
                                               object:nil];

    barButton = [[BBBadgeBarButtonItem alloc]
                 initWithCustomUIButton:btnAdd_Cart];

    //barButton.badgeOriginX = 2;
    //barButton.badgeOriginY = 0;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [self CHECK_COUNTER];

    dispatch_async(dispatch_get_main_queue(), ^{

        [self.collectionView reloadData];

        [self.collectionView layoutIfNeeded];

        if (self->intscrollitem < self.nsarray_product.count) {

            NSIndexPath *indexPath =
            [NSIndexPath indexPathForItem:self->intscrollitem
                                inSection:0];

            [self.collectionView scrollToItemAtIndexPath:indexPath
                                        atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                animated:NO];
        }

        [self setUpView:self->intscrollitem];
    });
}

- (void)dealloc {
    // Remove observer when the view controller is deallocated
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationUserDidTakeScreenshotNotification
                                                  object:nil];
}

-(void)setUpRightNavigationBarItems{
    btnAdd_Cart =  [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd_Cart.frame = CGRectMake(0, 0, 44, 44);
    [btnAdd_Cart setImage:[UIImage imageNamed:@"cart_menu.png"] forState:UIControlStateNormal];
    btnAdd_Cart.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btnAdd_Cart.imageEdgeInsets = UIEdgeInsetsMake(3, 6, 1, 0);
    [btnAdd_Cart addTarget:self action:@selector(btn_CartMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *about = [[UIBarButtonItem alloc] initWithCustomView:btnAdd_Cart];
    about.tintColor = [UIColor whiteColor];
    
    UIButton * btn_Search =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Search.frame = CGRectMake(0,5,30,30);
    [btn_Search setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [[btn_Search imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_Search.tintColor = [UIColor whiteColor];
    [btn_Search addTarget:self action:@selector(searchNavigationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barSearchBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_Search];
    //self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:about, barSearchBtn, nil];
    self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:about, nil];
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
        [self.searchBar setHidden:false];
    }else{
        [self.searchBar setHidden:true];
        [self.searchBar resignFirstResponder];
    }
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.nsarray_product = self.arrayMasterProductList;
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
        self.nsarray_product = [[self.arrayMasterProductList filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    //dispatch_async(dispatch_get_main_queue(), ^{
    [self.collectionView reloadData];
    // });
}

#pragma mark:- Api Method
/*
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
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults
                           standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&idesc=%@&mobile=%@&tsnolist=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&ECAT_TYPE_NEW=%@&wtf=%@&wtt=%@&activity=%@&branchid=%@&stamp=%@&quality=%@&remark=%@",apptype,str_idesc,mobile,tsnolist,ip,db,ipusername,pswd,ftppath,ECAT_TYPE_NEW,@"",@"",@"",@"",@"",@"",@""];
        
        URL_API =[WEB_URL URL_SINGLE_ITEM];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_items_android.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&idesc=%@&mobile=%@&tsnolist=%@&ftppath=%@&ECAT_TYPE_NEW=%@",apptype,category,str_idesc,mobile,tsnolist,ftppath,ECAT_TYPE_NEW];

    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&idesc=%@&mobile=%@&tsnolist=%@&ECAT_TYPE_NEW=%@",apptype,category,str_idesc,mobile,tsnolist,ECAT_TYPE_NEW];
        URL_API =[WEB_URL URL_SINGLE_ITEM];
    }
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSLog(@"urlString ::::%@",urlString);

    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSLog(@"api ::::%@",api);
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
            
            self.nsarray_product =[[NSMutableArray alloc]init];
            self.nsarray_qty =[[NSMutableArray alloc]init];
            self.nsarray_product = [pDict objectForKey:@"items"];
            NSLog(@"nsarray_product slider ********************* :: %@",self.nsarray_product);
            
            [self.collectionView reloadData];

            NSInteger intscroll = [self->strindex intValue];

            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:intscroll inSection:0]
                                           atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                   animated:NO];
            
            for (int i = 0; i < [self.nsarray_product count]; i++) {
                
                NSDictionary * dictObject = [self.nsarray_product objectAtIndex:i];
                NSString *qty = [dictObject objectForKey:@"qty"];
                [self.nsarray_qty addObject:qty];
            }
            [self setUpView:intscrollitem];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}
*/

-(void)scrollData_InsertItem:(NSString *)strQty {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *category = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *firmname = [[NSUserDefaults standardUserDefaults]stringForKey:@"firmname"];
    NSString *name = [[NSUserDefaults standardUserDefaults]stringForKey:@"name"];

    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];

    NSString *str_idesc=[[self.nsarray_product valueForKey:@"idesc"] objectAtIndex:index_cart];
    NSString *str_tgno=[[self.nsarray_product valueForKey:@"tgno"] objectAtIndex:index_cart];
    NSString *str_tpre=[[self.nsarray_product valueForKey:@"tpre"] objectAtIndex:index_cart];
    NSString *str_gwt=[[self.nsarray_product valueForKey:@"gwt"] objectAtIndex:index_cart];
    NSString *str_design=[[self.nsarray_product valueForKey:@"design"] objectAtIndex:index_cart];
    NSString *salemrp=[[self.nsarray_product valueForKey:@"salemrp"] objectAtIndex:index_cart];
    NSString *tsno=[[self.nsarray_product valueForKey:@"tsno"] objectAtIndex:index_cart];
    NSString *stamp=[[self.nsarray_product valueForKey:@"stamp"] objectAtIndex:index_cart];
    NSString *remarks=text_remarks.text;

    NSString *str_qty= strQty; //text_count.text;
    NSString *wt=@"";
    NSString *rlid=@"0";
    NSString *branchid=@"0";
    
    [self.nsarray_qty replaceObjectAtIndex:index_cart withObject:str_qty];
    [self.collectionView reloadData];
    
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

        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&userid=%@&str_qty=%@&str_idesc=%@&str_tgno=%@&str_tpre=%@&str_gwt=%@&str_design=%@&mobile=%@&firmname=%@&name=%@&salemrp=%@&wt=%@&tsno=%@&stamp=%@&branchid=%@&rlid=%@&remarks=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,category,userid,str_qty,str_idesc,str_tgno,str_tpre,str_gwt,str_design,mobile,firmname,name,salemrp,wt,tsno,stamp,branchid,rlid,remarks,ip,db,ipusername,pswd,ftppath];

        URL_API =[WEB_URL URL_INSERT_ITEM];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/insert_singleitem_android.php",ip];

       loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&userid=%@&str_qty=%@&str_idesc=%@&str_tgno=%@&str_tpre=%@&str_gwt=%@&str_design=%@&mobile=%@&firmname=%@&name=%@&salemrp=%@&wt=%@&tsno=%@&stamp=%@&branchid=%@&rlid=%@&remarks=%@&ftppath=%@",apptype,category,userid,str_qty,str_idesc,str_tgno,str_tpre,str_gwt,str_design,mobile,firmname,name,salemrp,wt,tsno,stamp,branchid,rlid,remarks,ftppath];
        
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&userid=%@&str_qty=%@&str_idesc=%@&str_tgno=%@&str_tpre=%@&str_gwt=%@&str_design=%@&mobile=%@&firmname=%@&name=%@&salemrp=%@&wt=%@&tsno=%@&stamp=%@&branchid=%@&rlid=%@&remarks=%@",apptype,category,userid,str_qty,str_idesc,str_tgno,str_tpre,str_gwt,str_design,mobile,firmname,name,salemrp,wt,tsno,stamp,branchid,rlid,remarks];
        URL_API =[WEB_URL URL_INSERT_ITEM];
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

-(void)CHECK_COUNTER {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];

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

        loginRequest=[NSString stringWithFormat:@"mobile=%@&apptype=%@&userid=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",mobile,apptype,userid,ip,db,ipusername,pswd,ftppath];

        URL_API =[WEB_URL URL_COUNTER];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/counter.php",ip];
        loginRequest=[NSString stringWithFormat:@"mobile=%@&apptype=%@&userid=%@&ftppath=%@",mobile,apptype,userid,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"mobile=%@&apptype=%@&userid=%@",mobile,apptype,userid];
        URL_API =[WEB_URL URL_COUNTER];
    }
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
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
                [self parseCounter_Api:data];
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
            
            //check if the country code was valid
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            NSMutableArray *array_counter = [pDict objectForKey:@"counter"];
            NSString *str_counter = [array_counter description];
            
            NSLog(@"str_counter ::::::: %@",str_counter);
            
            if ([str_counter isEqualToString:@"0"]) {
                
            }else{
                barButton.badgeValue = str_counter;
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
    
    NSString * str_tgno = [[self.nsarray_product valueForKey:@"tgno"]objectAtIndex:index_cart];
    
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
            
            [self.nsarray_qty replaceObjectAtIndex:index_cart withObject:@"0"];
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



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.nsarray_product.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemSliderCell" forIndexPath:indexPath];
    
    [cell.imgeDataArray sd_setImageWithURL:[NSURL URLWithString:[[self.nsarray_product valueForKey:@"itemimage"] objectAtIndex:indexPath.row]]
                                 placeholderImage:[UIImage imageNamed:@"1024.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached:YES];
    cell.imgeDataArray.tag = indexPath.row;
    cell.imgeDataArray.contentMode = UIViewContentModeScaleAspectFill;

    NSString *sitem1=[[self.nsarray_product valueForKey:@"item1"] objectAtIndex:indexPath.row];
    NSString *sitem2=[[self.nsarray_product valueForKey:@"item2"] objectAtIndex:indexPath.row];
    NSString *sitem3=[[self.nsarray_product valueForKey:@"item3"] objectAtIndex:indexPath.row];
    NSString *sitem4=[[self.nsarray_product valueForKey:@"item4"] objectAtIndex:indexPath.row];

    NSString * strd1=[NSString stringWithFormat:@"%@ - %@",item1,sitem1];
    NSString * strd2=[NSString stringWithFormat:@"%@ - %@",item2,sitem2];
    NSString * strd3=[NSString stringWithFormat:@"%@ - %@",item3,sitem3];
    NSString * strd4=[NSString stringWithFormat:@"%@ - %@",item4,sitem4];


    NSString * str_deta = [NSString stringWithFormat:@"%@\n%@\n%@\n%@", strd1, strd2,strd3,strd4];
    
    
    NSString * str_dataTitle = [NSString stringWithFormat:@"%@:\n%@:\n%@:\n%@:", item1, item2,item3,item4];
    
    NSString * str_dataValue = [NSString stringWithFormat:@"%@\n%@\n%@\n%@", sitem1, sitem2,sitem3,sitem4];

    NSString *str_Title = @"Item: \nTagNo: \nStamp: \nGross Wt: ";
    
    cell.lblItemTitle.text = str_dataTitle;
    cell.lblTitle.text = str_dataValue;//str_deta;

    [cell.btn_addcart addTarget:self action:@selector(btn_addtocart:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn_addcart.tag=indexPath.row;
    //[cell.contentView addSubview:cell.btn_addcart];
    [cell.btn_whatsup addTarget:self action:@selector(btn_whatsUpShare:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn_whatsup.tag=indexPath.row;
    
    NSString *str_qty=[self.nsarray_qty objectAtIndex:indexPath.row];
    NSString *str_addCart = @"Add to cart";
    if ([str_qty isEqualToString:@"0"]) {
        cell.lbl_counter.text=@"";
        cell.lbl_counter.hidden=YES;
    } else {
        cell.lbl_counter.hidden=NO;
        cell.lbl_counter.text=[NSString stringWithString:str_qty];
        str_addCart = [NSString stringWithFormat:@"%@ (%@)", str_addCart, str_qty];
    }
    cell.lbl_counter.hidden=YES;
    //cell.lbl_counter.layer.cornerRadius = 13;
    cell.lbl_counter.clipsToBounds = true;
    [cell.btn_addcart setTitle:str_addCart forState: UIControlStateNormal];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        cell.lblItemTitle.font = [UIFont systemFontOfSize:19.0];
        cell.lblTitle.font = [UIFont systemFontOfSize:19.0];
    }
    CGFloat fontSize = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 24.0 : 18.0;
    cell.btn_addcart.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *strTemplate = [[NSUserDefaults standardUserDefaults]stringForKey:@"template"];
    if([strTemplate isEqualToString:@"2"]){
        [[BusyIndicator sharedInstance]startIndicator];
        imgfullVC *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"imgfullVC"];
        obj.imageUrlString = [[self.nsarray_product valueForKey:@"itemimage"]objectAtIndex:indexPath.row];;
        obj.str_img2 = [[self.nsarray_product valueForKey:@"itemimage2"]objectAtIndex:indexPath.row];;
        obj.str_img3 = [[self.nsarray_product valueForKey:@"itemimage3"]objectAtIndex:indexPath.row];;
        obj.str_img4 = [[self.nsarray_product valueForKey:@"itemimage4"]objectAtIndex:indexPath.row];;
        obj.str_img5 = [[self.nsarray_product valueForKey:@"itemimage5"]objectAtIndex:indexPath.row];;
        [self.navigationController pushViewController:obj animated:YES];
    }else{
        ItemDetail *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"ItemDetail"];
        obj.str_idesc=[[self.nsarray_product valueForKey:@"idesc"]objectAtIndex:indexPath.row];
        obj.str_image=[[self.nsarray_product valueForKey:@"itemimage"]objectAtIndex:indexPath.row];
        obj.str_image2=[[self.nsarray_product valueForKey:@"itemimage2"]objectAtIndex:indexPath.row];
        obj.str_image3=[[self.nsarray_product valueForKey:@"itemimage3"]objectAtIndex:indexPath.row];
        obj.str_image4=[[self.nsarray_product valueForKey:@"itemimage4"]objectAtIndex:indexPath.row];
        obj.str_image5=[[self.nsarray_product valueForKey:@"itemimage5"]objectAtIndex:indexPath.row];
        obj.str_tagno=[[self.nsarray_product valueForKey:@"tgno"]objectAtIndex:indexPath.row];
        obj.str_gwt=[[self.nsarray_product valueForKey:@"gwt"]objectAtIndex:indexPath.row];
        obj.str_qty=[[self.nsarray_product valueForKey:@"qty"]objectAtIndex:indexPath.row];
        obj.str_tpre=[[self.nsarray_product valueForKey:@"tpre"]objectAtIndex:indexPath.row];
        obj.str_design=[[self.nsarray_product valueForKey:@"design"]objectAtIndex:indexPath.row];
        obj.str_tsno=[[self.nsarray_product valueForKey:@"tsno"]objectAtIndex:indexPath.row];
        obj.str_item1=[[self.nsarray_product valueForKey:@"item1"]objectAtIndex:indexPath.row];
        obj.str_item2=[[self.nsarray_product valueForKey:@"item2"]objectAtIndex:indexPath.row];
        obj.str_item3=[[self.nsarray_product valueForKey:@"item3"]objectAtIndex:indexPath.row];
        obj.str_item4=[[self.nsarray_product valueForKey:@"item4"]objectAtIndex:indexPath.row];
        obj.str_rlid=@"0";
        obj.str_remarks=[[self.nsarray_product valueForKey:@"remarks"]objectAtIndex:indexPath.row];
        obj.str_shpc=@"0";
        obj.str_stamp=[[self.nsarray_product valueForKey:@"stamp"]objectAtIndex:indexPath.row];
        obj.str_tgimage=[[self.nsarray_product valueForKey:@"tgimage"]objectAtIndex:indexPath.row];
        obj.str_wt1=[[self.nsarray_product valueForKey:@"wt1"]objectAtIndex:indexPath.row];
        obj.str_status=[[self.nsarray_product valueForKey:@"status"]objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:obj animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.bounds.size;
}

/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
        return CGSizeMake((self.collectionView.frame.size.width - 2), (self.collectionView.frame.size.height - 2));
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint centerPoint = CGPointMake(self.collectionView.bounds.size.width / 2 + self.collectionView.contentOffset.x,
                                      self.collectionView.bounds.size.height / 2 + self.collectionView.contentOffset.y);

    NSIndexPath *centerIndexPath = [self.collectionView indexPathForItemAtPoint:centerPoint];

    if (centerIndexPath) {
        NSLog(@"Currently centered indexPath: %@", centerIndexPath);
        intscrollitem = centerIndexPath.item;
        NSLog(@"intscrollitem == %ld",(long)intscrollitem);
        [self setUpView:intscrollitem];
    }
}
*/

#pragma mark - ScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    [self updateCurrentIndex];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

    [self updateCurrentIndex];
}

- (void)updateCurrentIndex {

    CGPoint centerPoint = CGPointMake(
        self.collectionView.contentOffset.x + self.collectionView.frame.size.width / 2,
        self.collectionView.frame.size.height / 2
    );

    NSIndexPath *indexPath =
    [self.collectionView indexPathForItemAtPoint:centerPoint];

    if (indexPath) {

        intscrollitem = indexPath.item;

        NSLog(@"Current Index = %ld",(long)intscrollitem);

        strindex = [NSString stringWithFormat:@"%ld",
                    (long)intscrollitem];

        [self setUpView:intscrollitem];
    }
}

#pragma mark:- cell Button Action Method

-(void)btn_whatsUpShare:(UIButton*)sender{
    NSString *msg_mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    
    NSString *sitem1=[[self.nsarray_product valueForKey:@"item1"] objectAtIndex:sender.tag];
    NSString *sitem2=[[self.nsarray_product valueForKey:@"item2"] objectAtIndex:sender.tag];
    NSString *sitem3=[[self.nsarray_product valueForKey:@"item3"] objectAtIndex:sender.tag];
    NSString *sitem4=[[self.nsarray_product valueForKey:@"item4"] objectAtIndex:sender.tag];

    NSString * strd1=[NSString stringWithFormat:@"%@ - %@",item1,sitem1];
    NSString * strd2=[NSString stringWithFormat:@"%@ - %@",item2,sitem2];
    NSString * strd3=[NSString stringWithFormat:@"%@ - %@",item3,sitem3];
    NSString * strd4=[NSString stringWithFormat:@"%@ - %@",item4,sitem4];

    NSString * str_deta = [NSString stringWithFormat:@"%@\n%@\n%@\n%@", strd1, strd2,strd3,strd4];
    NSLog(@"%@",str_deta);
    [self shareOnWhatsApp:str_deta phone:@""];
}

-(void)btn_addtocart:(UIButton*)sender{
    
    NSString *chqty = [[NSUserDefaults standardUserDefaults]stringForKey:@"chqty"];
    if ([chqty isEqualToString:@"3"] || [chqty isEqualToString:@"2"]) {
        NSString *str_qty=[self.nsarray_qty objectAtIndex: sender.tag];
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
        NSString *str_qty=[self.nsarray_qty objectAtIndex:sender.tag];
        [self PopupWithQty:str_qty];
        index_cart = [sender tag];
        [UIView transitionWithView:view1
                          duration:0.4
                           options:UIViewAnimationOptionCurveEaseIn
                        animations:^{
            self->view1.hidden = NO;
        }
                        completion:NULL];
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


#pragma mark:- PopView Method

-(void)PopupWithQty:(NSString*)strQty{

    view1 = [[UIView alloc] initWithFrame:CGRectMake(30.0f, 20.0f, 300.0f, 280.0f)];
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
    //text_count.text=@"1";
    text_count.text = strQty;
    text_count.textAlignment=NSTextAlignmentCenter;
    [view1 addSubview:text_count];
    
    CGRect someRect_remarks = CGRectMake(50.0, 125.0, 200, 30.0);
    text_remarks = [[UITextField alloc] initWithFrame:someRect_remarks];
    text_remarks.placeholder=@"Remarks";
    text_remarks.textAlignment=NSTextAlignmentCenter;
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
    //UIImage* image_cancel = [UIImage imageNamed:@"cancel.png"];
    //[btn_cancel setBackgroundImage:image_cancel forState:UIControlStateNormal];
    [btn_cancel setBackgroundColor: [UIColor colorNamed:@"appRed_Color"]];
    [btn_cancel setTitle:@"Cancel" forState: UIControlStateNormal];
    [btn_cancel setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    btn_cancel.layer.cornerRadius = 5;
    [btn_cancel addTarget:self action:@selector(btn_cancel:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn_cancel];
}

-(void)btn_plus:(UIButton*)sender{
    NSString *str_total=text_count.text;
    int aValue = [[str_total stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
    NSLog(@"%d", aValue);
    aValue=aValue+1;
    NSString* myNewString = [NSString stringWithFormat:@"%i", aValue];
    text_count.text=myNewString;
    myCounter++;
    NSLog(@"myCounter =%d",myCounter);
}

-(void)btn_minus:(UIButton*)sender{
    NSString *str_total=text_count.text;
    if ([str_total isEqualToString:@"0"]) {
        
    }else{
        int aValue = [[str_total stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
        NSLog(@"%d", aValue);
        aValue=aValue-1;
        NSString* myNewString = [NSString stringWithFormat:@"%i", aValue];
        text_count.text=myNewString;
        myCounter--;
        NSLog(@"myCounter =%d",myCounter);
    }
}


-(void)btn_ok:(UIButton*)sender{
    [self scrollData_InsertItem:text_count.text];
    [UIView transitionWithView:view1
                      duration:0.4
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        self->view1.hidden = YES;
                    }
                    completion:NULL];
    transparentView.hidden=YES;
    [self.collectionView reloadData];
}

-(void)btn_cancel:(UIButton*)sender{
    [UIView transitionWithView:view1
                      duration:0.4
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        self->view1.hidden = YES;
                    }
                    completion:NULL];
    transparentView.hidden=YES;
}

#pragma mark: IBAction Button Method

- (void)setUpView:(NSUInteger)index {

    NSInteger total = self.nsarray_product.count;

    btn_prvs.hidden = (index == 0);

    btn_next.hidden = (index >= total - 1);
}

- (IBAction)btn_prvs:(id)sender {

    if (intscrollitem > 0) {

        intscrollitem--;

        NSLog(@"PREVIOUS INDEX = %ld",(long)intscrollitem);

        strindex = [NSString stringWithFormat:@"%ld",
                    (long)intscrollitem];

        [self setUpView:intscrollitem];

        NSIndexPath *indexPath =
        [NSIndexPath indexPathForItem:intscrollitem
                            inSection:0];

        [self.collectionView layoutIfNeeded];

        [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:YES];
    }
}

- (IBAction)btn_next:(id)sender {

    NSInteger totalItems = self.nsarray_product.count - 1;

    if (intscrollitem < totalItems) {

        intscrollitem++;

        NSLog(@"NEXT INDEX = %ld",(long)intscrollitem);

        strindex = [NSString stringWithFormat:@"%ld",
                    (long)intscrollitem];

        [self setUpView:intscrollitem];

        NSIndexPath *indexPath =
        [NSIndexPath indexPathForItem:intscrollitem
                            inSection:0];

        [self.collectionView layoutIfNeeded];

        [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:YES];
    }
}

#pragma mark:- ScreenShot Method

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

@end
