//
//  MMIHOMEPanel.m
//  Jwelly Customer
//
//  Created by Apple on 11/6/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import "MMIHOMEPanel.h"
#import "BusyIndicator.h"
#import "webUrlconstant.h"
#import "UIImageView+WebCache.h"
#import "WalletVC.h"
#import "WalletHistoryVC.h"
#import "ItemListVC.h"
#import "ProductGallery.h"
#import "AgentLogin.h"
#import "Aboutus.h"
#import "Contactus.h"
#import "Suggestion.h"
#import "ViewController/Menu/SWRevealViewController.h"
#import "CartList.h"
#import "TagCalculator.h"
#import "AddDemand.h"
#import "OrderList.h"
#import "CustomerVisit.h"
#import "TodayBhav.h"
#import "Undelivered.h"
#import "ViewController/MMI PANEL/OutStanding.h"
#import "HomeBannerCell.h"
#import "OrderRegisterVC.h"
#import <Speech/Speech.h>
#import "LedgerVC.h"
#import "HelpVC.h"
#import "LedgerDetailsVC.h"
#import "Gautom_HomeVC.h"
#import "CustomerEntry.h"
#import "StockVC.h"


#define MENUEWIDTH   250

@interface MMIHOMEPanel ()
{
    NSString *rights;
    UIBarButtonItem *rightButton;
    NSTimer *autoScrollTimer;
    NSInteger currentIndex;
}

@end

@implementation MMIHOMEPanel

-(void)btn_Refresh
{
    
}

#pragma mark - Class Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Jewel Desk";
    SWRevealViewController *revealController = [self revealViewController];
    //[revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    UIImage* image = [UIImage imageNamed:@"menu.png"];
    CGRect frameimg1 = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *someButton1 = [[UIButton alloc] initWithFrame:frameimg1];
    [someButton1 setBackgroundImage:image forState:UIControlStateNormal];
    [someButton1 addTarget:revealController action:@selector(revealToggle:)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithCustomView:someButton1];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    NSString *username = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
    lbl_welcome.text = [NSString stringWithFormat:@"Welcome %@",username];
    
    UIButton *btn_account =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_account.frame = CGRectMake(0,0,30,30);
    [btn_account addTarget:self action:@selector(btn_account) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image1 = [[UIImage imageNamed:@"icon_voice"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btn_account setBackgroundImage:image1 forState:UIControlStateNormal];
    
    UIBarButtonItem *btndelete = [[UIBarButtonItem alloc] initWithCustomView:btn_account];
    btndelete.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:btndelete, nil];
    rights = @"00000000000000";
    
    [[NSUserDefaults standardUserDefaults] setObject:rights forKey:@"rights"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *softid = [[NSUserDefaults standardUserDefaults]stringForKey:@"softid"];
    if (![softid isEqualToString:@"SQLECAT"] && ![softid isEqualToString:@"SQLQR"]) {
        [self GET_UserAi];
        //        rightButton = [[UIBarButtonItem alloc] initWithTitle:@"swid" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonTapped)];
        //        self.navigationItem.rightBarButtonItem = rightButton;
        
        // 1. Create the text button (softid)
        rightButton = [[UIBarButtonItem alloc] initWithTitle:softid style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonTapped)];
        rightButton.tintColor = [UIColor whiteColor]; // Optional: if you want white text
        
        // 2. Create the custom button with voice icon
        UIButton *btn_account = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_account.frame = CGRectMake(0, 0, 30, 30);
        [btn_account addTarget:self action:@selector(btn_account) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *image1 = [[UIImage imageNamed:@"icon_voice"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [btn_account setBackgroundImage:image1 forState:UIControlStateNormal];
        
        UIBarButtonItem *voiceButton = [[UIBarButtonItem alloc] initWithCustomView:btn_account];
        btn_account.tintColor = [UIColor whiteColor]; // For template image
        
        // 3. Add both buttons to the right side
        self.navigationItem.rightBarButtonItems = @[voiceButton, rightButton];
        
        [self GET_ECATID_API];
        
    }else{
        rightButton = [[UIBarButtonItem alloc] initWithTitle:softid style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonTapped)];
        rightButton.tintColor = [UIColor whiteColor]; // Optional: if you want white text
        
        // 2. Create the custom button with voice icon
        UIButton *btn_account = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_account.frame = CGRectMake(0, 0, 30, 30);
        [btn_account addTarget:self action:@selector(btn_account) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *image1 = [[UIImage imageNamed:@"icon_voice"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [btn_account setBackgroundImage:image1 forState:UIControlStateNormal];
        
        UIBarButtonItem *voiceButton = [[UIBarButtonItem alloc] initWithCustomView:btn_account];
        btn_account.tintColor = [UIColor whiteColor]; // For template image
        
        UIButton *btn_Help = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_Help.frame = CGRectMake(0, 0, 30, 30);
        [btn_Help addTarget:self action:@selector(barBtnHelp) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *image_Help =  [UIImage systemImageNamed:@"questionmark.circle.fill"];
        [btn_Help setBackgroundImage:image_Help forState:UIControlStateNormal];
        btn_Help.tintColor = [UIColor whiteColor];
        UIBarButtonItem *helpBarButton = [[UIBarButtonItem alloc] initWithCustomView:btn_Help];
        helpBarButton.tintColor = [UIColor whiteColor]; // For template image
        
        // 3. Add both buttons to the right side
        self.navigationItem.rightBarButtonItems = @[rightButton, voiceButton, helpBarButton];
        [self GET_ITEMSHOW];
        [self GET_COMPANYDETAIL];
    }
    [self scrollData_HOME];
    
    // Initialize voice recognition components
    self.audioEngine = [[AVAudioEngine alloc] init];
    self.speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:@"en-IN"]];
    // Check if speech recognizer is available
    if (!self.speechRecognizer.isAvailable) {
        NSLog(@"❌ Speech recognizer is not available for locale: en-IN");
        [self showVoiceFeedback:@"Speech recognition is not available for your language. Please check device settings."];
    } else {
        NSLog(@"✅ Speech recognizer is available");
    }
    self.isListening = NO;
    [self requestSpeechAuthorization];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self->currentIndex = 0;
    [self startAutoScroll];
    
    // Reset navigation flag when returning to this view
    //self.isNavigating = NO;
    [self stopListening];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopAutoScroll];
    
    // Stop voice recognition if active
    if (self.isListening) {
        NSLog(@"🔄 Stopping voice recognition due to view disappearing");
        [self stopListening];
    }
}

- (void)rightButtonTapped {
    // Do something when the right button is tapped
    NSLog(@"Right button tapped!");
    [self showDialogECAT];
    //[self openGoutamVC];
}

- (void)requestSpeechAuthorization {
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    NSLog(@"✅ Speech recognition authorized.");
                    break;
                case SFSpeechRecognizerAuthorizationStatusDenied:
                    NSLog(@"❌ Speech recognition denied by user.");
                    [self showVoiceFeedback:@"Speech recognition access denied. Please enable it in Settings > Privacy & Security > Speech Recognition."];
                    break;
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    NSLog(@"❌ Speech recognition restricted.");
                    [self showVoiceFeedback:@"Speech recognition is restricted on this device."];
                    break;
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                    NSLog(@"❓ Speech recognition authorization not determined.");
                    break;
            }
        });
    }];
}

