//
//  CustomImageView.m
//  PicLab
//
//

#import "CustomImageView.h"

@implementation CustomImageView

- (id)initWithFrame:(CGRect)frame andImage:(UIImage*)image
{
    self = [super initWithFrame:frame];
    if (self)
	{
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
		
        _initialbounds = self.bounds;
        _width = self.bounds.size.width;
        _height = self.bounds.size.height;
        
        _centerX = self.center.x;
        _centerY = self.center.y;
		_intialCenter = CGPointMake(_centerX,_centerY);
		
		_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,
																   frame.size.height)];
		_imageView.image = image;
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:_imageView];
		
        UIPanGestureRecognizer* panGRForDrag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragImageView:)];
        UIPinchGestureRecognizer* pinchGRForZoom = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchZoomimageView:)];
        [self addGestureRecognizer:pinchGRForZoom];
		[self addGestureRecognizer:panGRForDrag];
    }
    return self;
}

- (void) updateImage:(UIImage*)image
{
	_imageView.image = image;
}

- (void) updateCenter
{
	CGAffineTransform transform = CGAffineTransformMakeScale(1.0,  1.0);
	self.transform = transform;
	self.center = _intialCenter;
}

#pragma mark --
#pragma mark Gesture methods

- (void) dragImageView:(UIPanGestureRecognizer*)sender
{
    static CGRect originalFrame;
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        originalFrame = sender.view.frame;
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translate = [sender translationInView:sender.view.superview];
        CGRect newFrame = CGRectMake(originalFrame.origin.x + translate.x,
                                     originalFrame.origin.y + translate.y,
                                     originalFrame.size.width,
                                     originalFrame.size.height);
        
//		if ((newFrame.origin.y > self.superview.frame.size.height-newFrame.size.height) ||
//			(newFrame.origin.y < 0) || ((newFrame.origin.x + newFrame.size.width) > 300) ||
//			(newFrame.origin.x < 0))
//            return;

		if(!self.isForPacking)
		{
			if ((newFrame.origin.y > self.superview.frame.size.height-40) || (newFrame.origin.y < (-40)) ||
				(newFrame.origin.x > self.superview.frame.size.width -40) || (newFrame.origin.x < (-40)))
				return;
		}
		
        self.frame = newFrame;
        
		_centerX = self.center.x;
		_centerY = self.center.y;
    }
    
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.layer.position = self.center;
}

- (void) pinchZoomimageView:(UIPinchGestureRecognizer*)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateChanged)
	{
        if ([recognizer scale]<1.0f)
            [recognizer setScale:1.0f];
		else if ([recognizer scale] > 1.50f)
			[recognizer setScale:1.50f];
		
        CGAffineTransform transform = CGAffineTransformMakeScale([recognizer scale],  [recognizer scale]);
        self.transform = transform;
    }
}

#pragma mark --
#pragma mark Touch methods

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return  NO;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
