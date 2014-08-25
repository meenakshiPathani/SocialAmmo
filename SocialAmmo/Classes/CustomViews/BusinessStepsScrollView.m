//
//  BusinessStepsScrollView.m
//  SocialAmmo
//
//  Created by Meenakshi on 22/08/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "BusinessStepsScrollView.h"

@implementation BusinessStepsScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    NSLog(@"touchesShouldCancelInContentView");
	
    if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:[UISlider class]])
        return NO;
    else
        return YES;
}


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	CGPoint pointOfContact = [gestureRecognizer locationInView:self];
	
	UIView* view = [self hitTest:pointOfContact withEvent:nil];
//	if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:[MKMapView class]])
	if ([view isKindOfClass:[UISlider class]] || [view isKindOfClass:[UIButton class]])
        return NO;
    else
        return YES;
}

@end
