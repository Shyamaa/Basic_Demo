//
//  Aboutus.m
//  MMI ECAT
//
//  Created by mmsoft116 on 29/09/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "Aboutus.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "SWRevealViewController.h"
#import "Suggestion.h"

@interface Aboutus ()

@end

@implementation Aboutus
@synthesize str_type;

- (void)viewDidLoad {
    [super viewDidLoad]; 
    // Do any additional setup after loading the view.
    NSString *scategory = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
    if ([scategory isEqualToString:@"Admin"]){
        UIButton *bnt_Add = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [bnt_Add addTarget:self action:@selector(btnAddCommemnt:) forControlEvents:UIControlEventTouchUpInside];
        bnt_Add.frame = CGRectMake(0, 0, 30, 30);
        UIBarButtonItem *barAddBtn = [[UIBarButtonItem alloc] initWithCustomView:bnt_Add];
        barAddBtn.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItems = @[barAddBtn];
    }
    //txt_data.userInteractionEnabled = false;
    if ([str_type isEqualToString:@"About us"]) {
        self.title=@"About us";
    }else if ([str_type isEqualToString:@"Why us"]){
        self.title=@"Why us";
    }else if ([str_type isEqualToString:@"Why Membership"]){
        self.title=@"Why Membership";
    }else if ([str_type isEqualToString:@"Why Membership"]){
        self.title=@"Why Membership";
    }
    /*
     SWRevealViewController *revealController = [self revealViewController];
     [revealController panGestureRecognizer];
     [revealController tapGestureRecognizer];
     
     self.navigationController.navigationBarHidden=NO;
     self.title=@"About US";
     
     [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
     
     UIImage* image = [UIImage imageNamed:@"menu.png"];
     CGRect frameimg1 = CGRectMake(0, 0, image.size.width, image.size.height);
     UIButton *someButton1 = [[UIButton alloc] initWithFrame:frameimg1];
     [someButton1 setBackgroundImage:image forState:UIControlStateNormal];
     [someButton1 addTarget:revealController action:@selector(revealToggle:)
     forControlEvents:UIControlEventTouchUpInside];
     
     UIBarButtonItem *revealButtonItem =[[UIBarButtonItem alloc] initWithCustomView:someButton1];
     self.navigationItem.leftBarButtonItem = revealButtonItem;
     */
    
    imgView.image = [UIImage imageNamed:@"banner_Default"];
    txt_data.delegate = self;
    [self URL_ABOUTUS_API];
    if (_isSideMenu){
        [self setUpLeftMenuBtn];
    }
    
    switch ([UIDevice currentDevice].userInterfaceIdiom) {
        case UIUserInterfaceIdiomPad:
            txt_data.font = [UIFont boldSystemFontOfSize:28.0];
            break;

        case UIUserInterfaceIdiomPhone:
            txt_data.font = [UIFont boldSystemFontOfSize:18.0];
            break;
        default:
            txt_data.font = [UIFont boldSystemFontOfSize:18.0];
            break;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return false;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return false;
}

-(void)btnAddCommemnt:(UIButton*)sender{
    Suggestion *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Suggestion"];
    obj.str_type = self.str_type;
    __weak typeof(self) weakSelf = self;
    obj.onCloseTapped = ^{
        [weakSelf URL_ABOUTUS_API];
    };
    [self.navigationController pushViewController:obj animated:YES];
}

-(void)URL_ABOUTUS_API {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *loginRequest=[NSString stringWithFormat:@"type=%@",str_type];
    NSLog(@"loginRequest :::::::::::::::::::  %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@"%@",[WEB_URL URL_ABOUT]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        // handle response
        if ([data length] >0 && error == nil){
            //process the JSON response
            //use the main queue so that we can interact with the screen
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parse_ABOUT:data];
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

- (void)parse_ABOUT:(NSData *) data {
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
            NSMutableDictionary *pDict = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingAllowFragments error:&error];
            NSMutableArray *arrayResponse_success = [pDict objectForKey:@"success"];
            NSString *str_success = [arrayResponse_success description];
            if ([str_success isEqualToString:@"1"]) {
                NSMutableArray*nsarray_desc = [pDict objectForKey:@"desc"];
                NSString *str_desc = [nsarray_desc description];
                txt_data.text=str_desc;
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}
@end
