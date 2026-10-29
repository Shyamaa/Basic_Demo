//
//  ErrorHandler.h
//  Jwelly Ecat
//
//  Created by MMI Softwares Pvt Ltd on 16/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * ErrorHandler - Centralized error management system
 * 
 * Provides consistent error handling across the application with:
 * - User-friendly error messages
 * - Automatic error logging
 * - Standardized error presentation
 * - Network error handling
 * - Validation error handling
 */
@interface ErrorHandler : NSObject

/**
 * Handle any error with automatic user notification
 * @param error The error to handle
 * @param viewController The view controller to present the error in
 */
+ (void)handleError:(NSError *)error inViewController:(UIViewController *)viewController;

/**
 * Handle network-specific errors
 * @param error The network error to handle
 * @param viewController The view controller to present the error in
 */
+ (void)handleNetworkError:(NSError *)error inViewController:(UIViewController *)viewController;

/**
 * Handle validation errors
 * @param message The validation error message
 * @param viewController The view controller to present the error in
 */
+ (void)handleValidationError:(NSString *)message inViewController:(UIViewController *)viewController;

/**
 * Show a generic network error message
 * @param viewController The view controller to present the error in
 */
+ (void)showNetworkErrorInViewController:(UIViewController *)viewController;

/**
 * Show a custom error message
 * @param title The error title
 * @param message The error message
 * @param viewController The view controller to present the error in
 */
+ (void)showErrorWithTitle:(NSString *)title 
                   message:(NSString *)message 
         inViewController:(UIViewController *)viewController;

/**
 * Log error for debugging purposes
 * @param error The error to log
 * @param context Additional context information
 */
+ (void)logError:(NSError *)error withContext:(NSString *)context;

@end

NS_ASSUME_NONNULL_END 