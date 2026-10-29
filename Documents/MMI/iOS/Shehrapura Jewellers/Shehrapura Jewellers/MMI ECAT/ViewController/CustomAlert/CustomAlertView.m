//
//  CustomAlertView.m
//  Jewel Desk
//
//  Created by App Dev on 18/01/24.
//  Copyright © 2024 MMI Softwares. All rights reserved.
//

#import "CustomAlertView.h"
#import "webUrlconstant.h"
#import "BusyIndicator.h"

@interface CustomAlertView ()

@end

@implementation CustomAlertView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [txt_mobile addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
}


- (void)textFieldDidChange:(UITextField *)textField {
    
    NSString * mobile = textField.text;
    
    NSLog(@"mobile ::::::::::::::::::::::::::  %@",mobile);
    NSLog(@"length :::::::::::::::: %lu",(unsigned long)mobile.length);
    
    if (mobile.length == 10) {
        [self CallApi:mobile];
    }

}

- (IBAction)btn_save:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Do you want save?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self URL_INSERT_MEMBERS];
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Canelled");
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)btn_unknown:(id)sender {
    
}

- (IBAction)btn_cancel:(id)sender {
    NSString *selectedValue = @"The value you want to pass";
    [self.delegate didSelectValue:selectedValue];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)CallApi:(NSString *)mobile{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    NSError *error;
    if (error) {
        NSLog(@"Error creating JSON data: %@", error.localizedDescription);
        return;
    }
    
    NSString *URL_API;
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        URL_API = [WEB_URL URL_MEMBERS];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_members.php",ip];
    }else{
        URL_API = [WEB_URL URL_MEMBERS];
    }
    
    NSLog(@"URL_MEMBERS :::::::::::::  %@",URL_API);
    NSURL *url = [NSURL URLWithString:URL_API];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"Accept: application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Bearer your_access_token" forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error sending request: %@", error.localizedDescription);
            return;
        }

        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_member:data];
            });
        }
    }];
    
    [task resume];
}


- (void) parseResponse_member:(NSData *) data {
    NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"JSON data = %@", myData);
    NSError *error = nil;

    NSDictionary *responseData = [NSJSONSerialization
                           JSONObjectWithData:data
                           options:NSJSONReadingAllowFragments
                           error:&error];
    
    NSLog(@"Response ::::::::::::::::::::: %@", responseData);
    NSMutableArray * array_loginid = [responseData objectForKey:@"loginid"];
    NSString *loginid = [array_loginid description];
    NSLog(@"loginid: %@", loginid);
}

-(void)URL_INSERT_MEMBERS {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *apptype = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    
    NSString *str_contact = txt_mobile.text;
    NSString *str_pname = txt_partyname.text;
    NSString *str_address = txt_address.text;
    NSString *str_address2 = txt_address2.text;
    NSString *str_address3 = txt_address3.text;
    NSString *str_location = txt_location.text;
    NSString *str_city = txt_city.text;
    NSString *str_email = txt_emailid.text;
    NSString *sm_mobile = txt_mobile2.text;
    
    
    if ([apptype isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];

        loginRequest=[NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&cpphone=%@&mobile=%@&cpemail=%@&cpcity=%@&cpname=%@&cpadd1=%@&cpadd2=%@&cpadd3=%@&cplocation=%@&sm_mobile=%@",apptype,ip,db,ipusername,pswd,ftppath,str_contact,str_contact,str_email,str_city,str_pname,str_address,str_address2,str_address3,str_location,sm_mobile];
        
        URL_API =[WEB_URL URL_INSERT_MEMBERS];
    }else  if ([apptype isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/insert_members.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&ftppath=%@&cpphone=%@&mobile=%@&cpemail=%@&cpcity=%@&cpname=%@&cpadd1=%@&cpadd2=%@&cpadd3=%@&cplocation=%@&sm_mobile=%@",apptype,ftppath,str_contact,str_contact,str_email,str_city,str_pname,str_address,str_address2,str_address3,str_location,sm_mobile];
        
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&cpphone=%@&mobile=%@&cpemail=%@&cpcity=%@&cpname=%@&cpadd1=%@&cpadd2=%@&cpadd3=%@&cplocation=%@&sm_mobile=%@",apptype,str_contact,str_contact,str_email,str_city,str_pname,str_address,str_address2,str_address3,str_location,sm_mobile];
        URL_API =[WEB_URL URL_INSERT_MEMBERS];
    }
    
    NSLog(@"loginRequest :: %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSLog(@"api :: %@",api);

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
                [self parse_Insertmember:data];
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


- (void)parse_Insertmember:(NSData *) data {
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
            
            NSMutableArray *array_message = [pDict objectForKey:@"message"];
            NSString *str_msg = [array_message description];
            
            NSLog(@"str_success ************************ %@",str_success);
           
            
            if ([str_success isEqualToString:@"1"]) 
            {
                NSMutableArray *nsarray_cpid = [pDict objectForKey:@"cpid"];
                NSString * str_cpid = [nsarray_cpid description];
                
                NSMutableArray *nsarray_visid = [pDict objectForKey:@"visid"];
                NSString * visid = [nsarray_visid description];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:str_msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    if (str_cpid.length !=0) {
                        if (self.completionHandler) {
                            self.completionHandler(str_cpid,self->txt_partyname.text, self->txt_mobile.text,visid);
                        }
                       [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
                [alertController addAction:confirmAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }else{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:str_msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alertController addAction:confirmAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}


@end
