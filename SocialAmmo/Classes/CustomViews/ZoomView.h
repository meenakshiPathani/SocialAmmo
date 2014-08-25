//
//  ZoomView.h
//  Social Ammo
//
//  Created by Rupesh Kumar on 6/4/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomView : UIView<UIScrollViewDelegate>
{
	IBOutlet AsyncImageView* _userPostImageview;
	IBOutlet UIScrollView* _scrollView;
}

+ (ZoomView*) zoomView;

- (void) showViewWithURL:(NSString*)imageUrl onView:(UIView*)view;

- (IBAction) cancelBtnAction:(id)sender;

@end
