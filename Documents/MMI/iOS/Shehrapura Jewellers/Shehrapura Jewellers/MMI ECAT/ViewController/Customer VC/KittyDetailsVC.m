//
//  KittyDetailsVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 14/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "KittyDetailsVC.h"
#import "webUrlconstant.h"
#import "BusyIndicator.h"

#pragma mark - Custom NewRateBook UITableViewCell

@interface KittyDetailsVCTablCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *subView;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UILabel *lblAmount;
@property (nonatomic, strong) IBOutlet UILabel *lblRate;
@property (nonatomic, strong) IBOutlet UILabel *lblWt;

@end

@implementation KittyDetailsVCTablCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

@end

#pragma mark - UserListActivity

@interface KittyDetailsVC()
{
    NSString *orderID;
    NSString *strAmount;
    NSString *strBhavRate;
    NSString *strBhavWt;
}
    
@end

@implementation KittyDetailsVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Kitty Det";
    self.razorpay = [RazorpayCheckout initWithKey:@"rzp_test_1DP5mmOlF5G5ag" andDelegate:self];
    //self.razorpay = [RazorpayCheckout initWithKey:@"rzp_live_ujFCitNMadlokW" andDelegate:self];// Swiz Gold live key
    [self scrollData_kitty];
    [self setUpNavigationButton];
    self.txtAmount.delegate = self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

- (void)setUpNavigationButton {
    UIButton *button_Pay =  [UIButton buttonWithType: UIButtonTypeSystem];
    [button_Pay setFrame:CGRectMake(0, 0, 70, 35)];
    [button_Pay setTitle:@"Pay" forState:UIControlStateNormal];
    [button_Pay setTintColor:[UIColor colorNamed:@"appRed_Color"]];
    [button_Pay setBackgroundColor:[UIColor whiteColor]];
    button_Pay.layer.cornerRadius = 5;
    [button_Pay addTarget:self action:@selector(payBarBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barPayBtn = [[UIBarButtonItem alloc] initWithCustomView:button_Pay];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 4;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: barPayBtn, nil];
}

#pragma mark:- UITextField Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.txtAmount) {
        NSString *updatedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSLog(@"amount %@", updatedString);
        CGFloat amount = [updatedString floatValue];
        CGFloat rate = [self.txtViewTodayRate.text floatValue];
        CGFloat wtvalue = (amount / rate);
        self.txtWt.text = [NSString stringWithFormat:@"%.3f", wtvalue];
    }
    return YES;
}

#pragma mark:- Action Method

-(void)payBarBtnAction{
    [self todayRateApi];
    NSString *strCategory = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
    self.payModeStackView.hidden = true;
    if ([strCategory isEqualToString:@"Staff"] || [strCategory isEqualToString:@"Agent"] || [strCategory isEqualToString:@"4"] ){
        self.btnCash.selected = true;
        self.btnOnline.selected = false;
        self.payModeStackView.hidden = false;
    }
}

-(IBAction)payModeBtnAction:(UIButton *)sender{
    self.btnCash.selected = false;
    self.btnOnline.selected = false;
    sender.selected = !sender.selected;
}

-(IBAction)payPopUpBtnAction:(UIButton *)sender{
    if (sender.tag == 24){
        if ([self.txtAmount.text isEqualToString:@""] || (self.txtAmount.text.length == 0) || [self.txtAmount.text intValue] <= 0) {
            [self alertMsg:@"Please enter valid amount"];
        }else{
            self.payView.hidden = true;
            NSString *strRate = [self.txtViewTodayRate.text isEqualToString:@""] ? @"0" : self.txtViewTodayRate.text;
            NSString *strWeight = [self.txtWt.text isEqualToString:@""] ? @"0" : self.txtWt.text;
            
            NSString *strCategory = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
            if ([strCategory isEqualToString:@"Staff"] || [strCategory isEqualToString:@"Agent"] || [strCategory isEqualToString:@"4"] ){
                //cash or online
                NSString *statusType = self.btnOnline.selected ? @"Online" : @"Cash";
                NSLog(@"Status = %@", statusType);
                [self payApiWithBhr:strRate bhw:strWeight amt:self.txtAmount.text status:statusType];
            }else{
                if ([self.txtViewTodayRate.text isEqualToString:@""]){
                    [self insterPaymentWithRate: @"0" weight: @"0" amount: self.txtAmount.text];
                }else{
                    [self insterPaymentWithRate:strRate weight:strWeight amount:self.txtAmount.text];
                }
            }
        }
    }else{
        self.payView.hidden = true;
        self.txtViewTodayRate.text = @"";
        self.txtAmount.text = @"";
        self.txtWt.text = @"";
    }
}

