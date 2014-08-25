//
//  PageView.m
//  Social Ammo
//
//  Created by Meenakshi on 19/02/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "PageView.h"

@implementation PageView

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
	NSArray* array = [[NSBundle mainBundle] loadNibNamed:kPageViewNib owner:self options:nil];
	if (array.count > 0)
		[self addSubview:[array objectAtIndex:0]];

}

- (void) setPageImage:(UIImage*)image title:(NSString*)title
{
	_imageView.image = image;
	_label.text = title;
}

@end
