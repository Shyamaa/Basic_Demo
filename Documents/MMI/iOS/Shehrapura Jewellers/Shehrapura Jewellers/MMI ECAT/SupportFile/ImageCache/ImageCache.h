
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ImageCacheDownloadCompletionHandler)(UIImage *image);

@interface ImageCache : NSObject
@property (nonatomic, retain) NSCache *imgCache;

+ (id)sharedInstance;

- (UIImage*)imageForKey:(NSString*)key;
- (void)setImage:(UIImage*)image forKey:(NSString*)key;
- (void)downloadImageAtURL:(NSURL*)url completionHandler:(ImageCacheDownloadCompletionHandler)completion;
#pragma mark - Methods

//
@end
