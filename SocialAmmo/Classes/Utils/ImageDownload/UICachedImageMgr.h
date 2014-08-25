//
//  UICachedImageMgr.h
//  
//

#import "ImageHttpConnection.h"

@interface UIImageProxy : NSObject
{
	UIImage*	_image;
	NSObject*	_userInfo;
}

@property(nonatomic, readonly)	BOOL		hasImage;
@property(nonatomic, retain)	UIImage*	image;
@property(nonatomic, readonly)	CGSize		size;

@property(nonatomic, readonly) NSObject*	userInfo;


+ (UIImageProxy*) imageProxyWithUserInfo:(NSObject*) userInfo;

- (id) initWithContentsOfFile:(NSString*)path withUserInfo:(NSObject*)userInfo;
- (id) initWithImage:(UIImage*)image withUserInfo:(NSObject*)userInfo;

- (void) drawInRect:(CGRect) rect;
- (CGRect) drawProportionallyInRect:(CGRect) rect;
- (void) drawAtPoint:(CGPoint) point;

   
@end


#define	kNotificationImageLoaded		@"CachedImageLoaded"
#define kNotificationImageLoadFail		@"CacheImageLoadFail"
#define	kMaxImageConnection				10

@interface UICachedImageMgr : NSObject <ImageHttpConnectionDelegate>
{
	NSString*				_baseDirectory;

	NSUInteger				_cacheSize;
	NSMutableDictionary*	_cachedImages;

	ImageHttpConnection*			_connections[kMaxImageConnection];
}

@property(nonatomic, assign) NSUInteger		cacheSize;

- (id) initWithBaseDirectory:(NSString*)directory;
- (void) clearDiskCache;
- (NSString*) cacheDirecotryPath;

- (UIImage*) saveImageToDisk:(NSData*)imageData withName:(NSString*)imageName;
+ (UIImageProxy*) imageWithURl:(NSString*)url userInfo:(NSObject*)userInfo;
- (UIImageProxy*) imageWithUrl:(NSString*)url userInfo:(NSObject*)userInfo;
- (BOOL) purgeCacheForImageUrl:(NSString*)url;
- (BOOL) purgeCachedImages:(BOOL)alsoFromDisk;

+ (id) defaultMgr;
+ (void) clearDiskCache;

@end

