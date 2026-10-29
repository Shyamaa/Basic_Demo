//
//  OrderDetail.m
//  MMI ECAT
//
//  Created by mmsoft116 on 01/10/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "OrderDetail.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "UIImageView+WebCache.h"
#import "WalletVC.h"
#import "WalletHistoryVC.h"
#import "ItemListVC.h"
#import "MainActivity.h"
#import "ViewController/WebActivity/WebActivity.h"
#import "CartItemTblCell.h"
#import "OrderDetailsInfo.h"

#define MENUEWIDTH   250

@interface OrderDetail ()

@end

@implementation OrderDetail

@synthesize str_qty,str_wt,str_odate,str_mobile,str_orderno,str_username;


#pragma mark - Class Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    if ([ECAT_TYPE isEqualToString:@"3"]) {
        self.title = [NSString stringWithFormat:@"%@ %@ %@",str_orderno,str_username,str_mobile];
    }else{
        self.title = [NSString stringWithFormat:@"%@",str_orderno];
    }
    
    UIButton * btn_pdf =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_pdf.frame = CGRectMake(0,0,30,30);
    
    btn_pdf.tintColor = [UIColor whiteColor];
    [btn_pdf setImage:[UIImage imageNamed:@"pdf.png"] forState:UIControlStateNormal];
    [btn_pdf addTarget:self action:@selector(btn_pdf:) forControlEvents:UIControlEventTouchUpInside];
    
    // Wrap the button in a UIBarButtonItem
    UIBarButtonItem *pdfBarButton = [[UIBarButtonItem alloc] initWithCustomView: btn_pdf];
    
    // Create the button
    UIButton *btn_delete = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_delete.frame = CGRectMake(0, 0, 30, 30);
    // Set the image with template rendering mode
    UIImage *image = [[UIImage imageNamed:@"delete.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btn_delete setBackgroundImage:image forState:UIControlStateNormal];
    
    // Configure button appearance
    [[btn_delete imageView] setContentMode:UIViewContentModeScaleAspectFit];
    btn_delete.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    btn_delete.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    btn_delete.tintColor = [UIColor whiteColor];
    
    // Add the button action
    [btn_delete addTarget:self action:@selector(btnDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // Wrap the button in a UIBarButtonItem
    UIBarButtonItem *deleteBarButton = [[UIBarButtonItem alloc] initWithCustomView: btn_delete];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 12;
    if (str_orderno.length > 0) {
        //self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: deleteBarButton, pdfBarButton, nil];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: pdfBarButton, nil];
    }else{
        UIButton * btn_Filter =  [UIButton buttonWithType:UIButtonTypeCustom];
        btn_Filter.frame = CGRectMake(0,0,30,30);
        btn_Filter.tintColor = [UIColor whiteColor];
        [btn_Filter setTitle:@"Filter" forState:UIControlStateNormal];
        [btn_Filter addTarget:self action:@selector(btn_Filter:) forControlEvents:UIControlEventTouchUpInside];
        // Wrap the button in a UIBarButtonItem
        UIBarButtonItem *filterBarButton = [[UIBarButtonItem alloc] initWithCustomView: btn_Filter];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: deleteBarButton, nil];
    }
    
    [self scrollData_Category];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200; // Estimated row height
}

-(void)viewWillAppear:(BOOL)animated{
    btnAdd_Cart.hidden=NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    btnAdd_Cart.hidden=YES;
}


#pragma mark - Navigation Button Action Methods

- (void)btn_pdf:(id)sender {
    [self getPdfWithOrderno:str_orderno type:@"1" pdftype:@"get_pdf10.php"];
}

-(void)btnDeleteAction:(UIButton*)sender{
    NSString *strOrderId = [[nsarray_data valueForKey:@"orderno"] objectAtIndex:0];
    NSString *strAlertMsg = [NSString stringWithFormat:@"Do you want delete order no : %@", strOrderId];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message: strAlertMsg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
        NSLog(@"order no delete api");
        [self URL_SINGLE_ITEM_DELETE:strOrderId];
        //[self DELETE_DATA];
    }];
    [alert addAction:noAction];
    [alert addAction:yesAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)btn_Filter:(id)sender {
    
}

#pragma mark - Api Call Methods

-(void)scrollData_Category {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *category = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
    
    NSString *activity=@"product";
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    NSString *rlid=@"0";
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&mobile=%@&userid=%@&activity=%@&rlid=%@&orderno=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,category,mobile,userid,activity,rlid,str_orderno,ip,db,ipusername,pswd,ftppath];
        URL_API =[WEB_URL URL_SHOW_ORDERDETAILS];
        
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/show_orderno_item.php",ip];
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&mobile=%@&userid=%@&activity=%@&rlid=%@&orderno=%@&ftppath=%@",apptype,category,mobile,userid,activity,rlid,str_orderno,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&category=%@&mobile=%@&userid=%@&activity=%@&rlid=%@&orderno=%@",apptype,category,mobile,userid,activity,rlid,str_orderno];
        URL_API =[WEB_URL URL_SHOW_ORDERDETAILS];
    }
    NSLog(@"loginRequest ******************************* %@",loginRequest);
    
    NSLog(@"URL_API ******************************* %@",URL_API);
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
        // End processs load view
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        [[BusyIndicator sharedInstance]stopIndicator];
        NSError *error = nil;
        //parsing the JSON response
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            //check if the country code was valid
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            nsarray_data = [[NSMutableArray alloc]init];
            nsarray_data = [pDict objectForKey:@"tg_master"];
            NSLog(@"nsarray_data :: %@",nsarray_data);
            [self.tableView reloadData];
            
            if ([nsarray_data count] > 0 && str_orderno.length !=0){
                self.lblOrderValue.text = [NSString stringWithFormat:@"Order No - %@", [[nsarray_data valueForKey:@"orderno"] objectAtIndex:0]];
                self.lblDateValue.text = [NSString stringWithFormat:@"%@", [[nsarray_data valueForKey:@"item_date"] objectAtIndex:0]];
                NSString *cName = [NSString stringWithFormat:@"%@", [[nsarray_data valueForKey:@"cname"] objectAtIndex:0]];
                cName = SafeString(cName);
                NSString *username = [NSString stringWithFormat:@"%@", [[nsarray_data valueForKey:@"username"] objectAtIndex:0]];
                username = SafeString(username);
                self.lblName.text = cName.length > 0 ? cName : username;
                NSString *cmobile = [NSString stringWithFormat:@"%@", [[nsarray_data valueForKey:@"cmobile"] objectAtIndex:0]];
                cmobile = SafeString(cmobile);
                NSString *mobile = [NSString stringWithFormat:@"%@", [[nsarray_data valueForKey:@"mobile"] objectAtIndex:0]];
                mobile = SafeString(mobile);
                self.lblPhone.text = cmobile.length > 0 ? cmobile : mobile;
                [self.phoneNumberView setHidden:YES];
                if (self.lblPhone.text.length > 0 && self.lblName.text.length > 0) {
                    [self.phoneNumberView setHidden:NO];
                }
            }else{
                self.lblOrderValue.text = @"ALL";
                self.lblDateValue.text = @"";
                self.lblName.text = @"";
                self.lblPhone.text = @"";
                [self.phoneNumberView setHidden:YES];
            }
            float totalWtValue = 0.0;
            for (NSDictionary *dictObject in nsarray_data) {
                NSString *totalwt = dictObject[@"item_gwt"];
                totalWtValue += [totalwt floatValue]; // floatValue returns 0.0 if invalid
            }
            lbl_pc.text = [NSString stringWithFormat:@"PC - %lu", (unsigned long)nsarray_data.count];
            lbl_wt.text = [NSString stringWithFormat:@"Wt - %.2f", totalWtValue];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)URL_SINGLE_ITEM_DELETE:(NSString *)itemId {
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
        loginRequest=[NSString stringWithFormat:@"mobile=%@&cart_id=%@&apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",mobile,itemId,apptype,ip,db,ipusername,pswd,ftppath];
        URL_API =[WEB_URL URL_Order_DELETE];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/delete_order_ecat.php",ip];
        loginRequest=[NSString stringWithFormat:@"mobile=%@&cart_id=%@&apptype=%@&ftppath=%@",mobile,itemId,apptype,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"mobile=%@&cart_id=%@&apptype=%@",mobile,itemId,apptype];
        URL_API =[WEB_URL URL_Order_DELETE];
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
        }else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            [[BusyIndicator sharedInstance]stopIndicator];
        }else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
            [[BusyIndicator sharedInstance]stopIndicator];
        }
    }] resume];
}

