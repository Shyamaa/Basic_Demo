//
//  APIManager.h
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 16/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Completion handler for API requests
 * @param data The parsed JSON response data
 * @param error Any error that occurred during the request
 */
typedef void (^APICompletionHandler)(NSDictionary * _Nullable data, NSError * _Nullable error);

/**
 * APIManager - Centralized network request manager
 * 
 * Features:
 * - Singleton pattern for global access
 * - Automatic JSON parsing
 * - Comprehensive error handling
 * - Request cancellation support
 * - Detailed logging
 * - Timeout management
 */
@interface APIManager : NSObject

/**
 * Shared instance of APIManager
 * @return The singleton instance
 */
+ (instancetype)sharedManager;

/**
 * Perform a GET request
 * @param urlString The URL to request
 * @param params Query parameters to append to the URL
 * @param completion Completion handler called with result
 */
- (void)GET:(NSString *)urlString
 parameters:(nullable NSDictionary *)params
 completion:(APICompletionHandler)completion;

/**
 * Perform a POST request
 * @param urlString The URL to request
 * @param params JSON body parameters
 * @param completion Completion handler called with result
 */
- (void)POST:(NSString *)urlString
  parameters:(nullable NSDictionary *)params
  completion:(APICompletionHandler)completion;

/**
 * Cancel all active requests
 */
- (void)cancelAllRequests;

/**
 * Cancel a specific request by its identifier
 * @param taskIdentifier The task identifier to cancel
 */
- (void)cancelRequestWithIdentifier:(NSUInteger)taskIdentifier;

@end
