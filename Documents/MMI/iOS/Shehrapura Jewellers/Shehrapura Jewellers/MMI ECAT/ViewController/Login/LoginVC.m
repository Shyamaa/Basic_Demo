//
//  ViewController.m
//  AirMobileShop
//
//  Created by MMI SOFTWARE on 06/06/19.
//  Copyright © 2019 MMI Softwares. All rights reserved.
//

#import "LoginVC.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "HomeVC.h"
#import "CountryListDataSource.h"
#import "CountryCell.h"
#import "RegisterVC.h"

@interface LoginVC ()
{
    NSString *str_type;
}

@end

@implementation LoginVC

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
   
    
	self.navigationController.navigationBarHidden=NO;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    NSLog(@"screenHeight ::%f",screenRect.size.width);
   
    webUrlconstant *classA = [webUrlconstant sharedInstance];
    str_type =[classA APPTYPE];
    
    if (![str_type isEqualToString:@"3"]) {
        self.navigationItem.hidesBackButton = YES;
    }
   
    
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
    
    str_countrycode = @"91";
    str_countryname = @"+91 (India)";
    NSString *countryCode = [NSString stringWithFormat:@"+%@", self->str_countrycode];
    [self->btn_countrycode setTitle : countryCode forState:UIControlStateNormal];

    [txt_swid.layer setMasksToBounds:YES];
    [txt_swid.layer setCornerRadius:10.0f];
    [txt_swid.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [txt_swid.layer setBorderWidth:1];
    
	[txt_mobile.layer setMasksToBounds:YES];
	[txt_mobile.layer setCornerRadius:10.0f];
	[txt_mobile.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
	[txt_mobile.layer setBorderWidth:1];
	
	[btn_countrycode.layer setMasksToBounds:YES];
	[btn_countrycode.layer setCornerRadius:10.0f];
	[btn_countrycode.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
	[btn_countrycode.layer setBorderWidth:1];
	
	[btn_login.layer setMasksToBounds:YES];
	[btn_login.layer setCornerRadius:10.0f];
	[btn_login.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
	[btn_login.layer setBorderWidth:1];
    
    
    if ([str_type isEqualToString:@"3"]) {
        txt_swid.hidden = YES;
        btn_countrycode.hidden = NO;
    }else{
        btn_register.hidden = YES;
        btn_countrycode.hidden = YES;
    }
	
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField==txt_mobile) {
		[txt_mobile resignFirstResponder];
	}  else{
		[textField resignFirstResponder];
	}
	return YES;
}

- (IBAction)btn_login:(id)sender {
	
	if (txt_mobile.text.length ==0){
		UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
																	  message:@"Please Enter Your Register Mobile Number"
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
	}else {
        if ([str_type isEqualToString:@"3"]) {
            [self performSelectorOnMainThread:@selector(CHECK_LOGIN) withObject:nil waitUntilDone:NO];

        }else{
            if([txt_swid.text isEqualToString:@"SQLECAT"] || [txt_swid.text isEqualToString:@"SQLQR"]){
                [self performSelectorOnMainThread:@selector(RegisterDemo) withObject:nil waitUntilDone:NO];
            }else{
                [self performSelectorOnMainThread:@selector(CHECK_SWID) withObject:nil waitUntilDone:NO];
            }
            
        }
    }
}

-(void)CHECK_SWID {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile=txt_mobile.text;
    NSString *softid=txt_swid.text;
    NSString *comtype=@"4";
    NSString *product=@"E-CAT MOBILE APP";
    NSString* deviceid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    NSLog(@"deviceid :: %@",deviceid);
    
    NSString *loginRequest=[NSString stringWithFormat:@"mobile=%@&softid=%@&comtype=%@&product=%@&deviceid=%@",mobile,softid,comtype,product,deviceid];
    NSLog(@"response  %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@"%@",[WEB_URL URL_CHECK_MOBILE_SWID]];
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
                [self parseLogin_SWIDApi:data];
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


- (void)parseLogin_SWIDApi:(NSData *) data {
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
            
            NSMutableArray *nsarray_data1 = [pDict objectForKey:@"register"];
            for (int i = 0; i < [nsarray_data1 count]; i++) {
                
                NSDictionary * dictObject = [nsarray_data1 objectAtIndex:i];
                NSString *str_msg = [dictObject objectForKey:@"msg"];

                NSInteger int_msg =[str_msg intValue];
                NSLog(@"int_msg %ld",(long)int_msg);

                if (int_msg == 0) {
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
                    
                } else {
                    ConfirmPin *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmPin"];
                    obj.str_regmobile=str_msg;
                    obj.str_swid=txt_swid.text;
                    obj.str_mobile=txt_mobile.text;

                    [self.navigationController pushViewController:obj animated:YES];
                }
            }

        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}


-(void)RegisterDemo {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile=txt_mobile.text;
    NSString *softid=txt_swid.text;
    NSString *comtype=@"4";
    NSString *product=@"E-CAT MOBILE APP";
    NSString* deviceid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    NSLog(@"deviceid :: %@",deviceid);
    
    NSString *loginRequest=[NSString stringWithFormat:@"mobile=%@&softid=%@&comtype=%@&product=%@&deviceid=%@",mobile,softid,comtype,product,deviceid];
    NSLog(@"response  %@",loginRequest);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@"%@",[WEB_URL URL_REGISTER_DEMO]];
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
                [self parseLogin_DEMO:data];
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


- (void)parseLogin_DEMO:(NSData *) data {
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
            
            NSMutableArray *nsarray_data1 = [pDict objectForKey:@"register"];
            for (int i = 0; i < [nsarray_data1 count]; i++) {
                
                NSDictionary * dictObject = [nsarray_data1 objectAtIndex:i];
                NSString *str_msg = [dictObject objectForKey:@"msg"];

                NSInteger int_msg =[str_msg intValue];
                NSLog(@"int_msg %ld",(long)int_msg);

                if (int_msg == 0) {
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
                    
                } else {
                    ConfirmPin *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmPin"];
                    obj.str_regmobile=str_msg;
                    obj.str_swid=txt_swid.text;
                    obj.str_mobile=txt_mobile.text;
                    [self.navigationController pushViewController:obj animated:YES];
                }
            }

        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}


-(void)CHECK_LOGIN {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

	[[BusyIndicator sharedInstance]startIndicator];
	NSString *mobile=txt_mobile.text;

	NSString *loginRequest=[NSString stringWithFormat:@"mobile=%@&countrycode=%@",mobile,str_countrycode];
	//	NSLog(@"response  %@",loginRequest);
	NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@"%@",[WEB_URL URL_CHECK_MOBILE]];
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
//			NSMutableArray *nsarray_msg = [pDict objectForKey:@"message"];
//			NSString *str_msg = [nsarray_msg description];
			
			if ([str_success isEqualToString:@"1"]) {
			
				ConfirmPin *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmPin"];
                obj.str_mobile = txt_mobile.text;
                obj.countrycode = str_countrycode;
				[self.navigationController pushViewController:obj animated:YES];
			}else{
                RegisterVC *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVC"];
                obj.str_mobile= txt_mobile.text;
                obj.str_ccode = str_countrycode;
                obj.str_cname = str_countryname;
                [self.navigationController pushViewController:obj animated:YES];
			}
		}
	}
	@catch (NSException *exception) {
	}
	@finally {
	}
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
        //[self->btn_countrycode setTitle:self->str_countryname forState:UIControlStateNormal];
        
        NSString *countryCode = [NSString stringWithFormat:@"+%@", self->str_countrycode];
        [self->btn_countrycode setTitle : countryCode forState:UIControlStateNormal];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:doneAction];
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

- (IBAction)done:(id)sender
{
    [self Alertswid];
}


- (IBAction)btn_register:(id)sender
{
    RegisterVC *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVC"];
    obj.str_mobile = txt_mobile.text;
    obj.str_ccode = str_countrycode;
    obj.str_cname = str_countryname;
    [self.navigationController pushViewController:obj animated:YES];
}

@end