- (void)parse_SINGLE_ITEM:(NSData *) data {
    @try {
        // End processs load view
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
                
                [self scrollData_Category];
                
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

-(void)DELETE_DATA{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
   
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE_NEW"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *regmobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"regmobile"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    
    NSString *is_admin = @"0";
    if ([regmobile isEqualToString:mobile]) {
        is_admin = @"1";
    }
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];

        loginRequest = [NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&mobile=%@&type=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&is_admin=%@",ECAT_TYPE_NEW,apptype,mobile,@"1",ip,db,ipusername,pswd,ftppath,is_admin];

        URL_API = [WEB_URL URL_DELETE_ALL_ORDER];
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/delete_all_order.php",ip];
        loginRequest = [NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&mobile=%@&type=%@&is_admin=%@",ECAT_TYPE_NEW,apptype,mobile,@"1",is_admin];
    }else{
        loginRequest = [NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&mobile=%@&type=%@",ECAT_TYPE_NEW,apptype,mobile,@"1"];
        URL_API = [WEB_URL URL_DELETE_ALL_ORDER];
    }
    
    NSLog(@"URL_API ***************** %@",URL_API);
    NSLog(@"loginRequest ***************** %@",loginRequest);

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
        }else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            [[BusyIndicator sharedInstance]stopIndicator];
        }else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
            [[BusyIndicator sharedInstance]stopIndicator];
        }
    }] resume];
}

