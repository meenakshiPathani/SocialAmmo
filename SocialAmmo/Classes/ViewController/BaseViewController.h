//
//  BaseViewController.h
//  SocialAmmo
//
//  Created by Meenakshi on 25/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


@interface BaseViewController : UIViewController
{
	
}
- (void) addBackButton;
- (void) addNextButton;

- (void)popUpView:(UIView*)subView fromPoint:(CGPoint)iconPoint;

@end
