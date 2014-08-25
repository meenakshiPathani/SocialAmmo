//
//  AsyncImageView.h
//  PhotoGalleryView
//

#import <UIKit/UIKit.h>

@class UIImageProxy;

@interface AsyncImageView : UIImageView 
{
	UIImageProxy*               _imageProxy;
	UIActivityIndicatorView*	_indicatorView;
}

@property (nonatomic, retain) NSString* imageUrl;

- (BOOL) becomeActive;
- (BOOL) resignActive;

@end