-(void)setUpPayView:(NSString *)strRate{
    self.payView.hidden = false;
    self.txtViewTodayRate.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.txtViewTodayRate.layer.borderWidth = 1;
    self.txtViewTodayRate.layer.cornerRadius = 5;
    self.todayRateStackView.hidden = true;
    self.wtStackView.hidden = true;
    
    NSString *ktype = [_selectData valueForKey:@"ktype"];
    NSString *kinsamt = [_selectData valueForKey:@"kinsamt"];
    
    if (![strRate isEqualToString:@""]){
        self.todayRateStackView.hidden = false;
        self.wtStackView.hidden = false;
        if ([ktype isEqualToString:@"3"] || [ktype isEqualToString:@"4"]) {
            self.txtViewTodayRate.text = strRate;
            self.txtAmount.text = kinsamt;
            double d_total = [kinsamt doubleValue] / [strRate doubleValue];
            self.txtWt.text = [NSString stringWithFormat:@"%.3f", d_total];
            self.txtAmount.enabled = ![ktype isEqualToString:@"3"];
        }
    }else{
        self.txtAmount.text = @"";
    }
}

#pragma mark: - TableVeiw Delegate and DataSouce


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [arraytblListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KittyDetailsVCTablCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KittyDetailsVCTablCell" forIndexPath:indexPath];
    
    cell.lblDate.text = [NSString stringWithFormat:@"%@", [[arraytblListData valueForKey:@"tdate"] objectAtIndex:indexPath.row]];
    cell.lblRate.text = [NSString stringWithFormat:@"%@", [[arraytblListData valueForKey:@"bhavrate"] objectAtIndex:indexPath.row]];
    cell.lblWt.text = [NSString stringWithFormat:@"%@", [[arraytblListData valueForKey:@"bhavwt"] objectAtIndex:indexPath.row]];
    CGFloat amount =  [[[arraytblListData valueForKey:@"amount"] objectAtIndex:indexPath.row] floatValue];
    if (amount < 0.00){
        cell.lblAmount.text = [NSString stringWithFormat:@"%@ Cr", [[arraytblListData valueForKey:@"amount"] objectAtIndex:indexPath.row]];
    }else{
        cell.lblAmount.text = [NSString stringWithFormat:@"%@ Dr", [[arraytblListData valueForKey:@"amount"] objectAtIndex:indexPath.row]];
    }
    return cell;
}

#pragma mark:- Api Method

