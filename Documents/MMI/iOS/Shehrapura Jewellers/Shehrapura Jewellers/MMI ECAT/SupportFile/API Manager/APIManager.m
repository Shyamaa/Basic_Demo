//
//  APIManager.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 16/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "APIManager.h"

@interface APIManager ()
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableDictionary *activeTasks;
@end

@implementation APIManager

+ (instancetype)sharedManager {
    static APIManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[APIManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 30.0;
        config.timeoutIntervalForResource = 60.0;
        config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        self.session = [NSURLSession sessionWithConfiguration:config];
        self.activeTasks = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)GET:(NSString *)urlString
 parameters:(NSDictionary *)params
 completion:(APICompletionHandler)completion {

    // Validate input
    if (!urlString || urlString.length == 0) {
        NSError *error = [NSError errorWithDomain:@"APIManager" 
                                            code:-1001 
                                        userInfo:@{NSLocalizedDescriptionKey: @"Invalid URL"}];
        completion(nil, error);
        return;
    }

    // Build URL with parameters
    NSURL *url = [NSURL URLWithString:urlString];
    if (params && params.count > 0) {
        NSMutableArray *queryItems = [NSMutableArray array];
        for (NSString *key in params) {
            NSString *value = [NSString stringWithFormat:@"%@", params[key]];
            [queryItems addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
        NSString *queryString = [queryItems componentsJoinedByString:@"&"];
        urlString = [NSString stringWithFormat:@"%@?%@", urlString, queryString];
        url = [NSURL URLWithString:urlString];
    }

    NSLog(@"🌐 GET Request: %@", urlString);

    NSURLSessionDataTask *task = [self.session dataTaskWithURL:url 
                                             completionHandler:^(NSData * _Nullable data, 
                                                                 NSURLResponse * _Nullable response, 
                                                                 NSError * _Nullable error) {
        [self handleResponse:data response:response error:error completion:completion];
    }];
    
    [self.activeTasks setObject:task forKey:@(task.taskIdentifier)];
    [task resume];
}

- (void)POST:(NSString *)urlString
  parameters:(NSDictionary *)params
  completion:(APICompletionHandler)completion {

    // Validate input
    if (!urlString || urlString.length == 0) {
        NSError *error = [NSError errorWithDomain:@"APIManager" 
                                            code:-1001 
                                        userInfo:@{NSLocalizedDescriptionKey: @"Invalid URL"}];
        completion(nil, error);
        return;
    }

    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 30.0;

    // Set headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    // Add body if parameters exist
    if (params && params.count > 0) {
        NSError *jsonError;
        NSData *body = [NSJSONSerialization dataWithJSONObject:params options:0 error:&jsonError];
        if (jsonError) {
            completion(nil, jsonError);
            return;
        }
        request.HTTPBody = body;
        
        NSLog(@"🌐 POST Request: %@", urlString);
        NSLog(@"📦 POST Body: %@", params);
    }

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request 
                                                 completionHandler:^(NSData * _Nullable data, 
                                                                     NSURLResponse * _Nullable response, 
                                                                     NSError * _Nullable error) {
        [self handleResponse:data response:response error:error completion:completion];
    }];
    
    [self.activeTasks setObject:task forKey:@(task.taskIdentifier)];
    [task resume];
}

- (void)handleResponse:(NSData *)data 
              response:(NSURLResponse *)response 
                 error:(NSError *)error 
            completion:(APICompletionHandler)completion {
    
    // Remove task from active tasks
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"📡 Response Status: %ld", (long)httpResponse.statusCode);
    }
    
    if (error) {
        NSLog(@"❌ Network Error: %@", error.localizedDescription);
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
        return;
    }
    
    if (!data || data.length == 0) {
        NSError *emptyDataError = [NSError errorWithDomain:@"APIManager" 
                                                     code:-1002 
                                                 userInfo:@{NSLocalizedDescriptionKey: @"Empty response data"}];
        NSLog(@"❌ Empty Response Data");
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, emptyDataError);
        });
        return;
    }
    
    // Parse JSON response
    NSError *jsonError;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    
    if (jsonError) {
        NSLog(@"❌ JSON Parse Error: %@", jsonError.localizedDescription);
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, jsonError);
        });
        return;
    }
    
    NSLog(@"✅ Response Success: %@", jsonObject);
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(jsonObject, nil);
    });
}

- (void)cancelAllRequests {
    for (NSNumber *taskId in self.activeTasks.allKeys) {
        NSURLSessionDataTask *task = self.activeTasks[taskId];
        [task cancel];
    }
    [self.activeTasks removeAllObjects];
    NSLog(@"🛑 Cancelled all active requests");
}

- (void)cancelRequestWithIdentifier:(NSUInteger)taskIdentifier {
    NSURLSessionDataTask *task = self.activeTasks[@(taskIdentifier)];
    if (task) {
        [task cancel];
        [self.activeTasks removeObjectForKey:@(taskIdentifier)];
        NSLog(@"🛑 Cancelled request with ID: %lu", (unsigned long)taskIdentifier);
    }
}

@end

