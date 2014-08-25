//
//  WIPCollectionCell.m
//  SocialAmmo
//
//  Created by Meenakshi on 23/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "WIPCollectionCell.h"

@interface WIPCollectionCell ()

@property UIButton* closeBtn;

@end

@implementation WIPCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)prepareForReuse
{
	_cellImageView.image = nil;
	[self.layer removeAllAnimations];
	self.transform = CGAffineTransformIdentity;
	
	[self.closeBtn removeFromSuperview];

	_isWiggling = NO;
}

- (void) startWigglingForCell:(id)target action:(SEL)selector
{
	if (_isWiggling)
		return;
	
	[self.layer removeAllAnimations];

	self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-5));
	
	[UIView animateWithDuration:0.25
						  delay:0.0
						options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse)
					 animations:^ {
						 self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(5));
					 }
					 completion:NULL
	 ];
	
	if (self.closeBtn == nil)
	{
		UIImage* closeBtnImg = [UIImage imageNamed:@"close_delete.png"];
		self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_closeBtn.frame = CGRectMake(0, 0, 50, 50);
		_closeBtn.layer.cornerRadius = 10;
		_closeBtn.tag = self.tag;
		CGFloat spacing = 40;
		_closeBtn.imageEdgeInsets = UIEdgeInsetsMake(-5, spacing, spacing, -5);
		[_closeBtn setImage:closeBtnImg forState:UIControlStateNormal];
	}

	[_closeBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_closeBtn];
	
	_isWiggling = YES;
}

- (void) stopWigglingForCell
{
	if (_isWiggling == NO)
		return;
	
	[self.layer removeAllAnimations];

	_isWiggling = NO;
	[UIView animateWithDuration:0.25
						  delay:0.0
						options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear)
					 animations:^ {
						 self.transform = CGAffineTransformIdentity;
					 }
					 completion:NULL
	 ];
	
	[self.closeBtn removeFromSuperview];
}

@end
