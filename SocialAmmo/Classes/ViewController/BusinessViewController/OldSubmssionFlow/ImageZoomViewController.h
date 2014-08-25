//
//  ZoomViewController.h
//  Social Ammo
//
//  Created by Rupesh Kumar on 5/27/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageZoomViewController: BaseViewController
{
	IBOutlet AsyncImageView* _userPostImageview;
	IBOutlet UIScrollView* _scrollView;
}

@property (nonatomic,retain) NSString* fullImageURL;
@property (nonatomic) CGPoint closeCenter;


- (IBAction) cancelBtnAction:(id)sender;

@end
