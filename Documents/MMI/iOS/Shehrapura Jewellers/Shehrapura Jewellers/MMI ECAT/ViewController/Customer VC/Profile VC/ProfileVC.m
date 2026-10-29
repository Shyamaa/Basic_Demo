//
//  ProfileVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 16/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "ProfileVC.h"
#import "EditProfileVC.h"

@interface ProfileVC()

@end

@implementation ProfileVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Profile";
    if (_isSideMenu){
        [self setUpLeftMenuBtn];
    }
    [self GET_USER];
    [self setUpData];
}

-(void)setUpData{
    [self.imgProfile sd_setImageWithURL:[NSURL URLWithString:@""]
                                 placeholderImage:[UIImage imageNamed:@"user_white.png"] options:SDWebImageRefreshCached];
    NSString *profile = [[NSUserDefaults standardUserDefaults] stringForKey:@"profiledisplay"];
    NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"mobile"];
    
    
    NSString *firmname = [[NSUserDefaults standardUserDefaults] stringForKey:@"firmname"];
    NSString *emailId = [[NSUserDefaults standardUserDefaults] stringForKey:@"emailid"];
    NSString *address = [[NSUserDefaults standardUserDefaults] stringForKey:@"address"];
    NSString *city = [[NSUserDefaults standardUserDefaults] stringForKey:@"city"];
    NSString *state = [[NSUserDefaults standardUserDefaults] stringForKey:@"state"];
    NSString *gstno = [[NSUserDefaults standardUserDefaults] stringForKey:@"gstno"];
    NSString *hmno = [[NSUserDefaults standardUserDefaults] stringForKey:@"hmno"];
    NSString *panno = [[NSUserDefaults standardUserDefaults] stringForKey:@"panno"];

    NSLog(@"Profile = %@, Name = %@, mobile = %@", profile,name,mobile);
    //NSLog(@"firmname = %@, emailId = %@, address = %@, area = %@", firmname,emailId,address);
    NSLog(@"Dispaye");
    self.lblName.text = name;
    self.lblMobile.text = mobile;
    self.txtEmailID.text = emailId;
    self.txtFirmName.text = firmname;
    self.txtAddress.text = address;
    self.txtCity.text = city;
    self.txtState.text = state;
    self.txtGstNo.text = gstno;
    self.txtHmNo.text = hmno;
    self.txtPanNo.text = panno;

}


-(IBAction)btnActionEditProfile:(id)sender{
    EditProfileVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileVC"];
    [self.navigationController pushViewController:obj animated:YES];
}


-(void)GET_USER {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance] startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"mobile"];
    NSString *loginRequest = [NSString stringWithFormat:@"mobile=%@", mobile];
    NSData *data1 = [loginRequest dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[WEB_URL URL_USERDETAIL]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[BusyIndicator sharedInstance] stopIndicator];
            if (data.length > 0 && !error) {
                [self parseLogin_Api:data];
            } else if (error) {
                NSLog(@"Error: %@", error);
            } else {
                NSLog(@"Empty Response");
            }
        });
    }] resume];
    
}