-(void)barBtnHelp {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HelpVC *successVC = [storyboard instantiateViewControllerWithIdentifier:@"HelpVC"];
    [self.navigationController pushViewController:successVC animated:YES];
}

-(void)btn_account {
    [self setUpListening];
    if (self.isListening) {
        NSLog(@"🛑 Stopping voice recognition");
        [self stopListening];
    } else {
        NSLog(@"🎤 Starting voice recognition");
        [self startListening];
    }
}

- (void)parseCommandFromSpeech:(NSString *)spokenText {
    NSLog(@"🎯 Processing voice command: %@", spokenText);
    
    NSString *text = [[spokenText uppercaseString] stringByReplacingOccurrencesOfString:@"HELLO MMI" withString:@""];
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSLog(@"🔍 Processed text: %@", text);
    
    if (text.length == 0) {
        NSLog(@"⚠️ Empty text after processing, ignoring command");
        [self showVoiceFeedback:@"Please speak a valid command"];
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
        [self showVoiceFeedback:[NSString stringWithFormat:@"Command not recognized: %@", text]];
    }
}

- (void)showVoiceFeedback:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *feedbackAlert = [UIAlertController alertControllerWithTitle:@"Voice Command"
                                                                               message:message
                                                                        preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [feedbackAlert addAction:okAction];
        [self presentViewController:feedbackAlert animated:YES completion:nil];
    });
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
    } else if ([strtype isEqualToString:@"2"]) {
        LedgerDetailsVC *obj = [storyboard instantiateViewControllerWithIdentifier:@"LedgerDetailsVC"];
        dispatch_async(dispatch_get_main_queue(), ^{
            obj.str_LedgerName = pname;
            [self.navigationController pushViewController:obj animated:YES];
        });
    } else if ([strtype isEqualToString:@"3"]) {
        OutStanding *obj = [storyboard instantiateViewControllerWithIdentifier:@"OutStanding"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:obj animated:YES];
        });
    } else if ([strtype isEqualToString:@"4"]) {
        CartList *obj = [storyboard instantiateViewControllerWithIdentifier:@"CartList"];
        obj.str_tag = pname;
        obj.str_rlid = @"0";
        obj.str_idesc = @"MMI";
        obj.str_activity = @"MMI HOME";
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
        [self showVoiceFeedback:@"Failed to configure audio session. Please try again."];
        return;
    }
    
    // Set audio session mode with error handling
    if (![audioSession setMode:AVAudioSessionModeMeasurement error:&error]) {
        NSLog(@"❌ Failed to set audio session mode: %@", error.localizedDescription);
        [self showVoiceFeedback:@"Failed to configure audio mode. Please try again."];
        return;
    }
    
    // Activate audio session with error handling
    if (![audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error]) {
        NSLog(@"❌ Failed to activate audio session: %@", error.localizedDescription);
        [self showVoiceFeedback:@"Failed to activate audio session. Please try again."];
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
                            [weakSelf showVoiceFeedback:@"No speech detected. Please try again."];
                        });
                    }
                }];
                
                // Add a longer fallback timer (10 seconds) to ensure we stop listening
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (weakSelf.isListening) {
                        NSLog(@"⏰ Long timeout reached, forcing stop");
                        [weakSelf stopListening];
                        [weakSelf showVoiceFeedback:@"Voice recognition timeout. Please try again."];
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
            [self showVoiceFeedback:@"Audio format not supported on this device. Please try on a physical device."];
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
        [self showVoiceFeedback:@"Failed to start audio recording. Please try on a physical device."];
        return;
    }
    
    // Prepare and start audio engine with error handling
    [self.audioEngine prepare];
    NSError *startError = nil;
    if (![self.audioEngine startAndReturnError:&startError]) {
        NSLog(@"❌ AudioEngine start error: %@", startError.localizedDescription);
        [self showVoiceFeedback:@"Failed to start audio engine. Please try on a physical device."];
        return;
    }
    NSLog(@"✅ Audio engine started successfully");
}