- (void)parseResponse_Save:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        NSError *error = nil;
        [[BusyIndicator sharedInstance]stopIndicator];
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
            if ([str_success isEqualToString:@"1"]){
                [self scrollData_Category];
            }else{
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message" message:str_msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
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

#pragma mark - Table View Datasource and Delegates Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[nsarray_data valueForKey:@"item1"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CartItemTblCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartItemTblCell" forIndexPath:indexPath];
    // Configure the cell
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.imgViewItem.layer setCornerRadius:8.0f];
    [cell.imgViewItem.layer setMasksToBounds:YES];
    [cell.imgViewItem.layer setBorderColor:[UIColor grayColor].CGColor];
    [cell.imgViewItem.layer setBorderWidth:1.0f];
    [cell.imgViewItem setShowActivityIndicatorView:YES];
    if (@available(iOS 13.0, *)) {
        [cell.imgViewItem setIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    } else {
        // Fallback on earlier versions
    }
    NSURL *URL;
    URL = [NSURL URLWithString:[[nsarray_data valueForKey:@"imgname"] objectAtIndex:indexPath.row]];
    NSString *myString = [URL absoluteString];
    [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
    [cell.imgViewItem sd_setImageWithURL:[NSURL URLWithString:myString]
                        placeholderImage:[UIImage imageNamed:@"1024.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    
    cell.lblItemName.text = [NSString stringWithFormat:@"%@",[[nsarray_data valueForKey:@"item_idesc"]  objectAtIndex:indexPath.row]];
    cell.lblItemTagNo.text = [NSString stringWithFormat:@"Tag No - %@",[[nsarray_data valueForKey:@"item_tgno"]  objectAtIndex:indexPath.row]];
    cell.lblItemGrossWt.text = [NSString stringWithFormat:@"Gross Wt. - %@",[[nsarray_data valueForKey:@"item_gwt"]  objectAtIndex:indexPath.row]];
    cell.lblItemQuantity.text = [NSString stringWithFormat:@"Quantity. - %@",[[nsarray_data valueForKey:@"item_qty"]  objectAtIndex:indexPath.row]];
    cell.lblItemItemWt.text = [NSString stringWithFormat:@"Item Wt. - %@",[[nsarray_data valueForKey:@"itemwt"]  objectAtIndex:indexPath.row]];
    cell.lblItemMrp.text = [NSString stringWithFormat:@"MRP - %@",[[nsarray_data valueForKey:@"salemrp"]  objectAtIndex:indexPath.row]];
    NSString *strStamp = [[nsarray_data valueForKey:@"stamp"]  objectAtIndex:indexPath.row];
    cell.lblItemStamp.hidden = true;
    if (SafeString(strStamp).length > 0) {
        cell.lblItemStamp.hidden = false;
        cell.lblItemStamp.text = [NSString stringWithFormat:@"Stamp - %@",strStamp];
    }
    NSString *strRemark = [[nsarray_data valueForKey:@"remarks"]  objectAtIndex:indexPath.row];
    cell.lblItemRemark.hidden = true;
    if (SafeString(strRemark).length > 0) {
        cell.lblItemRemark.hidden = false;
        cell.lblItemRemark.text = [NSString stringWithFormat:@"Remarks - %@",strRemark];
    }
    
    NSString *strStatus = [[nsarray_data valueForKey:@"status"]  objectAtIndex:indexPath.row];
    cell.lblItemStatus.hidden = true;
    if (SafeString(strStatus).length > 0) {
        cell.lblItemStatus.hidden = false;
        cell.lblItemStatus.text = [NSString stringWithFormat:@"Status - %@",strStatus];
    }
    
    cell.btnEdit.tag = indexPath.row;
    [cell.btnEdit addTarget:self action:@selector(btn_WhatsAppShare:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnDelete.tag = indexPath.row;
    [cell.btnDelete addTarget:self action:@selector(btn_delete:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnDelete.hidden = true;
    cell.btnEdit.hidden = true;

    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    //if ([ECAT_TYPE isEqualToString:@"3"]) {
        cell.btnDelete.hidden = false;
        cell.btnEdit.hidden = false;
    //}
    
    NSString *chqty = [[NSUserDefaults standardUserDefaults]stringForKey:@"chqty"];
    if ([chqty isEqualToString:@"2"]) {
        cell.btnEdit.hidden = true;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailsInfo *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetailsInfo"];
    obj.dicItemData = [nsarray_data objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:obj animated:YES];
}

-(void)btn_WhatsAppShare:(UIButton*)sender{
    NSInteger index_c = [sender tag];
    NSString *strItemId = [[nsarray_data valueForKey:@"cart_id"]objectAtIndex:index_c];
}

-(void)btn_delete:(UIButton*)sender{
    NSInteger index_c = [sender tag];
    NSString *strItemId = [[nsarray_data valueForKey:@"cart_id"]objectAtIndex:index_c];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"Do you want delete?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
        NSLog(@"Do you update delete api, now use cart delete api");
        [self URL_SINGLE_ITEM_DELETE:strItemId];
        
    }];
    [alert addAction:noAction];
    [alert addAction:yesAction];
    [self presentViewController:alert animated:YES completion:nil];
    
//    cart_id = [[nsarray_data valueForKey:@"cart_id"]objectAtIndex:index_c];
//    [self URL_SINGLE_ITEM_DELETE];
}

#pragma mark - Pdf Api Methods

- (void)getPdfWithOrderno:(NSString *)orderno type:(NSString *)type pdftype:(NSString *)pdftype {
    
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSString *mainUrl = [[webUrlconstant sharedInstance] getMainUrl];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    NSString *rlid=@"0";
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&type=%@&orderno=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,type,str_orderno,ip,db,ipusername,pswd,ftppath];
        
        URL_API = [NSString stringWithFormat:@"%@%@",mainUrl, pdftype];
        
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"%@%@",ip, pdftype];
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&type=%@&orderno=%@&ftppath=%@",apptype,type,str_orderno,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&type=%@&orderno=%@",apptype,type,str_orderno];
        URL_API = [NSString stringWithFormat:@"%@%@",mainUrl, pdftype];
    }
    
    NSLog(@"loginRequest ******************************* %@",loginRequest);
    NSLog(@"URL_API ******************************* %@",URL_API);
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
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_pdf:data];
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

- (void)parseResponse_pdf:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
                NSString *mainUrl = [[webUrlconstant sharedInstance] getMainUrl];
                NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
                NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
                
                NSMutableArray*nsarray_pdf = [pDict objectForKey:@"pdf"];
                NSString *pdf = [nsarray_pdf description];
                
                NSString *str_url;
                if ([ECAT_TYPE isEqualToString:@"1"] || [ECAT_TYPE isEqualToString:@"3"]) {
                    NSLog(@"mainUrl ****************** %@",mainUrl);
                    str_url = [NSString stringWithFormat:@"%@pdf/%@", mainUrl, pdf];
                    NSLog(@"str_url ****************** %@",str_url);
                    
                    NSURL *url = [NSURL URLWithString:str_url];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                    } else {
                        NSLog(@"Cannot open URL");
                    }
                    //                    WebActivity *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"WebActivity"];
                    //                    obj.str_type = @"PDf";
                    //                    obj.str_url = str_url;
                    //                    [self.navigationController pushViewController:obj animated:YES];
                } else {
                    str_url = [NSString stringWithFormat:@"http://%@/jwellyecat/pdf/%@", ip, pdf];
                }
                
                
                // Start file download
                //                [self downloadAndShareFileWithURL:str_url fileName:pdf];
                
            }else{
                [self showAlertWithMessage:str_msg];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

#pragma mark - Alert Methods

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Pdf Methods

- (void)downloadAndShareFileWithURL:(NSString *)fileUrl fileName:(NSString *)fileName {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Create the directory for saving the file
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES) firstObject];
        NSString *pdfFolderPath = [documentsDirectory stringByAppendingPathComponent:@"ECAT_APP"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:pdfFolderPath]) {
            [fileManager createDirectoryAtPath:pdfFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
            NSLog(@"Pdf Directory created");
        }
        
        NSString *filePath = [pdfFolderPath stringByAppendingPathComponent:fileName];
        
        NSURL *url = [NSURL URLWithString:fileUrl];
        
        // Download the file asynchronously
        NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Failed to download file: %@", error.localizedDescription);
                return;
            }
            
            if (data) {
                // Save the file locally
                [data writeToFile:filePath atomically:YES];
                NSLog(@"File saved at path: %@", filePath);
                
                // Share the file on the main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self shareFileAtPath:filePath];
                });
            } else {
                NSLog(@"No data received for the file.");
            }
        }];
        [downloadTask resume]; // Start the download
    });
}

