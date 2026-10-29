//
//  Suggestion.m
//  Jwelly Customer
//
//  Created by mmsoft116 on 05/10/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "Suggestion.h"
#import "SWRevealViewController.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"

int returnPressed = 0;
int newLine;

@interface Suggestion ()

@end

@implementation Suggestion

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(_openWithSidMenu){
        [self setUpLeftMenuBtn];
    }
    /*
     SWRevealViewController *revealController = [self revealViewController];
     [revealController panGestureRecognizer];
     [revealController tapGestureRecognizer];
     
     self.navigationController.navigationBarHidden=NO;
     self.title=@"Suggestion";
     
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
    
    
    //    // typically inside of the -(void) viewDidLoad method
    //    txt_feedback.layer.borderWidth = 5.0f;
    //    txt_feedback.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.title = self.str_type;
    txt_feedback.text = self.str_type;
    previousRect = CGRectZero;
    txt_feedback.delegate = self;
    txt_feedback.layer.borderWidth = 1.0f;
    txt_feedback.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    txt_feedback.layer.cornerRadius = 6;
    txt_feedback.textColor = [UIColor lightGrayColor];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        
        returnPressed +=1;
        
        if(returnPressed < 17){
            
            txt_feedback.frame = CGRectMake(8, 8, txt_feedback.frame.size.width, txt_feedback.frame.size.height + 17);
            
            newLine = 17*returnPressed;
            
            [UIView animateWithDuration:0.1 animations:^
                 {
                self->dock.transform = CGAffineTransformMakeTranslation(0, -250 - newLine);
            }
            ];
            
        }
    }
    
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView{
    
    UITextPosition* pos = txt_feedback.endOfDocument;
    
    CGRect currentRect = [txt_feedback caretRectForPosition:pos];
    
    if (currentRect.origin.y > previousRect.origin.y || [txt_feedback.text isEqualToString:@"\n"]){
        
        returnPressed +=1;
        
        if(returnPressed < 17 && returnPressed > 1){
            
            txt_feedback.frame = CGRectMake(8, 8, txt_feedback.frame.size.width, txt_feedback.frame.size.height + 17);
            
            newLine = 17*returnPressed;
            
            [UIView animateWithDuration:0.1 animations:^
                 {
                self->dock.transform = CGAffineTransformMakeTranslation(0, -250 - newLine);
            }
            ];
            
        }
    }
    previousRect = currentRect;
    
    
}



- (BOOL)textViewShouldBeginEditing:(UITextView *)textField {
    
    if([txt_feedback.text isEqualToString:@""] || [txt_feedback.text isEqualToString:self.str_type]){
        txt_feedback.text = @"";
    }
    
    txt_feedback.textColor = [UIColor blackColor];
    
    [UIView animateWithDuration:0.209 animations:^
     {
        self->dock.transform = CGAffineTransformMakeTranslation(0, -250 - newLine);
    }
                     completion:^(BOOL finished){}];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [txt_feedback resignFirstResponder];
        [self.view endEditing:YES];
        
        int height = returnPressed*20;
        
        [UIView animateWithDuration:0.209 animations:^
         {
            self->dock.transform = CGAffineTransformMakeTranslation(0, -height);
        }];
        
        if([txt_feedback.text isEqualToString:@""]){
            txt_feedback.textColor = [UIColor lightGrayColor];
            txt_feedback.text = self.str_type;
        }
    }
}


- (IBAction)btn_send:(id)sender {
    if (txt_feedback.text.length == 0 || [txt_feedback.text isEqualToString: self.str_type ]) {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                      message:@"Enter Message."
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
    }else{
        //        if ([self.str_type isEqualToString:@"aboutus"]) {
        //
        //        }else{
        [self scrollData_Category];
        [[BusyIndicator sharedInstance]startIndicator];
        //        }
    }
}

-(void)scrollData_Category {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSString *strValue=txt_feedback.text;
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *loginRequest=[NSString stringWithFormat:@"narr=%@&mobile=%@",strValue,mobile];
    NSString *api = [NSString stringWithFormat:@"%@",[WEB_URL URL_FEEDBACK]];
    if ([self.str_type isEqualToString:@"About us"]) {
        loginRequest=[NSString stringWithFormat:@"type=%@&aboutus=%@&mobile=%@",self.str_type,strValue,mobile];
        api = [NSString stringWithFormat:@"%@",[WEB_URL URL_SaveAboutUs]];
    }
    NSLog(@"response  %@",loginRequest);
    NSLog(@"Api name url   %@",api);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:60.0];
    //Apply the data to the body
    [request setHTTPBody:data1];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        // handle response
        if ([data length] >0 && error == nil){
            //process the JSON response
            //use the main queue so that we can interact with the screen
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_category:data];
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



- (void) parseResponse_category:(NSData *) data {
    @try {
        
        ////////////// End processs load view
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        
        [[BusyIndicator sharedInstance]stopIndicator];
        NSError *error = nil;
        
        //parsing the JSON response
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            
            //check if the country code was valid
            NSDictionary *pDict = [NSJSONSerialization
                                   JSONObjectWithData:data
                                   options:NSJSONReadingAllowFragments
                                   error:&error];
            NSLog(@"pDict == %@",pDict);
            
            NSString *user = [pDict objectForKey:@"success"];
            NSString *message = [pDict objectForKey:@"message"];
            
            NSLog(@"user == %@",user);
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:nil
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                //Handel your yes please button action here
                [alert dismissViewControllerAnimated:YES completion:nil];
                self->txt_feedback.text=@"";
                if (self.onCloseTapped) {
                    self.onCloseTapped();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
    }
}
@end
