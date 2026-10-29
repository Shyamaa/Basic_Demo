//
//  PaymentActivity.m
//  Jewel Desk
//
//  Created by App Dev on 27/11/23.
//  Copyright © 2023 MMI Softwares. All rights reserved.
//

#import "PaymentActivity.h"

@interface PaymentActivity ()

@end

@implementation PaymentActivity
@synthesize str_amount,str_emailid,str_orderno;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 
    NSString *username = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];

    lbl_name.text = username;
    lbl_mobile.text = mobile;
    lbl_orderno.text = str_amount;
    checked=@"0";
    

    NSString *str_surl =@"http:///sajanjewellersonline.in/apps/jwellyecat/PAYMENT/response.php";
    NSString *str_ky = [NSString stringWithFormat:@"key=EUKQS2ZPQ8&txnid=%@&amount=%@&firstname=%@&email=%@&phone=%@&productinfo=MobileApp&surl=%@&furl=%@",str_orderno,str_amount,username,txt_emailid.text,mobile,str_surl,str_surl];
    NSString *str_url = [NSString stringWithFormat:@"http:///sajanjewellersonline.in/apps/jwellyecat/PAYMENT/easebuzz.php?%@",str_ky];
    NSLog(@"str_url :::::::::::::::::: %@",str_url);

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_paynow:(id)sender {
    
}

- (IBAction)btn_termandcondition:(id)sender {
    
    if ([checked isEqualToString:@"0"])
    {
        checked=@"1";
        
        UIImage* image = [UIImage imageNamed:@"uncheckcircle.png"];
        [btn_term setImage:image forState:UIControlStateNormal];
        
    }else{
        checked=@"0";
        UIImage* image = [UIImage imageNamed:@"checkcircle.png"];
        [btn_term setImage:image forState:UIControlStateNormal];
      
      }
    
}



-(void)PayNowApi {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];

    NSString *loginRequest=[NSString stringWithFormat:@"amount=%@&mobile=%@&emailid=%@&orderId=%@",str_amount,mobile,txt_emailid.text,str_orderno];
    //    NSLog(@"response  %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@"%@",[WEB_URL URL_INSERT_PAY]];
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
                [self parsepay_Api:data];
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


- (void)parsepay_Api:(NSData *) data {
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
//            NSMutableArray *nsarray_msg = [pDict objectForKey:@"message"];
//            NSString *str_msg = [nsarray_msg description];
            
            if ([str_success isEqualToString:@"1"]) {
                NSString *username = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
                NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];

                NSString *str_surl =@"http:///sajanjewellersonline.in/apps/jwellyecat/PAYMENT/response.php";
                NSString *str_ky = [NSString stringWithFormat:@"key=EUKQS2ZPQ8&txnid=%@&amount=%@&firstname=%@&email=%@&phone=%@&productinfo=MobileApp&surl=%@&furl=%@",str_orderno,str_amount,username,txt_emailid.text,mobile,str_surl,str_surl];
               
                
                NSString *str_url = [NSString stringWithFormat:@"http:///sajanjewellersonline.in/apps/jwellyecat/PAYMENT/easebuzz.php?%@%@",str_ky];
                NSLog(@"str_url :::::::::::::::::: %@",str_ky);
                
        
            }else{
               
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

@end