- (void)parseLogin_Api:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        NSError *error = nil;
        [[BusyIndicator sharedInstance]stopIndicator];
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
            
            NSLog(@"pDict ::::::::::::::: %@",pDict);
            NSMutableArray *array_success = [pDict objectForKey:@"success"];
            NSString *str_success = [array_success description];
            NSMutableArray *nsarray_msg = [pDict objectForKey:@"message"];
            NSString *str_msg = [nsarray_msg description];
            NSString *category = [[NSUserDefaults standardUserDefaults]stringForKey:@"userCategory"];
            if ([str_success isEqualToString:@"1"])
            {
                NSMutableArray *nsarray_loginid = [pDict objectForKey:@"loginid"];
                NSString *str_loginid = [nsarray_loginid description];
                NSMutableArray*nsarray_username = [pDict objectForKey:@"username"];
                NSString *str_username = [nsarray_username description];
                NSMutableArray*nsarray_mobile = [pDict objectForKey:@"mobile"];
                NSString *str_mobile = [nsarray_mobile description];
                NSMutableArray *nsarray_category = [pDict objectForKey:@"category"];
                category = [nsarray_category description];
                NSMutableArray *nsarray_mdob = [pDict objectForKey:@"mdob"];
                NSString *mdob = [nsarray_mdob description];
                NSMutableArray *nsarray_spousename = [pDict objectForKey:@"spousename"];
                NSString *spousename = [nsarray_spousename description];
                NSMutableArray *ns_sdob = [pDict objectForKey:@"sdob"];
                NSString *sdob = [ns_sdob description];
                NSMutableArray *ns_anniversary = [pDict objectForKey:@"anniversary"];
                NSString *anniversary = [ns_anniversary description];
                NSMutableArray *nsarray_address = [pDict objectForKey:@"address"];
                NSString *address = [nsarray_address description];
                NSMutableArray *nsarray_sprofile = [pDict objectForKey:@"profile"];
                NSString *profile = [nsarray_sprofile description];
                NSMutableArray *nsarray_firmname = [pDict objectForKey:@"firmname"];
                NSString *firmname = [nsarray_firmname description];
                NSMutableArray *nsarray_landno = [pDict objectForKey:@"landno"];
                NSString *landno = [nsarray_landno description];
                NSMutableArray *ns_area = [pDict objectForKey:@"area"];
                NSString *area = [ns_area description];
                NSMutableArray *nsarray_closingdate = [pDict objectForKey:@"closingdate"];
                NSString *closingdate = [nsarray_closingdate description];
                NSMutableArray *nsarray_orderdelete = [pDict objectForKey:@"orderdelete"];
                NSString *orderdelete = [nsarray_orderdelete description];
                NSMutableArray *nsarray_profiledisplay = [pDict objectForKey:@"profiledisplay"];
                NSString *profiledisplay = [nsarray_profiledisplay description];
                NSMutableArray *ns_emailid= [pDict objectForKey:@"emailid"];
                NSString *emailid = [ns_emailid description];
                NSMutableArray *nsarray_branchid = [pDict objectForKey:@"branchid"];
                NSString *branchid = [nsarray_branchid description];
                
                NSMutableArray *nsarray_cityid = [pDict objectForKey:@"city"];
                NSString *city = [nsarray_cityid description];
                NSMutableArray *nsarray_stateid = [pDict objectForKey:@"state"];
                NSString *state = [nsarray_stateid description];
                NSMutableArray *nsarray_gstnoid = [pDict objectForKey:@"gstno"];
                NSString *gstno = [nsarray_gstnoid description];
                NSMutableArray *nsarray_hmnoid = [pDict objectForKey:@"hmno"];
                NSString *hmno = [nsarray_hmnoid description];
                NSMutableArray *nsarray_pannoid = [pDict objectForKey:@"panno"];
                NSString *panno = [nsarray_pannoid description];
                
                [[NSUserDefaults standardUserDefaults] setObject:str_loginid forKey:@"loginid"];
                [[NSUserDefaults standardUserDefaults] setObject:str_username forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:str_mobile forKey:@"mobile"];
                [[NSUserDefaults standardUserDefaults] setObject:category forKey:@"userCategory"];
                [[NSUserDefaults standardUserDefaults] setObject:mdob forKey:@"mdob"];
                [[NSUserDefaults standardUserDefaults] setObject:spousename forKey:@"spousename"];
                [[NSUserDefaults standardUserDefaults] setObject:sdob forKey:@"sdob"];
                [[NSUserDefaults standardUserDefaults] setObject:anniversary forKey:@"anniversary"];
                [[NSUserDefaults standardUserDefaults] setObject:address forKey:@"address"];
                [[NSUserDefaults standardUserDefaults] setObject:profile forKey:@"profile"];
                [[NSUserDefaults standardUserDefaults] setObject:firmname forKey:@"firmname"];
                [[NSUserDefaults standardUserDefaults] setObject:landno forKey:@"landno"];
                [[NSUserDefaults standardUserDefaults] setObject:area forKey:@"area"];
                [[NSUserDefaults standardUserDefaults] setObject:closingdate forKey:@"closingdate"];
                [[NSUserDefaults standardUserDefaults] setObject:orderdelete forKey:@"orderdelete"];
                [[NSUserDefaults standardUserDefaults] setObject:profiledisplay forKey:@"profiledisplay"];
                [[NSUserDefaults standardUserDefaults] setObject:emailid forKey:@"emailid"];
                [[NSUserDefaults standardUserDefaults] setObject:branchid forKey:@"branchid"];
                
                [[NSUserDefaults standardUserDefaults] setObject:city forKey:@"city"];
                [[NSUserDefaults standardUserDefaults] setObject:state forKey:@"state"];
                [[NSUserDefaults standardUserDefaults] setObject:gstno forKey:@"gstno"];
                [[NSUserDefaults standardUserDefaults] setObject:hmno forKey:@"hmno"];
                [[NSUserDefaults standardUserDefaults] setObject:panno forKey:@"panno"];
                
                [self setUpData];
            } else {
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message" message:str_msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
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


@end