//- (void)stopListening {
//    NSLog(@"🛑 Stopping voice recognition...");
//    
//    // Cancel silence timer
//    if (self.silenceTimer) {
//        [self.silenceTimer invalidate];
//        self.silenceTimer = nil;
//    }
//    
//    // Stop audio engine
//    if (self.audioEngine.isRunning) {
//        [self.audioEngine stop];
//        [self.audioEngine.inputNode removeTapOnBus:0];
//    }
//    
//    // End recognition request
//    if (self.recognitionRequest) {
//        [self.recognitionRequest endAudio];
//    }
//    
//    // Cancel recognition task
//    if (self.recognitionTask) {
//        [self.recognitionTask cancel];
//    }
//    
//    // Reset properties
//    self.recognitionRequest = nil;
//    self.recognitionTask = nil;
//    self.isListening = NO;
//    
//    // Reset navigation flag
//    self.isNavigating = NO;
//    
//    // Deactivate audio session
//    NSError *error;
//    if (![[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error]) {
//        NSLog(@"⚠️ Warning: Could not deactivate audio session: %@", error.localizedDescription);
//        // Don't show error to user for deactivation issues
//    }
//    
//    // Dismiss alert on main queue
//    if (self.listeningAlert) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.listeningAlert dismissViewControllerAnimated:YES completion:nil];
//            self.listeningAlert = nil;
//        });
//    }
//    
//    NSLog(@"✅ Voice recognition stopped successfully");
//}

-(void)openGoutamVC{
    Gautom_HomeVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"Gautom_HomeVC"];
    [self.navigationController pushViewController:obj animated:YES];
}

- (void)GET_ECATID_API {
    self.arrayAdapterEcatid = [[NSMutableArray alloc] init];
    [self.arrayAdapterEcatid removeAllObjects];
    
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *loginRequest = [NSString stringWithFormat:@"mobile=%@",mobile];
    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    NSString *URL_API = [NSString stringWithFormat:@"%@",[WEB_URL URL_GET_ECATID]];
    
    NSLog(@"URL_API ::::::::::::::::::::  %@",URL_API);
    NSLog(@"GET_ECATID ::::::::::::::::::::  %@",loginRequest);
    
    NSURL *url = [NSURL URLWithString:URL_API];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    request.HTTPBody = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"GET_ECATID_API error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            NSLog(@"JSON parse error: %@", jsonError.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showToastWithMessage:jsonError.localizedDescription];
            });
            return;
        }
        
        NSArray *ecatidlist = jsonResponse[@"ecatidlist"];
        for (int i = 0; i < ecatidlist.count; i++) {
            NSDictionary *dict = ecatidlist[i];
            NSString *swid = dict[@"swid"];
            [self.arrayAdapterEcatid addObject:swid];
        }
    }];
    
    [task resume];
}

// Helper method to show a Toast
- (void)showToastWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}


- (void)showDialogECAT {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"SELECT ECAT ID :-"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSString *ecatid in self.arrayAdapterEcatid) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:ecatid
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
            // Save to UserDefaults
            [[NSUserDefaults standardUserDefaults] setObject:ecatid forKey:@"softid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // Set the toolbar label
            //            self.toolbarSwid.text = ecatid;
            self->rightButton = [[UIBarButtonItem alloc] initWithTitle:ecatid style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonTapped)];
            //self.navigationItem.rightBarButtonItem = self->rightButton;
            // Call API
            [self GET_CONFIG:ecatid];
        }];
        [alert addAction:action];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)GET_CONFIG:(NSString *)softid {
    [[BusyIndicator sharedInstance] startIndicator];
    
    NSString *postString = [NSString stringWithFormat:@"softid=%@", softid];
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *apiURL = [[webUrlconstant sharedInstance] URL_GET_DB];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[BusyIndicator sharedInstance] stopIndicator];
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else if (data.length > 0) {
                [self parse_GET_CONFIG:data softid:softid];
            } else {
                NSLog(@"Empty Response");
            }
        });
    }] resume];
}

- (void)parse_GET_CONFIG:(NSData *)data softid:(NSString *)softid {
    @try {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"Response: %@", responseDict);
        
        NSString *success = [responseDict[@"success"] description];
        NSString *message = [responseDict[@"message"] description];
        
        if ([success isEqualToString:@"1"])
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[responseDict[@"ip"] description] forKey:@"ip"];
            [defaults setObject:[responseDict[@"db"] description] forKey:@"db"];
            [defaults setObject:[responseDict[@"username"] description] forKey:@"ipusername"];
            [defaults setObject:[responseDict[@"pswd"] description] forKey:@"pswd"];
            [defaults setObject:softid forKey:@"softid"];
            [defaults setObject:[responseDict[@"ftppath"] description] forKey:@"ftppath"];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}

