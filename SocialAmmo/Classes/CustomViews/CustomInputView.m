//
//  CustomInputView.m
//  PicLab
//
//  Created by Rupesh Kumar on 2/17/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "CustomInputView.h"

#define kColorImage [UIImage imageNamed:@"color_rect.png"]
 //[UIImage imageNamed:@"color_rect.png"]

@implementation CustomInputView

- (void) dealloc
{
    self.customInputViewDelegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.image = kColorImage;
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self)
	{
		self.image = kColorImage;
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.userInteractionEnabled = YES;
	}
	return self;
}


#pragma mark --
#pragma mark -- Touch action

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    [self colorAtPosition:touchPoint withImage:kColorImage];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    [self colorAtPosition:touchPoint withImage:kColorImage];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    [self colorAtPosition:touchPoint withImage:kColorImage];
}

// Get color from image at point
- (void) colorAtPosition:(CGPoint)position withImage:(UIImage*)currentImage
{
    CGRect sourceRect = CGRectMake(position.x, position.y, 1.f, 1.f);
    CGImageRef imageRef = CGImageCreateWithImageInRect(currentImage.CGImage, sourceRect);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *buffer = malloc(4);
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
    CGContextRef context = CGBitmapContextCreate(buffer, 1, 1, 8, 4, colorSpace, bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0.f, 0.f, 1.f, 1.f), imageRef);
    CGImageRelease(imageRef);
    CGContextRelease(context);
    
    CGFloat r = buffer[0] / 255.f;
    CGFloat g = buffer[1] / 255.f;
    CGFloat b = buffer[2] / 255.f;
    CGFloat a = buffer[3] / 255.f;
    
    free(buffer);
    
    UIColor* textColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
    DLog(@"tu %@",textColor.description);

    if (self.customInputViewDelegate && [self.customInputViewDelegate respondsToSelector:
										 @selector(fillTextWithColor:)])
		[self.customInputViewDelegate fillTextWithColor:textColor];
}


@end
