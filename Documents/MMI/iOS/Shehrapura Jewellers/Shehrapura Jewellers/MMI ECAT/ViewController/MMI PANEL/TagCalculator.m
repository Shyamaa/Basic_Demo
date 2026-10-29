//
//  TagCalculator.m
//  Jwelly Customer
//
//  Created by MMI SOFTWARES PVT LTD on 20/11/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "TagCalculator.h"
#import "MMIHOMEPanel.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "ImageCache.h"
#import "ScanViewController.h"

@interface TagCalculator ()
{}
@end

@implementation TagCalculator

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tag Calculator";
    [self setUpNavigation];
    str_item_width1 = @"0";
    str_item_width2 = @"0";
    str_item_width3 = @"0";
    str_item_width4 = @"0";
    str_item_width5 = @"0";
    str_item_width6 = @"0";
    str_item_width7 = @"0";
    str_item_width8 = @"0";
    str_item_width9 = @"0";
    str_item_width10 = @"0";
    str_item_width11 = @"0";
    str_item_width12 = @"0";
    str_item_width13 = @"0";
    str_item_width14 = @"0";
    str_item_width15 = @"0";
    str_item_width16 = @"0";
    str_item_width17 = @"0";
    str_item_width18 = @"0";
    str_item_width19 = @"0";
    str_item_width20 = @"0";
    
    str_item_name1 = @"";
    str_item_name2 = @"";
    str_item_name3 = @"";
    str_item_name4 = @"";
    str_item_name5 = @"";
    str_item_name6 = @"";
    str_item_name7 = @"";
    str_item_name8 = @"";
    str_item_name9 = @"";
    str_item_name10 = @"";
    str_item_name11 = @"";
    str_item_name12 = @"";
    str_item_name13 = @"";
    str_item_name14 = @"";
    str_item_name15 = @"";
    str_item_name16 = @"";
    str_item_name17 = @"";
    str_item_name18 = @"";
    str_item_name19 = @"";
    str_item_name20 = @"";
    
    img_tag.layer.cornerRadius = 10;
    img_tag.layer.borderWidth = 1;
    img_tag.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    scrollView.backgroundColor = [UIColor clearColor];
    //[self.view addSubview:scrollView];
    allItemStackView.hidden = true;
    if(self.str_tag.length > 0){
        self->tagno = self.str_tag;
        [self scrollData_Category];
    }else{
        [self PopupView];
    }
}

#pragma mark:- Navigation method

-(void)setUpNavigation{
    UIButton *btn_item =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_item.frame = CGRectMake(0,8,30,30);
    [btn_item setBackgroundImage:[UIImage imageNamed:@"tagcalculator_menu.png"] forState:UIControlStateNormal];
    [btn_item addTarget:self action:@selector(openTagView:) forControlEvents:UIControlEventTouchUpInside];
    [[btn_item imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_item.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    btn_item.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    btn_item.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *bar_item = [[UIBarButtonItem alloc] initWithCustomView:btn_item];
    bar_item.tintColor = [UIColor whiteColor];
    
    UIButton * btn_contact =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_contact.frame = CGRectMake(0,8,30,30);
    
    btn_contact.tintColor = [UIColor whiteColor];
    [btn_contact setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [btn_contact addTarget:self action:@selector(btn_scan:) forControlEvents:UIControlEventTouchUpInside];
    [[btn_contact imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_contact.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *barcontact = [[UIBarButtonItem alloc] initWithCustomView:btn_contact];
    barcontact.tintColor = [UIColor whiteColor];
    
    UIButton *btn_Download =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Download.frame = CGRectMake(0,8,30,30);
    [btn_Download setBackgroundImage:[UIImage systemImageNamed:@"arrow.down.document.fill"]forState:UIControlStateNormal];
    [btn_Download addTarget:self action:@selector(tappedDownloadFile) forControlEvents:UIControlEventTouchUpInside];
    [[btn_Download imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_Download.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    btn_Download.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    btn_Download.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *bar_Download = [[UIBarButtonItem alloc] initWithCustomView:btn_Download];
    bar_Download.tintColor = [UIColor whiteColor];
    
    UIButton * btn_Mic =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Mic.frame = CGRectMake(0,8,30,30);
    btn_Mic.tintColor = [UIColor whiteColor];
    [btn_Mic setImage:[UIImage imageNamed:@"icon_voice"] forState:UIControlStateNormal];
    [btn_Mic addTarget:self action:@selector(btn_MicAction:) forControlEvents:UIControlEventTouchUpInside];
    [[btn_Mic imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_Mic.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *bar_Mic = [[UIBarButtonItem alloc] initWithCustomView:btn_Mic];
    bar_Mic.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 12;
    self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:bar_item,space, barcontact, bar_Download, bar_Mic, nil];
    
    //    UIBarButtonItem *btn=[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(btnClick)];
    //    self.navigationItem.leftBarButtonItem = btn;
}

#pragma mark:- Navigation Button Action Method

-(void)tappedDownloadFile{
    [self insert_tagcalculatorApi:self->tagno];
}

- (void)btn_scan:(id)sender {
    ScanViewController *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"ScanViewController"];
    obj.str_act =@"Tag Calculator";
    [self.navigationController pushViewController:obj animated:YES];
}

- (void)btn_MicAction:(id)sender {
    [self setUpListening];
    if (self.isListening) {
        NSLog(@"🛑 Stopping voice recognition");
        [self stopListening];
    } else {
        NSLog(@"🎤 Starting voice recognition");
        [self startListening];
    }
}

- (void)openTagView:(id)sender {
    [self PopupView];
}

-(void)PopupView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please enter Tagno" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Please enter Tagno";
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UITextField *txt_tagno = alertController.textFields.firstObject;
        if (![txt_tagno.text isEqualToString:@"Please enter Tagno"]) {
            self->tagno=txt_tagno.text;
            [self scrollData_Category];
        }else{
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action){
        self->tagno=@"";
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark: Voice method

- (void)startListening {
    NSLog(@"🎤 Listening started...");
    NSError *error;
    
    // Cancel any existing recognition task
    if (self.recognitionTask) {
        [self.recognitionTask cancel];
        self.recognitionTask = nil;
    }
    
    // Configure audio session with proper error handling
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    // Set audio session category with error handling
    if (![audioSession setCategory:AVAudioSessionCategoryRecord error:&error]) {
        NSLog(@"❌ Failed to set audio session category: %@", error.localizedDescription);
        [self alertMsgWithTitle: @"Failed to configure audio session. Please try again." title:@"Voice Command"];
        return;
    }
    
    // Set audio session mode with error handling
    if (![audioSession setMode:AVAudioSessionModeMeasurement error:&error]) {
        NSLog(@"❌ Failed to set audio session mode: %@", error.localizedDescription);
        [self alertMsgWithTitle:@"Failed to configure audio mode. Please try again." title:@"Voice Command"];
        return;
    }
    
    // Activate audio session with error handling
    if (![audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error]) {
        NSLog(@"❌ Failed to activate audio session: %@", error.localizedDescription);
        [self alertMsgWithTitle:@"Failed to activate audio session. Please try again." title:@"Voice Command"];
        return;
    }
    
    self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
    
    // Remove existing tap if any
    [inputNode removeTapOnBus:0];
    
    // Set to YES to get partial results and isFinal property
    self.recognitionRequest.shouldReportPartialResults = YES;
    self.isListening = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.listeningAlert = [UIAlertController alertControllerWithTitle:@"Listening..." message:@" " preferredStyle:UIAlertControllerStyleAlert];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 250, 40)];
        label.tag = 101;
        label.text = @"Speak now...";
        label.textAlignment = NSTextAlignmentCenter;
        [self.listeningAlert.view addSubview:label];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Stop" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self stopListening];
        }];
        [self.listeningAlert addAction:cancelAction];
        [self presentViewController:self.listeningAlert animated:YES completion:nil];
    });
    
    __weak typeof(self) weakSelf = self;
    __block NSString *lastSpokenText = @"";
    __block NSDate *lastUpdateTime = [NSDate date];
    
    self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        
        if (result) {
            NSString *spokenText = result.bestTranscription.formattedString;
            BOOL isFinal = result.isFinal;
            
            NSLog(@"🗣 Got result - Text: %@, isFinal: %@", spokenText, isFinal ? @"YES" : @"NO");
            
            // Update last spoken text and time
            if (spokenText.length > 0) {
                lastSpokenText = spokenText;
                lastUpdateTime = [NSDate date];
                
                // Cancel existing silence timer
                if (weakSelf.silenceTimer) {
                    [weakSelf.silenceTimer invalidate];
                    weakSelf.silenceTimer = nil;
                }
            }
            
            // Update UI with partial results
            dispatch_async(dispatch_get_main_queue(), ^{
                UILabel *label = [weakSelf.listeningAlert.view viewWithTag:101];
                if ([label isKindOfClass:[UILabel class]]) {
                    label.text = spokenText.length > 0 ? spokenText : @"Speak now...";
                }
            });
            
            // Process final result
            if (isFinal && spokenText.length > 0) {
                NSLog(@"✅ Final result received: %@", spokenText);
                
                // Cancel silence timer if it exists
                if (weakSelf.silenceTimer) {
                    [weakSelf.silenceTimer invalidate];
                    weakSelf.silenceTimer = nil;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf stopListening];
                    [weakSelf parseCommandFromSpeech:spokenText];
                });
            } else if (spokenText.length > 0) {
                // Start silence timer for partial results
                if (weakSelf.silenceTimer) {
                    [weakSelf.silenceTimer invalidate];
                }
                
                weakSelf.silenceTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
                    NSLog(@"⏰ Silence timeout reached, processing last spoken text: %@", lastSpokenText);
                    
                    if (lastSpokenText.length > 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf stopListening];
                            [weakSelf parseCommandFromSpeech:lastSpokenText];
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf stopListening];
                            [weakSelf alertMsgWithTitle:@"No speech detected. Please try again." title:@"Voice Command"];
                        });
                    }
                }];
                
                // Add a longer fallback timer (10 seconds) to ensure we stop listening
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (weakSelf.isListening) {
                        NSLog(@"⏰ Long timeout reached, forcing stop");
                        [weakSelf stopListening];
                        [weakSelf alertMsgWithTitle:@"Voice recognition timeout. Please try again." title:@"Voice Command"];
                    }
                });
            }
        }
        
        if (error) {
            NSLog(@"❌ Speech error: %@", error.localizedDescription);
            
            // Cancel silence timer
            if (weakSelf.silenceTimer) {
                [weakSelf.silenceTimer invalidate];
                weakSelf.silenceTimer = nil;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf stopListening];
                
                // Only show error alert if not navigating
                if (!weakSelf.isNavigating) {
                    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Voice Recognition Error"
                                                                                        message:error.localizedDescription
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [errorAlert addAction:okAction];
                    [weakSelf presentViewController:errorAlert animated:YES completion:nil];
                } else {
                    NSLog(@"🚫 Skipping error alert due to navigation");
                }
            });
        }
    }];
    
    // Get the output format with error handling
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    
    // Validate the format before using it
    if (!recordingFormat || recordingFormat.sampleRate <= 0 || recordingFormat.channelCount <= 0) {
        NSLog(@"❌ Invalid audio format detected. Sample rate: %f, Channel count: %lu",
              recordingFormat.sampleRate, (unsigned long)recordingFormat.channelCount);
        
        // Try different formats in order of preference
        NSArray *sampleRates = @[@44100.0, @22050.0, @16000.0, @8000.0];
        NSArray *channelCounts = @[@1, @2];
        
        BOOL formatFound = NO;
        for (NSNumber *sampleRate in sampleRates) {
            for (NSNumber *channels in channelCounts) {
                AVAudioFormat *testFormat = [[AVAudioFormat alloc] initWithCommonFormat:AVAudioPCMFormatFloat32
                                                                             sampleRate:[sampleRate doubleValue]
                                                                               channels:[channels unsignedIntegerValue]
                                                                            interleaved:NO];
                
                if (testFormat) {
                    NSLog(@"✅ Found valid format - Sample rate: %f, Channel count: %lu",
                          testFormat.sampleRate, (unsigned long)testFormat.channelCount);
                    recordingFormat = testFormat;
                    formatFound = YES;
                    break;
                }
            }
            if (formatFound) break;
        }
        
        if (!formatFound) {
            NSLog(@"❌ Failed to create valid audio format");
            [self alertMsgWithTitle:@"Audio format not supported on this device. Please try on a physical device." title:@"Voice Command"];
            return;
        }
    }
    
    NSLog(@"✅ Using audio format - Sample rate: %f, Channel count: %lu",
          recordingFormat.sampleRate, (unsigned long)recordingFormat.channelCount);
    
    // Install tap with error handling
    @try {
        [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer *buffer, AVAudioTime *when) {
            if (weakSelf.recognitionRequest) {
                [weakSelf.recognitionRequest appendAudioPCMBuffer:buffer];
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"❌ Exception while installing audio tap: %@", exception.reason);
        [self alertMsgWithTitle:@"Failed to start audio recording. Please try on a physical device." title:@"Voice Command"];
        return;
    }
    
    // Prepare and start audio engine with error handling
    [self.audioEngine prepare];
    NSError *startError = nil;
    if (![self.audioEngine startAndReturnError:&startError]) {
        NSLog(@"❌ AudioEngine start error: %@", startError.localizedDescription);
        [self alertMsgWithTitle:@"Failed to start audio engine. Please try on a physical device." title:@"Voice Command"];
        return;
    }
    NSLog(@"✅ Audio engine started successfully");
}

