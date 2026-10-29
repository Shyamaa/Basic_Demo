//
//  ConfirmPin.m
//  MMI ECAT
//
//  Created by mmsoft116 on 04/09/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "ConfirmPin.h"
#import "Gautom_HomeVC.h"
#import "MainActivity.h"
#import "MCX_RATE.h"


@interface ConfirmPin ()
{
    NSString *str_type;
}
@end

@implementation ConfirmPin
@synthesize str_mobile,str_swid,str_regmobile,countrycode;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    webUrlconstant *classA = [webUrlconstant sharedInstance];
    str_type = [classA APPTYPE];
    
    [txt_otp.layer setMasksToBounds:YES];
    [txt_otp.layer setCornerRadius:10.0f];
    [txt_otp.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [txt_otp.layer setBorderWidth:1];
    
    [btn_confirm.layer setMasksToBounds:YES];
    [btn_confirm.layer setCornerRadius:10.0f];
    [btn_confirm.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [btn_confirm.layer setBorderWidth:1];

    lbl_mobile.text = [NSString stringWithString:str_mobile];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == txt_otp) {
        [txt_otp resignFirstResponder];
    }  else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction)btn_confirm:(id)sender {
   
    if (txt_otp.text.length ==0){
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                      message:@"Please Enter OTP"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
        {
            NSLog(@"you pressed Yes, please button");
        }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        if ([str_type isEqualToString:@"3"]) {
            [self performSelectorOnMainThread:@selector(CHECK_LOGIN) withObject:nil waitUntilDone:NO];
        }else{
            if([str_swid isEqualToString:@"SQLECAT"] || [str_swid isEqualToString:@"SQLQR"]){
                [self Register_Demo];
            }else {
                [self CHECK_SWID];
            }
        }
    }
    
}