- (void)scrollData_HOME {
    [[BusyIndicator sharedInstance] startIndicator];
    
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *mobile = [defaults stringForKey:@"mobile"];
    NSString *ECAT_TYPE_NEW = [defaults stringForKey:@"ECAT_TYPE_NEW"];
    NSString *ECAT_TYPE = [defaults stringForKey:@"ECAT_TYPE"];
    NSString *apptype = ECAT_TYPE;
    NSString *type = @"ios";
    
    NSString *loginRequest, *URL_API;
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        loginRequest = [NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&mobile=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&type=%@",
                        ECAT_TYPE_NEW, apptype, mobile,
                        [defaults stringForKey:@"ip"],
                        [defaults stringForKey:@"db"],
                        [defaults stringForKey:@"ipusername"],
                        [defaults stringForKey:@"pswd"],
                        [defaults stringForKey:@"ftppath"],
                        type];
        URL_API = [WEB_URL URL_HOMEAPI];
    } else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ip = [defaults stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_homemmipanel.php", ip];
        loginRequest = [NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&mobile=%@&ftppath=%@&type=%@",
                        ECAT_TYPE_NEW, apptype, mobile,
                        [defaults stringForKey:@"ftppath"],
                        type];
    } else {
        loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@&ECAT_TYPE_NEW=%@&type=%@",
                        apptype, mobile, ECAT_TYPE_NEW, type];
        URL_API = [WEB_URL URL_HOMEAPI];
    }
    
    NSLog(@"URL_API: %@", URL_API);
    NSLog(@"Request: %@", loginRequest);
    
    NSURL *url = [NSURL URLWithString:URL_API];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *postData = [loginRequest dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setTimeoutInterval:60];
    [request setHTTPBody:postData];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[BusyIndicator sharedInstance] stopIndicator];
            if (data.length > 0 && !error) {
                [self parse_category1:data];
            } else {
                NSLog(@"%@", error ? error.localizedDescription : @"Empty Response");
            }
        });
    }] resume];
}


