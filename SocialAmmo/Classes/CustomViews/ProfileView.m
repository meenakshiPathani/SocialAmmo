//
//  ProfileView.m
//  Social Ammo
//
//  Created by Meenakshi on 18/02/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "ProfileView.h"

@implementation ProfileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
		[self baseInit];
    }
    return self;
}

#pragma mark-

- (void)baseInit
{
	NSArray* array = [[NSBundle mainBundle] loadNibNamed:kProfileViewNib owner:self options:nil];
	if (array.count > 0)
		[self addSubview:[array objectAtIndex:0]];
	
	NSUInteger radius = 22; 
	self.layer.cornerRadius = radius;
	self.clipsToBounds = YES;
	self.layer.borderColor = [UIColor whiteColor].CGColor;
	self.layer.borderWidth = 2.0f;
}

#pragma mark-
#pragma mark Button actions-

-(IBAction) profileButtonPressed:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(showProfile)])
		[self.delegate showProfile];
}

#pragma mark-

- (void) setProfileUrl:(NSString*)profileUrl
{
	_profileImageView.image = nil;
	
	_profileImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
	_profileImageView.imageUrl = profileUrl;
	[_profileImageView becomeActive];
}

- (void) setProfileBtnTitle:(NSString*)title
{
	[_profileButton setTitle:title forState:UIControlStateNormal];
	_profileButton.backgroundColor = [kBlueColor colorWithAlphaComponent:.40];
	_profileButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 20);
}


@end