- (void)parseCommandFromSpeech:(NSString *)spokenText {
    NSLog(@"🎯 Processing voice command: %@", spokenText);
    
    NSString *text = [[spokenText uppercaseString] stringByReplacingOccurrencesOfString:@"HELLO MMI" withString:@""];
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSLog(@"🔍 Processed text: %@", text);
    
    if (text.length == 0) {
        NSLog(@"⚠️ Empty text after processing, ignoring command");
        [self alertMsgWithTitle:@"Please speak a valid command" title:@"Voice Command"];
        return;
    }
    
    BOOL commandRecognized = NO;
    
    if ([text containsString:@"TAG QUERY"] || [text containsString:@"TAGQUERY"] || [text containsString:@"TAKEQUERY"] || [text containsString:@"QUERY"]) {
        text = [[text stringByReplacingOccurrencesOfString:@" " withString:@""]
                stringByReplacingOccurrencesOfString:@"TO" withString:@"2"];
        
        text = [text stringByReplacingOccurrencesOfString:@"TAGQUERY" withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@"TAKEQUERY" withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@"QUERY" withString:@""];
        
        NSLog(@"✅ Navigate to TagCalculator with: %@", text);
        [self showviewitem:text strtype:@"5"];
        commandRecognized = YES;
        
    } else if ([text containsString:@"ESTIMATE"]) {
        text = [[text stringByReplacingOccurrencesOfString:@" " withString:@""]
                stringByReplacingOccurrencesOfString:@"TO" withString:@"2"];
        text = [[text stringByReplacingOccurrencesOfString:@"ESTIMATE" withString:@""]
                stringByReplacingOccurrencesOfString:@"PLUS" withString:@"+"];
        text = [text stringByReplacingOccurrencesOfString:@"PLASH" withString:@"+"];
        text = [text stringByReplacingOccurrencesOfString:@"+" withString:@","];
        
        NSLog(@"✅ Navigate to CartitemActivity with: %@", text);
        [self showviewitem:text strtype:@"4"];
        commandRecognized = YES;
        
    } else if ([text containsString:@"OUTSTANDING"] || [text containsString:@"STANDING"]) {
        NSString *cname = [text stringByReplacingOccurrencesOfString:@"OUTSTANDING " withString:@""];
        NSLog(@"✅ Navigate to OutStanding with: %@", cname);
        [self showviewitem:cname strtype:@"3"];
        commandRecognized = YES;
        
    } else if ([text containsString:@"LASER"] || [text containsString:@"PLEASURE"] || [text containsString:@"LEISURE"]) {
        NSString *cname = [[text stringByReplacingOccurrencesOfString:@"LEDGER " withString:@""]
                           stringByReplacingOccurrencesOfString:@"LASER " withString:@""];
        cname = [cname stringByReplacingOccurrencesOfString:@"PLEASURE " withString:@""];
        cname = [cname stringByReplacingOccurrencesOfString:@"LEISURE " withString:@""];
        NSLog(@"✅ Navigate to LedgerDetails with: %@", cname);
        [self showviewitem:cname strtype:@"2"];
        commandRecognized = YES;
        
    } else if ([text containsString:@"PRODUCT"]) {
        NSString *pname = [text stringByReplacingOccurrencesOfString:@"PRODUCT " withString:@""];
        pname = [pname stringByReplacingOccurrencesOfString:@"GALLERY " withString:@""];
        NSLog(@"✅ Navigate to ShowitemActivity with: %@", pname);
        [self showviewitem:pname strtype:@"1"];
        commandRecognized = YES;
    }
    
    if (!commandRecognized) {
        NSLog(@"❌ No recognized command found in: %@", text);
        [self alertMsgWithTitle:[NSString stringWithFormat:@"Command not recognized: %@", text] title:@"Voice Command"];
    }
}

- (void)showviewitem:(NSString *)pname strtype:(NSString *)strtype {
    NSLog(@"🚀 Navigating to page with: %@, type: %@", pname, strtype);
    
    // Stop voice recognition immediately
    if (self.isListening) {
        NSLog(@"🛑 Stopping voice recognition due to navigation");
        [self stopListening];
    }
    
    // Set navigation flag to prevent error alerts
    self.isNavigating = YES;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if ([strtype isEqualToString:@"1"]) {
        Showitem *obj = [storyboard instantiateViewControllerWithIdentifier:@"Showitem"];
        obj.str_idesc = pname;
        obj.str_siteid = @"";
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:obj animated:YES];
        });
    } else if ([strtype isEqualToString:@"5"]) {
        TagCalculator *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"TagCalculator"];
        obj.str_tag = pname;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:obj animated:YES];
        });
    }
}