-(void)scrollData_kitty {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    
    NSString *loginRequest=[NSString stringWithFormat:@"ktid=%@",self.strId];
    NSLog(@"response  %@",loginRequest);
    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",[WEB_URL URL_GET_Kittran]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
      {
        [[BusyIndicator sharedInstance]stopIndicator];
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
                    self->arraytblListData = [pDict objectForKey:@"kttranlist"];
                    if ([self->arraytblListData count] > 0){
                        
                        CGFloat totalAmount = 0;
                        CGFloat totalWt = 0;
                        double totalPositive = 0.0;
                        double totalNegative = 0.0;

                        for (NSDictionary *item in self->arraytblListData) {
                            CGFloat amount = [item[@"amount"] floatValue];
                            CGFloat wtValue = [item[@"bhavwt"] floatValue];
                            totalAmount += amount;
                            totalWt += wtValue;
                            /*
                            double value = amount.doubleValue;
                                if (value >= 0) {
                                    totalPositive += value;
                                } else {
                                    totalNegative += value;
                                }
                            */
                        }
                        NSLog(@"TTotal : %.2ld Cr", (long)totalAmount);
                        NSLog(@"TTotal Wt : %.2ld Cr", (long)totalWt);
                        if (totalAmount < 0.00){
                            self.lblTotal.text = [NSString stringWithFormat:@"Total : %.2ld Cr", (long)totalAmount];
                        }else{
                            self.lblTotal.text = [NSString stringWithFormat:@"Total : %.2ld Dr", (long)totalAmount];
                        }
                        self.lblWt.text = [NSString stringWithFormat:@"Wt. : %.3f", totalWt];
                    }else{
                        self.lblTotal.text = @"Total : 0.0 Cr";
                        self.lblWt.text = @"Wt : 0.0";
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
                    [self.tableView reloadData];
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

-(void)todayRateApi{
    NSString *stampid = [_selectData valueForKey:@"stampid"];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    
    NSString *loginRequest=[NSString stringWithFormat:@"stampid=%@",stampid];
    NSLog(@"response  %@",loginRequest);
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@"%@",[WEB_URL URL_CHECK_TODAYRATE]];
    NSURL *url = [NSURL URLWithString:api];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        [[BusyIndicator sharedInstance]stopIndicator];
        if ([data length] >0 && error == nil){
            [[BusyIndicator sharedInstance]stopIndicator];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parse_today:data];
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
- (void)parse_today:(NSData *) data {
    NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"JSON data = %@", myData);
    NSError *error = nil;
    NSDictionary *responseData = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingAllowFragments
                                  error:&error];
    NSMutableArray* arrayResponse_msg = [responseData objectForKey:@"message"];
    NSString *str_msg = [arrayResponse_msg description];
    NSMutableArray* array_status = [responseData objectForKey:@"success"];
    NSString * str_status = [array_status description];
    NSString *ktype = [_selectData valueForKey:@"ktype"];
    if ([str_status isEqualToString:@"0"] && ![ktype isEqualToString:@"5"]) {
        [self  alertMsg: str_msg];
    } else {
        NSMutableArray* array_rate = [responseData objectForKey:@"rate"];
        NSString * str_rate = [array_rate description];
        [self setUpPayView: str_rate];
    }
}

#pragma mark:- Cash payment Api Method

- (void)payApiWithBhr:(NSString *)bhavrate
                   bhw:(NSString *)bhavwt
                  amt:(NSString *)amount
                status:(NSString *)strStatus {
    [[BusyIndicator sharedInstance]stopIndicator];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    NSString *userMobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *kittyip = [defaults stringForKey:@"kittyip"];
    NSString *kittyuser = [defaults stringForKey:@"kittyuser"];
    NSString *kittypswd = [defaults stringForKey:@"kittypswd"];
    NSString *kittydb = [defaults stringForKey:@"kittydb"];
    NSString *ECAT_TYPE = [defaults stringForKey:@"ECAT_TYPE"];
    
    NSString *kmno = [self.selectData valueForKey:@"kmno"];
    NSString *stampid = [self.selectData valueForKey:@"stampid"];
    
    strAmount = amount;
    strBhavRate = bhavrate;
    strBhavWt = bhavwt;
    
    NSString *postString = [NSString stringWithFormat:
        @"stampid=%@&ktid=%@&kmno=%@&bhavrate=%@&amount=%@&bhavwt=%@&mobile=%@&ECAT_TYPE=%@&kittyip=%@&kittyuser=%@&kittypswd=%@&kittydb=%@&status=%@",
        stampid, self.strId, kmno, bhavrate, amount, bhavwt, userMobile,
        ECAT_TYPE, kittyip, kittyuser, kittypswd, kittydb, strStatus];

    NSString *api = [NSString stringWithFormat:@"%@",[WEB_URL URL_GET_KittyPaymentMode]];

    NSURL *url = [NSURL URLWithString:api]; // replace with real endpoint
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
        dataTaskWithRequest:request
          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [[BusyIndicator sharedInstance]stopIndicator];
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

        NSString *successStr = responseDict[@"success"];
        NSString *message = responseDict[@"message"];
        NSInteger success = [successStr integerValue];
        [[BusyIndicator sharedInstance]stopIndicator];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            //[self presentViewController:alert animated:YES completion:nil];
            if (success == 1) {
                [self scrollData_kitty];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if ([self->orderID isKindOfClass:[NSString class]] || self->orderID.length != 0) {
//                        if ([amount intValue] > 0) {
//                            //[self payWithRazorPay: self->orderID amount: amount];
//                        }
//                    }
//                });
            }else{
                [self presentViewController:alert animated:YES completion:nil];
            }
        });
    }];

    [task resume];
}

