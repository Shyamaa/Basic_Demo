//
//  Logger.h
//  Jwelly Ecat
//
//  Created by MMI Softwares Pvt Ltd on 16/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Log level enumeration
 */
typedef NS_ENUM(NSInteger, MMILogLevel) {
    MMILogLevelVerbose = 0,
    MMILogLevelDebug,
    MMILogLevelInfo,
    MMILogLevelWarning,
    MMILogLevelError,
    MMILogLevelCritical
};

/**
 * Logger - Modern logging system
 * 
 * Features:
 * - Multiple log levels
 * - File logging
 * - Performance logging
 * - Crash reporting integration
 * - Network request logging
 * - User action tracking
 */
@interface Logger : NSObject

#pragma mark - Configuration

/**
 * Set the minimum log level
 * @param level The minimum level to log
 */
+ (void)setLogLevel:(MMILogLevel)level;

/**
 * Enable/disable file logging
 * @param enabled Whether to enable file logging
 */
+ (void)setFileLoggingEnabled:(BOOL)enabled;

/**
 * Enable/disable console logging
 * @param enabled Whether to enable console logging
 */
+ (void)setConsoleLoggingEnabled:(BOOL)enabled;

#pragma mark - Logging Methods

/**
 * Log verbose message
 * @param format The format string
 * @param ... The arguments
 */
+ (void)verbose:(NSString *)format, ...;

/**
 * Log debug message
 * @param format The format string
 * @param ... The arguments
 */
+ (void)debug:(NSString *)format, ...;

/**
 * Log info message
 * @param format The format string
 * @param ... The arguments
 */
+ (void)info:(NSString *)format, ...;

/**
 * Log warning message
 * @param format The format string
 * @param ... The arguments
 */
+ (void)warning:(NSString *)format, ...;

/**
 * Log error message
 * @param format The format string
 * @param ... The arguments
 */
+ (void)error:(NSString *)format, ...;

/**
 * Log critical message
 * @param format The format string
 * @param ... The arguments
 */
+ (void)critical:(NSString *)format, ...;

#pragma mark - Specialized Logging

/**
 * Log network request
 * @param method The HTTP method
 * @param url The request URL
 * @param headers The request headers
 * @param body The request body
 */
+ (void)logNetworkRequest:(NSString *)method 
                      url:(NSString *)url 
                  headers:(nullable NSDictionary *)headers 
                     body:(nullable id)body;

/**
 * Log network response
 * @param statusCode The HTTP status code
 * @param url The response URL
 * @param headers The response headers
 * @param data The response data
 * @param error The error if any
 */
+ (void)logNetworkResponse:(NSInteger)statusCode 
                       url:(NSString *)url 
                   headers:(nullable NSDictionary *)headers 
                      data:(nullable NSData *)data 
                     error:(nullable NSError *)error;

/**
 * Log user action
 * @param action The action performed
 * @param screen The screen where action occurred
 * @param details Additional details
 */
+ (void)logUserAction:(NSString *)action 
                screen:(NSString *)screen 
               details:(nullable NSDictionary *)details;

/**
 * Log performance metric
 * @param metric The metric name
 * @param value The metric value
 * @param unit The unit of measurement
 */
+ (void)logPerformance:(NSString *)metric 
                 value:(double)value 
                  unit:(NSString *)unit;

/**
 * Log app lifecycle event
 * @param event The lifecycle event
 * @param details Additional details
 */
+ (void)logLifecycleEvent:(NSString *)event 
                  details:(nullable NSDictionary *)details;

#pragma mark - Utility Methods

/**
 * Get log file path
 * @return The path to the current log file
 */
+ (NSString *)logFilePath;

/**
 * Clear log files
 */
+ (void)clearLogs;

/**
 * Get log file size in bytes
 * @return The size of the log file
 */
+ (unsigned long long)logFileSize;

/**
 * Export logs to file
 * @param filePath The path to export to
 * @return YES if successful
 */
+ (BOOL)exportLogsToFile:(NSString *)filePath;

@end

// Convenience macros for easier logging
#define MMI_LOG_VERBOSE(format, ...) [Logger verbose:format, ##__VA_ARGS__]
#define MMI_LOG_DEBUG(format, ...) [Logger debug:format, ##__VA_ARGS__]
#define MMI_LOG_INFO(format, ...) [Logger info:format, ##__VA_ARGS__]
#define MMI_LOG_WARNING(format, ...) [Logger warning:format, ##__VA_ARGS__]
#define MMI_LOG_ERROR(format, ...) [Logger error:format, ##__VA_ARGS__]
#define MMI_LOG_CRITICAL(format, ...) [Logger critical:format, ##__VA_ARGS__]

NS_ASSUME_NONNULL_END 