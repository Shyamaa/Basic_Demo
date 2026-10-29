//
//  CategoryListActivity.m
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 29/08/22.
//  Copyright © 2022 MMI Softwares. All rights reserved.
//

#import "CategoryListActivity.h"
#import "webUrlconstant.h"
#import "BusyIndicator.h"
#import "ProductGallery.h"
#import "Showitem.h"
#import "CustomIOSAlertView.h"
#import "AddCategory.h"
#import "ItemListActivity.h"

@interface CategoryListActivity ()
{
    UIButton *btnAdd_Cart;
    BOOL isSearching_search;
}
@end

@implementation CategoryListActivity
@synthesize searchBar;

#pragma  mark:- Class Method

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Category List";
    searchBar.placeholder = @"Search";
    [self setUpNavigationBtn];
    [self scrollData_item];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Remove the button from the navigation bar when leaving this controller
    for (UIView *subview in self.navigationController.navigationBar.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview removeFromSuperview];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark:- Set Up Navigation and Action Method

-(void)setUpNavigationBtn{
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    if ([ECAT_TYPE isEqualToString:@"3"]){
        UIButton *  btnAdd =  [UIButton buttonWithType:UIButtonTypeContactAdd];
        btnAdd.frame = CGRectMake(0,8,30,30);
        [btnAdd addTarget:self action:@selector(addBarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [[btnAdd imageView] setContentMode: UIViewContentModeScaleAspectFit];
        btnAdd.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        btnAdd.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        UIBarButtonItem *barBtnAdd = [[UIBarButtonItem alloc] initWithCustomView:btnAdd];
        barBtnAdd.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects: barBtnAdd, nil];
    }else{
        if (_openWithSidMenu) {
            SWRevealViewController *revealController = [self revealViewController];
            //[revealController panGestureRecognizer];
            [revealController tapGestureRecognizer];
            UIImage *image = [UIImage imageNamed:@"menu.png"];
            CGRect frameimg1 = CGRectMake(0, 0, image.size.width, image.size.height);
            UIButton *someButton1 = [[UIButton alloc] initWithFrame:frameimg1];
            [someButton1 setBackgroundImage:image forState:UIControlStateNormal];
            [someButton1 addTarget:revealController action:@selector(revealToggle:)
                  forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *revealButtonItem =[[UIBarButtonItem alloc] initWithCustomView:someButton1];
            self.navigationItem.leftBarButtonItem = revealButtonItem;
        }
    }
   
}

-(void)addBarBtnAction:(UIButton*)sender{
    AddCategory *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"AddCategory"];
    obj.preCategoryData = nil;
    obj.onValueSelected = ^(NSString *value) {
        NSLog(@"Received from child via block: %@", value);
        //[obj.navigationController popViewControllerAnimated:YES];
        [self scrollData_item];
    };
    [self.navigationController pushViewController:obj animated:YES];
}

#pragma mark: - Table View Delegate and Data Source Method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tblArray_item count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [self.tableView_Order dequeueReusableCellWithIdentifier:myIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString * idesc = [[tblArray_item valueForKey:@"idesc"] objectAtIndex:indexPath.row]; //@""
    NSString *status = [NSString stringWithFormat:@"%@",[[tblArray_item valueForKey:@"status"] objectAtIndex:indexPath.row]];
    UILabel *lbl_itemname = [[UILabel alloc] init];
    lbl_itemname.frame = CGRectMake(10,10, cell.frame.size.width-185, 80);
    [lbl_itemname setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    lbl_itemname.text = [NSString stringWithFormat:@"%@",idesc];
    lbl_itemname.textAlignment = NSTextAlignmentLeft;
    lbl_itemname.textColor=[UIColor blackColor];
    lbl_itemname.numberOfLines = 4;
    [cell.contentView addSubview:lbl_itemname];
    
    UIButton * btn_Details = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Details.frame = CGRectMake(self.view.frame.size.width-180.0f, 25.0f, 100.0f, 50.0f);
    [btn_Details setTitle:@"View Item" forState: UIControlStateNormal];
    btn_Details.titleLabel.font = [UIFont systemFontOfSize:15.0];
    btn_Details.backgroundColor = [UIColor colorNamed:@"appRed_Color"];
    btn_Details.tag = indexPath.row;
    [btn_Details addTarget:self action:@selector(btn_ViewItem:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btn_Details];
    
    UISwitch *btnSwitch = [[UISwitch alloc] init];
    btnSwitch.frame = CGRectMake(self.view.frame.size.width-60.0f, 10.0f, 35.0f, 30.0f);
    btnSwitch.on = [status isEqualToString:@"1"] ? true : false;
    btnSwitch.onTintColor = [UIColor colorNamed:@"appRed_Color"];
    btnSwitch.tag = indexPath.row;
    [btnSwitch addTarget:self action:@selector(updateSwitchValue:) forControlEvents:UIControlEventValueChanged];
    
    
    UIButton * btn_delete = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_delete.frame = CGRectMake(self.view.frame.size.width-50.0f, 55.0f, 30.0f, 35.0f);
    btn_delete.titleLabel.font = [UIFont systemFontOfSize:15.0];
    UIImage* image_minus = [UIImage imageNamed:@"delete.png"];
    [btn_delete setBackgroundImage:image_minus forState:UIControlStateNormal];
    btn_delete.tag = indexPath.row;
    [btn_delete addTarget:self action:@selector(btn_delete:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    if ([ECAT_TYPE isEqualToString:@"3"]){
        [cell.contentView addSubview:btnSwitch];
        [cell.contentView addSubview:btn_delete];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AddCategory *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCategory"];
    obj.preCategoryData = [tblArray_item objectAtIndex:indexPath.row];
    obj.onValueSelected = ^(NSString *value) {
        NSLog(@"Received from child via block: %@", value);
        //[obj.navigationController popViewControllerAnimated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self scrollData_item];
        });
    };
    [self.navigationController pushViewController:obj animated:YES];
}

#pragma mark: Table Cell Button Action Method

-(void)btn_ViewItem:(UIButton*)sender{
    ItemListActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemListActivity"];
    obj.strIdesc = [[tblArray_item valueForKey:@"idesc"] objectAtIndex: sender.tag];
    [self.navigationController pushViewController:obj animated:YES];
}

-(void)updateSwitchValue:(UISwitch*)sender{
    NSString *statusValue = sender.on ? @"active" : @"inactive";
    NSString *itemName = [[tblArray_item valueForKey:@"idesc"] objectAtIndex: sender.tag];
    NSString *msg = [NSString stringWithFormat: @"Do you want %@ %@?",statusValue, itemName];
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message" message:msg preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
         //[self URL_ITEM_DELETE: [[self->array_item valueForKey:@"idesc"] objectAtIndex:index_c]];
         [self updateStatusApi:itemName status:statusValue];
     }];
     UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
         sender.on = !sender.on;
     }];
     [alert addAction:noButton];
     [alert addAction:yesButton];
     [self presentViewController:alert animated:YES completion:nil];
}

