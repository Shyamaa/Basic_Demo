#import "ImageCache.h"

@interface ImageCache () {
    NSMutableDictionary *_cache;
}
@end

@implementation ImageCache

@synthesize imgCache;

#pragma mark - Methods

static ImageCache* sharedImageCache = nil;

+(ImageCache*)sharedImageCache
{
    @synchronized([ImageCache class])
    {
        if (!sharedImageCache)
            sharedImageCache= [[self alloc] init];
        
        return sharedImageCache;
    }
    
    return nil;
}

+(id)alloc
{
    @synchronized([ImageCache class])
    {
        NSAssert(sharedImageCache == nil, @"Attempted to allocate a second instance of a singleton.");
        sharedImageCache = [super alloc];
        
        return sharedImageCache;
    }
    
    return nil;
}

//-(id)init
//{
//    self = [super init];
//    if (self != nil)
//    {
//        imgCache = [[NSCache alloc] init];
//    }
//    
//    return self;
//}
//
//- (void) AddImage:(NSString *)imageURL: (UIImage *)image
//{
//    [imgCache setObject:image forKey:imageURL];
//}
//
//- (NSString*) GetImage:(NSString *)imageURL
//{
//    return [imgCache objectForKey:imageURL];
//}
//
//- (BOOL) DoesExist:(NSString *)imageURL
//{
//    if ([imgCache objectForKey:imageURL] == nil)
//    {
//        return false;
//    }
//    
//    return true;
//}
//
//
//@end

+ (id)sharedInstance {
    static ImageCache *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if ((self = [super init])) {
        _cache = [NSMutableDictionary new];
    }
    return self;
}

- (UIImage*)imageForKey:(NSString*)key {
    return [_cache objectForKey:key];
}

- (void)setImage:(UIImage*)image forKey:(NSString*)key {
    [_cache setObject:image forKey:key];
}

- (void)downloadImageAtURL:(NSURL*)url completionHandler:(ImageCacheDownloadCompletionHandler)completion {
    UIImage *cachedImage = [self imageForKey:[url absoluteString]];
    if (cachedImage) {
        completion(cachedImage);
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            if (image != nil) {
               [self setImage:image forKey:[url absoluteString]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(image);
            });
        });
    }
}

@end
