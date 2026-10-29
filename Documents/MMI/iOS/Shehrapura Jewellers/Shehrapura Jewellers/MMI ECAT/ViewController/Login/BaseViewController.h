//
//
//  BaseViewController.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 15/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+DatePicker.h"
#import "UITextField+PickerWithSearch.h"
#import "webUrlconstant.h"
#import "BusyIndicator.h"
#import "ImagePickerHelper.h"
#import "APIManager.h"
// TODO: Uncomment these imports after adding files to Xcode project
// #import "ErrorHandler.h"
// #import "DeviceUtils.h"
// #import "ValidationUtils.h"
#import <MessageUI/MessageUI.h>
#import "UIImageView+WebCache.h"
#import <Speech/Speech.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * BaseViewController - Enhanced base class for all view controllers
 * 
 * Provides:
 * - Modern device detection
 * - Centralized error handling
 * - Input validation
 * - Haptic feedback
 * - Screen capture protection
 * - Keyboard management
 * - Common UI utilities
 */
@interface BaseViewController : UIViewController<MFMessageComposeViewControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,SFSpeechRecognizerDelegate>

// Voice Recognition Properties
@property (nonatomic, strong) SFSpeechRecognizer *speechRecognizer;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property (nonatomic, strong) SFSpeechRecognitionTask *recognitionTask;
@property (nonatomic, assign) BOOL isListening;
@property (nonatomic, strong) UIAlertController *listeningAlert;
@property (nonatomic, assign) BOOL isNavigating;
@property (nonatomic, strong) NSTimer *silenceTimer;
@property (nonatomic, strong) AVAudioEngine *audioEngine;

- (void)setUpListening;
- (void)stopListening;

- (void)showPickerWithData:(NSArray<NSString *> *)data
               onSelection:(void (^)(NSString *selectedItem))completion;
- (void)showPickerWithTitle:(NSString *)title
                       data:(NSArray<NSString *> *)data
                onSelection:(void (^)(NSString *selectedItem))completion;

- (void)openCamera;
- (void)openPhotoLibrary;
    
#pragma mark - Setup Methods

/**
 * Setup date picker for text field
 * @param textField The text field to configure
 */
- (void)setupDatePickerForTextField:(UITextField *)textField;

/**
 * Setup time picker for text field
 * @param textField The text field to configure
 */
- (void)setupTimePickerForTextField:(UITextField *)textField;

/**
 * Setup list picker for text field
 * @param textField The text field to configure
 */
- (void)setupListPickerForTextField:(UITextField *)textField;

#pragma mark - Alert & Communication

/**
 * Show alert message
 * @param message The message to display
 */
- (void)alertMsg:(NSString *)message;
- (void)alertMsgWithTitle:(NSString *)message title:(NSString *)strTitle ;

/**
 * Make phone call
 * @param phoneNumber The phone number to call
 */
- (void)phoneCallMethod:(NSString *)phoneNumber;

/**
 * Share message on WhatsApp
 * @param message The message to share
 * @param phoneNumber The phone number
 */
- (void)shareOnWhatsApp:(NSString *)message phone:(NSString *)phoneNumber;

/**
 * Send SMS
 * @param message The message to send
 * @param phoneNumber The phone number
 */
- (void)phoneSMSMethod:(NSString *)message number:(NSString *)phoneNumber;

/**
 * Share content with image
 * @param message The message to share
 * @param imageUrl The image URL
 */
- (void)shareContent:(NSString *)message imageUrl:(NSString *)imageUrl;

#pragma mark - Data & Validation

/**
 * Filter array data
 * @param arrayData The array to filter
 * @return Filtered array
 */
- (NSArray *)filterData:(NSArray *)arrayData;

/**
 * Validate email format (legacy method - use ValidationUtils instead)
 * @param email The email to validate
 * @return YES if valid
 */
- (BOOL)isValidEmail:(NSString *)email;

#pragma mark - Modern Utilities

/**
 * Generate haptic feedback
 * @param style The haptic feedback style
 */
- (void)generateHapticFeedback:(UIImpactFeedbackStyle)style;

/**
 * Get device-specific layout constant
 * @param key The layout key
 * @return The layout value
 */
- (CGFloat)layoutConstantForKey:(NSString *)key;

/**
 * Setup modern navigation bar
 */
- (void)setupModernNavigationBar;

/**
 * Set navigation title on the left side
 * @param title The title to display
 */
- (void)setNavigationTitleOnLeft:(NSString *)title;

/**
 * Set navigation title on the left side with custom styling
 * @param title The title to display
 * @param font The font to use
 * @param color The text color
 */
- (void)setNavigationTitleOnLeft:(NSString *)title 
                            font:(UIFont *)font 
                           color:(UIColor *)color;

/**
 * Set navigation title on the left side with subtitle
 * @param title The main title
 * @param subtitle The subtitle
 */
- (void)setNavigationTitleOnLeft:(NSString *)title 
                        subtitle:(NSString *)subtitle;

/**
 * Set navigation title on the left side with custom image and text
 * @param title The title text
 * @param imageName The image name to show before the title
 */
- (void)setNavigationTitleOnLeft:(NSString *)title 
                      withImage:(NSString *)imageName;

/**
 * Reset navigation title to center (default behavior)
 */
- (void)resetNavigationTitleToCenter;

/**
 * Set navigation title with custom alignment
 * @param title The title text
 * @param alignment The text alignment (Left, Center, Right)
 */
- (void)setNavigationTitle:(NSString *)title 
                alignment:(NSTextAlignment)alignment;

/**
 * Ensure navigation bar items are properly styled
 * Call this method if you need to force update the styling
 */
- (void)ensureNavigationBarStyling;

/**
 * Ensure back button shows only the arrow without text
 */
- (void)ensureBackButtonArrowOnly;

/**
 * Setup modern table view
 * @param tableView The table view to configure
 */
- (void)setupModernTableView:(UITableView *)tableView;

/**
 * Setup modern collection view
 * @param collectionView The collection view to configure
 */
- (void)setupModernCollectionView:(UICollectionView *)collectionView;

/**
 * Show loading indicator
 * @param message Optional loading message
 */
- (void)showLoading:(nullable NSString *)message;

/**
 * Hide loading indicator
 */
- (void)hideLoading;

/**
 * Handle API error
 * @param error The error to handle
 */
- (void)handleAPIError:(NSError *)error;

/**
 * Validate form fields
 * @param fields Dictionary of field names to validation results
 * @return YES if all validations pass
 */
- (BOOL)validateFormFields:(NSDictionary<NSString *, id> *)fields;

- (void)logoutApp;
- (void)setUpLeftMenuBtn;
-(void)GET_ITEMSHOWApi;
-(void)setUpNavigationLogo;
NSString *SafeString(id value);
@end

NS_ASSUME_NONNULL_END
