//
//  BankDetail.m
//  Jewel Desk
//
//  Created by Apple on 2/6/22.
//  Copyright © 2022 MMI Softwares. All rights reserved.
//

#import "BankDetail.h"
#import "webUrlconstant.h"
#import "BusyIndicator.h"
#import "PopupBankdetail.h"

@interface BankDetail ()

@end

@implementation BankDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Bank Detail";
    
    [view_bank1.layer setBorderColor:[[UIColor colorNamed:@"appRed_Color"]CGColor]];
    [view_bank2.layer setBorderColor:[[UIColor colorNamed:@"appRed_Color"]CGColor]];
    [view_upi.layer setBorderColor:[[UIColor colorNamed:@"appRed_Color"]CGColor]];
    
    [self setupNavigationBar];
    
    if (_isSideMenu){
        [self setUpLeftMenuBtn];
    }
    
    [self GET_BANKDETAIL];
}

- (void)setupNavigationBar {
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(openBtnAddAction)];
    self.navigationItem.rightBarButtonItem = addButton;
}

#pragma mark: -  Helper Method

- (void)openBtnAddAction {
    [self btn_account];
}

-(void)btn_account{
    
//    PopupBankdetail *popup = [[PopupBankdetail alloc] init];
//    popup.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    popup.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:popup animated:YES completion:nil];

    
    PopupBankdetail *popupVC = [[PopupBankdetail alloc] init];
      popupVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
      popupVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    popupVC.dicBankData = bankDetailsData;
      popupVC.completionHandler = ^(NSString *acname,NSString *acnumber,NSString *bankname,NSString *branch,NSString *ifsc,NSString *gstin,NSString *upi,NSString *acname2,NSString *acnumber2,NSString *bankname2,NSString *branch2,NSString *ifsc2) {
          
          NSLog(@"Select acname: %@", acname);
          NSLog(@"Select acnumber: %@", acnumber);
          NSLog(@"Select bankname: %@", bankname);
          NSLog(@"Select branch: %@", branch);
          NSLog(@"Select ifsc: %@", ifsc);
          NSLog(@"Select gstin: %@", gstin);
          NSLog(@"Select upi: %@", upi);
          NSLog(@"Select acname2: %@", acname2);
          NSLog(@"Select acnumber2: %@", acnumber2);
          NSLog(@"Select bankname2: %@", bankname2);
          NSLog(@"Select branch2: %@", branch2);
          NSLog(@"Select ifsc2: %@", ifsc2);
          
          [self SAVE_BANKDETAIL:acname
                   withacnumber:acnumber
                   withbankname:bankname
                   withbranch:branch
                   withifsc:ifsc
                   withgstin:gstin
                   withupi:upi
                   withacname2:acname2
                   withacnumber2:acnumber2
                   withbank2:bankname2
                   withbranch2:branch2
                   withifsc2:ifsc2];

      };
      [self presentViewController:popupVC animated:YES completion:nil];
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark: -  Button Action Method

- (IBAction)btn_qrcode2:(id)sender {
    imgfullVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"imgfullVC"];
    obj.imageUrlString = str_qrcode;
    obj.str_img2 = @"";
    obj.str_img3 = @"";
    obj.str_img4 = @"";
    obj.str_img5 = @"";
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)btn_qrcode1:(id)sender {
    imgfullVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"imgfullVC"];
    obj.imageUrlString = str_qrcode2;
    obj.str_img2 = @"";
    obj.str_img3 = @"";
    obj.str_img4 = @"";
    obj.str_img5 = @"";
    [self.navigationController pushViewController:obj animated:YES];
}

#pragma mark: - Api Method

-(void)GET_BANKDETAIL {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance] startIndicator];
    NSString *api = [NSString stringWithFormat:@"%@", [WEB_URL URL_COMPANY_DETAIL]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *loginRequest = @"apptype=3";
    NSData *data1 = [loginRequest dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[BusyIndicator sharedInstance]stopIndicator];
            if (data.length > 0 && error == nil) {
                [self parseLogin_Api:data];
            } else {
                NSLog(@"Error: %@", error.localizedDescription);
            }
        });
    }] resume];
}

