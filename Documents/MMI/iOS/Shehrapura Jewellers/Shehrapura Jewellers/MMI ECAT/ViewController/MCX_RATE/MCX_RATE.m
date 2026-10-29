//
//  MCX_RATE.m
//  Jwelly Customer
//
//  Created by MMI SOFTWARES PVT LTD on 13/01/22.
//  Copyright © 2022 MMI Softwares. All rights reserved.
//

#import "MCX_RATE.h"
#import "webUrlconstant.h"
#import "BankDetail.h"

@interface MCX_RATE ()
{
    NSString *str_gold_retail;
    NSString *str_sil_retail;
    NSString *str_gold_rtgs;
    NSString *str_sil_rtgs;
}
@end

@implementation MCX_RATE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIImage* image3 = [UIImage imageNamed:@"menutop.png"];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem=mailbutton;
   
    [self GET_BADLA_MAX];
    
    UITapGestureRecognizer *tap_live =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(tap_live:)];
    [view_live addGestureRecognizer:tap_live];
    
    
    UITapGestureRecognizer *tap_jewellery =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(tap_jewellery:)];
    [view_jewellery addGestureRecognizer:tap_jewellery];
    

    UITapGestureRecognizer *tap_msg =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(tap_msg:)];
    [view_msg addGestureRecognizer:tap_msg];
    
    UITapGestureRecognizer *tap_bank =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(tap_bank:)];
    [view_bank addGestureRecognizer:tap_bank];
    
    UITapGestureRecognizer *tap_contact =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(tap_contact:)];
    [view_contact addGestureRecognizer:tap_contact];
    
}
-(void)viewWillAppear:(BOOL)animated {
    
     self.myTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(theAction) userInfo:nil repeats:YES];
    
}
- (void)tap_live:(UITapGestureRecognizer *)recognizer
{
  CGPoint location = [recognizer locationInView:[recognizer.view superview]];

    NSLog(@"location ******************************* ");
  //Do stuff here...
}


- (void)tap_jewellery:(UITapGestureRecognizer *)recognizer
{
  CGPoint location = [recognizer locationInView:[recognizer.view superview]];

    NSLog(@"location ******************************* ");

    Brochures *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Brochures"];
    [self.navigationController pushViewController:obj animated:YES];
}


- (void)tap_msg:(UITapGestureRecognizer *)recognizer
{
  CGPoint location = [recognizer locationInView:[recognizer.view superview]];


    NotificationVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationVC"];
    [self.navigationController pushViewController:obj animated:YES];
    
}

- (void)tap_bank:(UITapGestureRecognizer *)recognizer
{
  CGPoint location = [recognizer locationInView:[recognizer.view superview]];

    NSLog(@"location ******************************* ");
    BankDetail *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"BankDetail"];
    [self.navigationController pushViewController:obj animated:YES];
    
}