#pragma mark:- API method

-(void)scrollData_Category {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *apptype=[NSString stringWithFormat:@"%@",ECAT_TYPE];
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&tgno=%@&mobile=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,tagno,mobile,ip,db,ipusername,pswd,ftppath];
        URL_API =[WEB_URL URL_SETDESIGNDATA];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_setdesigndata.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&tgno=%@&mobile=%@&ftppath=%@",apptype,tagno,mobile,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&tgno=%@&mobile=%@",apptype,tagno,mobile];
        URL_API =[WEB_URL URL_SETDESIGNDATA];
    }
    
    NSLog(@"Param = %@", loginRequest);
    NSLog(@"Tag Url = %@", URL_API);
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:60.0];
    //Apply the data to
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
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [[BusyIndicator sharedInstance]stopIndicator];
        
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        NSLog(@"Tag Responce = %@", jsonObject);
        
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            //check if the country code was valid
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            NSMutableArray * rensarray_data =[[NSMutableArray alloc]init];
            rensarray_data = [pDict objectForKey:@"data"];
            NSLog(@"nsarray_data :: %@",rensarray_data);
            if (rensarray_data.count > 0){
                str_image=@"";
                allItemStackView.hidden = false;
                for (int i = 0; i < [rensarray_data count]; i++) {
                    
                    NSDictionary * dictObject = [rensarray_data objectAtIndex:i];
                    NSString *caption = [dictObject objectForKey:@"caption"];
                    NSString *value = [dictObject objectForKey:@"value"];
                    NSString *imageby = [dictObject objectForKey:@"imageby"];
                    NSString *itemimage = [dictObject objectForKey:@"itemimage"];
                    NSString *itemname = [dictObject objectForKey:@"itemname"];
                    if ([imageby isEqualToString:@"1"] && [itemname isEqualToString:@"design"]) {
                        str_image =itemimage;
                        /*
                         [[ImageCache sharedInstance] downloadImageAtURL:[NSURL URLWithString:itemimage]
                         completionHandler:^(UIImage *image) {
                         self->img_tag.image = image;
                         [[BusyIndicator sharedInstance]stopIndicator];
                         }];
                         */
                        [self->img_tag sd_setImageWithURL:[NSURL URLWithString:itemimage]
                                         placeholderImage:[UIImage imageNamed:@"1024.png"]
                                                  options:SDWebImageRefreshCached];
                        //[self.view addSubview:img_tag];
                        
                    }else if ([imageby isEqualToString:@"0"] && [itemname isEqualToString:@"tgno"]) {
                        str_image =itemimage;
                        /*
                         [[ImageCache sharedInstance] downloadImageAtURL:[NSURL URLWithString:itemimage]
                         completionHandler:^(UIImage *image) {
                         self->img_tag.image = image;
                         [[BusyIndicator sharedInstance]stopIndicator];
                         }];
                         */
                        [self->img_tag sd_setImageWithURL:[NSURL URLWithString:itemimage]
                                         placeholderImage:[UIImage imageNamed:@"1024.png"]
                                                  options:SDWebImageRefreshCached];
                        
                        [self setUpView];
                    }else{
                        str_image =itemimage;
                        [self->img_tag sd_setImageWithURL:[NSURL URLWithString:itemimage]
                                         placeholderImage:[UIImage imageNamed:@"1024.png"]
                                                  options:SDWebImageRefreshCached];
                        [self setUpView];
                    }
                    
                    
                    if (i==0) {
                        str_tsno = [dictObject objectForKey:@"tsno"];
                        lbl_key1.text=[NSString stringWithFormat:@"%@",caption];
                        lbl_value1.text=[NSString stringWithFormat:@"%@",value];
                    }
                    
                    if (i==1) {
                        lbl_key2.text=[NSString stringWithFormat:@"%@",caption];
                        lbl_value2.text=[NSString stringWithFormat:@"%@",value];
                    }
                    
                    if (i==2) {
                        lbl_key3.text=[NSString stringWithFormat:@"%@",caption];
                        lbl_value3.text=[NSString stringWithFormat:@"%@",value];
                    }
                    
                    if (i==3) {
                        lbl_key4.text=[NSString stringWithFormat:@"%@",caption];
                        lbl_value4.text=[NSString stringWithFormat:@"%@",value];
                    }
                    
                    if (i==4) {
                        lbl_key5.text=[NSString stringWithFormat:@"%@",caption];
                        lbl_value5.text=[NSString stringWithFormat:@"%@",value];
                    }
                    
                    if (i==5) {
                        lbl_key6.text=[NSString stringWithFormat:@"%@",caption];
                        lbl_value6.text=[NSString stringWithFormat:@"%@",value];
                    }
                    
                    if (i==6) {
                        lbl_key7.text=[NSString stringWithFormat:@"%@",caption];
                        lbl_value7.text=[NSString stringWithFormat:@"%@",value];
                    }
                    
                    if (i==7) {
                        lbl_key8.text=[NSString stringWithFormat:@"%@",caption];
                        lbl_value8.text=[NSString stringWithFormat:@"%@",value];
                    }
                    
                    if (i==8) {
                        lbl_key9.text=[NSString stringWithFormat:@"%@",caption];
                        lbl_value9.text=[NSString stringWithFormat:@"%@",value];
                    }
                    if (i==9) {
                        lbl_key10.text=[NSString stringWithFormat:@"%@",caption];
                        lbl_value10.text=[NSString stringWithFormat:@"%@",value];
                    }
                    if (i==10) {
                        lbl_key11.text=[NSString stringWithFormat:@"%@",caption];
                        lbl_value11.text=[NSString stringWithFormat:@"%@",value];
                    }
                    if (i==11) {
                        lbl_key12.text=[NSString stringWithFormat:@"%@",caption];
                        lbl_value12.text=[NSString stringWithFormat:@"%@",value];
                    }
                    if (i==12) {
                        lbl_key13.text=[NSString stringWithFormat:@"%@",caption];
                        lbl_value13.text=[NSString stringWithFormat:@"%@",value];
                    }
                    if (i==13) {
                        lbl_key14.text=[NSString stringWithFormat:@"%@",caption];
                        lbl_value14.text=[NSString stringWithFormat:@"%@",value];
                    }
                    
                    
                    if (i==14) {
                        lbl_key15.text=[NSString stringWithFormat:@"%@",caption];
                        lbl_value15.text=[NSString stringWithFormat:@"%@",value];
                    }
                    
                    if (i==15) {
                        lbl_key16.text=[NSString stringWithFormat:@"%@",caption];
                        lbl_value16.text=[NSString stringWithFormat:@"%@",value];
                    }
                    
                    if (i==16) {
                        lbl_key17.text=[NSString stringWithFormat:@"%@",caption];
                        lbl_value17.text=[NSString stringWithFormat:@"%@",value];
                    }
                    
                    if (i==17) {
                        lbl_key18.text=[NSString stringWithFormat:@"%@",caption];
                        lbl_value18.text=[NSString stringWithFormat:@"%@",value];
                    }
                    
                    if (i==18) {
                        lbl_key19.text=[NSString stringWithFormat:@"%@",caption];
                        lbl_value19.text=[NSString stringWithFormat:@"%@",value];
                    }
                    
                    if (i==19) {
                        lbl_key20.text=[NSString stringWithFormat:@"%@",caption];
                        lbl_value20.text=[NSString stringWithFormat:@"%@",value];
                    }
                    
                    if (i==20) {
                        lbl_key21.text=[NSString stringWithFormat:@"%@",caption];
                        lbl_value21.text=[NSString stringWithFormat:@"%@",value];
                    }
                    [self scrollData_STUDD];
                    
                    
                }
            }else{
                [self alertMsg:@"No Record Found"];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)scrollData_STUDD {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *apptype=[NSString stringWithFormat:@"%@",ECAT_TYPE];
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&tsno=%@&mobile=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,str_tsno,mobile,ip,db,ipusername,pswd,ftppath];
        URL_API =[WEB_URL URL_STUDD];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_studddata.php",ip];
        loginRequest=[NSString stringWithFormat:@"apptype=%@&tsno=%@&mobile=%@&ftppath=%@",apptype,str_tsno,mobile,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&tsno=%@&mobile=%@",apptype,str_tsno,mobile];
        URL_API =[WEB_URL URL_STUDD];
    }
    
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:60.0];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_datastudd:data];
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

