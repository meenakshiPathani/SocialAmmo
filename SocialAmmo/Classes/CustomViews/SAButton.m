//
//  SAButton.m
//  Social Ammo
//
//  Created by Meenakshi on 21/01/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SAButton.h"

@implementation SAButton

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

- (void)baseInit
{
	self.exclusiveTouch = YES;
	self.layer.borderWidth = 2.0f;
	self.layer.cornerRadius = 16.0f;
	
	[self setColor:[UIColor whiteColor]];
	self.titleLabel.font = [UIFont fontWithName:kFontRalewayBold size:18.0];
	
	// Multiple line text
	self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void) setColor:(UIColor*)color
{
	self.layer.borderColor = color.CGColor;
	[self setTitleColor:color forState:UIControlStateNormal];
	
	[self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
	[self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
}


@end