-(void)btn_delete:(UIButton*)sender{
    NSInteger index_c = [sender tag];
   UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message" message:@"Do you want delete?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self URL_ITEM_DELETE: [[self->array_item valueForKey:@"idesc"] objectAtIndex:index_c]];
    }];
    UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}];
    [alert addAction:noButton];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark:- Api Method

-(void)scrollData_item {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
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
        loginRequest = [NSString stringWithFormat:@"ip=%@&ipusername=%@&password=%@&dbname=%@&ftppath=%@&apptype=%@",ip,ipusername,pswd,db,ftppath,apptype];
        URL_API = [NSString stringWithFormat: @"%@", [WEB_URL URL_GET_CATEGORY1]];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_item.php",ip];
        loginRequest = [NSString stringWithFormat:@"ip=%@&ftppath=%@&apptype=%@",ip,ftppath,apptype];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@",apptype];
        URL_API = [WEB_URL URL_GET_CATEGORY1];
    }
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSURL *url = [NSURL URLWithString:URL_API];
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_itemcat:data];
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

- (void) parseResponse_itemcat:(NSData *) data {
    @try {
        array_item = [[NSMutableArray alloc]init];
        
        [[BusyIndicator sharedInstance]stopIndicator];
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView_Order reloadData];
        });
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
            
            array_item = [pDict objectForKey:@"data"];
            tblArray_item = [array_item mutableCopy];
            [self.tableView_Order reloadData];
//            NSLog(@"array_item :: %@",array_item);
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)URL_ITEM_DELETE:(NSString *)idesc {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];

    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults] stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    NSString *activity = @"delete";
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest = [NSString stringWithFormat:@"mobile=%@&idesc=%@&apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&activity=%@",mobile,idesc,apptype,ip,db,ipusername,pswd,ftppath,activity];
        
        URL_API =[WEB_URL URL_DELETE_IDESC];
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/delete_idesc.php",ip];
        loginRequest = [NSString stringWithFormat:@"mobile=%@&idesc=%@&apptype=%@&ftppath=%@&activity=%@",mobile,idesc,apptype,ftppath,activity];

    }else{
        loginRequest = [NSString stringWithFormat:@"mobile=%@&idesc=%@&apptype=%@&activity=%@",mobile,idesc,apptype,activity];
        URL_API = [WEB_URL URL_DELETE_IDESC];
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
        
        if ([data length] >0 && error == nil){
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
            
            
            if ([str_success isEqualToString:@"1"]) {
                [self scrollData_item];
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

- (void)updateStatusApi:(NSString *)strName status:(NSString *) strStatus{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance] startIndicator];
    NSString *strFlagValue = [strStatus isEqualToString:@"inactive"] ? @"INACTIVE" :  @"IN STOCK";
    NSString *api = [NSString stringWithFormat:@"%@", [WEB_URL URL_ActiveIdesc]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
   
    NSString *loginRequest = [NSString stringWithFormat:@"apptype=3&flag=%@&idesc=%@",
                              strFlagValue, strName];

    NSData *data1 = [loginRequest dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[BusyIndicator sharedInstance]stopIndicator];
            if (data.length > 0 && error == nil) {
                [self parsesave_Api:data];
            } else {
                NSLog(@"Error: %@", error.localizedDescription);
            }
        });
    }] resume];
}

- (void)parsesave_Api:(NSData *)data {
    @try {
        NSError *error;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (jsonObject && !error){
            NSLog(@"jsonObject Successfully  = %@", jsonObject);
            NSDictionary *pDict = (NSDictionary *)jsonObject;
            NSString *str_success = [[pDict objectForKey:@"success"] description];
            NSString *str_msg = [[pDict objectForKey:@"message"] description];
            if ([str_success isEqualToString:@"1"]){
                [self scrollData_item];
            } else {
                [self alertMsg:str_msg];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception.reason);
    }
}

#pragma mark: - Serach Filter method


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [tblArray_item removeAllObjects];
    if([searchText length] != 0) {
        for (NSDictionary *item in array_item) {
            NSString *value = [[item valueForKey:@"idesc"] lowercaseString];
                if ([value containsString: [searchText lowercaseString]]){
                [tblArray_item addObject:item];
            }
        }
    }else {
        tblArray_item = [array_item mutableCopy];
    }
    [self.tableView_Order reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    NSLog(@"Search Clicked");
    [self.searchBar resignFirstResponder];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}


@end