- (void)shareFileAtPath:(NSString *)filePath {
    NSString *shareDetail = @"1";  // Assuming "1" is for WhatsApp sharing
    
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    if (!fileURL) {
        NSLog(@"File not found");
        return;
    }
    
    if ([shareDetail isEqualToString:@"2"]) {
        // Share via iOS share sheet
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[fileURL] applicationActivities:nil];
        [self presentViewController:activityController animated:YES completion:nil];
    } else if ([shareDetail isEqualToString:@"1"]) {
        // Share via WhatsApp (business)
        [self shareViaWhatsAppWithFileURL:fileURL isBusiness:YES];
        
    } else {
        // Share via WhatsApp (personal)
        [self shareViaWhatsAppWithFileURL:fileURL isBusiness:NO];
    }
}

- (void)shareViaWhatsAppWithFileURL:(NSURL *)fileURL isBusiness:(BOOL)isBusiness {
    NSString *whatsAppURLScheme = isBusiness ? @"whatsapp://send?text=" : @"whatsapp://send?text=";
    
    // WhatsApp needs to have a file path to send the document
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"whatsapp://"]]) {
        // Create WhatsApp URL for sharing
        NSString *filePath = fileURL.path;
        NSString *escapedFilePath = [filePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSString *whatsAppURLString = [NSString stringWithFormat:@"%@&document=%@", whatsAppURLScheme, escapedFilePath];
        NSURL *whatsAppURL = [NSURL URLWithString:whatsAppURLString];
        
        if ([[UIApplication sharedApplication] canOpenURL:whatsAppURL]) {
            [[UIApplication sharedApplication] openURL:whatsAppURL options:@{} completionHandler:nil];
        } else {
            NSLog(@"WhatsApp not installed");
        }
    } else {
        NSLog(@"WhatsApp is not installed on this device.");
    }
}

#pragma mark - Phone call Button Methods

-(IBAction)btn_PhoneCall:(UIButton*)sender{
    
    NSString *phoneNumber = self.lblPhone.text;
    if (phoneNumber.length > 0) {
        // Format the phone number with tel://
        NSString *formattedPhoneNumber = [NSString stringWithFormat:@"tel://%@", phoneNumber];
        
        // Check if the device can open the phone URL (i.e., making calls is supported)
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:formattedPhoneNumber]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:formattedPhoneNumber] options:@{} completionHandler:nil];
        } else {
            // Show an alert if the device cannot make calls (e.g., on a simulator or non-cellular device)
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:@"Your device cannot make phone calls."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else {
        // Show an alert if the phone number is empty
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Number"
                                                                       message:@"Please enter a valid phone number."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
