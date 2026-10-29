//
//  AgentLogin.m
//  Jwelly Customer
//
//  Created by mmsoft116 on 10/10/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "AgentLogin.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "MainActivity.h"

@interface AgentLogin ()

@end

@implementation AgentLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_login:(id)sender {
    
    if (txt_userid.text.length ==0){
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                      message:@"Please Enter Your Register user id"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        NSLog(@"you pressed Yes, please button");
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }else if (txt_password.text.length ==0){
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                      message:@"Please Enter Your Register password"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        NSLog(@"you pressed Yes, please button");
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }else  {
        [self performSelectorOnMainThread:@selector(CHECK_LOGIN) withObject:nil waitUntilDone:NO];
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==txt_userid) {
        [txt_userid becomeFirstResponder];
    }  else  if (textField==txt_password) {
        [txt_password resignFirstResponder];
    } else{
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)CHECK_LOGIN {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *userid=txt_userid.text;
    NSString *password=txt_password.text;

    NSString *loginRequest=[NSString stringWithFormat:@"userid=%@&userpswd=%@",userid,password];
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@"%@",[WEB_URL URL_AGENT_LOGIN]];

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
            
                NSMutableArray *nsarray_username = [pDict objectForKey:@"username"];
                NSString *str_username = [nsarray_username description];
                
                NSMutableArray *nsarray_loginid = [pDict objectForKey:@"loginid"];
                NSString *str_loginid = [nsarray_loginid description];
                
                NSMutableArray *nsarray_userid = [pDict objectForKey:@"userid"];
                NSString *str_userid = [nsarray_userid description];
                
                NSMutableArray*nsarray_category = [pDict objectForKey:@"category"];
                NSString *str_category = [nsarray_category description];
                
                NSMutableArray *nsarray_mobile = [pDict objectForKey:@"mobile"];
                NSString *str_mobile = [nsarray_mobile description];
                
                
                [[NSUserDefaults standardUserDefaults] setObject:str_loginid forKey:@"loginid"];
                [[NSUserDefaults standardUserDefaults] setObject:str_username forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:str_mobile forKey:@"mobile"];
                [[NSUserDefaults standardUserDefaults] setObject:str_category forKey:@"category"];
                [[NSUserDefaults standardUserDefaults] setObject:str_userid forKey:@"userid"];

                
                MainActivity *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"MainActivity"];
                [self.navigationController pushViewController:obj animated:YES];
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
