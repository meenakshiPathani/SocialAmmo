//
//  UICachedImageMgr.h
//  
//
#import "UIUtils.h"
#import "UICachedImageMgr.h"
#import "UIImage+Extensions.h"

#define	kCachedImageFolder		@"CachedImage/"

@implementation UIImageProxy

@synthesize userInfo = _userInfo;
@synthesize image = _image;

- (BOOL) hasImage
{
	return (_image && _image.CGImage);
}

- (CGSize) size
{
	return [self hasImage] ? _image.size : CGSizeZero;
}

#pragma mark -

+ (UIImageProxy*) imageProxyWithUserInfo:(NSObject*) userInfo
{
	UIImageProxy* obj = [[UIImageProxy alloc] initWithImage:nil withUserInfo:userInfo];
	return [obj autorelease];
}

- (id) initWithContentsOfFile:(NSString*)path withUserInfo:(NSObject*)userInfo
{
    self = [super init];
    if (self)
    {
        _image = [[UIImage alloc] initWithContentsOfFile:path];
        _userInfo = [userInfo retain];
    }
	return self;
}

- (id) initWithImage:(UIImage*)image withUserInfo:(NSObject*)userInfo
{
    self = [super init];
    if (self)
    {
        _image = [image retain];
        _userInfo = [userInfo retain];
    }
	return self;
}

- (void) dealloc
{
	[_image release];
	[_userInfo release];

	[super dealloc];
}

#pragma mark -

- (void) drawInRect:(CGRect) rect
{
	if ([self hasImage])
		[_image drawInRect:rect];
}

- (CGRect) drawProportionallyInRect:(CGRect) rect
{
	if ([self hasImage])
	{
		CGSize sz = rect.size;
		CGSize imgSz = _image.size;

		CGFloat dx = sz.width / imgSz.width;
		CGFloat dy = sz.height / imgSz.height;

		CGFloat minScale = MIN(dx, dy);
		sz.width = imgSz.width * minScale;
		sz.height = imgSz.height * minScale;
		
		rect.origin.x += (rect.size.width - sz.width) * 0.5;
		rect.origin.y += (rect.size.height - sz.height) * 0.5;
		
		rect.size = sz;
		[_image drawInRect:rect];
	}

	return rect;
}

- (void) drawAtPoint:(CGPoint) point
{
	if ([self hasImage])
		[_image drawAtPoint:point];
}

@end


#pragma mark -

static UICachedImageMgr* gDefaultCachedImageMgr = nil;

@implementation UICachedImageMgr

@synthesize cacheSize = _cacheSize;


+ (id) defaultMgr
{
	if (gDefaultCachedImageMgr == nil)
		gDefaultCachedImageMgr = [[UICachedImageMgr alloc] initWithBaseDirectory:@"Images"];
	
	return gDefaultCachedImageMgr;
}

+ (UIImageProxy*) imageWithURl:(NSString*)url userInfo:(NSObject*)userInfo
{
	return [[UICachedImageMgr defaultMgr] imageWithUrl:url userInfo:userInfo];
}

+ (void) clearDiskCache
{
	NSString* filePath = [UIUtils documentDirectoryWithSubpath:kCachedImageFolder];
	
	NSFileManager* fileMgr = [NSFileManager defaultManager];
	[fileMgr removeItemAtPath:filePath error:nil];
}


#pragma mark -

- (id) initWithBaseDirectory:(NSString*)directory
{
    self = [super init];
    if (self)
    {
        _cacheSize = 1;			// default
        _baseDirectory = [directory retain];
    }
	return self;
}


- (void) clearDiskCache
{
	NSString* filePath = [self cacheDirecotryPath];

	NSFileManager* fileMgr = [NSFileManager defaultManager];
	[fileMgr removeItemAtPath:filePath error:nil];
}