- (void)parseLogin_Api:(NSData *)data {
    @try {
        NSError *error;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        if (jsonObject && !error)
        {
            NSLog(@"Successfully deserialized...");
            NSDictionary *pDict = (NSDictionary *)jsonObject;
            NSString *str_success = [[pDict objectForKey:@"success"] description];
            NSString *str_msg = [[pDict objectForKey:@"message"] description];
            
            if ([str_success isEqualToString:@"1"])
            {
                bankDetailsData = pDict;
                NSLog(@"bank Details Data %@", bankDetailsData);
                lbl_firmname1.text = [pDict[@"accname"] description];
                lbl_accno1.text = [NSString stringWithFormat:@"A/C - %@", [pDict[@"accno"] description]];
                lbl_bankname1.text = [NSString stringWithFormat:@"Bank - %@", [pDict[@"bankname"] description]];
                lbl_branchname.text = [NSString stringWithFormat:@"Branch - %@", [pDict[@"branch"] description]];
                lbl_ifsc.text = [NSString stringWithFormat:@"IFSC - %@", [pDict[@"ifsc"] description]];
                
                lbl_firmname2.text = lbl_firmname1.text;
                lbl_accno2.text = [pDict[@"accno2"] description];
                lbl_bankname2.text = [pDict[@"bankname2"] description];
                lbl_branchname2.text = [pDict[@"branch2"] description];
                lbl_ifsc2.text = [pDict[@"ifsc2"] description];
                
                if ( [pDict[@"accno2"] description].length !=0) {
                    view_bank2.hidden = NO;
                }
                
                if ( [pDict[@"gstin"] description].length !=0 && [pDict[@"upi"] description].length !=0) {
                    view_upi.hidden = NO;
                    lbl_gst1.text = [NSString stringWithFormat:@"GSTIN - %@", [pDict[@"gstin"] description]];
                    lbl_upi1.text = [NSString stringWithFormat:@"UPI - %@", [pDict[@"upi"] description]];
                }
                
                str_qrcode = [pDict[@"qrcode"] description];
                if (str_qrcode.length == 0) {
                    btn_qrcode1.hidden = YES;
                }
                
                str_qrcode2 = [pDict[@"qrcode2"] description];
                if (str_qrcode2.length == 0) {
                    btn_qrcode2.hidden =YES;
                }
            } else {
                [self showAlertWithTitle:@"Success" andMessage:str_msg];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception.reason);
    }
}

- (void)SAVE_BANKDETAIL:(NSString *)acname
             withacnumber:(NSString *)acnumber
             withbankname:(NSString *)bankname
             withbranch:(NSString *)branch
             withifsc:(NSString *)ifsc
             withgstin:(NSString *)gstin
             withupi:(NSString *)upi
             withacname2:(NSString *)acname2
             withacnumber2:(NSString *)acnumber2
             withbank2:(NSString *)bankname2
             withbranch2:(NSString *)branch2
             withifsc2:(NSString *)ifsc2;

{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance] startIndicator];
    NSString *api = [NSString stringWithFormat:@"%@", [WEB_URL URL_SAVE_COMPANY]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
   
    NSString *loginRequest = [NSString stringWithFormat:@"apptype=3&accname=%@&accnumber=%@&bankname=%@&branch=%@&ifsc=%@&gstin=%@&upi=%@&accname2=%@&accnumber2=%@&bankname2=%@&branch2=%@&ifsc2=%@",
                              acname, acnumber, bankname, branch, ifsc, gstin, upi, acname2, acnumber2, bankname2, branch2, ifsc2];


    
    NSData *data1 = [loginRequest dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[BusyIndicator sharedInstance]stopIndicator];
            if (data.length > 0 && error == nil) {
                [self parsesave_Api:data];
            } else {
                NSLog(@"Error: %@", error.localizedDescription);
            }
        });
    }] resume];
}

- (void)parsesave_Api:(NSData *)data {
    @try {
        NSError *error;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        if (jsonObject && !error)
        {
            NSLog(@"Successfully deserialized...");
            NSDictionary *pDict = (NSDictionary *)jsonObject;
            NSString *str_success = [[pDict objectForKey:@"success"] description];
            NSString *str_msg = [[pDict objectForKey:@"message"] description];
            
            if ([str_success isEqualToString:@"1"])
            {
                [self GET_BANKDETAIL];
            } else {
                [self showAlertWithTitle:@"Failed" andMessage:str_msg];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception.reason);
    }
}


@end