-(void)CHECK_LOGIN {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *ios_deviceid=[[NSUserDefaults standardUserDefaults] objectForKey:@"devicetoken"];
//    NSLog(@"devicetoken == %@",ios_deviceid);
    NSString *otp=txt_otp.text;
    NSString *loginRequest=[NSString stringWithFormat:@"mobile=%@&pin=%@&ios_deviceid=%@",str_mobile,otp,ios_deviceid];
    //    NSLog(@"response  %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@"%@",[WEB_URL URL_CONFIRM_PIN]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseLogin_Api:data];
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


- (void)parseLogin_Api:(NSData *) data {
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
            
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            
            NSMutableArray *arrayResponse_success = [pDict objectForKey:@"success"];
            NSString *str_success = [arrayResponse_success description];
            NSMutableArray*nsarray_msg = [pDict objectForKey:@"message"];
            NSString *str_msg = [nsarray_msg description];
            
            if ([str_success isEqualToString:@"1"]) {
                
                NSString *ECAT_TYPE=@"3";
                [[NSUserDefaults standardUserDefaults] setObject:ECAT_TYPE forKey:@"ECAT_TYPE"];
                [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"ECAT_TYPE_NEW"];
                
                NSMutableArray*nsarray_loginid = [pDict objectForKey:@"loginid"];
                NSString *str_loginid = [nsarray_loginid description];
                
                NSMutableArray*nsarray_username = [pDict objectForKey:@"username"];
                NSString *str_username = [nsarray_username description];
                
                NSMutableArray*nsarray_mobile = [pDict objectForKey:@"mobile"];
                NSString *str_mobile = [nsarray_mobile description];
                
                NSMutableArray*nsarray_category = [pDict objectForKey:@"category"];
                NSString *str_category = [nsarray_category description];
                
                NSMutableArray*nsarray_address = [pDict objectForKey:@"address"];
                NSString *address = [nsarray_address description];
                NSMutableArray *nsTemplate = [pDict objectForKey:@"template"];
                NSString *strTemplate = [nsTemplate description];
                
                [[NSUserDefaults standardUserDefaults] setObject:str_loginid forKey:@"loginid"];
                [[NSUserDefaults standardUserDefaults] setObject:str_username forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:str_mobile forKey:@"mobile"];
                [[NSUserDefaults standardUserDefaults] setObject:str_category forKey:@"category"];
                [[NSUserDefaults standardUserDefaults] setObject:address forKey:@"address"];
                [[NSUserDefaults standardUserDefaults] setObject:strTemplate forKey:@"template"];

                webUrlconstant *classA = [webUrlconstant sharedInstance];
                NSString *str_mcxrate = [classA APPTYPE_MCX];

                if([str_mcxrate isEqualToString:@"1"]){
                    MCX_RATE *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"MCX_RATE"];
                    [self.navigationController pushViewController:obj animated:YES];
                }else if([strTemplate isEqualToString:@"2"]){
                    Gautom_HomeVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Gautom_HomeVC"];
                    [self.navigationController pushViewController:obj animated:YES];
                }else{
                    MainActivity *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"MainActivity"];
                    [self.navigationController pushViewController:obj animated:YES];
                }
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

-(void)CHECK_SWID {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *otp=txt_otp.text;
    NSString *comtype=@"4";
    NSString* deviceid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    

    NSString *loginRequest=[NSString stringWithFormat:@"mobile=%@&otp=%@&deviceid=%@&comtype=%@&softid=%@",str_mobile,otp,deviceid,comtype,str_swid];
    NSLog(@"response  %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@"%@",[WEB_URL URL_CONFIRM_PIN_SWID]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseLogin_SWID:data];
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


- (void)parseLogin_SWID:(NSData *) data {
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
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            NSMutableArray *nsarray_data1 = [pDict objectForKey:@"register"];
            for (int i = 0; i < [nsarray_data1 count]; i++) {
                
                NSDictionary * dictObject = [nsarray_data1 objectAtIndex:i];
                NSString *str_msg = [dictObject objectForKey:@"msg"];
                
                if ([str_msg isEqualToString:@"OTP is confirmed!"]) {
                    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

                    NSString *str_ip = [dictObject objectForKey:@"ip"];
                    NSString *str_db = [dictObject objectForKey:@"db"];
                    NSString *str_username = [dictObject objectForKey:@"username"];
                    NSString *str_pswd = [dictObject objectForKey:@"pswd"];
                    NSString *str_version = [dictObject objectForKey:@"version"];
                    NSString *str_ftppath = [dictObject objectForKey:@"ftppath"];
                    NSString *str_servertype = [dictObject objectForKey:@"servertype"];
//                     NSString *str_ftpuser = [dictObject objectForKey:@"ftpuser"];
//                     NSString *str_ftppass = [dictObject objectForKey:@"ftppass"];
                    if ([str_version isEqualToString:@"01"]) {
                        NSString *ECAT_TYPE=[WEB_URL APPTYPE];
                        [[NSUserDefaults standardUserDefaults] setObject:ECAT_TYPE forKey:@"ECAT_TYPE"];
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"ECAT_TYPE_NEW"];
                    }else if ([str_version isEqualToString:@"02"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"ECAT_TYPE"];
                        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"ECAT_TYPE_NEW"];
                    }else if ([str_version isEqualToString:@"04"]) {
                        NSString *ECAT_TYPE=[WEB_URL APPTYPE];
                        [[NSUserDefaults standardUserDefaults] setObject:ECAT_TYPE forKey:@"ECAT_TYPE"];
                        [[NSUserDefaults standardUserDefaults] setObject:@"4" forKey:@"ECAT_TYPE_NEW"];
                    }else{
                        NSString *ECAT_TYPE=[WEB_URL APPTYPE];
                        [[NSUserDefaults standardUserDefaults] setObject:ECAT_TYPE forKey:@"ECAT_TYPE"];
                        [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"ECAT_TYPE_NEW"];
                    }
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userid"];
                    [[NSUserDefaults standardUserDefaults] setObject:str_mobile forKey:@"mobile"];
                    [[NSUserDefaults standardUserDefaults] setObject:str_ip forKey:@"ip"];
                    [[NSUserDefaults standardUserDefaults] setObject:str_db forKey:@"db"];
                    [[NSUserDefaults standardUserDefaults] setObject:str_username forKey:@"ipusername"];
                    [[NSUserDefaults standardUserDefaults] setObject:str_pswd forKey:@"pswd"];
                    [[NSUserDefaults standardUserDefaults] setObject:str_ftppath forKey:@"ftppath"];
                    [[NSUserDefaults standardUserDefaults] setObject:str_swid forKey:@"softid"];
                    [[NSUserDefaults standardUserDefaults] setObject:str_regmobile forKey:@"regmobile"];
                    [[NSUserDefaults standardUserDefaults] setObject:str_servertype forKey:@"servertype"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ftpuser"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ftppass"];
                  
                    if (str_ip.length == 0) {
                        ConfigVC *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"ConfigVC"];
                        [self.navigationController pushViewController:obj animated:YES];
                    } else {
                        MMIHOMEPanel *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"MMIHOMEPanel"];
                        [self.navigationController pushViewController:obj animated:YES];
                    }
                }else{
                    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message" message:str_msg preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                                {}];
                    [alert addAction:yesButton];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}


-(void)Register_Demo {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *otp=txt_otp.text;
    NSString *comtype=@"4";
    NSString* deviceid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    

    NSString *loginRequest=[NSString stringWithFormat:@"mobile=%@&otp=%@&deviceid=%@&comtype=%@&softid=%@",str_mobile,otp,deviceid,comtype,str_swid];
    NSLog(@"response  %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@"%@",[WEB_URL URL_REGISTER_CONFIRM_DEMO]];
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
                [self parseLogin_Register_Demo:data];
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


- (void)parseLogin_Register_Demo:(NSData *) data {
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
            
            NSMutableArray *nsarray_data1 = [pDict objectForKey:@"register"];
            for (int i = 0; i < [nsarray_data1 count]; i++)
            {
                NSDictionary * dictObject = [nsarray_data1 objectAtIndex:i];
                NSString *str_msg = [dictObject objectForKey:@"msg"];
                
                if ([str_msg isEqualToString:@"OTP is confirmed!"]) {
                    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

                    NSString *str_ip = [dictObject objectForKey:@"ip"];
                    NSString *str_db = [dictObject objectForKey:@"db"];
                    NSString *str_username = [dictObject objectForKey:@"username"];
                    NSString *str_pswd = [dictObject objectForKey:@"pswd"];
                    NSString *str_version = [dictObject objectForKey:@"version"];
                    NSString *str_ftppath = [dictObject objectForKey:@"ftppath"];
                    NSString *str_servertype = [dictObject objectForKey:@"servertype"];
//                    NSString *str_ftpuser = [dictObject objectForKey:@"ftpuser"];
//                    NSString *str_ftppass = [dictObject objectForKey:@"ftppass"];
                    if ([str_version isEqualToString:@"01"]) {
                        NSString *ECAT_TYPE=[WEB_URL APPTYPE];
                        [[NSUserDefaults standardUserDefaults] setObject:ECAT_TYPE forKey:@"ECAT_TYPE"];
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"ECAT_TYPE_NEW"];
                    }else if ([str_version isEqualToString:@"02"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"ECAT_TYPE"];
                        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"ECAT_TYPE_NEW"];
                    }else if ([str_version isEqualToString:@"04"]) {
                        NSString *ECAT_TYPE=[WEB_URL APPTYPE];
                        [[NSUserDefaults standardUserDefaults] setObject:ECAT_TYPE forKey:@"ECAT_TYPE"];
                        [[NSUserDefaults standardUserDefaults] setObject:@"4" forKey:@"ECAT_TYPE_NEW"];
                    }else{
                        NSString *ECAT_TYPE=[WEB_URL APPTYPE];
                        [[NSUserDefaults standardUserDefaults] setObject:ECAT_TYPE forKey:@"ECAT_TYPE"];
                        [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"ECAT_TYPE_NEW"];
                    }
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userid"];
                    [[NSUserDefaults standardUserDefaults] setObject:str_mobile forKey:@"mobile"];
                    [[NSUserDefaults standardUserDefaults] setObject:str_ip forKey:@"ip"];
                    [[NSUserDefaults standardUserDefaults] setObject:str_db forKey:@"db"];
                    [[NSUserDefaults standardUserDefaults] setObject:str_username forKey:@"ipusername"];
                    [[NSUserDefaults standardUserDefaults] setObject:str_pswd forKey:@"pswd"];
                    [[NSUserDefaults standardUserDefaults] setObject:str_ftppath forKey:@"ftppath"];
                    [[NSUserDefaults standardUserDefaults] setObject:str_swid forKey:@"softid"];
                    [[NSUserDefaults standardUserDefaults] setObject:str_regmobile forKey:@"regmobile"];
                    [[NSUserDefaults standardUserDefaults] setObject:str_servertype forKey:@"servertype"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ftpuser"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ftppass"];
                  
                    if (str_ip.length == 0) {
                        ConfigVC *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"ConfigVC"];
                        [self.navigationController pushViewController:obj animated:YES];
                    } else {
                        MMIHOMEPanel *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"MMIHOMEPanel"];
                        [self.navigationController pushViewController:obj animated:YES];
                    }
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
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

@end
