//
//  CustomerVisitApplyDataVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 26/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "CustomerVisitApplyDataVC.h"

@interface CustomerVisitApplyDataVC()
@end

@implementation CustomerVisitApplyDataVC

- (instancetype)init {
    self = [super initWithNibName:@"CustomerVisitApplyDataVC" bundle:nil];
    if (self) {
        // Any additional setup
    }
    return self;
}

#pragma mark: Class Method

- (void)viewDidLoad{
    [super viewDidLoad];
    // Add target to textField for editingChanged event
    [self.txtLbr addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    selectedItemListData = [[NSMutableArray alloc] init];
    if (_dicData != nil && _dicData.count > 0) {
        [self setData];
    }
    NSArray *stampListPickerData = @[@"ALL", @"14K", @"16K", @"18K", @"20K", @"22K", @"23K", @"24K"];
    [self.txtStamp addPickerWithData:stampListPickerData searchEnabled:NO];
    NSArray *lbrOnPickerData = @[@"Gr.Wt", @"N. Wt", @"PC", @"Rs"];
    [self.txtLbrOn addPickerWithData:lbrOnPickerData searchEnabled:NO];
    [self getItemListDataApi];
}

-(void)setData{
    self.txtItem.text = [NSString stringWithFormat:@"%@", [_dicData valueForKey:@"idesc"]];
    self.txtStamp.text = [NSString stringWithFormat:@"%@", [_dicData valueForKey:@"stamp"]];
    self.txtTunch.text = [NSString stringWithFormat:@"%@", [_dicData valueForKey:@"tunch"]];
    self.txtWstg.text = [NSString stringWithFormat:@"%@", [_dicData valueForKey:@"wstg"]];
    self.txtLbr.text = [NSString stringWithFormat:@"%@", [_dicData valueForKey:@"lbr"]];
    self.txtQuantiy.text = [NSString stringWithFormat:@"%@", [_dicData valueForKey:@"item_qty"]];
    self.txtAmount.text = [NSString stringWithFormat:@"%@", [_dicData valueForKey:@"salemrp"]];
    [self set_Fine];
}

- (void)textFieldDidChange:(UITextField *)textField {
    // Get the text from the textField and update the label
    NSString *text = textField.text;
    
    // Example: Display the text in the label (or convert to a float or any other transformation)
    self.txtAmount.text = text;//[NSString stringWithFormat:@"You typed: %@", text];
    if (textField == self.txtLbr) {
        [self set_Fine];
        [self setAmountValue];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)set_Fine {
    double d_wstg = 0.0, d_nwt = 0.0, d_tunch = 0.0;
    if (![self.txtWstg.text isEqualToString:@""]) {
        d_wstg = [self.txtWstg.text doubleValue];
    }
    if (![self.txtTunch.text isEqualToString:@""]) {
        d_tunch = [self.txtTunch.text doubleValue];
    }
    if (![self.txtLbr.text isEqualToString:@""]) {
        d_nwt = [self.txtLbr.text doubleValue];
    }
    double d_fine = ((d_wstg + d_tunch) * d_nwt) / 100;
    self.txtFine.text = [NSString stringWithFormat:@"%f", d_fine];
}


-(void)setAmountValue{
    float totalValue = 0.0;
    float lbrValue = 0.0;
    if (![self.txtLbr.text isEqualToString:@""]) {
        lbrValue = [self.txtLbr.text floatValue];
    }
    if ([self.txtLbrOn.text isEqualToString:@"Gr.Wt"]) {
        float wstgValue = [self.txtWstg.text floatValue];
        totalValue = (lbrValue * wstgValue);
    }else if ([self.txtLbrOn.text isEqualToString:@"N.Wt"]) {
        float tunchValue = [self.txtTunch.text floatValue];
        totalValue = (lbrValue * tunchValue);
    }else{
        totalValue = lbrValue;
    }
    self.txtAmount.text = [NSString stringWithFormat:@"%.2ld", (long)totalValue];
}

#pragma mark: Button Action Method

-(IBAction)okButtonAction:(id)sender{
    if ([self.txtItem.text isEqualToString:@""]){
        [self alertMsg:@"Please Select Item"];
    }else if ([self.txtStamp.text isEqualToString:@""]){
        [self alertMsg:@"Please Select Stemp"];
//    }else if ([self.txtTunch.text isEqualToString:@""]){
//        [self alertMsg:@"Please Select Tunch"];
//    }else if ([self.txtWstg.text isEqualToString:@""]){
//        [self alertMsg:@"Please Select WSTG"];
    }else if ([self.txtLbr.text isEqualToString:@""]){
        [self alertMsg:@"Please Select LBR"];
    }else if (![self.txtAmount.text isEqualToString:@""]){
        //[self setAmountValue];
        //[self saveDataApi];
        [self saveDataApiMethod];
    }
    return;
    if (![self.txtAmount.text isEqualToString:@""]){
        if (self.completionHandler) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            // Add a string
            [dict setObject:self.txtItem.text forKey:@"item"];
            [dict setObject:self.txtStamp.text forKey:@"stamp"];
            [dict setObject:self.txtTunch.text forKey:@"tunch"];
            [dict setObject:self.txtWstg.text forKey:@"wstg"];
            [dict setObject:self.txtLbr.text forKey:@"lbr"];
            [dict setObject:self.txtLbrOn.text forKey:@"lbrOn"];
            [dict setObject:self.txtFine.text forKey:@"fine"];
            [dict setObject:self.txtAmount.text forKey:@"amount"];
            self.completionHandler(dict);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(IBAction)cancelButtonAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark: - Api Methods

-(void)getItemListDataApi{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *apptype = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE_NEW"];
    NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
    NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
    NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
    NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
    NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];

    NSDictionary *params = @{
        @"apptype": apptype,
        @"ECAT_TYPE_NEW": ECAT_TYPE_NEW,
        @"ip": ip,
        @"ipusername": ipusername,
        @"password": pswd,
        @"dbname": db,
        @"ftppath": ftppath,
    };
    NSLog(@"params: %@", params);
    
    [[APIManager sharedManager] GET: [WEB_URL URL_GET_All_IDESC]
                         parameters: params
                         completion:^(NSDictionary *data, NSError *error) {
        if (!error) {
            NSLog(@"Item List Data Response: %@", data);
            NSArray *pickerData = [data mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.txtItem addPickerWithData:pickerData searchEnabled:NO];
            });
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [[BusyIndicator sharedInstance]stopIndicator];
    }];
}

-(void)saveDataApi{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *apptype = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
    NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
    NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
    NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
    NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *strLbronValue = @"Rs";
    if(![self.txtLbrOn.text isEqualToString:@""]){
        strLbronValue = self.txtLbrOn.text;
    }
//    if ([apptype isEqualToString:@"1"]){
//        NSDictionary *params = @{
//            @"apptype": apptype,
//            @"ip": ip,
//            @"ipusername": ipusername,
//            @"password": pswd,
//            @"dbname": db,
//            @"ftppath": ftppath,
//        };
//    }
    NSDictionary *params = @{
        @"apptype": apptype,
        @"ip": ip,
        @"ipusername": ipusername,
        @"password": pswd,
        @"dbname": db,
        @"ftppath": ftppath,
        @"mobile":mobile,
        @"visid" : self.str_visid,
        @"idesc" : self.txtItem.text,
        @"stamp": self.txtStamp.text,
        @"tunch" : self.txtTunch.text,
        @"wstg" : self.txtWstg.text,
        @"lbr" : self.txtLbr.text,
        @"lbron" : strLbronValue,
        @"fine1" : @"3",//self.txtFine.text,
        @"t_amt" :@"10.0", //self.txtAmount.text,
    };
    NSLog(@"params: %@", params);
    
    [[APIManager sharedManager] GET: [WEB_URL URL_UPDATE_CARTTUNCH]
                         parameters: params
                         completion:^(NSDictionary *data, NSError *error) {
        if (!error) {
            NSLog(@"Data Response: %@", data);
            NSString *success = data[@"success"];
            NSLog(@"Data success Response: %@", success);
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [[BusyIndicator sharedInstance]stopIndicator];
    }];
}

-(void)saveDataApiMethod{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    
    NSString *strItem = self.txtItem.text;
    NSString *strStemp = self.txtStamp.text;
    NSString *strTuch = self.txtTunch.text;
    NSString *strWstg = self.txtWstg.text;
    NSString *strLbrOn = self.txtLbrOn.text;
    NSString *strLbr = self.txtLbr.text;
    NSString *strFine = self.txtFine.text.length > 0 ? self.txtFine.text : @"0";
    NSString *strAmount = self.txtAmount.text;
    NSString *strLbronValue = @"Rs";
    if(![self.txtLbrOn.text isEqualToString:@""]){
        strLbronValue = self.txtLbrOn.text;
    }

    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];

        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@&visid=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&idesc=%@&stamp=%@&tunch=%@&wstg=%@&lbr=%@&lbron=%@&fine1=%@&t_amt=%@",apptype,mobile,self.str_visid,ip,db,ipusername,pswd,ftppath,strItem,strStemp,strTuch,strWstg,strLbronValue,strLbr,strFine,strAmount];

        URL_API = [WEB_URL URL_UPDATE_CARTTUNCH];
 
    }else{
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@&visid=%@&idesc=%@&stamp=%@&tunch=%@&wstg=%@&lbr=%@&lbron=%@&fine1=%@&t_amt=%@",apptype,mobile,self.str_visid,strItem,strStemp,strTuch,strWstg,strLbrOn,strLbr,strFine,strAmount];
        
        //loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@&visid=%@",apptype,mobile,self.str_visid];
        
        URL_API = [WEB_URL URL_UPDATE_CARTTUNCH];
    }

    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    
    NSLog(@"param : %@", urlString);
    NSLog(@"API URL : %@", api);
    
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
                //[self parseResponse_Save:data];
                
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"JSON data = %@", json);
                NSString *success = json[@"success"];
                NSLog(@"Data success Response: %@", success);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([success isEqualToString:@"1"]){
                        if (self.completionHandler) {
                            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                            // Add a string in dic
                            [dict setObject:self.txtItem.text forKey:@"item"];
                            [dict setObject:self.txtStamp.text forKey:@"stamp"];
                            [dict setObject:self.txtTunch.text forKey:@"tunch"];
                            [dict setObject:self.txtWstg.text forKey:@"wstg"];
                            [dict setObject:self.txtLbr.text forKey:@"lbr"];
                            [dict setObject:self.txtLbrOn.text forKey:@"lbrOn"];
                            [dict setObject:self.txtFine.text forKey:@"fine"];
                            [dict setObject:self.txtAmount.text forKey:@"amount"];
                            self.completionHandler(dict);
                        }
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                });
                [[BusyIndicator sharedInstance]stopIndicator];
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


@end