- (void) dealloc
{
	[_baseDirectory release];
	[_cachedImages release];

	for (int i = 0; i < kMaxImageConnection; ++i)
	{
		if (_connections[i])
		{
			[_connections[i] autorelease];		// autorelease and NOT release, otherwise we might be in loop
			_connections[i] = nil;
		}
	}

	if (self == gDefaultCachedImageMgr)
		gDefaultCachedImageMgr = nil;
	[super dealloc];
}

#pragma mark -

- (NSString*) cacheDirecotryPath
{
	NSString* filePath = [UIUtils documentDirectoryWithSubpath:kCachedImageFolder];
	if (_baseDirectory != nil)
		filePath = [filePath stringByAppendingFormat:@"%@/", _baseDirectory];
	return filePath;
}

- (NSString*) imageNameFromURLString:(NSString*)url
{
	NSString* name = [url lastPathComponent];

	return name;
}

- (NSUInteger) cancelAndReuseRandomConnection
{
	int randomConnection = 0;		// should be random ?
	
	ImageHttpConnection* connection = _connections[randomConnection];
	if (connection != nil)
	{
		[connection cancelRequest];
		_ReleaseObject(connection);
	}
	
	return randomConnection;	
}

- (NSUInteger) freeConnectionSlotWithCancel:(BOOL)cancel
{
	for (int i = 0; i < kMaxImageConnection; ++i)
	{
		if (_connections[i] == nil)
			return i;

			// cleanup any unused connection
		if ([_connections[i] isFree])
		{
			[_connections[i] release];
			_connections[i] = nil;
			return i;
		}
	}

	if (cancel)
		return [self cancelAndReuseRandomConnection];

	return kMaxImageConnection;
}

- (ImageHttpConnection*) sendRequestForImageUrl:(NSString*) url userInfo:(NSObject*)userInfo
{
	ImageHttpConnection* connection = [[ImageHttpConnection alloc] initWithDelegate:self userInfo:userInfo];

	[connection sendRequestWithUrlString:url];
	
	return connection;		// Not auto-released
}

#pragma mark -

- (UIImageProxy*) cachedImageWithName:(NSString*)imageName
{
	UIImageProxy* imageProxy = [_cachedImages objectForKey:imageName];
	return imageProxy;
}

- (void) addToImageCache:(UIImageProxy*)imageProxy withName:(NSString*)imageName
{
	if (_cacheSize == 0)
		return;
	
	if (_cachedImages == nil)
		_cachedImages = [[NSMutableDictionary alloc] initWithCapacity:_cacheSize];
	
	if (_cachedImages.count >= _cacheSize)
	{
		id key = [[_cachedImages keyEnumerator] nextObject];
		[_cachedImages removeObjectForKey:key];
		assert(_cachedImages.count < _cacheSize);
	}
	
	[_cachedImages setObject:imageProxy forKey:imageName];
}