- (void) parse_category1:(NSData *) data {
    @try {
        
        ////////////// End processs load view
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSONDATA_HOME ===== %@", myData);
        
        NSError *error = nil;
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
            
            ns_banner = [[NSMutableArray alloc]init];
            ns_banner = [pDict objectForKey:@"bannerlist"];

            dispatch_async(dispatch_get_main_queue(), ^{
                self.bannerCollectionView.hidden = YES;
                if (self->ns_banner.count > 0) {
                    [self.bannerCollectionView reloadData];
                    self.bannerCollectionView.hidden = NO;
                }
            });
            
            ns_item = [pDict objectForKey:@"item"];
            NSLog(@"tg_master ::::::::::: :: %@",ns_item);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}


- (void)GET_UserAi
{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSString * URL_API = [WEB_URL URL_CHECK_USER];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *softid = [[NSUserDefaults standardUserDefaults]stringForKey:@"softid"];
    
    NSURL *url = [NSURL URLWithString:URL_API];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *postString = [NSString stringWithFormat:@"softid=%@&mobile=%@", softid, mobile];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"GET_UserAi Error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError;
        NSDictionary *json2 = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            NSLog(@"JSON Parsing Error: %@", jsonError.localizedDescription);
            return;
        }
        
        NSString *success = json2[@"success"];
        NSString *amcdue = json2[@"amcdue"];
        NSString *message = json2[@"message"];
        NSString *mobile = json2[@"mobile"] ? json2[@"mobile"] : @"";
        [[BusyIndicator sharedInstance]stopIndicator];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([success isEqualToString:@"1"]) {
                if ([[amcdue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"1"]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                        exit(0);
                    }];
                    UIAlertAction *callAction = [UIAlertAction actionWithTitle:@"Call" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", mobile]];
                        [[UIApplication sharedApplication] openURL:phoneURL options:@{} completionHandler:nil];
                    }];
                    [alert addAction:okAction];
                    [alert addAction:callAction];
                    [self presentViewController:alert animated:YES completion:nil];
                } else if ([[amcdue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"2"]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                                   message:message
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    UIAlertAction *callAction = [UIAlertAction actionWithTitle:@"Call" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", mobile]];
                        [[UIApplication sharedApplication] openURL:phoneURL options:@{} completionHandler:nil];
                    }];
                    [alert addAction:okAction];
                    [alert addAction:callAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                
                self->rights = json2[@"rights"];
                
                NSLog(@"rights ::::::::::::::: %@",self->rights);
                [[NSUserDefaults standardUserDefaults] setObject:self->rights forKey:@"rights"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self GET_ITEMSHOW];
                [self GET_COMPANYDETAIL];
                
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobile"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    LoginVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
                    [self.navigationController pushViewController:obj animated:YES];
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        });
    }];
    
    [task resume];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _bannerCollectionView){
        return  CGSizeMake(self.bannerCollectionView.frame.size.width, self.bannerCollectionView.frame.size.height);
    }else{
        // Calculate item width for 3 items per row
        CGFloat itemWidth = (self.collectionView.frame.size.width - 30) / 4;
        return CGSizeMake(itemWidth, 120); // Adjust the height as per your design
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _bannerCollectionView){
        return [ns_banner count];
    }else{
        return [ns_item  count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _bannerCollectionView){
        HomeBannerCell *bannerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBannerCell" forIndexPath:indexPath];
        NSString *str_url = [[ns_banner valueForKey:@"imgurl"] objectAtIndex:indexPath.row];
        str_url = [str_url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        [bannerCell.bannerImageView sd_setImageWithURL:[NSURL URLWithString:str_url]
                                      placeholderImage:[UIImage imageNamed:@"banner_Default.png"]
                                               options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
        bannerCell.bannerImageView.contentMode = UIViewContentModeScaleAspectFit;
        // Apply border radius and drop shadow to the cell content view
        bannerCell.contentView.layer.cornerRadius = 10;
        bannerCell.contentView.layer.masksToBounds = YES;
        // Set background color to white and add border
        bannerCell.contentView.backgroundColor = [UIColor whiteColor];
        bannerCell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        bannerCell.contentView.layer.borderWidth = 1.0;
        // Add shadow to the cell content view
        bannerCell.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        bannerCell.contentView.layer.shadowOpacity = 1.7;
        bannerCell.contentView.layer.shadowRadius = 10.0;
        bannerCell.contentView.layer.shadowOffset = CGSizeMake(3, 3);
        return bannerCell;
    }else{
        CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCell" forIndexPath:indexPath];
        
        NSString *str_url = [[ns_item valueForKey:@"imgurl"] objectAtIndex:indexPath.row];
        str_url = [str_url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        cell.imgeDataArray.tag = indexPath.row;
        [cell.imgeDataArray sd_setImageWithURL:[NSURL URLWithString:str_url]
                              placeholderImage:[UIImage imageNamed:@"1024.png"]
                                       options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
        cell.imgeDataArray.contentMode = UIViewContentModeScaleAspectFit;
        cell.lblTitle.text = [[ns_item valueForKey:@"caption"] objectAtIndex:indexPath.row];
        
        // Apply border radius and drop shadow to the cell content view
        cell.contentView.layer.cornerRadius = 10;
        cell.contentView.layer.masksToBounds = YES;
        // Set background color to white and add border
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.contentView.layer.borderWidth = 1.0;
        // Add shadow to the cell content view
        cell.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.contentView.layer.shadowOpacity = 1.7;
        cell.contentView.layer.shadowRadius = 10.0;
        cell.contentView.layer.shadowOffset = CGSizeMake(3, 3);
        
        return cell;
    }
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _bannerCollectionView){
        
    }else{
        NSString *str_type = [[ns_item valueForKey:@"type"] objectAtIndex:indexPath.row];
        NSString *rights = [[NSUserDefaults standardUserDefaults]stringForKey:@"rights"];
        unichar character = [rights characterAtIndex:2];
        NSString *str_first = [NSString stringWithFormat:@"%c", character];
        if ([str_type isEqualToString:@"Product Gallery"]) {
            unichar character = [rights characterAtIndex:0];
            NSString *str_first = [NSString stringWithFormat:@"%c", character];
            
            if ([str_first isEqualToString:@"1"]) {
                [self alertMsg:@"You do not have permission to use this feature"];
            }else{
                NSString *displayby = [[NSUserDefaults standardUserDefaults]stringForKey:@"displayby"];
                if ([displayby isEqualToString:@"1"]) {
                    ProductGroup *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductGroup"];
                    [self.navigationController pushViewController:obj animated:YES];
                }else{
                    ProductGallery *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductGallery"];
                    obj.str_igroup = @"";
                    [self.navigationController pushViewController:obj animated:YES];
                }
                
            }
        }else if ([str_type isEqualToString:@"Tag Calculator"]) {
            unichar character = [rights characterAtIndex:1];
            NSString *str_first = [NSString stringWithFormat:@"%c", character];
            if ([str_first isEqualToString:@"1"]) {
                [self alertMsg:@"You do not have permission to use this feature"];
            }else{
                TagCalculator *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"TagCalculator"];
                obj.str_tag = @"";
                [self.navigationController pushViewController:obj animated:YES];
            }
            
        }else if ([str_type isEqualToString:@"Physical Stock"]) {
            unichar character = [rights characterAtIndex:1];
            NSString *str_first = [NSString stringWithFormat:@"%c", character];
            if ([str_first isEqualToString:@"1"]) {
                [self alertMsg:@"You do not have permission to use this feature"];
            }else{
                StockVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"StockVC"];
                //obj.str_tag = @"";
                [self.navigationController pushViewController:obj animated:YES];
            }
        }else if ([str_type isEqualToString:@"Customer Visit"]) {
            unichar character = [rights characterAtIndex:5];
            NSString *str_first = [NSString stringWithFormat:@"%c", character];
            
            if ([str_first isEqualToString:@"1"]) {
                [self alertMsg:@"You do not have permission to use this feature"];
            }else{
                CustomerVisit *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomerVisit"];
                obj.str_act = @"";
                [self.navigationController pushViewController:obj animated:YES];
            }
            
        }else if ([str_type isEqualToString:@"Customer Repair"]) { //Customer Repair
            unichar character = [rights characterAtIndex:8];
            NSString *str_first = [NSString stringWithFormat:@"%c", character];
            if ([str_first isEqualToString:@"1"]) {
                [self alertMsg:@"You do not have permission to use this feature"];
            }else{
                //Customer Order
                AddDemand *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDemand"];
                obj.str_Activity = @"REP";
                [self.navigationController pushViewController:obj animated:YES];
            }
        }else if ([str_type isEqualToString:@"Add Your Demand"]) { //Customer Order
            unichar character = [rights characterAtIndex:8];
            NSString *str_first = [NSString stringWithFormat:@"%c", character];
            if ([str_first isEqualToString:@"1"]) {
                [self alertMsg:@"You do not have permission to use this feature"];
            }else{
                //Customer Order
                AddDemand *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"AddDemand"];
                obj.str_Activity = @"ORD";
                [self.navigationController pushViewController:obj animated:YES];
            }
        }else if ([str_type isEqualToString:@"Customer Entry"]) {
            unichar character = [rights characterAtIndex:8];
            NSString *str_first = [NSString stringWithFormat:@"%c", character];
            if ([str_first isEqualToString:@"1"]) {
                [self alertMsg:@"You do not have permission to use this feature"];
            }else{
                CustomerEntry *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomerEntry"];
                //obj.str_Activity = @"REP";
                [self.navigationController pushViewController:obj animated:YES];
            }
        }else if ([str_type isEqualToString:@"Quotation"]) {
            unichar character = [rights characterAtIndex:2];
            NSString *str_first = [NSString stringWithFormat:@"%c", character];
            
            if ([str_first isEqualToString:@"1"]) {
                [self alertMsg:@"You do not have permission to use this feature"];
            }else{
                CartList *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"CartList"];
                obj.str_tag = @"";
                obj.str_rlid = @"0";
                obj.str_idesc = @"MMI";
                obj.str_activity = @"MMI HOME";
                [self.navigationController pushViewController:obj animated:YES];
            }
        }else if ([str_type isEqualToString:@"My Order"]) {
            unichar character = [rights characterAtIndex:3];
            NSString *str_first = [NSString stringWithFormat:@"%c", character];
            
            if ([str_first isEqualToString:@"1"]) {
                [self alertMsg:@"You do not have permission to use this feature"];
            }else{
                OrderList *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderList"];
                [self.navigationController pushViewController:obj animated:YES];
            }
        }else if ([str_type isEqualToString:@"Outstanding"]) {
            unichar character = [rights characterAtIndex:6];
            NSString *str_first = [NSString stringWithFormat:@"%c", character];
            
            if ([str_first isEqualToString:@"1"]) {
                [self alertMsg:@"You do not have permission to use this feature"];
            }else{
                OutStanding *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"OutStanding"];
                [self.navigationController pushViewController:obj animated:YES];
            }
        }else if ([str_type isEqualToString:@"Today Bhav"]) {
            unichar character = [rights characterAtIndex:11];
            NSString *str_first = [NSString stringWithFormat:@"%c", character];
            
            if ([str_first isEqualToString:@"1"]) {
                [self alertMsg:@"You do not have permission to use this feature"];
            }else{
                TodayBhav *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"TodayBhav"];
                [self.navigationController pushViewController:obj animated:YES];
            }
        }else if([str_type isEqualToString:@"Undelivered"]){
            unichar character = [rights characterAtIndex:10];
            NSString *str_first = [NSString stringWithFormat:@"%c", character];
            
            if ([str_first isEqualToString:@"1"]) {
                [self alertMsg:@"You do not have permission to use this feature"];
            }else{
                Undelivered *obj= [self.storyboard instantiateViewControllerWithIdentifier:@"Undelivered"];
                [self.navigationController pushViewController:obj animated:YES];
            }
        } else if([str_type isEqualToString:@"Order Scan"]){
            CustomerVisit *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomerVisit"];
            obj.str_act = @"OL";
            [self.navigationController pushViewController:obj animated:YES];
        }else if([str_type isEqualToString:@"Estimate"]){
            CustomerVisit *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomerVisit"];
            obj.str_act = @"SL";
            [self.navigationController pushViewController:obj animated:YES];
        }else if ([str_type isEqualToString:@"My Estimate"]) {
            OrderList *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderList"];
            obj.str_act = @"SL";
            [self.navigationController pushViewController:obj animated:YES];
        }else if([str_type isEqualToString:@"Order Register"]){
            if ([str_first isEqualToString:@"1"]) {
                [self alertMsg:@"You do not have permission to use this feature"];
            }else{
                OrderRegisterVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderRegisterVC"];
                obj.str_ViewType = @"ORD";
                [self.navigationController pushViewController:obj animated:YES];
            }
        }else if ([str_type isEqualToString:@"Repair Register"]) {
            if ([str_first isEqualToString:@"1"]) {
                [self alertMsg:@"You do not have permission to use this feature"];
            }else{
                OrderRegisterVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderRegisterVC"];
                obj.str_ViewType = @"REP";
                [self.navigationController pushViewController:obj animated:YES];
            }
        } else if([str_type isEqualToString:@"Ledger"]){
            //            CustomerVisit *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomerVisit"];
            //            obj.str_act = @"OL";
            LedgerVC *obj = [[LedgerVC alloc] init];
            [self.navigationController pushViewController:obj animated:YES];
        }
    }
}

