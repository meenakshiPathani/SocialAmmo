//
//  UserTopBarView.m
//  Social Ammo
//
//  Created by Meenakshi on 27/01/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HomeTopBarView.h"

@implementation HomeTopBarView

+ (HomeTopBarView*) topBarView
{
	NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"HomeTopBarView"
												   owner:self options:nil];
	return (array.count > 0) ? [array objectAtIndex:0] : nil;
}

- (void) prepareTopBarLayoutForUserType:(EUserType)userType andController:(UIViewController*)viewController
{
	[UIUtils setExclusiveTouchForButtons:self];
	UIButton* revelBtn = [UIUtils getRevelButtonItem:viewController];
	CGRect rrect = revelBtn.frame;
	rrect.origin = CGPointMake(5, 0);
	revelBtn.frame = rrect;
	[self addSubview:revelBtn];
	
	switch (userType)
	{
		case EUserTypeCreator:
		{
			[self setBarForCreator:userType];
			break;
		}
		case EUserTypeBuisness:
		{
			[self setBarForBusiness:userType];
			break;
		}
		default:
			break;
	}
}

- (void) setBarForCreator:(EUserType)userType
{
	[self setButtonImage:_homeButton image:@"newsfeed.png"
		   selectedImage:@""];
}

- (void) setBarForBusiness:(EUserType)userType
{
	[self setButtonImage:_homeButton image:@"submission.png"
		   selectedImage:@""];
}


- (void) setButtonImage:(UIButton*)btn image:(NSString*)imageName
		  selectedImage:(NSString*)selImageName
{
	UIImage* image = [UIImage imageNamed:imageName];
	UIImage* selImage = [UIImage imageNamed:selImageName];

	[btn setImage:image forState:UIControlStateNormal];
	[btn setImage:selImage forState:UIControlStateHighlighted];
	[btn setImage:selImage forState:UIControlStateDisabled];
	[btn setImage:selImage forState:UIControlStateSelected];
}

#pragma mark-

- (IBAction) topBarButtonPressed:(UIButton*)sender
{
	if (self.delegate && [self.delegate respondsToSelector: @selector(topBarButtonSelected:)])
		[self.delegate topBarButtonSelected:sender];
}

#pragma mark-

- (void) showMessageNotifyIcon:(BOOL)show
{
	NSString* imageName = (show) ? @"notification2" : @"notification";
	[_messageButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void) showSubmissionNotifyIcon:(BOOL)show
{
	_submissionNotifyImageView.hidden = !show;
}

- (void) showBeaconbarSelcted
{
	_selectedBeaconbar.hidden = NO;
	_selectedSubmisionBar.hidden = YES;
	_selctedMessageBar.hidden = YES;
}

- (void) showSubmissionSeleccted
{
	_selectedBeaconbar.hidden = YES;
	_selectedSubmisionBar.hidden = NO;
	_selctedMessageBar.hidden = YES;
}

- (void) showSelectedMessageBar
{
	_selectedBeaconbar.hidden = YES;
	_selectedSubmisionBar.hidden = YES;
	_selctedMessageBar.hidden = NO;
}


@end
 