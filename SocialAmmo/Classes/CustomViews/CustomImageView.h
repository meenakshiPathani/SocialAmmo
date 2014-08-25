//
//  CustomImageView.h
//  PicLab
//
//


@interface CustomImageView : UIScrollView
{
    CGFloat _centerY;
    CGFloat _centerX;
    CGRect _initialbounds;
	
	UIImageView* _imageView;
	CGPoint _intialCenter;
	
    CGFloat _width;
    CGFloat _height;
}

@property (nonatomic) BOOL isForPacking;

- (id)initWithFrame:(CGRect)frame andImage:(UIImage*)image;
- (void) updateImage:(UIImage*)image;
- (void) updateCenter;
@end
