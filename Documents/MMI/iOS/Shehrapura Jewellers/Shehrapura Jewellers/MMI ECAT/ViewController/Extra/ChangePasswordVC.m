//
//  ChangePasswordVC.m
//  AirMobileShop
//
//  Created by Suresh Soni on 10/06/19.
//  Copyright © 2019 MMI Softwares. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"

@interface ChangePasswordVC ()

@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	[txt_new_password.layer setMasksToBounds:YES];
	[txt_new_password.layer setCornerRadius:10.0f];
	[txt_new_password.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
	[txt_new_password.layer setBorderWidth:1];
	
	
	[txt_old_password.layer setMasksToBounds:YES];
	[txt_old_password.layer setCornerRadius:10.0f];
	[txt_old_password.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
	[txt_old_password.layer setBorderWidth:1];
	
	
	[txt_confirm_password.layer setMasksToBounds:YES];
	[txt_confirm_password.layer setCornerRadius:10.0f];
	[txt_confirm_password.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
	[txt_confirm_password.layer setBorderWidth:1];
	
	[btn_update.layer setMasksToBounds:YES];
	[btn_update.layer setCornerRadius:10.0f];
	[btn_update.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
	[btn_update.layer setBorderWidth:1];
	
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[self.view endEditing:YES];// this will do the trick
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField==txt_old_password) {
		[txt_new_password becomeFirstResponder];
	} else if (textField==txt_new_password) {
		[txt_old_password becomeFirstResponder];
	}  else  if (textField==txt_old_password) {
		[txt_old_password resignFirstResponder];
	} else{
		[textField resignFirstResponder];
	}
	return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_update:(id)sender {
	
	if (txt_old_password.text.length ==0){
		UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
																	  message:@"Please Enter Old Password"
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
	}else if (txt_new_password.text.length ==0){
		UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
																	  message:@"Please Enter New Password"
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
	}else if (txt_confirm_password.text.length ==0){
		UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
																	  message:@"Please Enter Confirm Password"
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
	}
	else {
		
		if ([txt_new_password.text isEqualToString:txt_confirm_password.text]) {
			[self performSelectorOnMainThread:@selector(CHECK_REGISTER) withObject:nil waitUntilDone:NO];
			
		}else{
			UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
																		  message:@"Please Enter same password and confirm password"
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
		}
		
		
	}
	
}

-(void)CHECK_REGISTER {
	[[BusyIndicator sharedInstance]startIndicator];
	NSString *password=txt_new_password.text;
	NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];


	NSString *loginRequest=[NSString stringWithFormat:@"userid=%@&password=%@",userid,password];
	//	NSLog(@"response  %@",loginRequest);
	NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api= [NSString stringWithFormat:@""];

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
@end
