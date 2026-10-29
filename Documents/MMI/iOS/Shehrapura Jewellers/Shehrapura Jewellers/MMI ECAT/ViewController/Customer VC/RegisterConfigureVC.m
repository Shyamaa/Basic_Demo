//
//  RegisterConfigureVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 16/06/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "RegisterConfigureVC.h"

@interface RegisterConfigureVC()
{
    NSMutableArray *charArray;
}
@end

@implementation RegisterConfigureVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Register Configure";
    charArray = [NSMutableArray array];
    [self apiRegisterConfigure:@"" type:@"GET"];
}

-(void)setUpSelectedButton{
    _btnEmail.selected = [[charArray objectAtIndex:0] isEqualToString:@"1"];
    _btnName.selected = [[charArray objectAtIndex:1] isEqualToString:@"1"];
    _btnAddress.selected = [[charArray objectAtIndex:2] isEqualToString:@"1"];
    _btnGstNo.selected = [[charArray objectAtIndex:3] isEqualToString:@"1"];
    _btnPanCard.selected = [[charArray objectAtIndex:4] isEqualToString:@"1"];
    _btnInterestedIn.selected = [[charArray objectAtIndex:5] isEqualToString:@"1"];
}

#pragma mark - Button Action Method

-(IBAction)selectedButtonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    NSString *newValue = sender.selected ? @"1" : @"0";
    [charArray replaceObjectAtIndex:sender.tag withObject:newValue];
}

-(IBAction)saveButtonAction:(id)sender{
    NSString *str_Output = [charArray componentsJoinedByString:@""];
    NSLog(@"str_Output = %@", str_Output);
    [self apiRegisterConfigure:str_Output type:@"Save"];
}

#pragma mark -  API Method

- (void)apiRegisterConfigure:(NSString *)str_reg_menu type:(NSString *)str_type{
    [[BusyIndicator sharedInstance]startIndicator];
    //NSString *str_mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSString *api = [NSString stringWithFormat:@"%@", [WEB_URL URL_Register_config]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *postString = [NSString stringWithFormat:@"reg_menu=%@&type=%@",str_reg_menu,str_type];
    //NSString *postString = [NSString stringWithFormat:@"mobile=%@", str_mobile];
    NSLog(@"Register config Param = %@", postString);
    NSLog(@"Register config Url = %@", url);
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            [[BusyIndicator sharedInstance]stopIndicator];
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonDict) {
                NSLog(@"Register config Response = %@", jsonDict);
                NSString *status = jsonDict[@"success"];
                NSString *message = jsonDict[@"message"];
                if ([status isEqualToString:@"1"]) {
                    for (NSInteger i = 0; i < [message length]; i++) {
                        NSString *character = [NSString stringWithFormat:@"%C", [message characterAtIndex:i]];
                        [self->charArray addObject:character];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([str_reg_menu isEqualToString:@""]){
                            [self setUpSelectedButton];
                        }else{
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self alertMsg:message];
                    });
                }
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

@end
