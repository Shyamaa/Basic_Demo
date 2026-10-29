//
//  Contactus.m
//  MMI ECAT
//
//  Created by mmsoft116 on 29/09/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "Contactus.h"
#import "AddContactusVC.h"

@interface Contactus ()
{
    NSString *str_fb;
    NSString *str_twitter;
    NSString *str_insta;
    NSString *str_website;
    NSDictionary *contactUsData;
}
@end

@implementation Contactus
@synthesize str_type;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"Contact us";
    
    if (_isSideMenu) {
        [self setUpLeftMenuBtn];
    }
    
    NSString *scategory = [[NSUserDefaults standardUserDefaults]stringForKey:@"category"];
    if ([scategory isEqualToString:@"Admin"]){
        UIButton *bnt_Add = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [bnt_Add addTarget:self action:@selector(btnAddCommemnt:) forControlEvents:UIControlEventTouchUpInside];
        bnt_Add.frame = CGRectMake(0, 0, 30, 30);
        UIBarButtonItem *barAddBtn = [[UIBarButtonItem alloc] initWithCustomView:bnt_Add];
        barAddBtn.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItems = @[barAddBtn];
    }
    
    [view1.layer setMasksToBounds:YES];
    [view1.layer setCornerRadius:18.0f];
    [view1.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [view1.layer setBorderWidth:1];
    
    [view2.layer setMasksToBounds:YES];
    [view2.layer setCornerRadius:18.0f];
    [view2.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [view2.layer setBorderWidth:1];
    
    [view3.layer setMasksToBounds:YES];
    [view3.layer setCornerRadius:18.0f];
    [view3.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [view3.layer setBorderWidth:1];
    
    [view4.layer setMasksToBounds:YES];
    [view4.layer setCornerRadius:18.0f];
    [view4.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [view4.layer setBorderWidth:1];
    
    [view5.layer setMasksToBounds:YES];
    [view5.layer setCornerRadius:18.0f];
    [view5.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [view5.layer setBorderWidth:1];
    
    [view6.layer setMasksToBounds:YES];
    [view6.layer setCornerRadius:18.0f];
    [view6.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [view6.layer setBorderWidth:1];
    
    [view7.layer setMasksToBounds:YES];
    [view7.layer setCornerRadius:18.0f];
    [view7.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [view7.layer setBorderWidth:1];
    [self URL_Contactus_API];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self URL_Contactus_API];
}

-(void)btnAddCommemnt:(UIButton*)sender{
    AddContactusVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"AddContactusVC"];
    obj.contactUsData = contactUsData;
    __weak typeof(self) weakSelf = self;
    obj.onCloseTapped = ^{
        [weakSelf URL_Contactus_API];
    };
    [self.navigationController pushViewController:obj animated:YES];
}

#pragma mark: - Api Methods

-(void)URL_Contactus_API {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *loginRequest=[NSString stringWithFormat:@"type=%@",str_type];
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@"%@",[WEB_URL URL_CONTACTUS]];
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
                [self parse_contactus:data];
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


- (void)parse_contactus:(NSData *) data {
    @try {
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
            contactUsData = pDict;
            NSString *str_success = [arrayResponse_success description];
            
            if ([str_success isEqualToString:@"1"]) {
                
                NSMutableArray*nsarray_head1 = [pDict objectForKey:@"head1"];
                NSString *str_head1 = [nsarray_head1 description];
                NSMutableArray*nsarray_contact1 = [pDict objectForKey:@"contact1"];
                NSString *str_contact1 = [nsarray_contact1 description];
                NSMutableArray*nsarray_head2 = [pDict objectForKey:@"head2"];
                NSString *str_head2 = [nsarray_head2 description];
                NSMutableArray*nsarray_contact2 = [pDict objectForKey:@"contact2"];
                NSString *str_contact2 = [nsarray_contact2 description];
                NSMutableArray*nsarray_head3 = [pDict objectForKey:@"head3"];
                NSString *str_head3 = [nsarray_head3 description];
                NSMutableArray*nsarray_contact3 = [pDict objectForKey:@"contact3"];
                NSString *str_contact3 = [nsarray_contact3 description];
                NSMutableArray*nsarray_head4 = [pDict objectForKey:@"head4"];
                NSString *str_head4 = [nsarray_head4 description];
                NSMutableArray*nsarray_contact4 = [pDict objectForKey:@"contact4"];
                NSString *str_contact4 = [nsarray_contact4 description];
                NSMutableArray*nsarray_address = [pDict objectForKey:@"address"];
                NSString *str_adress = [nsarray_address description];
                NSMutableArray*nsarray_address1 = [pDict objectForKey:@"address1"];
                NSString *str_adress1 = [nsarray_address1 description];
                NSMutableArray *nsarray_fb = [pDict objectForKey:@"fb"];
                str_fb = [nsarray_fb description];
                NSMutableArray *nsarray_insta = [pDict objectForKey:@"insta"];
                str_insta = [nsarray_insta description];
                NSMutableArray *nsarray_twitter = [pDict objectForKey:@"twitter"];
                str_twitter = [nsarray_twitter description];
                
                NSMutableArray *nsarray_website = [pDict objectForKey:@"website"];
                str_website = [nsarray_website description];
                
                lbl_head1.text = [NSString stringWithFormat:@"%@",str_head1];
                lbl_head2.text = [NSString stringWithFormat:@"%@",str_head2];
                lbl_head3.text = [NSString stringWithFormat:@"%@",str_head3];
                lbl_head4.text = [NSString stringWithFormat:@"%@",str_head4];
                
                lbl_contact1.text = [NSString stringWithFormat:@"%@",str_contact1];
                lbl_contact2.text = [NSString stringWithFormat:@"%@",str_contact2];
                lbl_contact3.text = [NSString stringWithFormat:@"%@",str_contact3];
                lbl_contact4.text = [NSString stringWithFormat:@"%@",str_contact4];
                
                lbl_address.text = [NSString stringWithFormat:@"%@",str_adress];
                lbl_address2.text = [NSString stringWithFormat:@"%@",str_adress1];
                
                if (str_head1.length > 0) {
                    view1.hidden = NO;
                }
                if (str_head2.length > 0) {
                    view2.hidden = NO;
                }
                if (str_head3.length == 0) {
                    view3.hidden = YES;
                }
                if (str_head4.length == 0) {
                    view4.hidden = YES;
                }
                if (str_adress1.length == 0) {
                    view6.hidden = YES;
                }
                
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

#pragma mark:- Button Acions Methods

- (IBAction)btn_Call:(UIButton *)sender {
    NSString *strMobileNo = @"";
    switch (sender.tag) {
        case 1:
            strMobileNo = lbl_contact1.text;
            break;
        case 2:
            strMobileNo = lbl_contact2.text;
            break;
        case 3:
            strMobileNo = lbl_contact3.text;
            break;
        case 4:
            strMobileNo = lbl_contact4.text;
            break;
        default:
            strMobileNo = @"";
            break;
    }
    if (![strMobileNo isEqualToString:@""]) {
        [self phoneCallMethod:strMobileNo];
    }
}

- (IBAction)btn_Location:(UIButton *)sender {
    
}

- (IBAction)btn_website:(id)sender {
    NSURL *whatsappURL = [NSURL URLWithString:str_website];
    [[UIApplication sharedApplication] openURL:whatsappURL options:@{} completionHandler:nil];
}

- (IBAction)btn_insta:(id)sender {
    
    NSURL *whatsappURL = [NSURL URLWithString:str_insta];
    [[UIApplication sharedApplication] openURL:whatsappURL options:@{} completionHandler:nil];
    
}

- (IBAction)btn_twitter:(id)sender {
    NSURL *whatsappURL = [NSURL URLWithString:str_twitter];
    [[UIApplication sharedApplication] openURL:whatsappURL options:@{} completionHandler:nil];
}

- (IBAction)btn_fb:(id)sender {
    NSURL *whatsappURL = [NSURL URLWithString:str_fb];
    [[UIApplication sharedApplication] openURL:whatsappURL options:@{} completionHandler:nil];
}


@end
