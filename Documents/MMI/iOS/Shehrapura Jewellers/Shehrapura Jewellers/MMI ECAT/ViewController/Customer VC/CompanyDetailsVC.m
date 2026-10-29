//
//  CompanyDetailsVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 09/06/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "CompanyDetailsVC.h"
#import "SWRevealViewController.h"

@interface CompanyDetailsVC()
{
    NSDictionary *dicCompanyDetails;
}
@end

@implementation CompanyDetailsVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Company Config";
    if (self.isOpenFromHome == false){
        [self setUpNavigationBtn];
    }
    if (_isSideMenu){
        [self setUpLeftMenuBtn];
    }
    [self GET_COMPANYDETAIL];
}

#pragma mark:- Set Up Navigation and Action Method

-(void)setUpNavigationBtn{
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    if ([ECAT_TYPE isEqualToString:@"3"]){
        
    }else{
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

- (BOOL)areTextFieldsNotEmpty:(NSArray<UITextField *> *)textFields {
    for (UITextField *textField in textFields) {
        if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
            return NO;
        }
    }
    return YES;
}

#pragma mark:- Set Up View Method

-(void)setUpDetailsView{
    self.txtName.text = [dicCompanyDetails valueForKey:@"comname"];
    self.txtEmail.text = [dicCompanyDetails valueForKey:@"email"];
    self.txtMobile.text = [dicCompanyDetails valueForKey:@"mobile"];
    self.txtGstNo.text = [dicCompanyDetails valueForKey:@"gst_no"];
    self.txtAddress.text = [dicCompanyDetails valueForKey:@"address"];
}


-(IBAction)saveButtonAction:(id)sender{
    NSArray *fieldsToCheck = @[self.txtName, self.txtAddress, self.txtMobile, self.txtEmail, self.txtGstNo];

    if ([self areTextFieldsNotEmpty:fieldsToCheck]) {
        // All text fields have input
        [self saveCompanyDetails];
    } else {
        // At least one is empty
        [self showAlertWithTitle:@"Alert" andMessage:@"Please Enter required field"];
    }
}

- (void)saveCompanyDetails{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance] startIndicator];
    
    NSString *name = self.txtName.text;
    NSString *address = self.txtName.text;
    NSString *mobile = self.txtName.text;
    NSString *emailId = self.txtName.text;
    NSString *gstNo = self.txtName.text;
    
    NSString *api = [NSString stringWithFormat:@"%@", [WEB_URL URL_SAVE_COMPANY]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
   
    NSString *loginRequest = [NSString stringWithFormat:@"apptype=3&comname=%@&address=%@&mobile=%@&email=%@&gst_no=%@",
                              name, address, mobile, emailId, gstNo];

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
        
        if (jsonObject && !error)
        {
            NSLog(@"jsonObject Successfully  = %@", jsonObject);
            NSDictionary *pDict = (NSDictionary *)jsonObject;
            NSString *str_success = [[pDict objectForKey:@"success"] description];
            NSString *str_msg = [[pDict objectForKey:@"message"] description];
            if ([str_success isEqualToString:@"1"]){
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self showAlertWithTitle:@"Failed" andMessage:str_msg];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception.reason);
    }
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)GET_COMPANYDETAIL {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    
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
        
        loginRequest=[NSString stringWithFormat:@"ip=%@&ipusername=%@&password=%@&dbname=%@&ftppath=%@&apptype=%@&ECAT_TYPE_NEW=%@&mobile=%@",ip,ipusername,pswd,db,ftppath,apptype,ECAT_TYPE,mobile];
        
        URL_API =[WEB_URL URL_COMPANY_DETAIL];
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_company_details.php",ip];
        loginRequest = [NSString stringWithFormat:@"ip=%@&ftppath=%@&apptype=%@&ECAT_TYPE_NEW=%@&mobile=%@",ip,ftppath,apptype,ECAT_TYPE,mobile];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@",apptype,mobile];
        URL_API = [WEB_URL URL_COMPANY_DETAIL];
    }
    
    NSString *api = [NSString stringWithFormat: @"%@", URL_API];
    NSURL *url = [NSURL URLWithString:api];
    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseLogin_comp:data];
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


- (void)parseLogin_comp:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data companydetail = %@", myData);
        NSError *error = nil;
        [[BusyIndicator sharedInstance]stopIndicator];
        
        //parsing the JSON response
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
            
//            NSMutableArray *ns_smacno = [pDict objectForKey:@"smacno"];
//            NSString *smacno = [ns_smacno description];
//            NSMutableArray *ns_count = [pDict objectForKey:@"count"];
//            NSString *count = [ns_count description];
//            
//            [[NSUserDefaults standardUserDefaults] setObject:smacno forKey:@"smacno"];
//            [[NSUserDefaults standardUserDefaults] setObject:count forKey:@"count"];
            
            dicCompanyDetails = pDict;
            //NSLog(@"%@", dicCompanyDetails);
            [self setUpDetailsView];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

@end