- (void)tap_contact:(UITapGestureRecognizer *)recognizer
{
  CGPoint location = [recognizer locationInView:[recognizer.view superview]];

    NSLog(@"location ******************************* ");

    Contactus *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Contactus"];
    [self.navigationController pushViewController:obj animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [self.myTimer invalidate];
}
-(void) theAction {


    NSLog(@"Will appear after a 2 second delay.");
    
    [lbl_sale1 setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    [lbl_sale2 setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    [lbl_sale3 setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    [lbl_sale4 setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
  
    [lbl_gold_h setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    [lbl_gold_l setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    [lbl_silver_h setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    [lbl_silver_l setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    
    [lbl_gspot_h setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    [lbl_gspot_l setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    [lbl_silver_l setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    [lbl_sspot_h setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    [lbl_sspot_l setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    [lbl_inr_h setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    [lbl_inr_l setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    [lbl_gold_bid setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    [lbl_gold_ask setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    
    [lbl_silver_bid setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    [lbl_silver_ask setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    [lbl_sspot_bid setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    [lbl_sspot_ask setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    [lbl_inr_bid setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    [lbl_inr_ask setTextColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
    
    [self currentRate_API];

}


-(void)GET_BADLA_MAX {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSString *action=@"Get";
    NSString *loginRequest = [NSString stringWithFormat:@"action=%@",action];
    NSLog(@"response  %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@"%@",[WEB_URL URL_MCX_BADLA]];
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
                [self parseLogin_MCX:data];
            });
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            
        }
        else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
        }
    }] resume];
}


- (void)parseLogin_MCX:(NSData *) data {
        
        ////////////// End processs load view
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
            
//            NSMutableArray *arrayResponse_success = [pDict objectForKey:@"success"];
//            NSString *str_success = [arrayResponse_success description];
//            NSMutableArray*nsarray_msg = [pDict objectForKey:@"message"];
//            NSString *str_msg = [nsarray_msg description];
            
            NSMutableArray *nsarray_marq1 = [pDict objectForKey:@"marquee1"];
            NSString *str_marq1 = [nsarray_marq1 description];
//            _lbl_marquee1.text =[NSString stringWithFormat:@"%@",str_marq1];
            
            NSMutableArray *nsarray_marq2 = [pDict objectForKey:@"marquee2"];
            NSString *str_marq2 = [nsarray_marq2 description];
//            _lbl_marquee2.text =[NSString stringWithFormat:@"%@",str_marq2];
           
            NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:str_marq1];
            _lbl_marquee1.attributedText = attributedString1;
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str_marq2];
            _lbl_marquee2.attributedText = attributedString;
            

            NSMutableArray *nsarray_gbadla = [pDict objectForKey:@"gbadla"];
            str_gold_retail = [nsarray_gbadla description];
            
            NSMutableArray *nsarray_sbadla = [pDict objectForKey:@"sbadla"];
            str_sil_retail = [nsarray_sbadla description];
            
            NSMutableArray *nsarray_gbadla_rtgs = [pDict objectForKey:@"gbadla_rtgs"];
            str_gold_rtgs = [nsarray_gbadla_rtgs description];
            
            NSMutableArray *nsarray_sbadla_rtgs = [pDict objectForKey:@"sbadla_rtgs"];
            str_sil_rtgs = [nsarray_sbadla_rtgs description];
            
            NSMutableArray *nsarray_g_rtgs_cap = [pDict objectForKey:@"g_rtgs_cap"];
            NSString *str_g_rtgs_cap = [nsarray_g_rtgs_cap description];
            
            NSMutableArray *nsarray_goldcation = [pDict objectForKey:@"goldcation"];
            NSString *str_goldcation = [nsarray_goldcation description];
            
            NSMutableArray *nsarray_s_rtgs_cap = [pDict objectForKey:@"s_rtgs_cap"];
            NSString *str_s_rtgs_cap = [nsarray_s_rtgs_cap description];
            
            NSMutableArray *nsarray_silvercation = [pDict objectForKey:@"silvercation"];
            NSString *str_silvercation = [nsarray_silvercation description];

        
            lbl_bullion1.text =[NSString stringWithFormat:@"%@",str_g_rtgs_cap];
            lbl_bullion2.text =[NSString stringWithFormat:@"%@",str_goldcation];
            lbl_bullion3.text =[NSString stringWithFormat:@"%@",str_s_rtgs_cap];
            lbl_bullion4.text =[NSString stringWithFormat:@"%@",str_silvercation];
            
            lbl_sale_badla1.text =[NSString stringWithFormat:@"%@",str_gold_rtgs];
            lbl_sale_badla2.text =[NSString stringWithFormat:@"%@",str_gold_retail];
            lbl_sale_badla3.text =[NSString stringWithFormat:@"%@",str_sil_rtgs];
            lbl_sale_badla4.text =[NSString stringWithFormat:@"%@",str_sil_retail];
            
            [self currentRate_API];

    }
}


-(void)currentRate_API {
    NSString *grpid = [[NSUserDefaults standardUserDefaults]stringForKey:@"grpid"];
    
    NSString *loginRequest=[NSString stringWithFormat:@"grpid=%@",grpid];
    NSLog(@"response  %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    
    NSString *api = [NSString stringWithFormat:BASEURL_GETCURRENTMARKETRATE];
    
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
                [self parse_currentRate_API:data];
            });
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
        }
        else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
        }
    }] resume];
}


- (void) parse_currentRate_API:(NSData *) data {
    @try {
        
        
        ////////////// End processs load view
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
            
            
            NSMutableArray* arrayResponse = [pDict objectForKey:@"rows"];
            NSLog(@"222222222222 %@",arrayResponse);
            for (int i = 0; i < [arrayResponse count]; i++) {
                
                NSDictionary * dictObject = [arrayResponse objectAtIndex:i];
                NSString *Symbol = [dictObject objectForKey:@"Symbol"];
                
                if ([Symbol isEqualToString:@"GLD"]) {
                    
                    NSString *str_AskStatus = [dictObject objectForKey:@"AskStatus"];
                    if ([str_AskStatus isEqualToString:@"up"]) {
                        [lbl_gold_bid setTextColor:[UIColor colorWithRed:16/255.0f green:107/255.0f blue:33/255.0f alpha:1.0]];
                        [lbl_gold_ask setTextColor:[UIColor colorWithRed:16/255.0f green:107/255.0f blue:33/255.0f alpha:1.0]];
                        [lbl_gold_h setTextColor:[UIColor colorWithRed:16/255.0f green:107/255.0f blue:33/255.0f alpha:1.0]];
                        [lbl_gold_l setTextColor:[UIColor colorWithRed:16/255.0f green:107/255.0f blue:33/255.0f alpha:1.0]];
                    }
                    
                    if ([str_AskStatus isEqualToString:@"down"]) {
                        [lbl_gold_bid setTextColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
                        [lbl_gold_ask setTextColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
                        [lbl_gold_h setTextColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
                        [lbl_gold_l setTextColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
                    }
                    

                    lbl_gold_bid.text = [NSString stringWithFormat:@"%@",[dictObject objectForKey:@"Bid"]];
                    lbl_gold_ask.text = [NSString stringWithFormat:@"%@",[dictObject objectForKey:@"Ask"]];
                    lbl_gold_h.text = [NSString stringWithFormat:@"%@",[dictObject objectForKey:@"High"]];
                    lbl_gold_l.text = [NSString stringWithFormat:@"%@",[dictObject objectForKey:@"Low"]];
                    
                    
                    
                }else if ([Symbol isEqualToString:@"SLR"]) {
                    
                    NSString *str_AskStatus = [dictObject objectForKey:@"AskStatus"];
                    if ([str_AskStatus isEqualToString:@"up"]) {
                        [lbl_silver_bid setTextColor:[UIColor colorWithRed:16/255.0f green:107/255.0f blue:33/255.0f alpha:1.0]];
                        [lbl_silver_ask setTextColor:[UIColor colorWithRed:16/255.0f green:107/255.0f blue:33/255.0f alpha:1.0]];
                        [lbl_silver_h setTextColor:[UIColor colorWithRed:16/255.0f green:107/255.0f blue:33/255.0f alpha:1.0]];
                        [lbl_silver_l setTextColor:[UIColor colorWithRed:16/255.0f green:107/255.0f blue:33/255.0f alpha:1.0]];
                    }
                    
                    if ([str_AskStatus isEqualToString:@"down"]) {
                        [lbl_silver_bid setTextColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
                        [lbl_silver_ask setTextColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
                        [lbl_silver_h setTextColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
                        [lbl_silver_l setTextColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
                    }
                   
                    
                    
                    lbl_silver_bid.text = [NSString stringWithFormat:@"%@",[dictObject objectForKey:@"Bid"]];
                    lbl_silver_ask.text = [NSString stringWithFormat:@"%@",[dictObject objectForKey:@"Ask"]];
                    lbl_silver_h.text = [NSString stringWithFormat:@"%@",[dictObject objectForKey:@"High"]];
                    lbl_silver_l.text = [NSString stringWithFormat:@"%@",[dictObject objectForKey:@"Low"]];

                    
                }else if ([Symbol isEqualToString:@"XAUUSD"]) {
                    
                    NSString *str_AskStatus = [dictObject objectForKey:@"AskStatus"];
                    if ([str_AskStatus isEqualToString:@"up"]) {
                        [lbl_gspot_bid setTextColor:[UIColor colorWithRed:16/255.0f green:107/255.0f blue:33/255.0f alpha:1.0]];
                        [lbl_gspot_ask setTextColor:[UIColor colorWithRed:16/255.0f green:107/255.0f blue:33/255.0f alpha:1.0]];
                        [lbl_gspot_h setTextColor:[UIColor colorWithRed:16/255.0f green:107/255.0f blue:33/255.0f alpha:1.0]];
                        [lbl_gspot_l setTextColor:[UIColor colorWithRed:16/255.0f green:107/255.0f blue:33/255.0f alpha:1.0]];
                    }
                    
                    if ([str_AskStatus isEqualToString:@"down"]) {
                        [lbl_gspot_bid setTextColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
                        [lbl_gspot_ask setTextColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
                        [lbl_gspot_h setTextColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
                        [lbl_gspot_l setTextColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
                    }
                    
                    lbl_gspot_bid.text = [NSString stringWithFormat:@"%@",[dictObject objectForKey:@"Bid"]];
                    lbl_gspot_ask.text = [NSString stringWithFormat:@"%@",[dictObject objectForKey:@"Ask"]];
                    lbl_gspot_h.text = [NSString stringWithFormat:@"%@",[dictObject objectForKey:@"High"]];
                    lbl_gspot_l.text = [NSString stringWithFormat:@"%@",[dictObject objectForKey:@"Low"]];
                    
                }else if ([Symbol isEqualToString:@"XAGUSD"]) {
                    NSString *str_AskStatus = [dictObject objectForKey:@"AskStatus"];
                    if ([str_AskStatus isEqualToString:@"up"]) {
                        [lbl_sspot_bid setTextColor:[UIColor colorWithRed:16/255.0f green:107/255.0f blue:33/255.0f alpha:1.0]];
                        [lbl_sspot_ask setTextColor:[UIColor colorWithRed:16/255.0f green:107/255.0f blue:33/255.0f alpha:1.0]];
                        [lbl_sspot_h setTextColor:[UIColor colorWithRed:16/255.0f green:107/255.0f blue:33/255.0f alpha:1.0]];
                        [lbl_sspot_l setTextColor:[UIColor colorWithRed:16/255.0f green:107/255.0f blue:33/255.0f alpha:1.0]];
                    }
                    
                    if ([str_AskStatus isEqualToString:@"down"]) {
                        [lbl_sspot_bid setTextColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
                        [lbl_sspot_ask setTextColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
                        [lbl_sspot_h setTextColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
                        [lbl_sspot_l setTextColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
                    }
                    
                    lbl_sspot_bid.text = [NSString stringWithFormat:@"%@",[dictObject objectForKey:@"Bid"]];
                    lbl_sspot_ask.text = [NSString stringWithFormat:@"%@",[dictObject objectForKey:@"Ask"]];
                    lbl_sspot_h.text = [NSString stringWithFormat:@"%@",[dictObject objectForKey:@"High"]];
                    lbl_sspot_l.text = [NSString stringWithFormat:@"%@",[dictObject objectForKey:@"Low"]];

                    
                }else if ([Symbol isEqualToString:@"INRSpot"]) {
                    lbl_inr_bid.text = [NSString stringWithFormat:@"%@",[dictObject objectForKey:@"Bid"]];
                    lbl_inr_ask.text = [NSString stringWithFormat:@"%@",[dictObject objectForKey:@"Ask"]];
                    lbl_inr_h.text = [NSString stringWithFormat:@"%@",[dictObject objectForKey:@"High"]];
                    lbl_inr_l.text = [NSString stringWithFormat:@"%@",[dictObject objectForKey:@"Low"]];
                    
                    
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