- (void) parseResponse_datastudd:(NSData *) data {
    @try {
        
        [[BusyIndicator sharedInstance]stopIndicator];
        
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            //check if the country code was valid
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            nsarray_data =[[NSMutableArray alloc]init];
            nsarray_datadata =[[NSMutableArray alloc]init];
            nsarray_data = [pDict objectForKey:@"data"];
            nsarray_datadata = [pDict objectForKey:@"datadata"];
            
            ns_item1 =[[NSMutableArray alloc]init];
            ns_item2 =[[NSMutableArray alloc]init];
            ns_item3 =[[NSMutableArray alloc]init];
            ns_item4 =[[NSMutableArray alloc]init];
            ns_item5 =[[NSMutableArray alloc]init];
            ns_item6 =[[NSMutableArray alloc]init];
            ns_item7 =[[NSMutableArray alloc]init];
            ns_item8 =[[NSMutableArray alloc]init];
            ns_item9 =[[NSMutableArray alloc]init];
            ns_item10 =[[NSMutableArray alloc]init];
            
            ns_item11 =[[NSMutableArray alloc]init];
            ns_item12 =[[NSMutableArray alloc]init];
            ns_item13 =[[NSMutableArray alloc]init];
            ns_item14 =[[NSMutableArray alloc]init];
            ns_item15 =[[NSMutableArray alloc]init];
            ns_item16 =[[NSMutableArray alloc]init];
            ns_item17 =[[NSMutableArray alloc]init];
            ns_item18 =[[NSMutableArray alloc]init];
            ns_item19 =[[NSMutableArray alloc]init];
            ns_item20 =[[NSMutableArray alloc]init];
            
            [ns_item1 addObject:@""];
            [ns_item2 addObject:@""];
            [ns_item3 addObject:@""];
            [ns_item4 addObject:@""];
            [ns_item5 addObject:@""];
            [ns_item6 addObject:@""];
            [ns_item7 addObject:@""];
            [ns_item8 addObject:@""];
            [ns_item9 addObject:@""];
            [ns_item10 addObject:@""];
            [ns_item11 addObject:@""];
            [ns_item12 addObject:@""];
            [ns_item13 addObject:@""];
            [ns_item14 addObject:@""];
            [ns_item15 addObject:@""];
            [ns_item16 addObject:@""];
            [ns_item17 addObject:@""];
            [ns_item18 addObject:@""];
            [ns_item19 addObject:@""];
            [ns_item20 addObject:@""];
            
            
            NSLog(@" nsarray_data :::::::::::::::: %@",nsarray_data);
            NSInteger int_total;
            for (int i = 0; i < [nsarray_data count]; i++) {
                NSDictionary * dictObject = [nsarray_data objectAtIndex:i];
                NSString *width = [dictObject objectForKey:@"width"];
                NSInteger int_width = [width intValue];
                int_total =int_total+int_width;
            }
            
            
            
            if ([nsarray_data count]==1) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_name1=[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
            }
            
            if ([nsarray_data count]==2) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                
                str_item_name1=[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2=[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
            }
            
            if ([nsarray_data count]==3) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                
                str_item_name1=[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2=[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3=[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
            }
            
            if ([nsarray_data count]==4) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                
                str_item_name1=[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2=[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3=[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4=[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
            }
            
            if ([nsarray_data count]==5) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
            }
            
            if ([nsarray_data count]==6) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6=[[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                
            }
            
            if ([nsarray_data count]==7) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6=[[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7=[[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                
            }
            
            if ([nsarray_data count]==8) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6=[[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7=[[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8=[[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
            }
            
            if ([nsarray_data count]==9) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6=[[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7=[[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8=[[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9=[[nsarray_data valueForKey:@"width"] objectAtIndex:8];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                
            }
            
            if ([nsarray_data count]==10) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6=[[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7=[[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8=[[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9=[[nsarray_data valueForKey:@"width"] objectAtIndex:8];
                str_item_width10 =[[nsarray_data valueForKey:@"width"] objectAtIndex:9];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                str_item_name10 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:9];
            }
            
            if ([nsarray_data count]==11) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6=[[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7=[[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8=[[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9=[[nsarray_data valueForKey:@"width"] objectAtIndex:8];
                str_item_width10 =[[nsarray_data valueForKey:@"width"] objectAtIndex:9];
                str_item_width11 =[[nsarray_data valueForKey:@"width"] objectAtIndex:10];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                str_item_name10 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:9];
                str_item_name11 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:10];
                
            }
            
            if ([nsarray_data count]==12) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6=[[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7=[[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8=[[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9=[[nsarray_data valueForKey:@"width"] objectAtIndex:8];
                str_item_width10 =[[nsarray_data valueForKey:@"width"] objectAtIndex:9];
                str_item_width11 =[[nsarray_data valueForKey:@"width"] objectAtIndex:10];
                str_item_width12 =[[nsarray_data valueForKey:@"width"] objectAtIndex:11];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                str_item_name10 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:9];
                str_item_name11 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:10];
                str_item_name12 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:11];
            }
            
            if ([nsarray_data count]==13) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6=[[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7=[[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8=[[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9=[[nsarray_data valueForKey:@"width"] objectAtIndex:8];
                str_item_width10 =[[nsarray_data valueForKey:@"width"] objectAtIndex:9];
                str_item_width11 =[[nsarray_data valueForKey:@"width"] objectAtIndex:10];
                str_item_width12 =[[nsarray_data valueForKey:@"width"] objectAtIndex:11];
                str_item_width13 =[[nsarray_data valueForKey:@"width"] objectAtIndex:12];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                str_item_name10 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:9];
                str_item_name11 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:10];
                str_item_name12 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:11];
                str_item_name13 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:12];
            }
            
            if ([nsarray_data count]==14) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6=[[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7=[[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8=[[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9=[[nsarray_data valueForKey:@"width"] objectAtIndex:8];
                str_item_width10 =[[nsarray_data valueForKey:@"width"] objectAtIndex:9];
                str_item_width11 =[[nsarray_data valueForKey:@"width"] objectAtIndex:10];
                str_item_width12 =[[nsarray_data valueForKey:@"width"] objectAtIndex:11];
                str_item_width13 =[[nsarray_data valueForKey:@"width"] objectAtIndex:12];
                str_item_width14 =[[nsarray_data valueForKey:@"width"] objectAtIndex:13];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                str_item_name10 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:9];
                str_item_name11 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:10];
                str_item_name12 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:11];
                str_item_name13 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:12];
                str_item_name14 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:13];
            }
            
            if ([nsarray_data count]==15) {
                str_item_width1=[[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2=[[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3=[[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4=[[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5=[[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6=[[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7=[[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8=[[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9=[[nsarray_data valueForKey:@"width"] objectAtIndex:8];
                str_item_width10 =[[nsarray_data valueForKey:@"width"] objectAtIndex:9];
                str_item_width11 =[[nsarray_data valueForKey:@"width"] objectAtIndex:10];
                str_item_width12 =[[nsarray_data valueForKey:@"width"] objectAtIndex:11];
                str_item_width13 =[[nsarray_data valueForKey:@"width"] objectAtIndex:12];
                str_item_width14 =[[nsarray_data valueForKey:@"width"] objectAtIndex:13];
                str_item_width15 =[[nsarray_data valueForKey:@"width"] objectAtIndex:14];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                str_item_name10 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:9];
                str_item_name11 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:10];
                str_item_name12 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:11];
                str_item_name13 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:12];
                str_item_name14 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:13];
                str_item_name15 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:14];
                
            }
            if ([nsarray_data count] == 16) {
                str_item_width1 = [[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2 = [[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3 = [[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4 = [[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5 = [[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6 = [[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7 = [[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8 = [[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9 = [[nsarray_data valueForKey:@"width"] objectAtIndex:8];
                str_item_width10 = [[nsarray_data valueForKey:@"width"] objectAtIndex:9];
                str_item_width11 = [[nsarray_data valueForKey:@"width"] objectAtIndex:10];
                str_item_width12 = [[nsarray_data valueForKey:@"width"] objectAtIndex:11];
                str_item_width13 = [[nsarray_data valueForKey:@"width"] objectAtIndex:12];
                str_item_width14 = [[nsarray_data valueForKey:@"width"] objectAtIndex:13];
                str_item_width15 = [[nsarray_data valueForKey:@"width"] objectAtIndex:14];
                str_item_width16 = [[nsarray_data valueForKey:@"width"] objectAtIndex:15];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                str_item_name10 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:9];
                str_item_name11 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:10];
                str_item_name12 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:11];
                str_item_name13 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:12];
                str_item_name14 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:13];
                str_item_name15 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:14];
                str_item_name16 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:15];
            }
            
            if ([nsarray_data count] == 17) {
                str_item_width1 = [[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2 = [[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3 = [[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4 = [[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5 = [[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6 = [[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7 = [[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8 = [[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9 = [[nsarray_data valueForKey:@"width"] objectAtIndex:8];
                str_item_width10 = [[nsarray_data valueForKey:@"width"] objectAtIndex:9];
                str_item_width11 = [[nsarray_data valueForKey:@"width"] objectAtIndex:10];
                str_item_width12 = [[nsarray_data valueForKey:@"width"] objectAtIndex:11];
                str_item_width13 = [[nsarray_data valueForKey:@"width"] objectAtIndex:12];
                str_item_width14 = [[nsarray_data valueForKey:@"width"] objectAtIndex:13];
                str_item_width15 = [[nsarray_data valueForKey:@"width"] objectAtIndex:14];
                str_item_width16 = [[nsarray_data valueForKey:@"width"] objectAtIndex:15];
                str_item_width17 = [[nsarray_data valueForKey:@"width"] objectAtIndex:16];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                str_item_name10 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:9];
                str_item_name11 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:10];
                str_item_name12 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:11];
                str_item_name13 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:12];
                str_item_name14 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:13];
                str_item_name15 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:14];
                str_item_name16 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:15];
                str_item_name17 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:16];
                
            }
            
            if ([nsarray_data count] == 18) {
                str_item_width1 = [[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2 = [[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3 = [[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4 = [[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5 = [[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6 = [[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7 = [[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8 = [[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9 = [[nsarray_data valueForKey:@"width"] objectAtIndex:8];
                str_item_width10 = [[nsarray_data valueForKey:@"width"] objectAtIndex:9];
                str_item_width11 = [[nsarray_data valueForKey:@"width"] objectAtIndex:10];
                str_item_width12 = [[nsarray_data valueForKey:@"width"] objectAtIndex:11];
                str_item_width13 = [[nsarray_data valueForKey:@"width"] objectAtIndex:12];
                str_item_width14 = [[nsarray_data valueForKey:@"width"] objectAtIndex:13];
                str_item_width15 = [[nsarray_data valueForKey:@"width"] objectAtIndex:14];
                str_item_width16 = [[nsarray_data valueForKey:@"width"] objectAtIndex:15];
                str_item_width17 = [[nsarray_data valueForKey:@"width"] objectAtIndex:16];
                str_item_width18 = [[nsarray_data valueForKey:@"width"] objectAtIndex:17];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                str_item_name10 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:9];
                str_item_name11 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:10];
                str_item_name12 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:11];
                str_item_name13 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:12];
                str_item_name14 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:13];
                str_item_name15 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:14];
                str_item_name16 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:15];
                str_item_name17 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:16];
                str_item_name18 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:17];
                
            }
            
            if ([nsarray_data count] == 19) {
                str_item_width1 = [[nsarray_data valueForKey:@"width"] objectAtIndex:0];
                str_item_width2 = [[nsarray_data valueForKey:@"width"] objectAtIndex:1];
                str_item_width3 = [[nsarray_data valueForKey:@"width"] objectAtIndex:2];
                str_item_width4 = [[nsarray_data valueForKey:@"width"] objectAtIndex:3];
                str_item_width5 = [[nsarray_data valueForKey:@"width"] objectAtIndex:4];
                str_item_width6 = [[nsarray_data valueForKey:@"width"] objectAtIndex:5];
                str_item_width7 = [[nsarray_data valueForKey:@"width"] objectAtIndex:6];
                str_item_width8 = [[nsarray_data valueForKey:@"width"] objectAtIndex:7];
                str_item_width9 = [[nsarray_data valueForKey:@"width"] objectAtIndex:8];
                str_item_width10 = [[nsarray_data valueForKey:@"width"] objectAtIndex:9];
                str_item_width11 = [[nsarray_data valueForKey:@"width"] objectAtIndex:10];
                str_item_width12 = [[nsarray_data valueForKey:@"width"] objectAtIndex:11];
                str_item_width13 = [[nsarray_data valueForKey:@"width"] objectAtIndex:12];
                str_item_width14 = [[nsarray_data valueForKey:@"width"] objectAtIndex:13];
                str_item_width15 = [[nsarray_data valueForKey:@"width"] objectAtIndex:14];
                str_item_width16 = [[nsarray_data valueForKey:@"width"] objectAtIndex:15];
                str_item_width17 = [[nsarray_data valueForKey:@"width"] objectAtIndex:16];
                str_item_width18 = [[nsarray_data valueForKey:@"width"] objectAtIndex:17];
                str_item_width19 = [[nsarray_data valueForKey:@"width"] objectAtIndex:18];
                
                str_item_name1 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:0];
                str_item_name2 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:1];
                str_item_name3 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:2];
                str_item_name4 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:3];
                str_item_name5 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:4];
                str_item_name6 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:5];
                str_item_name7 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:6];
                str_item_name8 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:7];
                str_item_name9 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:8];
                str_item_name10 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:9];
                str_item_name11 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:10];
                str_item_name12 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:11];
                str_item_name13 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:12];
                str_item_name14 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:13];
                str_item_name15 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:14];
                str_item_name16 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:15];
                str_item_name17 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:16];
                str_item_name18 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:17];
                str_item_name19 =[[nsarray_data valueForKey:@"caption"] objectAtIndex:18];
                
            }
            
            int_width1 = [str_item_width1 intValue];
            int_width2 = [str_item_width2 intValue];
            int_width3 = [str_item_width3 intValue];
            int_width4 = [str_item_width4 intValue];
            int_width5 = [str_item_width5 intValue];
            int_width6 = [str_item_width6 intValue];
            int_width7 = [str_item_width7 intValue];
            int_width8 = [str_item_width8 intValue];
            int_width9 = [str_item_width9 intValue];
            int_width10 = [str_item_width10 intValue];
            int_width11 = [str_item_width11 intValue];
            int_width12 = [str_item_width12 intValue];
            int_width13 = [str_item_width13 intValue];
            int_width14 = [str_item_width14 intValue];
            int_width15 = [str_item_width15 intValue];
            int_width16 = [str_item_width16 intValue];
            int_width17 = [str_item_width17  intValue];
            int_width18 = [str_item_width18  intValue];
            int_width19 = [str_item_width19 intValue];
            int_width20 = [str_item_width20 intValue];
            
            int x = 0;
            for (int i = 0; i < 1; i++) {
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 700, 100)];
                [button setTitle:[NSString stringWithFormat:@"Button %d", i] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                [scrollView addSubview:button];
                x += button.frame.size.width;
            }
            scrollView.contentSize = CGSizeMake(x, scrollView.frame.size.height);
            scrollView.backgroundColor = [UIColor clearColor];
            //[self.view addSubview:scrollView];
            
            
            
            NSInteger int_tablewidth = int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+int_width15+int_width16+int_width17+int_width18+int_width19+190;
            self.tableView.frame=CGRectMake(0, 0, self.view.frame.size.width+int_tablewidth, 255);
            
            //            scrollView_List.contentSize = CGSizeMake(x, scrollView_List.frame.size.height);
            //            UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, int_tablewidth, 100)];
            //            [button1 setTitle:[NSString stringWithFormat:@"Button "] forState:UIControlStateNormal];
            //            [button1 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            //            [scrollView_List addSubview:button1];
            //
            //            scrollView_List.backgroundColor = [UIColor clearColor];
            //            [self.view addSubview:scrollView_List];
            CGRect frame = self.tableView.frame;
            frame.size.width = self.view.frame.size.width+int_total;
            self.tableView.frame = frame;
            tableViewWidth.constant = (105 * nsarray_data.count);
            [self.tableView reloadData];
            [scrollView_List reloadInputViews];
            
            //               [scrollView_List setContentSize:CGSizeMake(int_tablewidth, self.view.frame.size.height)];
            //               [self.view addSubview:scrollView_List];
            
            if ([nsarray_datadata count] ==0) {
                self.tableView.hidden=YES;
            }else{
                self.tableView.hidden=NO;
            }
            
            for (int i = 0; i < [nsarray_datadata count]; i++) {
                
                NSDictionary * dictObject1 = [nsarray_datadata objectAtIndex:i];
                
                NSString *item1 = [dictObject1 objectForKey:@"item0"];
                NSString *item2 = [dictObject1 objectForKey:@"item1"];
                NSString *item3 = [dictObject1 objectForKey:@"item2"];
                NSString *item4 = [dictObject1 objectForKey:@"item3"];
                NSString *item5 = [dictObject1 objectForKey:@"item4"];
                NSString *item6 = [dictObject1 objectForKey:@"item5"];
                NSString *item7 = [dictObject1 objectForKey:@"item6"];
                NSString *item8 = [dictObject1 objectForKey:@"item7"];
                NSString *item9 = [dictObject1 objectForKey:@"item8"];
                NSString *item10 = [dictObject1 objectForKey:@"item9"];
                NSString *item11 = [dictObject1 objectForKey:@"item10"];
                NSString *item12 = [dictObject1 objectForKey:@"item11"];
                NSString *item13 = [dictObject1 objectForKey:@"item12"];
                NSString *item14 = [dictObject1 objectForKey:@"item13"];
                NSString *item15 = [dictObject1 objectForKey:@"item14"];
                NSString *item16 = [dictObject1 objectForKey:@"item15"];
                NSString *item17 = [dictObject1 objectForKey:@"item16"];
                NSString *item18 = [dictObject1 objectForKey:@"item17"];
                NSString *item19 = [dictObject1 objectForKey:@"item18"];
                NSString *item20 = [dictObject1 objectForKey:@"item19"];
                
                
                if (item1 ==nil) {
                    [ns_item1 addObject:@""];
                }else{
                    [ns_item1 addObject:item1];
                }
                
                if (item2 ==nil) {
                    [ns_item2 addObject:@""];
                }else{
                    [ns_item2 addObject:item2];
                }
                
                if (item3 ==nil) {
                    [ns_item3 addObject:@""];
                }else{
                    [ns_item3 addObject:item3];
                }
                
                if (item4 ==nil) {
                    [ns_item4 addObject:@""];
                }else{
                    [ns_item4 addObject:item4];
                }
                if (item5 ==nil) {
                    [ns_item5 addObject:@""];
                }else{
                    [ns_item5 addObject:item5];
                }
                
                if (item6 ==nil) {
                    [ns_item6 addObject:@""];
                }else{
                    [ns_item6 addObject:item6];
                }
                if (item7 ==nil) {
                    [ns_item7 addObject:@""];
                }else{
                    [ns_item7 addObject:item7];
                }
                
                if (item8 ==nil) {
                    [ns_item8 addObject:@""];
                }else{
                    [ns_item8 addObject:item8];
                }
                
                if (item9 ==nil) {
                    [ns_item9 addObject:@""];
                }else{
                    [ns_item9 addObject:item9];
                }
                
                if (item10 ==nil) {
                    [ns_item10 addObject:@""];
                }else{
                    [ns_item10 addObject:item10];
                }
                
                if (item11 ==nil) {
                    [ns_item11 addObject:@""];
                }else{
                    [ns_item11 addObject:item11];
                }
                
                if (item12 ==nil) {
                    [ns_item12 addObject:@""];
                }else{
                    [ns_item12 addObject:item12];
                }
                
                if (item13 ==nil) {
                    [ns_item13 addObject:@""];
                }else{
                    [ns_item13 addObject:item13];
                }
                
                if (item14 ==nil) {
                    [ns_item14 addObject:@""];
                }else{
                    [ns_item14 addObject:item14];
                }
                
                if (item15 ==nil) {
                    [ns_item15 addObject:@""];
                }else{
                    [ns_item15 addObject:item15];
                }
                
                if (item16 ==nil) {
                    [ns_item16 addObject:@""];
                }else{
                    [ns_item16 addObject:item16];
                }
                
                if (item17 ==nil) {
                    [ns_item17 addObject:@""];
                }else{
                    [ns_item17 addObject:item17];
                }
                
                if (item18 ==nil) {
                    [ns_item18 addObject:@""];
                }else{
                    [ns_item18 addObject:item18];
                }
                
                if (item19 ==nil) {
                    [ns_item19 addObject:@""];
                }else{
                    [ns_item19 addObject:item19];
                }
                
                if (item20 ==nil) {
                    [ns_item20 addObject:@""];
                }else{
                    [ns_item20 addObject:item20];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
            
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

#pragma mark - Pdf Api Methods


- (void)insert_tagcalculatorApi:(NSString *)tagno{
    
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSString *mainUrl = [[webUrlconstant sharedInstance] getMainUrl];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    NSString *visid= @"0";
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@&tgno=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&visid=%@",apptype,mobile,tagno,ip,db,ipusername,pswd,ftppath,visid];
        
        URL_API = [WEB_URL URL_Insert_tagcalculator];
        
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/insert_tagcalculator.php",ip];
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@&tgno=%@&ftppath=%@&visid=%@",apptype,mobile,tagno,ftppath,visid];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@&tgno=%@&visid=%@",apptype,mobile,tagno,visid];
        URL_API = [WEB_URL URL_Insert_tagcalculator];
    }
    
    NSLog(@"loginRequest ******************************* %@",loginRequest);
    NSLog(@"URL_API ******************************* %@",URL_API);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:60.0];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_pdf:data type:@"taginsert"];
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



- (void)getPdfWithOrderno:(NSString *)orderno type:(NSString *)type  pdftype:(NSString *)pdftype {
    
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSString *mainUrl = [[webUrlconstant sharedInstance] getMainUrl];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *userid = [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    NSString *rlid= @"0";
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&type=%@&orderno=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@",apptype,type,orderno,ip,db,ipusername,pswd,ftppath];
        
        URL_API = [NSString stringWithFormat:@"%@%@",mainUrl, pdftype];
        
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"%@%@",ip, pdftype];
        
        loginRequest=[NSString stringWithFormat:@"apptype=%@&type=%@&orderno=%@&ftppath=%@",apptype,type,orderno,ftppath];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&type=%@&orderno=%@",apptype,type,orderno];
        URL_API = [NSString stringWithFormat:@"%@%@",mainUrl, pdftype];
    }
    
    NSLog(@"loginRequest ******************************* %@",loginRequest);
    NSLog(@"URL_API ******************************* %@",URL_API);
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:60.0];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_pdf:data type:@""];
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

- (void)parseResponse_pdf:(NSData *) data type:(NSString *)str_ResponseType{
    @try {
        [[BusyIndicator sharedInstance]stopIndicator];
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        NSError *error = nil;
        
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
            if([str_ResponseType isEqualToString:@"taginsert"]){
                NSMutableArray *arrayResponse_orderNo = [pDict objectForKey:@"orderno"];
                NSString *str_OrderNo = [arrayResponse_orderNo description];
                [self getPdfWithOrderno: str_OrderNo type:@"1" pdftype:@"get_pdf10.php"];
            }else{
            if ([str_success isEqualToString:@"1"]) {
                NSString *mainUrl = [[webUrlconstant sharedInstance] getMainUrl];
                NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
                NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
                NSMutableArray*nsarray_pdf = [pDict objectForKey:@"pdf"];
                NSString *pdf = [nsarray_pdf description];
                NSString *str_url;
                if ([ECAT_TYPE isEqualToString:@"1"] || [ECAT_TYPE isEqualToString:@"3"]) {
                    NSLog(@"mainUrl ****************** %@",mainUrl);
                    str_url = [NSString stringWithFormat:@"%@pdf/%@", mainUrl, pdf];
                    NSLog(@"str_url ****************** %@",str_url);
                    
                    NSURL *url = [NSURL URLWithString:str_url];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                    } else {
                        NSLog(@"Cannot open URL");
                    }
                } else {
                    str_url = [NSString stringWithFormat:@"http://%@/jwellyecat/pdf/%@", ip, pdf];
                }
            }else{
                [self alertMsg:str_msg];
            }
        }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

#pragma mark - Table View Data Source and Delegate Mathods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return nsarray_datadata.count > 0 ? nsarray_datadata.count + 1 : 0;//[ns_item1 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *myIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:myIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    
    int xorigin = 5;
    
    if (indexPath.row == 0) {
        for (NSDictionary *item in nsarray_data) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xorigin, 5, 100, 40)];
            label.text = [NSString stringWithFormat:@"%@",[item valueForKey:@"caption"] ];
            label.textAlignment = NSTextAlignmentCenter;
            label.font=[UIFont systemFontOfSize:14];
            label.layer.cornerRadius = 5;
            label.layer.borderWidth = 1;
            label.layer.borderColor = [UIColor lightGrayColor].CGColor;
            //label.backgroundColor = [UIColor lightGrayColor];
            label.textColor = [UIColor blackColor];
            [cell addSubview:label];
            xorigin += 105;
        }
    }else{
        NSDictionary * arrayData = [nsarray_datadata objectAtIndex:indexPath.row-1];
        NSLog(@"Array data = %@", arrayData);
        for (int i = 0; i < arrayData.count; i++) {
            NSString *key = [NSString stringWithFormat:@"item%d", i];
            NSString *value = arrayData[key];
            NSLog(@"%@: %@", key, value);
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xorigin, 0, 100, 40)];
            label.text = value;
            label.textAlignment = NSTextAlignmentCenter;
            label.font=[UIFont systemFontOfSize:14];
            label.layer.cornerRadius = 5;
            label.layer.borderWidth = 1;
            label.layer.borderColor = [UIColor lightGrayColor].CGColor;
            //label.backgroundColor = [UIColor lightGrayColor];
            label.textColor = [UIColor blackColor];
            [cell addSubview:label];
            xorigin += 105;
        }
    }
    
    /*
     if (indexPath.row==0) {
     UILabel *lbl_1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, int_width1, 35)];
     lbl_1.numberOfLines = 0;
     lbl_1.textColor = [UIColor blueColor];
     lbl_1.backgroundColor = [UIColor lightGrayColor];
     lbl_1.textAlignment = NSTextAlignmentCenter;
     lbl_1.text = [NSString stringWithFormat:@"%@",str_item_name1];
     lbl_1.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_1];
     
     UILabel *lbl_2 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+10, 5, int_width2, 35)];
     lbl_2.numberOfLines = 0;
     lbl_2.textColor = [UIColor blueColor];
     lbl_2.backgroundColor = [UIColor lightGrayColor];
     lbl_2.textAlignment = NSTextAlignmentCenter;
     lbl_2.text = [NSString stringWithFormat:@"%@",str_item_name2];
     lbl_2.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_2];
     
     UILabel *lbl_3 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+20, 5, int_width3, 35)];
     lbl_3.numberOfLines = 0;
     lbl_3.textColor = [UIColor blueColor];
     lbl_3.backgroundColor = [UIColor lightGrayColor];
     lbl_3.textAlignment = NSTextAlignmentCenter;
     lbl_3.text = [NSString stringWithFormat:@"%@", str_item_name3];
     lbl_3.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_3];
     
     UILabel *lbl_4 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+30, 5, int_width4, 35)];
     lbl_4.numberOfLines = 0;
     lbl_4.textColor = [UIColor blueColor];
     lbl_4.backgroundColor = [UIColor lightGrayColor];
     lbl_4.textAlignment = NSTextAlignmentCenter;
     lbl_4.text = [NSString stringWithFormat:@"%@", str_item_name4];
     lbl_4.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_4];
     
     
     UILabel *lbl_5 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+40, 5, int_width5, 35)];
     lbl_5.numberOfLines = 0;
     lbl_5.textColor = [UIColor blueColor];
     lbl_5.backgroundColor = [UIColor lightGrayColor];
     lbl_5.textAlignment = NSTextAlignmentCenter;
     lbl_5.text = [NSString stringWithFormat:@"%@", str_item_name5];
     lbl_5.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_5];
     
     UILabel *lbl_6 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+50, 5, int_width6, 35)];
     lbl_6.numberOfLines = 0;
     lbl_6.textColor = [UIColor blueColor];
     lbl_6.backgroundColor = [UIColor lightGrayColor];
     lbl_6.textAlignment = NSTextAlignmentCenter;
     lbl_6.text = [NSString stringWithFormat:@"%@", str_item_name6];
     lbl_6.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_6];
     
     UILabel *lbl_7 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+60, 5, int_width7, 35)];
     lbl_7.numberOfLines = 0;
     lbl_7.textColor = [UIColor blueColor];
     lbl_7.backgroundColor = [UIColor lightGrayColor];
     lbl_7.textAlignment = NSTextAlignmentCenter;
     lbl_7.text = [NSString stringWithFormat:@"%@", str_item_name7];
     lbl_7.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_7];
     
     UILabel *lbl_8 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+70, 5, int_width8, 35)];
     lbl_8.numberOfLines = 0;
     lbl_8.textColor = [UIColor blueColor];
     lbl_8.backgroundColor = [UIColor lightGrayColor];
     lbl_8.textAlignment = NSTextAlignmentCenter;
     lbl_8.text = [NSString stringWithFormat:@"%@", str_item_name8];
     lbl_8.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_8];
     
     UILabel *lbl_9 = [[UILabel alloc]initWithFrame: CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+80, 5, int_width9, 35)];
     lbl_9.numberOfLines = 0;
     lbl_9.textColor = [UIColor blueColor];
     lbl_9.backgroundColor = [UIColor lightGrayColor];
     lbl_9.textAlignment = NSTextAlignmentCenter;
     lbl_9.text = [NSString stringWithFormat:@"%@", str_item_name9];
     lbl_9.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_9];
     
     UILabel *lbl_10 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+90, 5, int_width10, 35)];
     lbl_10.numberOfLines = 0;
     lbl_10.textColor = [UIColor blueColor];
     lbl_10.backgroundColor = [UIColor lightGrayColor];
     lbl_10.textAlignment = NSTextAlignmentCenter;
     lbl_10.text = [NSString stringWithFormat:@"%@", str_item_name10];
     lbl_10.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_10];
     
     UILabel *lbl_11 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+100, 5, int_width11, 35)];
     lbl_11.numberOfLines = 0;
     lbl_11.textColor = [UIColor blueColor];
     lbl_11.backgroundColor = [UIColor lightGrayColor];
     lbl_11.textAlignment = NSTextAlignmentCenter;
     lbl_11.text = [NSString stringWithFormat:@"%@", str_item_name11];
     lbl_11.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_11];
     
     
     UILabel *lbl_12 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+110, 5, int_width12, 35)];
     lbl_12.numberOfLines = 0;
     lbl_12.textColor = [UIColor blueColor];
     lbl_12.backgroundColor = [UIColor lightGrayColor];
     lbl_12.textAlignment = NSTextAlignmentCenter;
     lbl_12.text = [NSString stringWithFormat:@"%@", str_item_name12];
     lbl_12.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_12];
     
     UILabel *lbl_13 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+120, 5, int_width13, 35)];
     lbl_13.numberOfLines = 0;
     lbl_13.textColor = [UIColor blueColor];
     lbl_13.backgroundColor = [UIColor lightGrayColor];
     lbl_13.textAlignment = NSTextAlignmentCenter;
     lbl_13.text = [NSString stringWithFormat:@"%@", str_item_name13];
     lbl_13.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_13];
     
     UILabel *lbl_14 = [[UILabel alloc]initWithFrame: CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+130, 5, int_width14, 35)];
     lbl_14.numberOfLines = 0;
     lbl_14.textColor = [UIColor blueColor];
     lbl_14.backgroundColor = [UIColor lightGrayColor];
     lbl_14.textAlignment = NSTextAlignmentCenter;
     lbl_14.text = [NSString stringWithFormat:@"%@",str_item_name14];
     lbl_14.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_14];
     
     UILabel *lbl_15 = [[UILabel alloc]initWithFrame: CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+140, 5, int_width15, 35)];
     lbl_15.numberOfLines = 0;
     lbl_15.textColor = [UIColor blueColor];
     lbl_15.backgroundColor = [UIColor lightGrayColor];
     lbl_15.textAlignment = NSTextAlignmentCenter;
     lbl_15.text = [NSString stringWithFormat:@"%@", str_item_name15];
     lbl_15.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_15];
     
     UILabel *lbl_16 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+int_width15+150, 5, int_width16, 35)];
     lbl_16.numberOfLines = 0;
     lbl_16.textColor = [UIColor blueColor];
     lbl_16.backgroundColor = [UIColor lightGrayColor];
     lbl_16.textAlignment = NSTextAlignmentCenter;
     lbl_16.text = [NSString stringWithFormat:@"%@", str_item_name16];
     lbl_16.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_16];
     
     UILabel *lbl_17 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+int_width15+int_width16+160, 5, int_width17, 35)];
     lbl_17.numberOfLines = 0;
     lbl_17.textColor = [UIColor blueColor];
     lbl_17.backgroundColor = [UIColor lightGrayColor];
     lbl_17.textAlignment = NSTextAlignmentCenter;
     lbl_17.text = [NSString stringWithFormat:@"%@", str_item_name17];
     lbl_17.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_17];
     
     UILabel *lbl_18 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+int_width15+int_width16+int_width17+170, 5, int_width18, 35)];
     lbl_18.numberOfLines = 0;
     lbl_18.textColor = [UIColor blueColor];
     lbl_18.backgroundColor = [UIColor lightGrayColor];
     lbl_18.textAlignment = NSTextAlignmentCenter;
     lbl_18.text = [NSString stringWithFormat:@"%@", str_item_name18];
     lbl_18.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_18];
     
     UILabel *lbl_19 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+int_width15+int_width16+int_width17+int_width18+180, 5, int_width19, 35)];
     lbl_19.numberOfLines = 0;
     lbl_19.textColor = [UIColor blueColor];
     lbl_19.backgroundColor = [UIColor lightGrayColor];
     lbl_19.textAlignment = NSTextAlignmentCenter;
     lbl_19.text = [NSString stringWithFormat:@"%@", str_item_name19];
     lbl_19.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_19];
     
     UILabel *lbl_20 = [[UILabel alloc]initWithFrame: CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+int_width15+int_width16+int_width17+int_width18+int_width19+190, 5, int_width20, 35)];
     lbl_20.numberOfLines = 0;
     lbl_20.textColor = [UIColor blueColor];
     lbl_20.backgroundColor = [UIColor lightGrayColor];
     lbl_20.textAlignment = NSTextAlignmentCenter;
     lbl_20.text = [NSString stringWithFormat:@"%@", str_item_name20];
     lbl_20.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_20];
     }else{
     UILabel *lbl_1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, int_width1, 35)];
     lbl_1.numberOfLines = 0;
     lbl_1.textColor = [UIColor blueColor];
     lbl_1.backgroundColor = [UIColor lightGrayColor];
     lbl_1.textAlignment = NSTextAlignmentCenter;
     lbl_1.text = [NSString stringWithFormat:@"%@", [ns_item1 objectAtIndex:indexPath.row]];
     lbl_1.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_1];
     
     UILabel *lbl_2 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+10, 5, int_width2, 35)];
     lbl_2.numberOfLines = 0;
     lbl_2.textColor = [UIColor blueColor];
     lbl_2.backgroundColor = [UIColor lightGrayColor];
     lbl_2.textAlignment = NSTextAlignmentCenter;
     lbl_2.text = [NSString stringWithFormat:@"%@", [ns_item2 objectAtIndex:indexPath.row]];
     lbl_2.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_2];
     
     UILabel *lbl_3 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+20, 5, int_width3, 35)];
     lbl_3.numberOfLines = 0;
     lbl_3.textColor = [UIColor blueColor];
     lbl_3.backgroundColor = [UIColor lightGrayColor];
     lbl_3.textAlignment = NSTextAlignmentCenter;
     lbl_3.text = [NSString stringWithFormat:@"%@", [ns_item3 objectAtIndex:indexPath.row]];
     lbl_3.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_3];
     
     UILabel *lbl_4 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+30, 5, int_width4, 35)];
     lbl_4.numberOfLines = 0;
     lbl_4.textColor = [UIColor blueColor];
     lbl_4.backgroundColor = [UIColor lightGrayColor];
     lbl_4.textAlignment = NSTextAlignmentCenter;
     lbl_4.text = [NSString stringWithFormat:@"%@", [ns_item4 objectAtIndex:indexPath.row]];
     lbl_4.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_4];
     
     
     UILabel *lbl_5 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+40, 5, int_width5, 35)];
     lbl_5.numberOfLines = 0;
     lbl_5.textColor = [UIColor blueColor];
     lbl_5.backgroundColor = [UIColor lightGrayColor];
     lbl_5.textAlignment = NSTextAlignmentCenter;
     lbl_5.text = [NSString stringWithFormat:@"%@", [ns_item5 objectAtIndex:indexPath.row]];
     lbl_5.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_5];
     
     UILabel *lbl_6 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+50, 5, int_width6, 35)];
     lbl_6.numberOfLines = 0;
     lbl_6.textColor = [UIColor blueColor];
     lbl_6.backgroundColor = [UIColor lightGrayColor];
     lbl_6.textAlignment = NSTextAlignmentCenter;
     lbl_6.text = [NSString stringWithFormat:@"%@", [ns_item6 objectAtIndex:indexPath.row]];
     lbl_6.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_6];
     
     UILabel *lbl_7 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+60, 5, int_width7, 35)];
     lbl_7.numberOfLines = 0;
     lbl_7.textColor = [UIColor blueColor];
     lbl_7.backgroundColor = [UIColor lightGrayColor];
     lbl_7.textAlignment = NSTextAlignmentCenter;
     lbl_7.text = [NSString stringWithFormat:@"%@", [ns_item7 objectAtIndex:indexPath.row]];
     lbl_7.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_7];
     
     UILabel *lbl_8 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+70, 5, int_width8, 35)];
     lbl_8.numberOfLines = 0;
     lbl_8.textColor = [UIColor blueColor];
     lbl_8.backgroundColor = [UIColor lightGrayColor];
     lbl_8.textAlignment = NSTextAlignmentCenter;
     lbl_8.text = [NSString stringWithFormat:@"%@", [ns_item8 objectAtIndex:indexPath.row]];
     lbl_8.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_8];
     
     UILabel *lbl_9 = [[UILabel alloc]initWithFrame: CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+80, 5, int_width9, 35)];
     lbl_9.numberOfLines = 0;
     lbl_9.textColor = [UIColor blueColor];
     lbl_9.backgroundColor = [UIColor lightGrayColor];
     lbl_9.textAlignment = NSTextAlignmentCenter;
     lbl_9.text = [NSString stringWithFormat:@"%@", [ns_item9 objectAtIndex:indexPath.row]];
     lbl_9.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_9];
     
     UILabel *lbl_10 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+90, 5, int_width10, 35)];
     lbl_10.numberOfLines = 0;
     lbl_10.textColor = [UIColor blueColor];
     lbl_10.backgroundColor = [UIColor lightGrayColor];
     lbl_10.textAlignment = NSTextAlignmentCenter;
     lbl_10.text = [NSString stringWithFormat:@"%@", [ns_item10 objectAtIndex:indexPath.row]];
     lbl_10.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_10];
     
     UILabel *lbl_11 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+100, 5, int_width11, 35)];
     lbl_11.numberOfLines = 0;
     lbl_11.textColor = [UIColor blueColor];
     lbl_11.backgroundColor = [UIColor lightGrayColor];
     lbl_11.textAlignment = NSTextAlignmentCenter;
     lbl_11.text = [NSString stringWithFormat:@"%@", [ns_item11 objectAtIndex:indexPath.row]];
     lbl_11.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_11];
     
     
     UILabel *lbl_12 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+110, 5, int_width12, 35)];
     lbl_12.numberOfLines = 0;
     lbl_12.textColor = [UIColor blueColor];
     lbl_12.backgroundColor = [UIColor lightGrayColor];
     lbl_12.textAlignment = NSTextAlignmentCenter;
     lbl_12.text = [NSString stringWithFormat:@"%@", [ns_item12 objectAtIndex:indexPath.row]];
     lbl_12.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_12];
     
     UILabel *lbl_13 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+120, 5, int_width13, 35)];
     lbl_13.numberOfLines = 0;
     lbl_13.textColor = [UIColor blueColor];
     lbl_13.backgroundColor = [UIColor lightGrayColor];
     lbl_13.textAlignment = NSTextAlignmentCenter;
     lbl_13.text = [NSString stringWithFormat:@"%@", [ns_item13 objectAtIndex:indexPath.row]];
     lbl_13.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_13];
     
     UILabel *lbl_14 = [[UILabel alloc]initWithFrame: CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+130, 5, int_width14, 35)];
     lbl_14.numberOfLines = 0;
     lbl_14.textColor = [UIColor blueColor];
     lbl_14.backgroundColor = [UIColor lightGrayColor];
     lbl_14.textAlignment = NSTextAlignmentCenter;
     lbl_14.text = [NSString stringWithFormat:@"%@", [ns_item14 objectAtIndex:indexPath.row]];
     lbl_14.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_14];
     
     UILabel *lbl_15 = [[UILabel alloc]initWithFrame: CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+140, 5, int_width15, 35)];
     lbl_15.numberOfLines = 0;
     lbl_15.textColor = [UIColor blueColor];
     lbl_15.backgroundColor = [UIColor lightGrayColor];
     lbl_15.textAlignment = NSTextAlignmentCenter;
     lbl_15.text = [NSString stringWithFormat:@"%@", [ns_item15 objectAtIndex:indexPath.row]];
     lbl_15.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_15];
     
     UILabel *lbl_16 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+int_width15+150, 5, int_width16, 35)];
     lbl_16.numberOfLines = 0;
     lbl_16.textColor = [UIColor blueColor];
     lbl_16.backgroundColor = [UIColor lightGrayColor];
     lbl_16.textAlignment = NSTextAlignmentCenter;
     lbl_16.text = [NSString stringWithFormat:@"%@", [ns_item16 objectAtIndex:indexPath.row]];
     lbl_16.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_16];
     
     UILabel *lbl_17 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+int_width15+int_width16+160, 5, int_width17, 35)];
     lbl_17.numberOfLines = 0;
     lbl_17.textColor = [UIColor blueColor];
     lbl_17.backgroundColor = [UIColor lightGrayColor];
     lbl_17.textAlignment = NSTextAlignmentCenter;
     lbl_17.text = [NSString stringWithFormat:@"%@", [ns_item17 objectAtIndex:indexPath.row]];
     lbl_17.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_17];
     
     UILabel *lbl_18 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+int_width15+int_width16+int_width17+170, 5, int_width18, 35)];
     lbl_18.numberOfLines = 0;
     lbl_18.textColor = [UIColor blueColor];
     lbl_18.backgroundColor = [UIColor lightGrayColor];
     lbl_18.textAlignment = NSTextAlignmentCenter;
     lbl_18.text = [NSString stringWithFormat:@"%@", [ns_item18 objectAtIndex:indexPath.row]];
     lbl_18.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_18];
     
     UILabel *lbl_19 = [[UILabel alloc]initWithFrame:CGRectMake(int_width1+int_width2+int_width3+int_width4+int_width5+int_width6+int_width7+int_width8+int_width9+int_width10+int_width11+int_width12+int_width13+int_width14+int_width15+int_width16+int_width17+int_width18+180, 5, int_width19, 35)];
     lbl_19.numberOfLines = 0;
     lbl_19.textColor = [UIColor blueColor];
     lbl_19.backgroundColor = [UIColor lightGrayColor];
     lbl_19.textAlignment = NSTextAlignmentCenter;
     lbl_19.text = [NSString stringWithFormat:@"%@", [ns_item19 objectAtIndex:indexPath.row]];
     lbl_19.font=[UIFont fontWithName:@"Helvetica" size:12.0];
     [cell.contentView addSubview:lbl_19];
     }
     */
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark: Helper Mathod

-(void)setUpView{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    tapGesture.numberOfTapsRequired = 1;
    img_tag.userInteractionEnabled = YES;
    [img_tag addGestureRecognizer:tapGesture];
    img_tag.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)handleTap{
    [[BusyIndicator sharedInstance]startIndicator];
    imgfullVC *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"imgfullVC"];
    obj.imageUrlString=str_image;
    obj.str_img2 = @"";
    obj.str_img3 = @"";
    obj.str_img4 = @"";
    obj.str_img5 = @"";
    [self.navigationController pushViewController:obj animated:YES];
}

@end