#pragma mark - Auto Scroll Timer

- (void)startAutoScroll {
    if (autoScrollTimer == nil) {
        autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(autoScrollBanner) userInfo:nil repeats:YES];
    }
}

- (void)stopAutoScroll {
    [autoScrollTimer invalidate];
    if (autoScrollTimer) {
        [autoScrollTimer invalidate];
        autoScrollTimer = nil;
    }
}

- (void)autoScrollBanner {
    NSInteger numberOfItems = [self.bannerCollectionView numberOfItemsInSection:0];
    if (numberOfItems == 0) return;
    self->currentIndex = (self->currentIndex + 1) % numberOfItems;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self->currentIndex inSection:0];
        [self.bannerCollectionView scrollToItemAtIndexPath:indexPath
                                          atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                  animated:YES];
    });
}

-(void)GET_ITEMSHOW {
    [[BusyIndicator sharedInstance] startIndicator];
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"ip=%@&ipusername=%@&password=%@&dbname=%@&ftppath=%@&apptype=%@&ECAT_TYPE_NEW=%@&mobile=%@&apptype_4=%@",ip,ipusername,pswd,db,ftppath,apptype,ECAT_TYPE,mobile,ECAT_TYPE];
        
        URL_API =[WEB_URL URL_ITEMSHOW];
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_itemshow.php",ip];
        loginRequest=[NSString stringWithFormat:@"ip=%@&ftppath=%@&apptype=%@&ECAT_TYPE_NEW=%@&mobile=%@&apptype_4=%@",ip,ftppath,apptype,ECAT_TYPE,mobile,ECAT_TYPE];
    }else{
        loginRequest=[NSString stringWithFormat:@"apptype=%@&mobile=%@&apptype_4=%@",apptype,mobile,ECAT_TYPE];
        URL_API =[WEB_URL URL_ITEMSHOW];
    }
    
    NSString *api = [NSString stringWithFormat: @"%@", URL_API];
    
    NSLog(@"URL_ITEMSHOW ::::::::::::::::::::::::::::::: %@",api);
    NSURL *url = [NSURL URLWithString:api];
    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseLogin_showapi:data];
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


