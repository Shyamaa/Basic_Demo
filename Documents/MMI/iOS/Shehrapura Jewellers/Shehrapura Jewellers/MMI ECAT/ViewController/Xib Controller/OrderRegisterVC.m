//
//  OrderRegisterVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 09/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "OrderRegisterVC.h"
#import "OrderRegisterTblCell.h"
#import "webUrlconstant.h"
#import "BusyIndicator.h"
#import "UIImageView+WebCache.h"
#import "OrderRegisterMoreVC.h"


@interface OrderRegisterVC ()

@end

@implementation OrderRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigation];
    [self getOrderListApi];
}

- (void)setUpNavigation {
    if ([self.str_ViewType isEqualToString:@"REP"]) {
        self.title = @"Repair Register";
    }else{
        self.title = @"Order Register";
    }
    
    [self setUpNavigationButton];
}

- (void)setUpNavigationButton {
    UIButton *button_Short =  [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button_Short setFrame:CGRectMake(0, 0, 35, 35)];
    [button_Short setImage:[UIImage imageNamed:@"short"] forState:UIControlStateNormal];
    [[button_Short imageView] setContentMode: UIViewContentModeScaleAspectFit];
    button_Short.tintColor = [UIColor whiteColor];
    [button_Short addTarget:self action:@selector(shortNavigationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barShortBtn = [[UIBarButtonItem alloc] initWithCustomView:button_Short];
    
    UIButton * btn_Filter =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Filter.frame = CGRectMake(0,8,35,35);
    [btn_Filter setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [[btn_Filter imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_Filter.tintColor = [UIColor whiteColor];
    [btn_Filter addTarget:self action:@selector(filterNavigationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barFilterBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_Filter];
    
    UIButton * btn_Share =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Share.frame = CGRectMake(0,8,35,35);
    [btn_Share setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    btn_Share.tintColor = [UIColor whiteColor];
    [btn_Share addTarget:self action:@selector(shareNavigationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [[btn_Share imageView] setContentMode: UIViewContentModeScaleAspectFit];
    UIBarButtonItem *barShareBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_Share];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 4;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:barShareBtn, space, barFilterBtn, space, barShortBtn, nil];
}

#pragma mark - Navigation Button Action Methods

- (void)shortNavigationButtonAction {
    [tblArrayDataItem sortUsingDescriptors:@[
           [NSSortDescriptor sortDescriptorWithKey:@"cname" ascending:YES]
       ]];
    [_tableView reloadData];
    
//    NSArray *sortedArray = [tblArrayDataItem mutableCopy];
//    [sortedArray sortUsingDescriptors:@[
//        [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES]
//    ]];
    
}
- (void)filterNavigationButtonAction {
    [self presentFilterView];
}

- (void)shareNavigationButtonAction {
}

#pragma mark:- Present Customer Form

- (void)presentFilterView {
    OrderRegisterFilterVC *popupVC = [[OrderRegisterFilterVC alloc] init];
    popupVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    popupVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    popupVC.delegate = self;
    popupVC.arrayDataItem = tblArrayDataItem;
    [self presentViewController:popupVC animated:YES completion:nil];
}

// Implement the delegate method to get the data after the popup is dismissed
- (void)didFinishFilterOrderWithData:(NSData *)apiData customerData:(NSDictionary *)cdata{
    // Update the label with the data received from the popup
    NSLog(@"Cutomer API Data = %@", apiData);
    NSLog(@"Cutomer Data = %@", cdata);
    NSString *str_cname = [cdata valueForKey: @"cname"];
    NSString *str_cphone = [cdata valueForKey: @"contactNo1"];
    //[self parse_Insertmember:apiData con_mob: str_cphone cname:str_cname];
}

#pragma mark - Table View Data source

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tblArrayDataItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderRegisterTblCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderRegisterTblCell" forIndexPath:indexPath];
    cell.btnSMS.tag = indexPath.row;
    cell.btnWhatsUp.tag = indexPath.row;
    cell.btnCall.tag = indexPath.row;
    cell.btnCheck.tag = indexPath.row;
    cell.btnShowMore.tag = indexPath.row;
    
    cell.btnSMS.layer.borderWidth = 1.0f;
    cell.btnSMS.layer.borderColor = [UIColor colorNamed:@"appRed_Color"].CGColor;
    cell.btnWhatsUp.layer.borderWidth = 1.0f;
    cell.btnWhatsUp.layer.borderColor = [UIColor colorNamed:@"appRed_Color"].CGColor;
    cell.btnCall.layer.borderWidth = 1.0f;
    cell.btnCall.layer.borderColor = [UIColor colorNamed:@"appRed_Color"].CGColor;
    
    [cell.btnSMS addTarget:self action:@selector(tblCellSmsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnWhatsUp addTarget:self action:@selector(tblCellWhatsUpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnCall addTarget:self action:@selector(tblCellCallButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnCheck addTarget:self action:@selector(tblCellCheckButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnShowMore addTarget:self action:@selector(tblCellShowMoreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    NSURL *URL;
    URL = [NSURL URLWithString:[[tblArrayDataItem valueForKey:@"img_url"] objectAtIndex:indexPath.row]];
    NSString *myString = [URL absoluteString];
    [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
    [cell.imgViewItem sd_setImageWithURL:[NSURL URLWithString:myString]
                        placeholderImage:[UIImage imageNamed:@"1024.png"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    
    cell.lblJobNo.text = [NSString stringWithFormat:@"Job No : %@",[[tblArrayDataItem valueForKey:@"jobno"]  objectAtIndex:indexPath.row]];
    cell.lblDate.text = [NSString stringWithFormat:@"Date : %@",[[tblArrayDataItem valueForKey:@"deldate"]  objectAtIndex:indexPath.row]];
    cell.lblStamp.text = [NSString stringWithFormat:@"Stamp : %@",[[tblArrayDataItem valueForKey:@"curstamp"]  objectAtIndex:indexPath.row]];
    cell.lblCurrentWt.text = [NSString stringWithFormat:@"Cur Wt : %@",[[tblArrayDataItem valueForKey:@"curgwt"]  objectAtIndex:indexPath.row]];
    cell.lblName.text = [NSString stringWithFormat:@"Name : %@",[[tblArrayDataItem valueForKey:@"cname"]  objectAtIndex:indexPath.row]];
    NSString *str_Mobile = [[tblArrayDataItem valueForKey:@"mobile"]  objectAtIndex:indexPath.row];
    NSString *str_Status = [[tblArrayDataItem valueForKey:@"ostatus"]  objectAtIndex:indexPath.row];
    cell.lblMobile.text = [NSString stringWithFormat:@"Mobile : %@, %@",str_Mobile, str_Status];
    if ([self.str_ViewType isEqualToString:@"REP"] || ![str_Status isEqualToString:@"Pending"]){
        [cell.btnCheck setHidden:YES];
    }else{
        [cell.btnCheck setHidden:NO];
    }
    return cell;
}

#pragma mark - Table Button Cell Action Methods

- (void)tblCellSmsButtonAction:(UIButton *)sender {
    NSString *str_Name = [[tblArrayDataItem valueForKey:@"cname"]  objectAtIndex: sender.tag];
    NSString *message = [NSString stringWithFormat: @"Dear, %@ Your Order is Ready, Thanks", str_Name];
    NSString *phoneNumber = [[tblArrayDataItem valueForKey:@"mobile"]  objectAtIndex: sender.tag];
    //phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    //[self phoneSMSMethod:message number:phoneNumber];
    
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        // Optionally, you can pre-fill the recipient and message content
        messageController.recipients = @[phoneNumber]; // Replace with actual recipient phone number
        messageController.body = message;
        // Present the message composer
        [self presentViewController:messageController animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Your device doesn't support SMS."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)tblCellWhatsUpButtonAction:(UIButton *)sender {
    NSString *str_Name = [[tblArrayDataItem valueForKey:@"cname"]  objectAtIndex: sender.tag];
    NSString *phoneNumber = [[tblArrayDataItem valueForKey:@"mobile"]  objectAtIndex: sender.tag];
    NSString *message = [NSString stringWithFormat: @"Dear, %@ Your Order is Ready, Thanks", str_Name];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self shareOnWhatsApp:message phone:phoneNumber];
}


- (void)tblCellCallButtonAction:(UIButton *)sender {
    NSString *phoneNumber = [[tblArrayDataItem valueForKey:@"mobile"]  objectAtIndex: sender.tag];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self phoneCallMethod:phoneNumber];
}

- (void)tblCellCheckButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)tblCellShowMoreButtonAction:(UIButton *)sender {
    OrderRegisterMoreVC *popupVC = [[OrderRegisterMoreVC alloc] init];
    popupVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    popupVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    popupVC.arrayData = [tblArrayDataItem objectAtIndex:sender.tag];
    [self presentViewController:popupVC animated:YES completion:nil];
}

#pragma mark:- Api Methods

-(void)getOrderListApi {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    [self getAPIWithApiName: [WEB_URL URL_GET_OrderRegister]
                        act: self.str_ViewType
                 completion:^(NSDictionary *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"Order list Response: %@", response);
            self->tblArrayDataItem = [[NSMutableArray alloc]init];
            self->tblArrayDataItem = [[response objectForKey:@"ordlist"] mutableCopy];
            NSLog(@"ordlist : %@", self->tblArrayDataItem);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        [[BusyIndicator sharedInstance] stopIndicator];
    }];
}

- (void)getAPIWithApiName:(NSString *)apiName
                      act:str_type
               completion:(void (^)(NSDictionary *response, NSError *error))completion {
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
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&act=%@",apptype,ip,db,ipusername,pswd,ftppath,str_type];
        URL_API = apiName;
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/feeditem.php",ip];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ftppath=%@&type=%@",apptype,ftppath,str_type];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&type=%@",apptype,str_type];
        URL_API = apiName;
    }
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
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                NSError *jsonError;
            //                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            //
            //            });
        }else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            completion(nil, error);
            
        }else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
            completion(nil, error);
        }
    }] resume];
    // Create a data task to handle the request
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
        } else {
            NSError *jsonError;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError) {
                completion(nil, jsonError);
            } else {
                completion(jsonResponse, nil);
            }
        }
    }];
    // Start the request
    [dataTask resume];
}

@end
