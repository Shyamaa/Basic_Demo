//
//  ErrorHandler.m
//  Jwelly Ecat
//
//  Created by MMI Softwares Pvt Ltd on 16/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "ErrorHandler.h"

@implementation ErrorHandler

+ (void)handleError:(NSError *)error inViewController:(UIViewController *)viewController {
    if (!error || !viewController) {
        return;
    }
    
    // Log the error
    [self logError:error withContext:@"General Error"];
    
    // Determine error type and show appropriate message
    NSString *title = @"Error";
    NSString *message = error.localizedDescription;
    
    // Handle specific error domains
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        [self handleNetworkError:error inViewController:viewController];
        return;
    }
    
    // Handle custom error codes
    switch (error.code) {
        case -1001:
            title = @"Connection Timeout";
            message = @"The request timed out. Please check your internet connection and try again.";
            break;
        case -1002:
            title = @"Invalid Response";
            message = @"The server returned an invalid response. Please try again.";
            break;
        case -1003:
            title = @"Network Unavailable";
            message = @"Please check your internet connection and try again.";
            break;
        default:
            // Use the error's localized description
            break;
    }
    
    [self showErrorWithTitle:title message:message inViewController:viewController];
}

+ (void)handleNetworkError:(NSError *)error inViewController:(UIViewController *)viewController {
    if (!error || !viewController) {
        return;
    }
    
    // Log the network error
    [self logError:error withContext:@"Network Error"];
    
    NSString *title = @"Network Error";
    NSString *message;
    
    switch (error.code) {
        case NSURLErrorNotConnectedToInternet:
            message = @"No internet connection. Please check your network settings and try again.";
            break;
        case NSURLErrorTimedOut:
            message = @"Request timed out. Please check your internet connection and try again.";
            break;
        case NSURLErrorCannotFindHost:
            message = @"Unable to reach the server. Please try again later.";
            break;
        case NSURLErrorCannotConnectToHost:
            message = @"Unable to connect to the server. Please try again later.";
            break;
        case NSURLErrorNetworkConnectionLost:
            message = @"Network connection was lost. Please try again.";
            break;
        case NSURLErrorServerCertificateUntrusted:
            message = @"Security certificate issue. Please contact support.";
            break;
        default:
            message = @"A network error occurred. Please try again.";
            break;
    }
    
    [self showErrorWithTitle:title message:message inViewController:viewController];
}

+ (void)handleValidationError:(NSString *)message inViewController:(UIViewController *)viewController {
    if (!message || !viewController) {
        return;
    }
    
    NSLog(@"⚠️ Validation Error: %@", message);
    [self showErrorWithTitle:@"Validation Error" message:message inViewController:viewController];
}

+ (void)showNetworkErrorInViewController:(UIViewController *)viewController {
    if (!viewController) {
        return;
    }
    
    [self showErrorWithTitle:@"Network Error" 
                     message:@"Please check your internet connection and try again." 
           inViewController:viewController];
}

+ (void)showErrorWithTitle:(NSString *)title 
                   message:(NSString *)message 
         inViewController:(UIViewController *)viewController {
    
    if (!title || !message || !viewController) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" 
                                                           style:UIAlertActionStyleDefault 
                                                         handler:nil];
        [alert addAction:okAction];
        
        // Present the alert
        [viewController presentViewController:alert animated:YES completion:nil];
    });
}

+ (void)logError:(NSError *)error withContext:(NSString *)context {
    if (!error) {
        return;
    }
    
    NSString *logMessage = [NSString stringWithFormat:@"❌ %@ - Domain: %@, Code: %ld, Description: %@", 
                           context ?: @"Error", 
                           error.domain, 
                           (long)error.code, 
                           error.localizedDescription];
    
    NSLog(@"%@", logMessage);
    
    // Log additional error information if available
    if (error.userInfo.count > 0) {
        NSLog(@"📋 Error User Info: %@", error.userInfo);
    }
    
    // Log underlying error if available
    if (error.underlyingError) {
        NSLog(@"🔗 Underlying Error: %@", error.underlyingError.localizedDescription);
    }
}

@end 