- (UIImage*) saveImageToDisk:(NSData*)imageData withName:(NSString*)imageName
{
	NSString* filePath = [self cacheDirecotryPath];
	filePath = [filePath stringByAppendingString:imageName];

	NSFileManager* fileMgr = [NSFileManager defaultManager];
	[fileMgr createDirectoryAtPath:[filePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    UIImage* compressedImage = [UIImage imageWithData:imageData];
//    UIImage* scaledImage = [compressedImage imageByScalingToSize:CGSizeMake(67.0, 75.0)];
    
    if ([imageName hasSuffix:@".png"])
        [UIImagePNGRepresentation(compressedImage) writeToFile:filePath atomically:YES];
    else
        [UIImageJPEGRepresentation(compressedImage, 1.0) writeToFile:filePath atomically:YES];

	return compressedImage;
}


- (UIImageProxy*) pendingImageProxyForImage:(NSString*) name
{
	for (int i = 0; i < kMaxImageConnection; ++i)
	{
		ImageHttpConnection* connection = _connections[i];
		if (connection)
		{
				// Get our ImageProxy object, which we had set while initiating the request..
			UIImageProxy* imageProxy = (UIImageProxy*)[connection userInfo];
			
				// and the name (a little messy, probably we should have 'name' inside imageProxy
			NSString* imageName = [self imageNameFromURLString:connection.urlString];
			if ([imageName isEqualToString:name])
				return imageProxy;
		}
	}

	return nil;
}

#pragma mark -


- (UIImageProxy*) localImageWithName:(NSString*) imageName
{
	UIImageProxy* imageProxy = [self cachedImageWithName:imageName];
	if (imageProxy == nil)
	{
			// check if we have image file locally saved on disk
		NSString* filePath = [self cacheDirecotryPath];
		filePath = [filePath stringByAppendingString:imageName];
		
		UIImage* image = [UIImage imageWithContentsOfFile:filePath];
		if (image != nil)
		{
			imageProxy = [[UIImageProxy alloc] initWithImage:image withUserInfo:nil];
			[imageProxy autorelease];
		}
	}
	
	return imageProxy;
}


- (UIImageProxy*) imageWithUrl:(NSString*)url userInfo:(NSObject*)userInfo
{
		// first from local disk cache (or in-memory, if we are lucky)
	
	NSString* name = [self imageNameFromURLString:url];

	UIImageProxy* imageProxy = [self localImageWithName:name];

		// Nope, check if we have any existing connection pending for this image
	if (imageProxy == nil)
		imageProxy = [self pendingImageProxyForImage:name];

		// Finally, create a new connection for this image object
	if (imageProxy == nil)
	{
			// Find a usable connection slot, only if we have one free
		NSUInteger connectionIndex = [self freeConnectionSlotWithCancel:NO];
		if (connectionIndex >= kMaxImageConnection)
			return nil;		// Sorry service not available, try again.

			// Lets create and pass imageProxy to connection, which it will report back in delegate
		imageProxy = [UIImageProxy imageProxyWithUserInfo:userInfo];
		_connections[connectionIndex] = [self sendRequestForImageUrl:url userInfo:imageProxy];
	}

	return imageProxy;
}

- (BOOL) purgeCacheForImageUrl:(NSString*)url
{
	NSString* file = [self imageNameFromURLString:url];
	NSString* filePath = [self cacheDirecotryPath];
	filePath = [filePath stringByAppendingString:file];
	
	NSFileManager* fileMgr = [NSFileManager defaultManager];
	return [fileMgr removeItemAtPath:filePath error:nil];	
}

- (BOOL) purgeCachedImages:(BOOL)alsoFromDisk
{
	BOOL success = YES;
	
	[_cachedImages removeAllObjects];
	
	if (alsoFromDisk == YES)
	{
		NSString* filePath = [self cacheDirecotryPath];
		NSFileManager* fileMgr = [NSFileManager defaultManager];
		success = [fileMgr removeItemAtPath:filePath error:nil];
	}
	
	return success;
}

#pragma mark -

- (void) requestFailedWithError:(NSError*)errorCode connection:(ImageHttpConnection*)connection
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationImageLoadFail
														object:errorCode
													  userInfo:nil];
}

- (void) requestCompletedWithData:(NSData*)data connection:(ImageHttpConnection*)connection
{
	assert(connection);
	if (data == nil)
	{
		[connection cancelRequest];		// We are done
		return;
	}
		// Get our ImageProxy object, which we had set while initiating the request..
	UIImageProxy* imageProxy = (UIImageProxy*)[connection userInfo];
	
		// Save to disk, and add to memory cache
	NSString* imageName = [self imageNameFromURLString:connection.urlString];
	imageProxy.image = [self saveImageToDisk:data withName:imageName];
	[self addToImageCache:(UIImageProxy*)imageProxy withName:imageName];

	[connection cancelRequest];		// We are done..

	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationImageLoaded
														object:imageProxy
													  userInfo:nil];
}

@end