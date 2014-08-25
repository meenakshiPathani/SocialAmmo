//
//  AsyncImageView.m
//  PhotoGalleryView
//

#define	kNotificationImageLoaded	@"CachedImageLoaded"

#import <QuartzCore/QuartzCore.h>
#import "UICachedImageMgr.h"
#import "AsyncImageView.h"

@implementation AsyncImageView

@synthesize imageUrl;

- (void) startActivityIndicator
{
	_indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	_indicatorView.color = [UIColor darkGrayColor];
	
	_indicatorView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | 
									   UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin);

	_indicatorView.frame = CGRectMake(round((self.frame.size.width - 20) / 2), round((self.frame.size.height - 20) / 2), 20, 20);

	[self addSubview:_indicatorView];
	
//	[_indicatorView startAnimating];	
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
	{
		// Initialization code
		self.autoresizesSubviews = YES;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageLoaded:) name:kNotificationImageLoaded object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageLoadFail:) name:kNotificationImageLoadFail object:nil];
		[self startActivityIndicator];
	}
	return self;

}

- (id) initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame])
	{
			// Initialization code
		self.autoresizesSubviews = YES;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageLoaded:) name:kNotificationImageLoaded object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageLoadFail:) name:kNotificationImageLoadFail object:nil];
		[self startActivityIndicator];
    }
    return self;
}

- (void) setImageProxy
{
	if (![self.imageUrl length])
	{
        self.image = nil;
		[_indicatorView stopAnimating];
		return;
	}

    _ReleaseObject(_imageProxy);
    _imageProxy = [[UICachedImageMgr imageWithURl:self.imageUrl userInfo:self] retain];

	if (_imageProxy.hasImage)
	{
		self.image = _imageProxy.image;
		[_indicatorView stopAnimating];
	}
	else
		[_indicatorView startAnimating];
}

- (void) imageLoaded:(NSNotification*)notification
{
	UIImageProxy* imageProxy = [notification object];
	if (_imageProxy == imageProxy)
	{
		self.image = _imageProxy.image;
		[_indicatorView stopAnimating];
	}
}

- (void) imageLoadFail:(NSNotification*)notification
{
		[_indicatorView stopAnimating];
}


- (void)dealloc 
{
	_ReleaseObject(_imageProxy);
	_ReleaseObject(_indicatorView);
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationImageLoaded object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationImageLoadFail object:nil];

    [super dealloc];
}

#pragma mark -

- (BOOL) becomeActive
{
	[_indicatorView startAnimating];

	[self setImageProxy];
	return YES;
}

- (BOOL) resignActive
{
	_ReleaseObject(_imageProxy);
	return YES;
}

@end
