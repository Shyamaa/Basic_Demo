//
//  StockVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 29/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "StockVC.h"
#import "PhysicalStockVC.h"
#import "TagCalculator.h"
#import "ScanViewController.h"
#import "StockFilterVC.h"

@interface StockVC()
{
    NSString *selectedScanId;
    NSString *tagno;
}
@end

@implementation StockVC

#pragma mark: - Life Cycle

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Stock";
    [self setUpNavigationButton];
    stockListData = [[NSMutableArray alloc]init];
    scannedListData = [[NSMutableArray alloc]init];
    conflictListData = [[NSMutableArray alloc]init];
    unknownListData = [[NSMutableArray alloc]init];
    scanIdListData = [[NSMutableArray alloc]init];
    selectedScanId = @"";
    [self get_ScanId:NO];
    //[self get_StockData:@""];
}

#pragma mark: - Helper Methods

- (void)setUpNavigationButton {
    UIButton * btn_Filter =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Filter.frame = CGRectMake(0,5,30,30);
    [btn_Filter setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [[btn_Filter imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_Filter.tintColor = [UIColor whiteColor];
    [btn_Filter addTarget:self action:@selector(filterNavigationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barFilterBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_Filter];
    
    UIButton * btn_Tag=  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Tag =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Tag.frame = CGRectMake(0,5,30,30);
    [btn_Tag setImage:[UIImage imageNamed:@"tagcalculator_menu.png"] forState:UIControlStateNormal];
    [btn_Tag addTarget:self action:@selector(tagNavigationBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *tagBarButton = [[UIBarButtonItem alloc] initWithCustomView:btn_Tag];
    tagBarButton.tintColor = [UIColor whiteColor];
    
    UIButton * btn_Camera =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Camera.frame = CGRectMake(0,5,30,30);
    [btn_Camera setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [[btn_Camera imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_Camera.tintColor = [UIColor whiteColor];
    [btn_Camera addTarget:self action:@selector(cameraNavigationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barCameraBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_Camera];
    
    UIButton * btn_phyStock =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_phyStock.frame = CGRectMake(0,5,30,30);
    [btn_phyStock setImage:[UIImage imageNamed:@"physical_stock"] forState:UIControlStateNormal];
    [[btn_phyStock imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_phyStock.tintColor = [UIColor whiteColor];
    [btn_phyStock addTarget:self action:@selector(physStockNavigationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barPhyStockBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_phyStock];
    
    UIButton * btn_Scaner =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Scaner.frame = CGRectMake(0,5,30,30);
    [btn_Scaner setImage:[UIImage imageNamed:@"signal"] forState:UIControlStateNormal];
    [[btn_Scaner imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_Scaner.tintColor = [UIColor whiteColor];
    [btn_Scaner addTarget:self action:@selector(scanerNavigationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barScannerBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_Scaner];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 4;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:barFilterBtn, tagBarButton, barCameraBtn, nil];
    //self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:tagBarButton, barCameraBtn, barPhyStockBtn, nil];
}

- (void)filterNavigationButtonAction {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StockFilterVC *popupVC = [storyboard instantiateViewControllerWithIdentifier:@"StockFilterVC"];
    popupVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    popupVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    __weak typeof(self) weakSelf = self;
    popupVC.completionHandler = ^(NSDictionary *filterResponceData) {
        NSLog(@"Received from child: %@", filterResponceData);
        //NSString *joinedString = [filterResponceData componentsJoinedByString:@", "];
        //NSLog(@"%@", joinedString);
        
        NSString *pscid = [NSString stringWithFormat:@"%@",filterResponceData[@"pscid"]];
        NSString *dtime = filterResponceData[@"dtime"];
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        //strongSelf->txtItem.text = joinedString;
        
        NSString *titleName = [NSString stringWithFormat:@"%@    Scan Id :%@", dtime, pscid];
        [strongSelf->btnTitleDetails setTitle:titleName forState: UIControlStateNormal];
        strongSelf->selectedScanId = pscid;
        //[self get_StockData: pscid];
        [strongSelf get_ScanId:YES];
        //[strongSelf get_StockData:pscid];
    };
    [self presentViewController:popupVC animated:YES completion:nil];
}

- (void)tagNavigationBtnAction {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please enter Tagno" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Please enter Tagno";
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            UITextField *txt_tagno = alertController.textFields.firstObject;
            if (![txt_tagno.text isEqualToString:@"Please enter Tagno"]) {
                self->tagno=txt_tagno.text;
                //[self scrollData_Category];
            }else{
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action){
            self->tagno=@"";
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
}

- (void)cameraNavigationButtonAction {
    ScanViewController *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"ScanViewController"];
    obj.str_act =@"Stock";
    [self.navigationController pushViewController:obj animated:YES];
}

- (void)physStockNavigationButtonAction {
    PhysicalStockVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"PhysicalStockVC"];
    [self.navigationController pushViewController:obj animated:YES];
}

- (void)scanerNavigationButtonAction{
    
}

#pragma mark: - Button Action Method

-(IBAction)scanIdBtnAction:(id)sender{
    if (scanIdListData.count > 0) {
        scanIdListView.hidden = false;
    }
}

-(IBAction)scanIdOkBtnAction:(id)sender{
    scanIdListView.hidden = true;
}

-(IBAction)scanIdCancleBtnAction:(id)sender{
    scanIdListView.hidden = true;
}

-(void)pscidDeleteBtnAction:(UIButton*)sender{
    NSString * pscid = [[scanIdListData valueForKey:@"pscid"] objectAtIndex:sender.tag];
    [self confirmDeleteAlert:pscid];
}

-(void)confirmDeleteAlert: (NSString *)str_Pscid{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                  message:@"Are you sure want to delete it"
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action){
        
        [self URL_SINGLE_ITEM_DELETE:str_Pscid];
        self->scanIdListView.hidden = true;
    }];
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action){}];
    [alert addAction:noButton];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == stockTblView) {
        return stockListData.count;
    } else if (tableView == scannedTblView) {
        return scannedListData.count;
    } else if (tableView == conflictTblView) {
        return conflictListData.count;
    } else if (tableView == unknownTblView) {
        return unknownListData.count;
    } else if (tableView == scanIdListTblView) {
        return scanIdListData.count;
    }else{
        return 0;
    }
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
    subContainView.frame = CGRectMake(5,5, tableView.frame.size.width - 10, 40);
    subContainView.backgroundColor = UIColor.whiteColor;
    subContainView.layer.cornerRadius = 8;
    subContainView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    subContainView.layer.borderWidth = 1;
    subContainView.clipsToBounds = true;
    [cell.contentView addSubview:subContainView];
    
    UILabel *lbl_Name = [[UILabel alloc] init];
    lbl_Name.frame = CGRectMake(5, 5, subContainView.frame.size.width - 10, 32);
    [lbl_Name setFont: [UIFont systemFontOfSize:14]];
    lbl_Name.textAlignment = NSTextAlignmentCenter;
    //[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [subContainView addSubview:lbl_Name];
    
    NSString * titleName = @"";
    if (tableView == stockTblView) {
        titleName = [[stockListData valueForKey:@"tgno"] objectAtIndex:indexPath.row];
    } else if (tableView == scannedTblView) {
        titleName = [[scannedListData valueForKey:@"tgno"] objectAtIndex:indexPath.row];
    } else if (tableView == conflictTblView) {
        titleName = [[conflictListData valueForKey:@"tgno"] objectAtIndex:indexPath.row];
    } else if (tableView == unknownTblView) {
        titleName = [[unknownListData valueForKey:@"tgno"] objectAtIndex:indexPath.row];
    } else if (tableView == scanIdListTblView) {
        NSString * pscid = [[scanIdListData valueForKey:@"pscid"] objectAtIndex:indexPath.row];
        NSString * dtime = [[scanIdListData valueForKey:@"dtime"] objectAtIndex:indexPath.row];
        NSString * tgpc = [[scanIdListData valueForKey:@"tgpc"] objectAtIndex:indexPath.row];
        titleName = [NSString stringWithFormat:@"%@  %@  %@", pscid, dtime, tgpc];
        
        lbl_Name.textAlignment = NSTextAlignmentLeft;
        [lbl_Name setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        if (![selectedScanId isEqual: pscid]) {
            UIButton *btn_Delete = [[UIButton alloc] init];
            btn_Delete.frame = CGRectMake(subContainView.frame.size.width - 40, 5, 30, 30);
            [btn_Delete setImage:[UIImage imageNamed:@"delete"] forState: UIControlStateNormal];
            [btn_Delete addTarget:self action:@selector(pscidDeleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [subContainView addSubview:btn_Delete];
            btn_Delete.tag = indexPath.row;
        }
    }else{
        titleName = @"";
    }
    lbl_Name.text = [NSString stringWithFormat:@"%@", titleName];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {\
    if (tableView == scanIdListTblView) {
        NSString * pscid = [[scanIdListData valueForKey:@"pscid"] objectAtIndex:indexPath.row];
        NSString * dtime = [[scanIdListData valueForKey:@"dtime"] objectAtIndex:indexPath.row];
        NSString * tgpc = [[scanIdListData valueForKey:@"tgpc"] objectAtIndex:indexPath.row];
        NSString *titleName = [NSString stringWithFormat:@"%@    Scan Id :%@", dtime, pscid];
        [btnTitleDetails setTitle:titleName forState: UIControlStateNormal];
        selectedScanId = pscid;
        scanIdListView.hidden = true;
        [self get_StockData: pscid];
    }else{
        
        NSString * str_tagno = @"";
        if (tableView == stockTblView) {
            str_tagno = [[stockListData valueForKey:@"tgno"] objectAtIndex:indexPath.row];
        } else if (tableView == scannedTblView) {
            str_tagno = [[scannedListData valueForKey:@"tgno"] objectAtIndex:indexPath.row];
        } else if (tableView == conflictTblView) {
            str_tagno = [[conflictListData valueForKey:@"tgno"] objectAtIndex:indexPath.row];
        } else if (tableView == unknownTblView) {
            str_tagno = [[unknownListData valueForKey:@"tgno"] objectAtIndex:indexPath.row];
        }
        
        TagCalculator *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"TagCalculator"];
        obj.str_tag = str_tagno;
        [self.navigationController pushViewController:obj animated:YES];
    }
}

#pragma mark: - Api Method

-(void)get_StockData:(NSString *)strPscid {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *pscid = strPscid.length > 0 ? strPscid : @"";
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    
    if ([ECAT_TYPE isEqualToString:@"1"]){
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@&pscid=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,mobile,pscid,ip,db,ipusername,pswd,ftppath];
        
        URL_API =[WEB_URL URL_Get_physicalstock];
        
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_physicalstock.php",ip];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@&pscid=%@&ftppath=%@",apptype,mobile,pscid,ftppath];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@&pscid=%@",apptype,mobile,pscid];
        URL_API = [WEB_URL URL_Get_physicalstock];
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
            NSLog(@"Successfully Resopsnce Stock ... %@", jsonObject);
            
            //check if the country code was valid
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            stockListData = [pDict objectForKey:@"itemlist"];
            scannedListData = [pDict objectForKey:@"scanlist"];
            conflictListData = [pDict objectForKey:@"conflictlist"];
            unknownListData = [pDict objectForKey:@"unknownlist"];
            [stockTblView reloadData];
            [scannedTblView reloadData];
            [conflictTblView reloadData];
            [unknownTblView reloadData];
            [scanIdListTblView reloadData];
            lblStock.text = [NSString stringWithFormat: @"%lu", (unsigned long)stockListData.count];
            lblScanned.text = [NSString stringWithFormat: @"%lu", (unsigned long)scannedListData.count];
            lblConflict.text = [NSString stringWithFormat: @"%lu", (unsigned long)conflictListData.count];
            lblUnknow.text = [NSString stringWithFormat: @"%lu", (unsigned long)unknownListData.count];
            lblInfo.text = [NSString stringWithFormat: @"Missing : %lu", (unsigned long)stockListData.count];
            NSLog(@"info = %@",lblInfo.text);
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)get_ScanId:(Boolean)isFilter{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    
    if ([ECAT_TYPE isEqualToString:@"1"]){
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,mobile,ip,db,ipusername,pswd,ftppath];
        
        URL_API =[WEB_URL URL_Get_PScanid];
        
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_pscanid.php",ip];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@&ftppath=%@",apptype,mobile,ftppath];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@",apptype,mobile];
        URL_API = [WEB_URL URL_Get_PScanid];
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
                [self parseResponse_ScanId:data isFilter:isFilter];
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

- (void)parseResponse_ScanId:(NSData *) data isFilter:(Boolean)isFilter{
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
            NSLog(@"Successfully Resopsnce Stock ... %@", jsonObject);
            
            //check if the country code was valid
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            scanIdListData = [[NSMutableArray alloc]init];
            scanIdListData = [pDict objectForKey:@"pscanidlist"];
            [scanIdListTblView reloadData];
            if (scanIdListData.count > 0) {
                NSString * pscid = [[scanIdListData valueForKey:@"pscid"] lastObject];
                NSString * dtime = [[scanIdListData valueForKey:@"dtime"] lastObject];
                NSString * tgpc = [[scanIdListData valueForKey:@"tgpc"] lastObject];
                NSString *titleName = [NSString stringWithFormat:@"%@    Scan Id :%@", dtime, pscid];
                [btnTitleDetails setTitle:titleName forState: UIControlStateNormal];
                selectedScanId = pscid;
                [self get_StockData:selectedScanId];
//                if(isFilter){
//                    pscid = [[scanIdListData valueForKey:@"pscid"] lastObject];
//                    dtime = [[scanIdListData valueForKey:@"dtime"] lastObject];
//                    tgpc = [[scanIdListData valueForKey:@"tgpc"] lastObject];
//                    selectedScanId = pscid;
//                    NSString *titleName = [NSString stringWithFormat:@"%@    Scan Id :%@", dtime, pscid];
//                    [btnTitleDetails setTitle:titleName forState: UIControlStateNormal];
//                    [self get_StockData:selectedScanId];
//                }
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)URL_SINGLE_ITEM_DELETE: (NSString *)scanid {
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
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&scanid=%@", apptype,ip,db,ipusername, pswd, ftppath, scanid];
        
        URL_API =[WEB_URL URL_Delete_CART_Item];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/delete_cart_item.php",ip];
        loginRequest=[NSString stringWithFormat:@"scanid=%@&apptype=%@&ftppath=%@",scanid,apptype,ftppath];
        
    }else{
        loginRequest=[NSString stringWithFormat:@"scanid=%@&apptype=%@",scanid,apptype];
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
            
            if ([str_success isEqualToString:@"1"]) {
                //[self get_StockData:@""];
                [self get_ScanId:NO];
            }else{
                [self alertMsg: str_msg];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

@end
