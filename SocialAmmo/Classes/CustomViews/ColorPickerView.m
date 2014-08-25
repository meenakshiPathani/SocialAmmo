//
//  ColorPickerView.m
//  SocialAmmo
//
//  Created by Meenakshi on 24/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "ColorPickerView.h"

@implementation ColorPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id) createColorPickerView
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:kColorPickerViewNib
                                                      owner:self
                                                    options:nil];
    return [nibViews objectAtIndex:0];
}

#pragma mark- Button action

- (IBAction) doneButtonPressed:(UIButton*)sender
{
	if (self.delegate && [self.delegate respondsToSelector:@selector(colorPickerDoneButtonPressed:)])
		[self.delegate colorPickerDoneButtonPressed:_color];
}

#pragma mark --
#pragma mark -- Touch action

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:_colorImageView];
	if (CGRectContainsPoint(_colorImageView.frame, touchPoint))
	{
		_colorSelector.center = touchPoint;
		
		[self colorAtPosition:touchPoint withImage:_colorImageView.image];
	}
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:_colorImageView];
	if (CGRectContainsPoint(_colorImageView.frame, touchPoint))
	{
		_colorSelector.center = touchPoint;
		
		[self colorAtPosition:touchPoint withImage:_colorImageView.image];
	}}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:_colorImageView];
	if (CGRectContainsPoint(_colorImageView.frame, touchPoint))
	{
		_colorSelector.center = touchPoint;
		
		[self colorAtPosition:touchPoint withImage:_colorImageView.image];
	}
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
    
    _color = [UIColor colorWithRed:r green:g blue:b alpha:a];
    DLog(@"tu %@",_color.description);
	
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickColor:)])
		[self.delegate pickColor:_color];
}


@end
