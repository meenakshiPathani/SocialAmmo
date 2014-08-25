//
//  PageView.h
//  Social Ammo
//
//  Created by Meenakshi on 19/02/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


@interface PageView : UIView
{
	IBOutlet UIImageView*  _imageView;
	IBOutlet UILabel*	_label;
}
- (void) setPageImage:(UIImage*)image title:(NSString*)title;

@end