#pragma mark:- Online payment Api Method

- (void)insterPaymentWithRate:(NSString *)rate
                       weight:(NSString *)weight
                       amount:(NSString *)amount {
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *userMobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *kmno = [self.selectData valueForKey:@"kmno"];
    NSString *stampid = [self.selectData valueForKey:@"stampid"];
    
    strAmount = amount;
    strBhavRate = rate;
    strBhavWt = weight;
    
//    UIAlertController *loadingAlert = [UIAlertController alertControllerWithTitle:nil message:@"Loading..." preferredStyle:UIAlertControllerStyleAlert];
//    [self presentViewController:loadingAlert animated:YES completion:nil];

    NSString *postString = [NSString stringWithFormat:@"stampid=%@&ktid=%@&kmno=%@&bhavrate=%@&amount=%@&bhavwt=%@&mobile=%@",stampid, self.strId, kmno, rate, amount, weight, userMobile];
    
    NSLog(@"InsertPayment Params: %@", postString);
    
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    // Configure request
    NSURL *url = [NSURL URLWithString:[WEB_URL URL_GET_KittyInsertPayment]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
        dataTaskWithRequest:request
          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [[BusyIndicator sharedInstance]stopIndicator];
        dispatch_async(dispatch_get_main_queue(), ^{
            //[loadingAlert dismissViewControllerAnimated:YES completion:nil];
        });
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        [[BusyIndicator sharedInstance]stopIndicator];
        NSError *jsonError;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        self->orderID = [responseDict[@"orderid"] stringValue];
        if (!jsonError && [responseDict[@"success"] isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self->orderID isKindOfClass:[NSString class]] || self->orderID.length != 0) {
                    [self createOrderID:amount orderId: self->orderID];
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
    [[BusyIndicator sharedInstance]startIndicator];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loginid    = [defaults stringForKey:@"loginid"];
    NSString *userMobile = [defaults stringForKey:@"mobile"];
    NSString *userName   = [defaults stringForKey:@"username"];
    NSString *ECAT_TYPE  = [defaults stringForKey:@"ECAT_TYPE"];
    
    NSString *postString = [NSString stringWithFormat: @"loginid=%@&loginid01=%@&mobile=%@&cname=%@&catid=%@&ktid=%@&amount=%@&bhavrate=%@&method=%@&status=%@&txnid=%@&orderid=%@",loginid, loginid, userMobile, userName, ECAT_TYPE, self.strId, self->strAmount, self->strBhavRate, @"ONLINE", strStatus, payment_Id, self->orderID];
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
        [[BusyIndicator sharedInstance]stopIndicator];
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

-(void)payWithRazorPay:(NSString *)orderId amount:(int )amountInPaise{
    //[self.razorpay clearUserData];
    //[[BusyIndicator sharedInstance]stopIndicator];
    NSString *userMobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userName = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
    //Demo orderId = @"order_DBJOWzybf0sJbb"-
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (!appName) {
        appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    }
//    NSDecimalNumber *decimalRupees = [NSDecimalNumber decimalNumberWithString:strAmount];
//    NSInteger paise = 100;
//    if (![decimalRupees isEqualToNumber:[NSDecimalNumber notANumber]]) {
//        NSDecimalNumber *decimalPaise = [decimalRupees decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
//        // Optionally convert to integer (if needed)
//        paise = [decimalPaise integerValue];
//        NSLog(@"Paise (as NSDecimalNumber): %@", decimalPaise);
//        NSLog(@"Paise (as NSInteger): %ld", (long)paise);
//    } else {
//        NSLog(@"Invalid rupee amount string.");
//    }
    
    NSDictionary *options = @{
            @"amount": @((long)amountInPaise),
            @"currency": @"INR",
            @"description": @"Kitty Installment",
            //@"image": @"https://your-logo-url.com/logo.png",
            @"name": appName,
            @"orderId": orderId,
            @"prefill": @{
                    @"contact": userMobile,
                    @"username": userName,
                    @"email": @"test@example.com"
            },
            @"theme": @{
                    @"color": @"#330557"
            }
        };
    NSLog(@"Payment Param = %@", options);
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
