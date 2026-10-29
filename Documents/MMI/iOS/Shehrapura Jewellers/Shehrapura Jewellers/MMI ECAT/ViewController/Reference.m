//
//  Reference.m
//  Dia Jewels
//
//  Created by MMI SOFTWARES PVT LTD on 12/11/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "Reference.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "LoginVC.h"
#import "HomeVC.h"
#import "MainActivity.h"

@interface Reference ()

@end

@implementation Reference

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.title =@"References";
    
    [txt_name.layer setMasksToBounds:YES];
    [txt_name.layer setCornerRadius:10.0f];
    [txt_name.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [txt_name.layer setBorderWidth:1];
    
    
    [txt_mobile.layer setMasksToBounds:YES];
    [txt_mobile.layer setCornerRadius:10.0f];
    [txt_mobile.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [txt_mobile.layer setBorderWidth:1];
    
    
    [txt_interestedin.layer setMasksToBounds:YES];
    [txt_interestedin.layer setCornerRadius:10.0f];
    [txt_interestedin.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [txt_interestedin.layer setBorderWidth:1];
    
    [btn_register.layer setMasksToBounds:YES];
    [btn_register.layer setCornerRadius:10.0f];
    [btn_register.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [btn_register.layer setBorderWidth:1];
}


-(void)viewWillAppear:(BOOL)animated
{

    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==txt_name) {
        [txt_mobile becomeFirstResponder];
    } else if (textField==txt_mobile) {
        [textField resignFirstResponder];
    } else{
        [textField resignFirstResponder];
    }
    return YES;
}


- (IBAction)btn_register:(id)sender {
    if (txt_name.text.length ==0){
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                      message:@"Please Enter Name"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        /** What we write here???????? **/
                                        NSLog(@"you pressed Yes, please button");
                                        
                                        // call method whatever u need
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }else if (txt_mobile.text.length ==0){
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                      message:@"Please Enter Mobile"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        NSLog(@"you pressed Yes, please button");
                                        
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        [self performSelectorOnMainThread:@selector(CHECK_REGISTER) withObject:nil waitUntilDone:NO];
    }
    
}

-(void)CHECK_REGISTER {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *byuser = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];

    NSString *username=txt_name.text;
    NSString *mobile=txt_mobile.text;
    NSString *interested=txt_interestedin.text;

     NSString *loginRequest=[NSString stringWithFormat:@"mobile=%@&name=%@&interested=%@&byuser=%@",mobile,username,interested,byuser];
    NSLog(@"response  %@",loginRequest);
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@"%@",[WEB_URL URL_REFERENSE]];
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
                [self parseRegister_Api:data];
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


- (void)parseRegister_Api:(NSData *) data {
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

- (IBAction)btn_login:(id)sender {
    
    LoginVC *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    [self.navigationController pushViewController:obj animated:YES];
}

@end
