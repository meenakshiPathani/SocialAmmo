//
//  ZoomViewController.m
//  Social Ammo
//
//  Created by Rupesh Kumar on 5/27/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "ImageZoomViewController.h"

@interface ImageZoomViewController ()

@end

@implementation ImageZoomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationController.navigationBarHidden = YES;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 7
	if (KVersion >= 7)
	{
		self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
	}
#endif
	
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
	
    [_scrollView addGestureRecognizer:doubleTap];
	
	_userPostImageview.image = nil;
	_userPostImageview.imageUrl = self.fullImageURL;
	[_userPostImageview becomeActive];
    
    _userPostImageview.frame = _scrollView.bounds;
    _scrollView.maximumZoomScale = 4.0f;
    _scrollView.minimumZoomScale = 1.0f;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark --
#pragma mark -- private methods

- (IBAction) cancelBtnAction:(id)sender
{
	CGPoint newCenter = self.closeCenter;
    
    [UIView animateWithDuration: KPOP_OUT_IN_ICONS_DELAY
                          delay: 0
                        options: (UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         self.view.center = newCenter;
                         self.view.transform = CGAffineTransformMakeScale(0.05, 0.05);
						 self.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.navigationController.view removeFromSuperview];
						 [self.navigationController removeFromParentViewController];
                     }
     ];
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
