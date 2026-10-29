//
//  ForgetPasswordVC.m
//  AirMobileShop
//
//  Created by Suresh Soni on 10/06/19.
//  Copyright © 2019 MMI Softwares. All rights reserved.
//

#import "ForgetPasswordVC.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"

@interface ForgetPasswordVC ()

@end

@implementation ForgetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	
	[txt_email.layer setMasksToBounds:YES];
	[txt_email.layer setCornerRadius:10.0f];
	[txt_email.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
	[txt_email.layer setBorderWidth:1];
	
	[btn_reset_password.layer setMasksToBounds:YES];
	[btn_reset_password.layer setCornerRadius:10.0f];
	[btn_reset_password.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
	[btn_reset_password.layer setBorderWidth:1];
	
	
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[self.view endEditing:YES];// this will do the trick
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if (textField==txt_email) {
		[txt_email resignFirstResponder];
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

- (IBAction)btn_reset:(id)sender {
	
	if (txt_email.text.length ==0){
		UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
																	  message:@"Please Enter Email ID"
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
		[self performSelectorOnMainThread:@selector(CHECK_REGISTER) withObject:nil waitUntilDone:NO];
	}
		
}

-(void)CHECK_REGISTER {

	[[BusyIndicator sharedInstance]startIndicator];
	NSString *email=txt_email.text;

	
	NSString *loginRequest=[NSString stringWithFormat:@"email=%@",email];
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
