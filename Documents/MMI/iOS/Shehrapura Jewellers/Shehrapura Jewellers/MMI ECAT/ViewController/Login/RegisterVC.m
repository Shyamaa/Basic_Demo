//
//  RegisterVC.m
//  AirMobileShop
//
//  Created by Suresh Soni on 09/06/19.
//  Copyright © 2019 MMI Softwares. All rights reserved.
//

#import "RegisterVC.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "LoginVC.h"
#import "HomeVC.h"

@interface RegisterVC ()
{
    NSMutableArray *charArray;
}
@end

@implementation RegisterVC
@synthesize str_mobile,str_ccode,str_cname;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Register";
    charArray = [NSMutableArray array];
    
    self.countryname = @[@"+61 (Australia)", @"+973 (Bahrain)", @"+1 (Canada)", @"+357 (Cyprus)", @"+358 (Finland)", @"+33 (France)"
                          , @"+995 (Georgia)"
                          , @"+49 (Germany)"
                          , @"+30 (Greece)"
                          , @"+852 (Hong Kong)"
                          , @"+91 (India)"
                          , @"+39 (Italy)"
                          , @"+965 (Kuwait)"
                          , @"+961 (Lebanon)"
                          , @"+60 (Malasiya)"
                          , @"+52 (Mexico)"
                          , @"+977 (Nepal)"
                          , @"+64 (Newzeland)"
                          , @"+63 (Philippine)"
                          , @"+351 (Porutgal)"
                          , @"+974 (Qatar)"
                          , @"+966 (Saudi Arabia)"
                          , @"+65 (Singapore)"
                          , @"+34 (Spain)"
                          , @"+971 (United Arab Emirates)"
                          , @"+44 (United Kingdom"
                          , @"+1 (United States)"
                          , @"+880 (Bangladesh)"];
    
    self.countryCodes = @[@"61", @"973", @"1", @"357", @"358", @"33", @"995", @"49", @"30", @"852", @"91", @"39", @"965", @"961", @"60", @"52", @"977", @"64", @"63", @"351", @"974", @"966", @"65", @"34", @"971", @"44", @"1", @"880"];
    
    if (str_ccode.length == 0) {
        str_countrycode =@"91";
        str_countryname = @"+91 (India)";
    }else{
        str_countryname = str_cname;
        str_countrycode = str_ccode;

    }
    [btn_countrycode.layer setMasksToBounds:YES];
    [btn_countrycode.layer setCornerRadius:10.0f];
    [btn_countrycode.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [btn_countrycode.layer setBorderWidth:1];
    
    //[btn_countrycode setTitle:str_countryname forState:UIControlStateNormal];

    NSLog(@"countrycode ::::::::::::::: %@",str_countryname);
    NSLog(@"countrycode ::::::::::::::: %@",str_countryname);
    NSString *countryCode = [NSString stringWithFormat:@"+%@", self->str_countrycode];
    [self->btn_countrycode setTitle : countryCode forState:UIControlStateNormal];
    
    [txt_name.layer setMasksToBounds:YES];
    [txt_name.layer setCornerRadius:10.0f];
    [txt_name.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [txt_name.layer setBorderWidth:1];
    
    [txt_mobile.layer setMasksToBounds:YES];
    [txt_mobile.layer setCornerRadius:10.0f];
    [txt_mobile.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [txt_mobile.layer setBorderWidth:1];

    [btn_register.layer setMasksToBounds:YES];
    [btn_register.layer setCornerRadius:10.0f];
    [btn_register.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [btn_register.layer setBorderWidth:1];
    
    [txt_Email.layer setMasksToBounds:YES];
    [txt_Email.layer setCornerRadius:10.0f];
    [txt_Email.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [txt_Email.layer setBorderWidth:1];
    
    [txt_FirmName.layer setMasksToBounds:YES];
    [txt_FirmName.layer setCornerRadius:10.0f];
    [txt_FirmName.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [txt_FirmName.layer setBorderWidth:1];
    
    [txt_Address.layer setMasksToBounds:YES];
    [txt_Address.layer setCornerRadius:10.0f];
    [txt_Address.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [txt_Address.layer setBorderWidth:1];
    
    [txt_GstIn.layer setMasksToBounds:YES];
    [txt_GstIn.layer setCornerRadius:10.0f];
    [txt_GstIn.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [txt_GstIn.layer setBorderWidth:1];
    
    [txt_Pancard.layer setMasksToBounds:YES];
    [txt_Pancard.layer setCornerRadius:10.0f];
    [txt_Pancard.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [txt_Pancard.layer setBorderWidth:1];
    
    [txt_interestedin.layer setMasksToBounds:YES];
    [txt_interestedin.layer setCornerRadius:10.0f];
    [txt_interestedin.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [txt_interestedin.layer setBorderWidth:1];
    
    txt_mobile.text =str_mobile;
    [self apiRegisterConfigure:@"" type:@"GET"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

-(void)setUpFieldView{
    emailIdStackView.hidden = [[charArray objectAtIndex:0] isEqualToString:@"1"];
    firmNameStackView.hidden = [[charArray objectAtIndex:1] isEqualToString:@"1"];
    addressStackView.hidden = [[charArray objectAtIndex:2] isEqualToString:@"1"];
    gstInStackView.hidden = [[charArray objectAtIndex:3] isEqualToString:@"1"];
    panCardStackView.hidden = [[charArray objectAtIndex:4] isEqualToString:@"1"];
    interestedInStackView.hidden = [[charArray objectAtIndex:5] isEqualToString:@"1"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==txt_name) {
        [txt_mobile becomeFirstResponder];
    } else if (textField==txt_mobile) {
        [txt_Email becomeFirstResponder];
    } else if (textField==txt_Email) {
        [txt_FirmName becomeFirstResponder];
    } else if (textField==txt_FirmName) {
        [txt_Address becomeFirstResponder];
    } else if (textField==txt_Address) {
        [txt_GstIn becomeFirstResponder];
    } else if (textField==txt_GstIn) {
        [txt_Pancard becomeFirstResponder];
    } else if (textField==txt_Pancard) {
        [txt_interestedin becomeFirstResponder];
    }   else{
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

- (IBAction)btn_country:(id)sender {
    [self Alertswid];
}

-(void)CHECK_REGISTER {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];

    NSString *username=txt_name.text;
    NSString *emailid=txt_Email.text;
    NSString *mobile=txt_mobile.text;
    NSString *address=txt_Address.text;

    NSString *firmName=txt_FirmName.text;
    NSString *gst=txt_GstIn.text;
    NSString *panCard=txt_Pancard.text;
    NSString *interested=txt_interestedin.text;
    
    NSString *loginRequest=[NSString stringWithFormat:@"mobile=%@&name=%@&emailid=%@&address=%@&firmname=%@&gstin=%@&pancard=%@&interested=%@",mobile,username,emailid,address,firmName,gst,panCard,interested];
    
    NSLog(@"response  %@",loginRequest);
    NSLog(@"URl ::::::::::::::::::::::::::::::::::  %@",[WEB_URL URL_SIGNUP]);

    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@"%@",[WEB_URL URL_SIGNUP]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if ([data length] >0 && error == nil){
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
                ConfirmPin *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmPin"];
                obj.str_mobile=txt_mobile.text;
                [self.navigationController pushViewController:obj animated:YES];
                
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


-(void)Alertswid {
    UIViewController *controller = [[UIViewController alloc]init];
    CGRect rect;
    
    rect = CGRectMake(0, 0, self.view.frame.size.width-10, 400);
    [controller setPreferredContentSize:rect.size];
    
    [alertTableView reloadData];
    alertTableView  = [[UITableView alloc]initWithFrame:rect];
    alertTableView.delegate = self;
    alertTableView.dataSource = self;
    alertTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [alertTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [alertTableView setTag:1000];
    [controller.view addSubview:alertTableView];
    [controller.view bringSubviewToFront:alertTableView];
    [controller.view setUserInteractionEnabled:YES];
    [alertTableView setUserInteractionEnabled:YES];
    [alertTableView setAllowsSelection:YES];
    
    alertController = [UIAlertController alertControllerWithTitle:NULL message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:controller forKey:@"contentViewController"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"000000000000");
        self->str_countrycode = @"";
        self->str_countryname = @"";

    }];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"000000000000");
        //[self->btn_countrycode setTitle:self->str_countryname forState:UIControlStateNormal];
        NSString *countryCode = [NSString stringWithFormat:@"+%@", self->str_countrycode];
        [self->btn_countrycode setTitle : countryCode forState:UIControlStateNormal];
    }];
    [alertController addAction:doneAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.countryname count];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    CountryCell *cell = (CountryCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[CountryCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    cell.textLabel.text = [self.countryname objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    str_countryname = [self.countryname objectAtIndex:indexPath.row];
    str_countrycode = [self.countryCodes objectAtIndex:indexPath.row];

    NSLog(@"str_countryname ::%@",str_countryname);
    NSLog(@"strcode ::%@",str_countrycode);

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
                            [self setUpFieldView];
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
