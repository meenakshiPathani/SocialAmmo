//
//  ZoomView.m
//  Social Ammo
//
//  Created by Rupesh Kumar on 6/4/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "ZoomView.h"

@implementation ZoomView

+ (ZoomView*) zoomView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZoomView" owner:self options:nil] objectAtIndex:0];
}

- (void) showViewWithURL:(NSString*)imageUrl onView:(UIView*)view
{
    if (self.superview)
        return;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    [self setFrame:rect];
    [self setinitial:imageUrl];
	
    [view addSubview:self];
    [view bringSubviewToFront:self];
	[self animateShow];
}

- (IBAction) cancelBtnAction:(id)sender
{
	[self animateRemove];
}

#pragma  mark -- private

- (void) animateShow;
{
    self.alpha = 0.0;
    _scrollView.transform = CGAffineTransformMakeScale(3.0, 3.0);
    
	[UIView beginAnimations:nil context:nil];
    //	[UIView setAnimationDuration:5.0];            // Uncomment to see the animation in slow motion
	
    _scrollView.transform = CGAffineTransformIdentity;
    self.alpha = 1.0;
    
	[UIView commitAnimations];
}

- (void) animateRemove;
{
    _scrollView.transform = CGAffineTransformIdentity;
    
	[UIView beginAnimations:nil context:nil];
    //	[UIView setAnimationDuration:5.0];            // Uncomment to see the animation in slow motion
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeAnimationDidStop:finished:context:)];
	
    _scrollView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.alpha = 0.0;
    
	[UIView commitAnimations];
}

- (void) removeView
{
	_userPostImageview.image = nil;
	_userPostImageview.imageUrl = nil;
	
    [self removeFromSuperview];
}

- (void) removeAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
{
    [self removeView];
}

-(void) dealloc
{
	_userPostImageview.image = nil;
	_userPostImageview.imageUrl = nil;
}

- (void) setinitial:(NSString*)imageUrl
{
	UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
	
    [_scrollView addGestureRecognizer:doubleTap];
	
	_userPostImageview.image = nil;
	_userPostImageview.imageUrl = imageUrl;
	[_userPostImageview becomeActive];
    
    _userPostImageview.frame = _scrollView.bounds;
    _scrollView.maximumZoomScale = 4.0f;
    _scrollView.minimumZoomScale = 1.0f;
}

- (void)handleDoubleTap:(UIGestureRecognizer *)recognizer
{
    float newScale = [_scrollView zoomScale] * 4.0;
    
    if (_scrollView.zoomScale > _scrollView.minimumZoomScale)
    {
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
    }
    else
    {
        CGRect zoomRect = [self zoomRectForScale:newScale
                                      withCenter:[recognizer locationInView:recognizer.view]];
        [_scrollView zoomToRect:zoomRect animated:YES];
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    
    zoomRect.size.height = [_userPostImageview frame].size.height / scale;
    zoomRect.size.width  = [_userPostImageview frame].size.width  / scale;
    
    center = [_userPostImageview convertPoint:center fromView:_scrollView];
    
    zoomRect.origin.x    = center.x - ((zoomRect.size.width / 2.0));
    zoomRect.origin.y    = center.y - ((zoomRect.size.height / 2.0));
    
    return zoomRect;
}

#pragma  mark --
#pragma Mark -- Scroll view delgate

- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _userPostImageview;
}

@end
