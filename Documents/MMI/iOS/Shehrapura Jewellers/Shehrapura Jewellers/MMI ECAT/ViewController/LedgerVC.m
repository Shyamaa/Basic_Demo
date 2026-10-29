//
//  LedgerVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 02/07/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "LedgerVC.h"
#import "LedgerDetailsVC.h"
#import "Brochures.h"
#import "AddBanner.h"
#import "RegisterConfigureVC.h"
#import "ProductGroup.h"
#import "CategoryListActivity.h"
#import "ItemListActivity.h"
#import "OrderList.h"
#import "UserListActivity.h"
#import "AddDemand.h"
#import "OrderSoftware.h"
#import "Suggestion.h"
#import "BankDetail.h"
#import "TodayBhav.h"
#import "Aboutus.h"
#import "AdminOrderListVC.h"

@interface LedgerVC ()

@end

@implementation LedgerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
    
    NSString *strTemplate = [[NSUserDefaults standardUserDefaults]stringForKey:@"template"];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    if([strTemplate isEqualToString:@"2"] && [ECAT_TYPE isEqualToString:@"3"]){
        [self setUpNavigationLogo];
        tblList = [self.itemList mutableCopy];
    }else{
        self.title = @"Ledger";
        [self scrollData_Category];
    }
}


- (void)setupTableView {
    tblList = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tblList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *myIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *subContainView = [[UIView alloc] init];
    subContainView.frame = CGRectMake(10,10, tableView.frame.size.width - 20, 40);
    subContainView.backgroundColor = UIColor.whiteColor;
    subContainView.layer.cornerRadius = 10;
    subContainView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    subContainView.layer.borderWidth = 1;
    subContainView.clipsToBounds = true;
    [cell.contentView addSubview:subContainView];
    
    UILabel *lbl_Name = [[UILabel alloc] init];
    lbl_Name.frame = CGRectMake(10, 5, subContainView.frame.size.width - 20, 30);
    [lbl_Name setFont: [UIFont systemFontOfSize:16]];
    //[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [subContainView addSubview:lbl_Name];
    if (self.itemList.count > 0) {
        lbl_Name.text = [NSString stringWithFormat:@"%@",[[tblList valueForKey:@"caption"] objectAtIndex:indexPath.row]];
    }else{
        lbl_Name.text = [NSString stringWithFormat:@"%@",[[tblList valueForKey:@"cname"] objectAtIndex:indexPath.row]];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    LedgerDetailsVC *obj = [storyboard instantiateViewControllerWithIdentifier:@"LedgerDetailsVC"];
    //obj.profileType = @"user";
//    [self.navigationController pushViewController:obj animated:YES];
    if (self.itemList.count > 0) {
        NSString *strType = [NSString stringWithFormat:@"%@",[[tblList valueForKey:@"type"] objectAtIndex:indexPath.row]];
        [self openPageView:strType];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LedgerDetailsVC *successVC = [storyboard instantiateViewControllerWithIdentifier:@"LedgerDetailsVC"];
        successVC.selectDicData = [tblList objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:successVC animated:YES];
    }
}

-(void)openPageView:(NSString *)strType{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([strType isEqualToString: @"Register Config"]) {
        RegisterConfigureVC *obj = [storyboard instantiateViewControllerWithIdentifier:@"RegisterConfigureVC"];
        [self.navigationController pushViewController:obj animated:YES];
    } else if ([strType isEqualToString: @"Product Group"]) {
        ProductGroup *obj = [storyboard instantiateViewControllerWithIdentifier:@"ProductGroup"];
        [self.navigationController pushViewController:obj animated:YES];
    } else if ([strType isEqualToString: @"Add Item"]) {
        CategoryListActivity *obj = [storyboard instantiateViewControllerWithIdentifier:@"CategoryListActivity"];
        [self.navigationController pushViewController:obj animated:YES];
    } else if ([strType isEqualToString: @"Add Design"]) {
        ItemListActivity *obj = [storyboard instantiateViewControllerWithIdentifier:@"ItemListActivity"];
        [self.navigationController pushViewController:obj animated:YES];
    } else if ([strType isEqualToString: @"Order Management"]) {
        OrderList *obj = [storyboard instantiateViewControllerWithIdentifier:@"OrderList"];
        [self.navigationController pushViewController:obj animated:YES];
    } else if ([strType isEqualToString: @"Product Gallery"]) {
        ProductGallery *obj = [storyboard instantiateViewControllerWithIdentifier:@"ProductGallery"];
        obj.str_igroup =@"";
        [self.navigationController pushViewController:obj animated:YES];
    } else if ([strType isEqualToString: @"Contact us"]) {
        Contactus *obj = [storyboard instantiateViewControllerWithIdentifier:@"Contactus"];
        obj.str_type = strType;
        [self.navigationController pushViewController:obj animated:YES];
    } else if ([strType isEqualToString: @"About us"]) {
        Aboutus *obj = [storyboard instantiateViewControllerWithIdentifier:@"Aboutus"];
        obj.str_type = strType;
        [self.navigationController pushViewController:obj animated:YES];
    } else if ([strType isEqualToString: @"Why Membership"]) {
        Aboutus *obj = [storyboard instantiateViewControllerWithIdentifier:@"Aboutus"];
        obj.str_type = strType;
        [self.navigationController pushViewController:obj animated:YES];
    } else if ([strType isEqualToString: @"Add Banner"]) {
        AddBanner *obj = [storyboard instantiateViewControllerWithIdentifier:@"AddBanner"];
        [self.navigationController pushViewController:obj animated:YES];
    } else if ([strType isEqualToString: @"User Updation Entry"]) {
        UserListActivity *obj = [storyboard instantiateViewControllerWithIdentifier:@"UserListActivity"];
        [self.navigationController pushViewController:obj animated:YES];
    } else if ([strType isEqualToString: @"Brochures"]) {
        Brochures *brochuresVc = [storyboard instantiateViewControllerWithIdentifier:@"Brochures"];
        [self.navigationController pushViewController:brochuresVc animated:YES];
    } else if ([strType isEqualToString: @"Add Your Demand"]) {
        AddDemand *obj = [storyboard instantiateViewControllerWithIdentifier:@"AddDemand"];
        //obj.str_Activity = @"ORD";
        [self.navigationController pushViewController:obj animated:YES];
    } else if ([strType isEqualToString: @"Admin Order Management"]) {
//        OrderList *obj = [storyboard instantiateViewControllerWithIdentifier:@"OrderList"];
        AdminOrderListVC *obj = [storyboard instantiateViewControllerWithIdentifier:@"AdminOrderListVC"];
        [self.navigationController pushViewController:obj animated:YES];
        //[self alertMsg:@"Comming Soon"];
    } else if ([strType isEqualToString: @"Order"]) {
        OrderSoftware *obj = [storyboard instantiateViewControllerWithIdentifier:@"OrderSoftware"];
        [self.navigationController pushViewController:obj animated:YES];
    } else if ([strType isEqualToString: @"Customers Query & Feedback"]) {
        [self alertMsg:@"Comming Soon"];
    } else if ([strType isEqualToString: @"Alert Management"]) {
        [self alertMsg:@"Comming Soon"];
    } else if ([strType isEqualToString: @"Suggestion"]) {
        Suggestion *obj = [storyboard instantiateViewControllerWithIdentifier:@"Suggestion"];
        obj.str_type = @"Suggestion";
        [self.navigationController pushViewController:obj animated:YES];
    } else if ([strType isEqualToString: @"Bank Detail"]) {
        BankDetail *obj = [storyboard instantiateViewControllerWithIdentifier:@"BankDetail"];
        [self.navigationController pushViewController:obj animated:YES];
    } else if([strType isEqualToString:@"Today Rate"]){
        TodayBhav *obj = [storyboard instantiateViewControllerWithIdentifier:@"TodayBhav"];
        [self.navigationController pushViewController:obj animated:YES];
    } else if ([strType isEqualToString: @"Approval"]) {
        [self alertMsg:@"Comming Soon"];
    } else if ([strType isEqualToString: @"Logout"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Do you want logout?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self logoutApp];
        }];
        [alertController addAction:confirmAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Canelled");
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - Api Method

-(void)scrollData_Category {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *apptype = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;

    if ([apptype isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,mobile,ip,db,ipusername,pswd,ftppath];
        URL_API =[WEB_URL URL_SHOW_LEDGER];
    }else  if ([apptype isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/ledger_accounts.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@&ftppath=%@",apptype,mobile,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@",apptype,mobile];
        URL_API =[WEB_URL URL_SHOW_LEDGER];
    }
    NSLog(@"ledger_accounts loginRequest = %@",loginRequest);
    NSLog(@"ledger URL_API = %@",URL_API);
    
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
            tblList = [pDict objectForKey:@"ledger"];
            [self.tableView reloadData];
//            self.lblPcValue.text = [NSString stringWithFormat:@"PC - %lu", (unsigned long)[nsarray_orderno count]];
//            self.lblWtValue.text = [NSString stringWithFormat:@"Wt - %.2f", totalWtValue];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

@end
