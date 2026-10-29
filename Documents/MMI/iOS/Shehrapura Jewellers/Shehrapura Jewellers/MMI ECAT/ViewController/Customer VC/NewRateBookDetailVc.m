//
//  NewRateBookDetailVc.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 14/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "NewRateBookDetailVc.h"
#import "webUrlconstant.h"
#import "BusyIndicator.h"

#pragma mark - Custom NewRateBook UITableViewCell

@interface NewRateBookDetailTblCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *subView;
@property (nonatomic, strong) IBOutlet UILabel *lblRefNo;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UILabel *lblAmount;
@property (nonatomic, strong) IBOutlet UIButton *btnMode;

@end

@implementation NewRateBookDetailTblCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

@end

#pragma mark - New RateBook Detail Vc

@interface NewRateBookDetailVc ()
{
    NSString *orderID;
    NSString *strAmount;
    NSString *strBhavRate;
    NSString *strBhavWt;
}
  
@end

@implementation NewRateBookDetailVc

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Kitty Det";
    self.razorpay = [RazorpayCheckout initWithKey:@"rzp_test_1DP5mmOlF5G5ag" andDelegate:self];
    //Swiz Gold live key
    //self.razorpay = [RazorpayCheckout initWithKey:@"rzp_liv e_ujFCitNMadlokW" andDelegate:self];
    [self scrollData_kitty];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

#pragma mark: - TableVeiw Delegate and DataSouce


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [arraytblListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewRateBookDetailTblCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewRateBookDetailTblCell" forIndexPath:indexPath];
    
    cell.lblRefNo.text = [NSString stringWithFormat:@"%@", [[arraytblListData valueForKey:@"refno"] objectAtIndex:indexPath.row]];
    cell.lblDate.text = [NSString stringWithFormat:@"%@", [[arraytblListData valueForKey:@"ksdate"] objectAtIndex:indexPath.row]];
    cell.lblAmount.text = [NSString stringWithFormat:@"%@", [[arraytblListData valueForKey:@"kinsamt"] objectAtIndex:indexPath.row]];
    NSString *payType = [NSString stringWithFormat:@"%@", [[arraytblListData valueForKey:@"rmode"] objectAtIndex:indexPath.row]];
    NSString *msg = [NSString stringWithFormat:@"%@", [[arraytblListData valueForKey:@"msg"] objectAtIndex:indexPath.row]];
    cell.btnMode.tag = indexPath.row;
    cell.subView.backgroundColor = [UIColor whiteColor];
    if ([payType isEqualToString:@""]) {
        [cell.btnMode setBackgroundColor:[UIColor colorNamed:@"appRed_Color"]];
        [cell.btnMode addTarget:self action:@selector(btnModeType:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnMode setTitle:@"Pay Now" forState:UIControlStateNormal];
    }else{
        [cell.btnMode setTitle:payType forState:UIControlStateNormal];
        [cell.btnMode setBackgroundColor:[UIColor colorNamed:@"border_Color"]];
//        cell.subView.backgroundColor = [UIColor colorNamed:@"selected_Color"];
    }
    return cell;
    
}

#pragma mark:- Cell Button Method

-(void)btnModeType:(UIButton*) sender{
    NSString *str_stampid = [NSString stringWithFormat:@"%@", [[arraytblListData valueForKey:@"stampid"] objectAtIndex:sender.tag]];
    NSDictionary *selectData = [arraytblListData objectAtIndex: sender.tag];
    int amount = [[selectData valueForKey:@"kinsamt"] intValue];
    if (amount > 0){
        if ([self.strKittyType isEqualToString:@"Kitty Customer"]) {
            [self showPaymentPopup:selectData];
            //[self didTapOptionsButton:sender]; //for ipad if pop show bottom of cell
        }else{
            [self apiPaymentInsert:@"Online" selectData:selectData];
        }
    }else{
        [self alertMsg:@"Invalid Amount"];
    }
   
}

//- (void)didTapOptionsButton:(UIButton *)button{
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
//    //NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Options"
//                                                                   message:nil
//                                                            preferredStyle:UIAlertControllerStyleActionSheet];
//
//    [alert addAction:[UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"Edit tapped on row %ld", (long)indexPath.row);
//    }]];
//
//    [alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"Delete tapped on row %ld", (long)indexPath.row);
//    }]];
//
//    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
//
//    // ✅ iPad-style popover from button
//    UIPopoverPresentationController *popover = alert.popoverPresentationController;
//    if (popover) {
//        popover.sourceView = button;
//        popover.sourceRect = button.bounds;
//        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
//    }
//
//    [self presentViewController:alert animated:YES completion:nil];
//}


- (void)showPaymentPopup:(NSDictionary *)rowData {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please Select Payment Mode"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cash" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Option Cash selected");
        [self apiPayment:@"Cash" selectData:rowData];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Online" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Option Online selected");
        [self apiPayment:@"Online" selectData:rowData];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showSegmentPopup1 {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please Select Payment Mode"
                                                                   message:@"\n\n\n"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"Cash", @"Online"]];
    segment.frame = CGRectMake(10, 60, 240, 30);
    segment.selectedSegmentIndex = 0;

    [segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];

    [alert.view addSubview:segment];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Segment selected: %ld", (long)segment.selectedSegmentIndex);
    }];

    [alert addAction:okAction];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)segmentChanged:(UISegmentedControl *)sender {
    NSLog(@"Changed to index: %ld", (long)sender.selectedSegmentIndex);
}