- (void)parseLogin_showapi:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
            
            // Retrieve the arrays directly
            NSArray *cus_details = [pDict objectForKey:@"cus_details"];
            NSArray *vist_reason = [pDict objectForKey:@"vist_reason"];
            NSArray *qty = [pDict objectForKey:@"qty"];
            NSArray *rgap = [pDict objectForKey:@"rgap"];
            NSArray *chqty = [pDict objectForKey:@"chqty"];
            NSArray *sorder = [pDict objectForKey:@"sorder"];
            NSArray *interested = [pDict objectForKey:@"interested"];
            NSArray *addyourdemand = [pDict objectForKey:@"addyourdemand"];
            NSArray *wtgap = [pDict objectForKey:@"wtgap"];
            NSArray *wtdec = [pDict objectForKey:@"wtdec"];
            NSArray *printer = [pDict objectForKey:@"printer"];
            NSArray *aprval_stk = [pDict objectForKey:@"aprval_stk"];
            NSArray *tgstatus = [pDict objectForKey:@"tgstatus"];
            NSArray *instk = [pDict objectForKey:@"instk"];
            NSArray *outstk = [pDict objectForKey:@"outstk"];
            NSArray *disrate = [pDict objectForKey:@"disrate"];
            NSArray *vcmobile = [pDict objectForKey:@"vcmobile"];
            NSArray *displayby = [pDict objectForKey:@"displayby"];
            NSArray *visitdis = [pDict objectForKey:@"visitdis"];
            NSArray *configgst = [pDict objectForKey:@"configgst"];
            NSArray *screenshot = [pDict objectForKey:@"screenshot"];
            NSArray *appversion = [pDict objectForKey:@"appversion"];
            NSArray *appupdatedate = [pDict objectForKey:@"appupdatedate"];
            NSArray *finedecimal = [pDict objectForKey:@"finedecimal"];
            NSArray *sbhav_vrval = [pDict objectForKey:@"sbhav_vrval"];
            NSArray *gbhav_vrval = [pDict objectForKey:@"gbhav_vrval"];
            NSArray *salesman_dis = [pDict objectForKey:@"salesman_dis"];
            
            
            // Save to NSUserDefaults
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:sbhav_vrval forKey:@"sbhav_vrval"];
            [defaults setObject:gbhav_vrval forKey:@"gbhav_vrval"];
            [defaults setObject:finedecimal forKey:@"finedecimal"];
            [defaults setObject:cus_details forKey:@"cus_details"];
            [defaults setObject:vist_reason forKey:@"vist_reason"];
            [defaults setObject:qty forKey:@"qty"];
            [defaults setObject:rgap forKey:@"rgap"];
            [defaults setObject:chqty forKey:@"chqty"];
            [defaults setObject:sorder forKey:@"sorder"];
            [defaults setObject:interested forKey:@"interested"];
            [defaults setObject:addyourdemand forKey:@"addyourdemand"];
            [defaults setObject:wtgap forKey:@"wtgap"];
            [defaults setObject:wtdec forKey:@"wtdec"];
            [defaults setObject:printer forKey:@"printer"];
            [defaults setObject:tgstatus forKey:@"tgstatus"];
            [defaults setObject:instk forKey:@"instk"];
            [defaults setObject:outstk forKey:@"outstk"];
            [defaults setObject:disrate forKey:@"disrate"];
            [defaults setObject:vcmobile forKey:@"vcmobile"];
            [defaults setObject:displayby forKey:@"displayby"];
            [defaults setObject:visitdis forKey:@"visitdis"];
            [defaults setObject:configgst forKey:@"configgst"];
            [defaults setObject:screenshot forKey:@"screenshot"];
            [defaults setObject:appversion forKey:@"appversion"];
            [defaults setObject:appupdatedate forKey:@"appupdatedate"];
            [defaults setObject:salesman_dis forKey:@"salesman_dis"];
            [defaults setObject:salesman_dis forKey:@"aprval_stk"];
            
            
            // Synchronize to ensure the changes are saved
            [defaults synchronize];
            
            if ([str_success isEqualToString:@"1"]) {
                
                NSMutableArray *ns_item1 = [pDict objectForKey:@"item1"];
                NSString *item1 = [ns_item1 description];
                NSMutableArray *ns_item2 = [pDict objectForKey:@"item2"];
                NSString *item2 = [ns_item2 description];
                NSMutableArray *ns_item3 = [pDict objectForKey:@"item3"];
                NSString *item3 = [ns_item3 description];
                NSMutableArray *ns_item4 = [pDict objectForKey:@"item4"];
                NSString *item4 = [ns_item4 description];
                NSMutableArray *ns_item5 = [pDict objectForKey:@"item5"];
                NSString *item5 = [ns_item5 description];
                NSMutableArray *ns_item6 = [pDict objectForKey:@"item6"];
                NSString *item6 = [ns_item6 description];
                NSMutableArray *ns_idesc = [pDict objectForKey:@"idesc"];
                NSString *idesc = [ns_idesc description];
                NSMutableArray *ns_tgno = [pDict objectForKey:@"tgno"];
                NSString *tgno = [ns_tgno description];
                NSMutableArray *ns_gwt = [pDict objectForKey:@"gwt"];
                NSString *gwt = [ns_gwt description];
                NSMutableArray *ns_wt = [pDict objectForKey:@"wt"];
                NSString *wt = [ns_wt description];
                NSMutableArray *ns_sdiwt = [pDict objectForKey:@"sdiwt"];
                NSString *sdiwt = [ns_sdiwt description];
                NSMutableArray *ns_sstnwt = [pDict objectForKey:@"sstnwt"];
                NSString *sstnwt = [ns_sstnwt description];
                NSMutableArray *ns_stamp = [pDict objectForKey:@"stamp"];
                NSString *stamp = [ns_stamp description];
                NSMutableArray *ns_mrp = [pDict objectForKey:@"mrp"];
                NSString *mrp = [ns_mrp description];
                NSMutableArray *ns_gst = [pDict objectForKey:@"gst"];
                NSString *gst = [ns_gst description];
                NSMutableArray *ns_remarks = [pDict objectForKey:@"remarks"];
                NSString *remarks = [ns_remarks description];
                
                [[NSUserDefaults standardUserDefaults] setObject:idesc forKey:@"adddesign_idesc"];
                [[NSUserDefaults standardUserDefaults] setObject:tgno forKey:@"adddesign_tgno"];
                [[NSUserDefaults standardUserDefaults] setObject:gwt forKey:@"adddesign_gwt"];
                [[NSUserDefaults standardUserDefaults] setObject:wt forKey:@"adddesign_wt"];
                [[NSUserDefaults standardUserDefaults] setObject:sdiwt forKey:@"adddesign_sdiwt"];
                [[NSUserDefaults standardUserDefaults] setObject:sstnwt forKey:@"adddesign_sstnwt"];
                [[NSUserDefaults standardUserDefaults] setObject:stamp forKey:@"adddesign_stamp"];
                [[NSUserDefaults standardUserDefaults] setObject:mrp forKey:@"adddesign_mrp"];
                [[NSUserDefaults standardUserDefaults] setObject:gst forKey:@"adddesign_gst"];
                [[NSUserDefaults standardUserDefaults] setObject:remarks forKey:@"adddesign_remarks"];
                [[NSUserDefaults standardUserDefaults] setObject:item1 forKey:@"item1"];
                [[NSUserDefaults standardUserDefaults] setObject:item2 forKey:@"item2"];
                [[NSUserDefaults standardUserDefaults] setObject:item3 forKey:@"item3"];
                [[NSUserDefaults standardUserDefaults] setObject:item4 forKey:@"item4"];
                [[NSUserDefaults standardUserDefaults] setObject:item5 forKey:@"item5"];
                [[NSUserDefaults standardUserDefaults] setObject:item6 forKey:@"item6"];
                
            }else{
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message"
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

-(void)GET_COMPANYDETAIL {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        
        loginRequest=[NSString stringWithFormat:@"ip=%@&ipusername=%@&password=%@&dbname=%@&ftppath=%@&apptype=%@&ECAT_TYPE_NEW=%@&mobile=%@",ip,ipusername,pswd,db,ftppath,apptype,ECAT_TYPE,mobile];
        
        URL_API =[WEB_URL URL_COMPANY_DETAIL];
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_company_details.php",ip];
        loginRequest = [NSString stringWithFormat:@"ip=%@&ftppath=%@&apptype=%@&ECAT_TYPE_NEW=%@&mobile=%@",ip,ftppath,apptype,ECAT_TYPE,mobile];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&mobile=%@",apptype,mobile];
        URL_API = [WEB_URL URL_COMPANY_DETAIL];
    }
    
    NSString *api = [NSString stringWithFormat: @"%@", URL_API];
    NSURL *url = [NSURL URLWithString:api];
    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data1];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseLogin_comp:data];
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


- (void)parseLogin_comp:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data companydetail = %@", myData);
        NSError *error = nil;
        [[BusyIndicator sharedInstance]stopIndicator];
        
        //parsing the JSON response
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
            
            NSMutableArray *ns_smacno = [pDict objectForKey:@"smacno"];
            NSString *smacno = [ns_smacno description];
            NSMutableArray *ns_count = [pDict objectForKey:@"count"];
            NSString *count = [ns_count description];
            
            [[NSUserDefaults standardUserDefaults] setObject:smacno forKey:@"smacno"];
            [[NSUserDefaults standardUserDefaults] setObject:count forKey:@"count"];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}
@end
