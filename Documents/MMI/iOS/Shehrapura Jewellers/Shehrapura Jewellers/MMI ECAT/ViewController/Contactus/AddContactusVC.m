//
//  AddContactus.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 02/08/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "AddContactusVC.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AddContactusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.contactUsData != nil && [self.contactUsData isKindOfClass:[NSDictionary class]] && self.contactUsData.count > 0) {
        NSLog(@"Dictionary has data");
        [self setUpContactData];
        self.title = @"Edit Contact us";
    } else {
        self.title = @"Add Contact us";
        NSLog(@"Dictionary is nil or empty");
    }
}

-(void)setUpContactData{
    NSString *firmName = [self.contactUsData valueForKey:@"comname"];
    NSString *mobile = [self.contactUsData valueForKey:@"mobile"];
    
    NSString *head1 = [self.contactUsData valueForKey:@"head1"];
    NSString *contact1 = [self.contactUsData valueForKey:@"contact1"];
    
    NSString *head2 = [self.contactUsData valueForKey:@"head2"];
    NSString *contact2 = [self.contactUsData valueForKey:@"contact2"];
    
    NSString *head3 = [self.contactUsData valueForKey:@"head3"];
    NSString *contact3 = [self.contactUsData valueForKey:@"contact3"];
    
    NSString *head4 = [self.contactUsData valueForKey:@"head4"];
    NSString *contact4 = [self.contactUsData valueForKey:@"contact4"];
    
    NSString *address = [self.contactUsData valueForKey:@"address"];
    NSString *address1 = [self.contactUsData valueForKey:@"address1"];
    
    txtFirmName.text = firmName;
    txtMobileNo.text = mobile;
    
    txtHead1.text = head1;
    txtMobileNo1.text = contact1;
    txtHead2.text = head2;
    txtMobileNo2.text = contact2;
    txtHead3.text = head3;
    txtMobileNo3.text = contact3;
    txtHead4.text = head4;
    txtMobileNo4.text = contact4;
    
    txtAddress.text = address;
    txtAddress1.text = address1;
}


- (IBAction)saveBtnAction:(id)sender {
    if (txtFirmName.text.length == 0){
        [self alertMsg:@"Please enter firm name"];
    }else if (txtMobileNo.text.length == 0){
        [self alertMsg:@"Please enter mobile number"];
    }else if (txtHead1.text.length == 0){
        [self alertMsg:@"Please enter head1 name"];
    }else if (txtMobileNo1.text.length == 0){
        [self alertMsg:@"Please enter mobile number1"];
    }else if (txtAddress.text.length == 0){
        [self alertMsg:@"Please enter the address"];
    }else{
        [self apiSaveContactUsData];
    }
}

#pragma mark -  API Method

- (void)apiSaveContactUsData{
    [[BusyIndicator sharedInstance]startIndicator];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    NSString *str_fname = txtFirmName.text;
    NSString *str_mobile = txtMobileNo.text;
    NSString *str_head1 = txtHead1.text;
    NSString *str_mobile1 = txtMobileNo1.text;
    NSString *str_head2 = txtHead2.text;
    NSString *str_mobile2 = txtMobileNo2.text;
    
    NSString *str_head3 = txtHead3.text;
    NSString *str_mobile3 = txtMobileNo3.text;
    NSString *str_head4 = txtHead4.text;
    NSString *str_mobile4 = txtMobileNo4.text;
    
    NSString *str_address = txtAddress.text;
    NSString *str_address1 = txtAddress1.text;
    
    NSString *postString = [NSString stringWithFormat:@"fname=%@&mobile=%@&head1=%@&mobile1=%@&head2=%@&mobile2=%@&head3=%@&mobile3=%@&head4=%@&mobile4=%@&address=%@&address1=%@",
                            str_fname, str_mobile,
                            str_head1, str_mobile1,
                            str_head2, str_mobile2,
                            str_head3,str_mobile3,
                            str_head4,str_mobile4,
                            str_address,str_address1];
    
    NSString *api = [NSString stringWithFormat:@"%@", [WEB_URL URL_Insert_ContactUs]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Register config Url = %@", url);
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            [[BusyIndicator sharedInstance]stopIndicator];
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonDict) {
                NSLog(@"Add Countac Us  Response = %@", jsonDict);
                NSMutableDictionary *pDict = [NSJSONSerialization
                                              JSONObjectWithData:data
                                              options:NSJSONReadingAllowFragments
                                              error:&error];
                
                NSString *status = pDict[@"success"];
                NSString *message = pDict[@"message"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([status isEqualToString:@"1"]) {
                        [self confirmAlert:message];
                    } else {
                        [self alertMsg:message ?: @"Unknown error"];
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self alertMsg:jsonError.localizedDescription];
                });
            }
        } else {
            [[BusyIndicator sharedInstance]stopIndicator];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertMsg:error.localizedDescription];
            });
        }
    }];
    [task resume];
}

-(void)confirmAlert: (NSString *)strMsg{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:nil
                                  message:strMsg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
        //Handel your yes please button action here
        [alert dismissViewControllerAnimated:YES completion:nil];
        if (self.onCloseTapped) {
            self.onCloseTapped();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

NS_ASSUME_NONNULL_END