#pragma mark:- Api Method

-(void)scrollData_kitty {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    
    NSString *loginRequest=[NSString stringWithFormat:@"ktid=%@",self.kittId];
    NSLog(@"response  %@",loginRequest);
    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",[WEB_URL URL_GET_Kittydet]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
      {
        if ([data length] >0 && error == nil){
            [[BusyIndicator sharedInstance]stopIndicator];
            dispatch_async(dispatch_get_main_queue(), ^{
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
                    self->arraytblListData = [[NSMutableArray alloc]init];
                    self->arraytblListData = [pDict objectForKey:@"kittylist"];
                    [self.tableView reloadData];
                    if ([self->arraytblListData count] > 0){
                        double totalPositive = 0.0;
                        double totalNegative = 0.0;

                        for (NSDictionary *item in self->arraytblListData) {
                            if (item[@"kinsamt"] != [NSNull null]) {
                            NSNumber *amount = item[@"kinsamt"];
                                double value = amount.doubleValue;
                                if (value >= 0) {
                                    totalPositive += value;
                                } else {
                                    totalNegative += value;
                                }
                            }
                        }
                        self.lblRow.text = [NSString stringWithFormat:@"Row : %ld", (long)[self->arraytblListData count]];
                        self.lblRec.text = [NSString stringWithFormat:@"Rec : %.2ld", (long)totalNegative];
                        self.lblDue.text = [NSString stringWithFormat:@"Due : %.2ld", (long)totalPositive];
                    }else{
                        self.lblRow.text = @"Row : 0";
                        self.lblRec.text = @"Rec : 0.0";
                        self.lblDue.text = @"Due : 0.0";
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Record Found"
                                                                                          message:nil
                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                                  style:UIAlertActionStyleDefault
                                                                                handler:^(UIAlertAction *action) {
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
                        
                        [alert addAction:okAction];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                        
                    }
                }
                
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

-(void)apiPayment: (NSString *)payType selectData: (NSDictionary *)rowData{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSLog(@"selected row data  %@",rowData);
    NSString *appType = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *kittyip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
    NSString *kittydb = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
    NSString *kittyuser = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
    NSString *kittypswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
    NSString *userMobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
    
    NSString *kMno = [rowData valueForKey:@"kmno"];
    NSString *kAmount = [rowData valueForKey:@"kinsamt"];
    NSString *sTampid = [rowData valueForKey:@"stampid"];
    
    NSString *bhavrate = [rowData valueForKey:@"kinsamt"];
    NSString *bhavwt = [rowData valueForKey:@"stampid"];
    
    NSString *loginRequest = [NSString stringWithFormat:@"apptype=%@&kittyip=%@&kittydb=%@&kittyuser=%@&kittypswd=%@&ftppath=%@ &mobile=%@ &ktid=%@&kmno=%@&amount=%@&stampid=%@&status=%@&bhavrate=%@&bhavwt=%@",appType,kittyip,kittydb,kittyuser,kittypswd,ftppath,userMobile,self.kittId,kMno,kAmount,sTampid,payType,bhavrate,bhavwt];
    NSLog(@"response  %@",loginRequest);
    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",[WEB_URL URL_GET_KittyPaymentMode]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
      {
        if ([data length] >0 && error == nil){
            [[BusyIndicator sharedInstance]stopIndicator];
            dispatch_async(dispatch_get_main_queue(), ^{
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
                    NSString *msg = [pDict objectForKey:@"message"];
                    [self alertMsg:msg];
                    [self scrollData_kitty];
                }
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

-(void)apiPaymentInsert: (NSString *)payType selectData: (NSDictionary *)rowData{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *apptype = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *userMobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    
    NSString *kMno = [rowData valueForKey:@"kmno"];
    NSString *kAmount = [rowData valueForKey:@"kinsamt"];
    NSString *sTampid = [rowData valueForKey:@"stampid"];
    NSString *bhavrate = @"0";
    NSString *bhavwt = @"0";
    
    NSDictionary *params = @{
        @"apptype": apptype,
        @"mobile": userMobile,
        @"ktid" : self.kittId,
        @"kmno" : kMno,
        @"amount" : kAmount,
        @"stampid" : sTampid,
        @"status" : payType,
        @"bhavrate" : bhavrate,
        @"bhavwt" : bhavwt
        
    };
    strAmount = kAmount;
    strBhavRate = bhavrate;
    strBhavWt = bhavwt;
    NSLog(@"params: %@", params);
    [[APIManager sharedManager] GET: [WEB_URL URL_GET_KittyInsertPayment]
                         parameters: params
                         completion:^(NSDictionary *data, NSError *error) {
        if (!error) {
            NSLog(@"Insert Payment Response: %@", data);
            NSString *success = [data objectForKey:@"success"];
            self->orderID = [[data objectForKey:@"orderid"] stringValue];
            NSLog(@"Successfully = %@,  Orderid is = %@",success,self->orderID);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if ([self->orderID isKindOfClass:[NSString class]] || self->orderID.length != 0) {
                         [self createOrderID:kAmount orderId: self->orderID];
                     }
                 });
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [[BusyIndicator sharedInstance]stopIndicator];
    }];
}

- (void)createOrderID:(NSString *)strAmount orderId:(NSString *)strOrderId{
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *postString = [NSString stringWithFormat:@"amount=%@&orderid=%@",strAmount, strOrderId];
    NSLog(@"InsertPayment Params: %@", postString);
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    // Configure request
    NSURL *url = [NSURL URLWithString:[WEB_URL URL_RazorPayOrderId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
        dataTaskWithRequest:request
          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [[BusyIndicator sharedInstance]stopIndicator];
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        [[BusyIndicator sharedInstance]stopIndicator];
        NSError *jsonError;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        NSString *cOrderId = [responseDict[@"orderid"] stringValue];
        int amount = [responseDict[@"amount"] intValue];
        if (!jsonError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([cOrderId isKindOfClass:[NSString class]] || cOrderId.length != 0) {
                    if ([strAmount intValue] > 0) {
                        [self payWithRazorPay: cOrderId amount: amount];
                    }
                }
            });
        } else {
            NSString *msg = responseDict[@"message"] ?: @"Something went wrong";
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:msg preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
        [[BusyIndicator sharedInstance]stopIndicator];
    }];
    [task resume];
}

#pragma mark:- Update Razore payment Status Api Method with id

-(void)updateRazorPaymentApi:(NSString *)payment_Id status:(NSString *)strStatus{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loginid    = [defaults stringForKey:@"loginid"];
    NSString *userMobile = [defaults stringForKey:@"mobile"];
    NSString *userName   = [defaults stringForKey:@"username"];
    NSString *ECAT_TYPE  = [defaults stringForKey:@"ECAT_TYPE"];
    
    NSString *postString = [NSString stringWithFormat: @"loginid=%@&loginid01=%@&mobile=%@&cname=%@&catid=%@&ktid=%@&amount=%@&bhavrate=%@&method=%@&status=%@&txnid=%@&orderid=%@",loginid, loginid, userMobile, userName, ECAT_TYPE, self.kittId, self->strAmount, self->strBhavRate, @"ONLINE", strStatus, payment_Id, self->orderID];
    NSLog(@"param json = %@", postString);
    NSString *api = [NSString stringWithFormat:@"%@", [WEB_URL URL_UpdateRazorPayment]];
    
    NSURL *url = [NSURL URLWithString:api]; // replace with real endpoint
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
                                  dataTaskWithRequest:request
                                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"SaveApi Error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError || !responseDict) {
            NSLog(@"JSON parse error: %@", jsonError.localizedDescription);
            return;
        }
        
        NSLog(@"Responce Dic data : %@", responseDict);
        NSString *successStr = responseDict[@"success"];
        NSString *message = responseDict[@"message"];
        NSInteger success = [successStr integerValue];
        [[BusyIndicator sharedInstance]stopIndicator];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            if (success == 1) {
                [self scrollData_kitty];
            }
        });
    }];
    
    [task resume];
}

#pragma mark:- RazorPay Method

-(void)payWithRazorPay:(NSString *)orderId amount:(int)amountInPaise{
    NSString *userMobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userName = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
    //Demo orderId = @"order_DBJOWzybf0sJbb"
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (!appName) {
        appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    }
    /*
    NSDecimalNumber *decimalRupees = [NSDecimalNumber decimalNumberWithString:strAmount];
    NSInteger paise = 100;
    if (![decimalRupees isEqualToNumber:[NSDecimalNumber notANumber]]) {
        NSDecimalNumber *decimalPaise = [decimalRupees decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
        // Optionally convert to integer (if needed)
        paise = [decimalPaise integerValue];
        NSLog(@"Paise (as NSDecimalNumber): %@", decimalPaise);
        NSLog(@"Paise (as NSInteger): %ld", (long)paise);
    } else {
        NSLog(@"Invalid rupee amount string.");
    }
    */
    NSDictionary *options = @{
            @"amount": @((long)amountInPaise), //@"100", // amount in paise: ₹1.00
            @"currency": @"INR",
            @"description": @"Kitty Installment",
            //@"image": @"https://your-logo-url.com/logo.png",
            @"name": appName,
            @"orderId": orderId, // Optional, from Razorpay Orders API
            @"prefill": @{
                    @"contact": userMobile,
                    @"username": userName,
                    @"email": @"test@example.com"
            },
            @"theme": @{
                    @"color": @"#330557"
            }
        };
    [self.razorpay open:options];
}

#pragma mark: - RazorPay Delegate Methods

- (void)onPaymentSuccess:(NSString *)payment_id {
    NSLog(@"Success: %@", payment_id);
    NSString *strStatus = @"SUCCESS";
    [self updateRazorPaymentApi: payment_id status:strStatus];
}

- (void)onPaymentError:(int)code description:(NSString *)str {
    NSLog(@"Error: %@", str);
    NSLog(@"Error Code: %d", code);
    NSString *strStatus = @"FAILURE";
    [self updateRazorPaymentApi: @"" status:strStatus];
}

@end

