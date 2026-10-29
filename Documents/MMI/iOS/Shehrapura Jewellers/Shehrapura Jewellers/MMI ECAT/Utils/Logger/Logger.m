//
//  Logger.m
//  Jwelly Ecat
//
//  Created by MMI Softwares Pvt Ltd on 16/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "Logger.h"

@interface Logger ()
@property (class, nonatomic, strong) NSFileHandle *logFileHandle;
@property (class, nonatomic, strong) NSDateFormatter *dateFormatter;
@property (class, nonatomic, assign) MMILogLevel currentLogLevel;
@property (class, nonatomic, assign) BOOL fileLoggingEnabled;
@property (class, nonatomic, assign) BOOL consoleLoggingEnabled;
@end

@implementation Logger

static NSFileHandle *_logFileHandle = nil;
static NSDateFormatter *_dateFormatter = nil;
static MMILogLevel _currentLogLevel = MMILogLevelInfo;
static BOOL _fileLoggingEnabled = YES;
static BOOL _consoleLoggingEnabled = YES;

+ (NSFileHandle *)logFileHandle {
    return _logFileHandle;
}

+ (void)setLogFileHandle:(NSFileHandle *)logFileHandle {
    _logFileHandle = logFileHandle;
}

+ (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
        _dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    }
    return _dateFormatter;
}

+ (void)setDateFormatter:(NSDateFormatter *)dateFormatter {
    _dateFormatter = dateFormatter;
}

+ (MMILogLevel)currentLogLevel {
    return _currentLogLevel;
}

+ (void)setCurrentLogLevel:(MMILogLevel)currentLogLevel {
    _currentLogLevel = currentLogLevel;
}

+ (BOOL)fileLoggingEnabled {
    return _fileLoggingEnabled;
}

+ (void)setFileLoggingEnabled:(BOOL)fileLoggingEnabled {
    _fileLoggingEnabled = fileLoggingEnabled;
}

+ (BOOL)consoleLoggingEnabled {
    return _consoleLoggingEnabled;
}

+ (void)setConsoleLoggingEnabled:(BOOL)consoleLoggingEnabled {
    _consoleLoggingEnabled = consoleLoggingEnabled;
}

#pragma mark - Configuration

+ (void)setLogLevel:(MMILogLevel)level {
    self.currentLogLevel = level;
}

+ (void)setFileLoggingEnabled:(BOOL)enabled {
    self.fileLoggingEnabled = enabled;
    
    if (enabled && !self.logFileHandle) {
        [self setupLogFile];
    } else if (!enabled && self.logFileHandle) {
        [self.logFileHandle closeFile];
        self.logFileHandle = nil;
    }
}

+ (void)setConsoleLoggingEnabled:(BOOL)enabled {
    self.consoleLoggingEnabled = enabled;
}

#pragma mark - Private Methods

+ (void)setupLogFile {
    NSString *logFilePath = [self logFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Create logs directory if it doesn't exist
    NSString *logsDirectory = [logFilePath stringByDeletingLastPathComponent];
    if (![fileManager fileExistsAtPath:logsDirectory]) {
        [fileManager createDirectoryAtPath:logsDirectory 
               withIntermediateDirectories:YES 
                                attributes:nil 
                                     error:nil];
    }
    
    // Create log file if it doesn't exist
    if (![fileManager fileExistsAtPath:logFilePath]) {
        [fileManager createFileAtPath:logFilePath contents:nil attributes:nil];
    }
    
    // Open file handle for writing
    self.logFileHandle = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
    [self.logFileHandle seekToEndOfFile];
}

+ (NSString *)logLevelString:(MMILogLevel)level {
    switch (level) {
        case MMILogLevelVerbose: return @"VERBOSE";
        case MMILogLevelDebug: return @"DEBUG";
        case MMILogLevelInfo: return @"INFO";
        case MMILogLevelWarning: return @"WARNING";
        case MMILogLevelError: return @"ERROR";
        case MMILogLevelCritical: return @"CRITICAL";
        default: return @"UNKNOWN";
    }
}

+ (NSString *)logLevelEmoji:(MMILogLevel)level {
    switch (level) {
        case MMILogLevelVerbose: return @"🔍";
        case MMILogLevelDebug: return @"🐛";
        case MMILogLevelInfo: return @"ℹ️";
        case MMILogLevelWarning: return @"⚠️";
        case MMILogLevelError: return @"❌";
        case MMILogLevelCritical: return @"🚨";
        default: return @"❓";
    }
}

+ (void)logMessage:(NSString *)message level:(MMILogLevel)level {
    if (level < self.currentLogLevel) {
        return;
    }
    
    NSString *timestamp = [self.dateFormatter stringFromDate:[NSDate date]];
    NSString *levelString = [self logLevelString:level];
    NSString *levelEmoji = [self logLevelEmoji:level];
    NSString *formattedMessage = [NSString stringWithFormat:@"%@ %@ [%@] %@\n", 
                                 timestamp, levelEmoji, levelString, message];
    
    // Console logging
    if (self.consoleLoggingEnabled) {
        NSLog(@"%@", [formattedMessage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
    }
    
    // File logging
    if (self.fileLoggingEnabled) {
        if (!self.logFileHandle) {
            [self setupLogFile];
        }
        
        NSData *data = [formattedMessage dataUsingEncoding:NSUTF8StringEncoding];
        [self.logFileHandle writeData:data];
        [self.logFileHandle synchronizeFile];
    }
}

#pragma mark - Logging Methods

+ (void)verbose:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    [self logMessage:message level:MMILogLevelVerbose];
}

+ (void)debug:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    [self logMessage:message level:MMILogLevelDebug];
}

+ (void)info:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    [self logMessage:message level:MMILogLevelInfo];
}

