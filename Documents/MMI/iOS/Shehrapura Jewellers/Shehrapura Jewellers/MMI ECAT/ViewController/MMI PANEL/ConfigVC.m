//
//  ConfigVC.m
//  Jwelly Customer
//
//  Created by MMI SOFTWARES PVT LTD on 09/11/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "ConfigVC.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "MMIHOMEPanel.h"
#import "SWRevealViewController.h"


@interface ConfigVC ()

@end

@implementation ConfigVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Update DB";
    // Do any additional setup after loading the view.
    [self setUpNavigationLeftBtn];
    [self setUpNavigationRightBtn];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    if ([ECAT_TYPE isEqualToString:@"1"]){
        str_type=@"1";
        [self setUpRadioBtn];
    }else{
        str_type=@"2";
        [self setUpRadioBtn];
    }
    [self GET_CONFIG];
}

-(void)setUpNavigationLeftBtn{
    SWRevealViewController *revealController = [self revealViewController];
    //[revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIImage* image = [UIImage imageNamed:@"menu.png"];
    CGRect frameimg1 = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *someButton1 = [[UIButton alloc] initWithFrame:frameimg1];
    [someButton1 setBackgroundImage:image forState:UIControlStateNormal];
    [someButton1 addTarget:revealController action:@selector(revealToggle:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithCustomView:someButton1];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
}

-(void)setUpNavigationRightBtn{
    UIButton * btn_reload =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_reload.frame = CGRectMake(0,0,30,30);
    [btn_reload setImage:[UIImage systemImageNamed: @"arrow.clockwise"]
                forState:UIControlStateNormal];
    //[[btn_reload imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_reload.tintColor = [UIColor whiteColor];
    [btn_reload addTarget:self action:@selector(btn_save:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barReloadBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_reload];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 4;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: barReloadBtn, nil];
}

-(void)setUpRadioBtn{
    if([str_type isEqualToString: @"1"]){
        UIImage* image = [UIImage imageNamed:@"uncheckcircle.png"];
        [btn_local setImage:image forState:UIControlStateNormal];
        UIImage* image1 = [UIImage imageNamed:@"checkcircle.png"];
        [btn_server setImage:image1 forState:UIControlStateNormal];
    }else if([str_type isEqualToString: @"2"]){
        UIImage* image = [UIImage imageNamed:@"checkcircle.png"];
        [btn_local setImage:image forState:UIControlStateNormal];
        UIImage* image1 = [UIImage imageNamed:@"uncheckcircle.png"];
        [btn_server setImage:image1 forState:UIControlStateNormal];
    }else{
        UIImage* image = [UIImage imageNamed:@"uncheckcircle.png"];
        [btn_local setImage:image forState:UIControlStateNormal];
        UIImage* image1 = [UIImage imageNamed:@"uncheckcircle.png"];
        [btn_server setImage:image1 forState:UIControlStateNormal];
    }
}

- (IBAction)btn_server:(id)sender {
    str_type=@"1";
    [self setUpRadioBtn];
}

- (IBAction)btn_local:(id)sender {
    str_type=@"2";
    [self setUpRadioBtn];
}

- (IBAction)btn_save:(id)sender {
    if (txt_ip.text.length ==0){
        [self alertMsgWithTitle:@"Please Enter ip" title:@"Message"];
    }else if (txt_username.text.length ==0){
        [self alertMsgWithTitle:@"Please Enter username" title:@"Message"];
    }else if (txt_password.text.length ==0){
        [self alertMsgWithTitle:@"Please Enter password" title:@"Message"];
    }else if (txt_database.text.length ==0){
        [self alertMsgWithTitle:@"Please Enter database" title:@"Message"];
    }else{
       [self SAVE_CONFIG];
    }
}

#pragma mark: Api Methods

-(void)SAVE_CONFIG {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *softid = [[NSUserDefaults standardUserDefaults]stringForKey:@"softid"];
    NSString *ftppath=txt_url.text;
    NSString *ip=txt_ip.text;
    NSString *dbname=txt_database.text;
    NSString *password=txt_password.text;
    NSString *username=txt_username.text;
    NSString *server_type=str_type;

    NSString *loginRequest=[NSString stringWithFormat:@"ftppath=%@&softid=%@&ip=%@&dbname=%@&password=%@&username=%@&server_type=%@",ftppath,softid,ip,dbname,password,username,server_type];
    //    NSLog(@"response  %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@"%@",[WEB_URL URL_CONFIG_UPDATE]];
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
                NSString *softid = [[NSUserDefaults standardUserDefaults]stringForKey:@"softid"];

                NSString *ftppath=txt_url.text;
                NSString *ip=txt_ip.text;
                NSString *dbname=txt_database.text;
                NSString *password=txt_password.text;
                NSString *username=txt_username.text;
                
                [[NSUserDefaults standardUserDefaults] setObject:ip forKey:@"ip"];
                [[NSUserDefaults standardUserDefaults] setObject:dbname forKey:@"db"];
                [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"ipusername"];
                [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"pswd"];
                [[NSUserDefaults standardUserDefaults] setObject:softid forKey:@"softid"];
                [[NSUserDefaults standardUserDefaults] setObject:ftppath forKey:@"ftppath"];
                [[NSUserDefaults standardUserDefaults] setObject:str_type forKey:@"ECAT_TYPE"];

                if ([str_type isEqualToString:@"2"]) {
                    [self SAVE_UPDATE_CONFIG];
                }else{
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
    @catch (NSException *exception) {
    }
    @finally {
    }
}


-(void)SAVE_UPDATE_CONFIG {

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *ftppath=txt_url.text;
    NSString *softid = [[NSUserDefaults standardUserDefaults]stringForKey:@"softid"];

    NSString *ip=txt_ip.text;
    NSString *dbname=txt_database.text;
    NSString *password=txt_password.text;
    NSString *username=txt_username.text;
    
    NSString *server_type=str_type;
    NSString * Api_update_config =[NSString stringWithFormat:@"http://%@/jwellyecat/update_config.php",ip];
    NSLog(@"Api_update_config :: %@ ",Api_update_config);
    
    NSString *loginRequest=[NSString stringWithFormat:@"ftppath=%@&softid=%@&ip=%@&dbname=%@&password=%@&username=%@&server_type=%@",ftppath,softid,ip,dbname,password,username,server_type];
    NSLog(@"response :::::::::::::  %@",loginRequest);
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@"%@",Api_update_config];
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
                [self parseLogin_CONFIGApi:data];
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


- (void)parseLogin_CONFIGApi:(NSData *) data {
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
            
            if ([str_success isEqualToString:@"1"])
            {
                MMIHOMEPanel *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"MMIHOMEPanel"];
                [self.navigationController pushViewController:obj animated:YES];
            }else{
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message" message:str_msg preferredStyle:UIAlertControllerStyleAlert];
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





-(void)GET_CONFIG {

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *softid = [[NSUserDefaults standardUserDefaults]stringForKey:@"softid"];
    NSString *loginRequest=[NSString stringWithFormat:@"softid=%@",softid];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@"%@",[WEB_URL URL_GET_DB]];
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
                [self parse_GET_CONFIG:data];
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


- (void)parse_GET_CONFIG:(NSData *) data {
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
               
                NSMutableArray*nsarray_ip = [pDict objectForKey:@"ip"];
                NSString *str_ip = [nsarray_ip description];
                
                NSMutableArray*nsarray_db = [pDict objectForKey:@"db"];
                NSString *str_db = [nsarray_db description];
                
                NSMutableArray*nsarray_username = [pDict objectForKey:@"username"];
                NSString *str_username = [nsarray_username description];
                
                NSMutableArray*nsarray_pswd = [pDict objectForKey:@"pswd"];
                NSString *str_pswd = [nsarray_pswd description];
                
//                NSMutableArray*nsarray_server_type = [pDict objectForKey:@"server_type"];
//                NSString *str_server_type = [nsarray_server_type description];
                
                NSMutableArray*nsarray_ftppath = [pDict objectForKey:@"ftppath"];
                NSString *str_ftppath = [nsarray_ftppath description];
              
                txt_ip.text=str_ip;
                txt_database.text=str_db;
                txt_username.text=str_username;
                txt_password.text=str_pswd;
                txt_url.text=str_ftppath;

            }else{
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                              message:str_msg
                                                                       preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                //                                                NSLog(@"you pressed Yes, please button");
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

@end
