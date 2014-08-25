//
//  UIImageBaseView.m
//  Misc
//

#define kOriginY  ([UIUtils isiPhone]) ? 0 : 0

#import <QuartzCore/QuartzCore.h>
#import "UIImageBaseView.h"

@implementation UIImageBaseView

- (void) drawRect:(CGRect)rect
{
//	[[UIColor blueColor] set];
//    CGRect rectangle = CGRectMake(0, 0, 320, 20);
//	UIRectFill(rectangle);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBFillColor(context, 0.0, 0.0,0.0, 1.0);
//    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0,1.0);
//    CGContextFillRect(context, rectangle);
}

@end

#pragma mark -

@implementation UIImageBaseWindow

- (void) drawRect:(CGRect)rect
{
	UIImage* bgImage = ImageWithPath(ResourcePath( @"HomeScreen.png"));
	[bgImage drawAtPoint:CGPointZero];
}

@end

@implementation BorderImageView

- (id) initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
	if (self)
	{
		[self.layer setBorderColor:[UIColor grayColor].CGColor];
		[self.layer setBorderWidth:1.0];
		[self.layer setCornerRadius:10.0];
		[self setBackgroundColor:[UIColor clearColor]];
		self.clipsToBounds = YES;
	}
	return self;
}

@end

@implementation BorderView

- (id) initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
	if (self)
	{
		[self.layer setBorderColor:[UIColor blackColor].CGColor];
		[self.layer setBorderWidth:1.0];
		[self.layer setCornerRadius:10.0];
		self.clipsToBounds = YES;
	}
	return self;
}

@end

@implementation TopBar

- (void) drawRect:(CGRect)rect
{
	UIImage* bgImage = ImageWithPath(ResourcePath( @"Topborder.png"));
	[bgImage drawInRect:rect];
    
    bgImage = ImageWithPath(ResourcePath( @"Borderline.png"));
    [bgImage drawAtPoint:CGPointMake(0, 78)];
}

@end

@implementation BorderWebView

- (id) initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
	if (self)
	{
        [[self layer] setBorderWidth:4.0];  
        [[self layer] setBorderColor:[[UIColor grayColor] CGColor]];
        
        UIImageView* background = [[UIImageView alloc] initWithFrame:self.bounds];
        background.tag = 1000;
        background.image = [UIImage imageNamed:@"HomeScreen.png"];
        [self addSubview:background];
	}
	return self;
}

@end