+ (void)warning:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    [self logMessage:message level:MMILogLevelWarning];
}

+ (void)error:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    [self logMessage:message level:MMILogLevelError];
}

+ (void)critical:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    [self logMessage:message level:MMILogLevelCritical];
}

#pragma mark - Specialized Logging

+ (void)logNetworkRequest:(NSString *)method 
                      url:(NSString *)url 
                  headers:(NSDictionary *)headers 
                     body:(id)body {
    NSMutableString *logMessage = [NSMutableString string];
    [logMessage appendFormat:@"🌐 Network Request\n"];
    [logMessage appendFormat:@"Method: %@\n", method];
    [logMessage appendFormat:@"URL: %@\n", url];
    
    if (headers.count > 0) {
        [logMessage appendFormat:@"Headers: %@\n", headers];
    }
    
    if (body) {
        [logMessage appendFormat:@"Body: %@", body];
    }
    
    [self info:@"%@", logMessage];
}

+ (void)logNetworkResponse:(NSInteger)statusCode 
                       url:(NSString *)url 
                   headers:(NSDictionary *)headers 
                      data:(NSData *)data 
                     error:(NSError *)error {
    NSMutableString *logMessage = [NSMutableString string];
    [logMessage appendFormat:@"📡 Network Response\n"];
    [logMessage appendFormat:@"Status: %ld\n", (long)statusCode];
    [logMessage appendFormat:@"URL: %@\n", url];
    
    if (headers.count > 0) {
        [logMessage appendFormat:@"Headers: %@\n", headers];
    }
    
    if (data) {
        [logMessage appendFormat:@"Data Size: %lu bytes\n", (unsigned long)data.length];
    }
    
    if (error) {
        [logMessage appendFormat:@"Error: %@", error.localizedDescription];
    }
    
    MMILogLevel level = error ? MMILogLevelError : MMILogLevelInfo;
    [self logMessage:logMessage level:level];
}

+ (void)logUserAction:(NSString *)action 
                screen:(NSString *)screen 
               details:(NSDictionary *)details {
    NSMutableString *logMessage = [NSMutableString string];
    [logMessage appendFormat:@"👤 User Action\n"];
    [logMessage appendFormat:@"Action: %@\n", action];
    [logMessage appendFormat:@"Screen: %@", screen];
    
    if (details.count > 0) {
        [logMessage appendFormat:@"\nDetails: %@", details];
    }
    
    [self info:@"%@", logMessage];
}

+ (void)logPerformance:(NSString *)metric 
                 value:(double)value 
                  unit:(NSString *)unit {
    NSString *logMessage = [NSString stringWithFormat:@"⚡ Performance - %@: %.2f %@", metric, value, unit];
    [self info:@"%@", logMessage];
}

+ (void)logLifecycleEvent:(NSString *)event 
                  details:(NSDictionary *)details {
    NSMutableString *logMessage = [NSMutableString string];
    [logMessage appendFormat:@"🔄 Lifecycle Event: %@", event];
    
    if (details.count > 0) {
        [logMessage appendFormat:@"\nDetails: %@", details];
    }
    
    [self info:@"%@", logMessage];
}

#pragma mark - Utility Methods

+ (NSString *)logFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths.firstObject;
    NSString *logsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Logs"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    return [logsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"app_%@.log", dateString]];
}

+ (void)clearLogs {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *logsDirectory = [[self logFilePath] stringByDeletingLastPathComponent];
    
    if ([fileManager fileExistsAtPath:logsDirectory]) {
        NSError *error;
        [fileManager removeItemAtPath:logsDirectory error:&error];
        if (error) {
            [self error:@"Failed to clear logs: %@", error.localizedDescription];
        } else {
            [self info:@"Logs cleared successfully"];
        }
    }
}

+ (unsigned long long)logFileSize {
    NSString *logFilePath = [self logFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:logFilePath]) {
        NSError *error;
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:logFilePath error:&error];
        if (!error) {
            return [attributes fileSize];
        }
    }
    
    return 0;
}

+ (BOOL)exportLogsToFile:(NSString *)filePath {
    NSString *currentLogPath = [self logFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:currentLogPath]) {
        return NO;
    }
    
    NSError *error;
    [fileManager copyItemAtPath:currentLogPath toPath:filePath error:&error];
    
    if (error) {
        [self error:@"Failed to export logs: %@", error.localizedDescription];
        return NO;
    }
    
    [self info:@"Logs exported to: %@", filePath];
    return YES;
}

@end 