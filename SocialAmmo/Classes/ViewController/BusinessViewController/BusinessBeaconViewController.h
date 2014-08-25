//
//  BusinessBeaconViewController.h
//  SocialAmmo
//
//  Created by Rupesh Kumar on 7/30/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


@class iCarousel;

@interface BusinessBeaconViewController : UIViewController
{
	IBOutlet iCarousel* _caroselFlowView;
	
	IBOutlet UIScrollView* _scrollView;
	IBOutlet UIScrollView* _outerScrollView;
	
	IBOutlet UIButton* _arrowBtn;
	
	IBOutlet UIPageControl* _pageController;
	BOOL _pageControlBeingUsed;
	
	//Following two sets are fro updated scroll view implemetation that keeps the track of pages.
	NSMutableSet*	_recycledPages;
	NSMutableSet*	_visiblePages;
}

@property (nonatomic,retain) NSArray* businessList;

- (IBAction) changePage;
- (IBAction) tapOnArrowIcon:(id)sender;

- (void) sendRequestToLoadBusinessBeaconData;

@end
