//
//  CreatorBeaconViewController.h
//  SocialAmmo
//
//  Created by Rupesh Kumar on 7/29/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

@class  BusinessOpenSubmissionInfo;

@protocol CreatorBeaconDelegate <NSObject>

- (void) displayCreatorHubForSubmssion:(BusinessOpenSubmissionInfo*)info;

@end

@interface CreatorBeaconViewController : UIViewController
{
	IBOutlet UIScrollView* _scrollView;
	
	IBOutlet UIButton* _rightArraowBtn;
	IBOutlet UIButton* _leftArraowBtn;
	
	IBOutlet UIPageControl* _pageController;
	BOOL _pageControlBeingUsed;
	
	//Following two sets are fro updated scroll view implemetation that keeps the track of pages.
	NSMutableSet*	_recycledPages;
	NSMutableSet*	_visiblePages;
}

@property (nonatomic, weak)id<CreatorBeaconDelegate> delegate;

- (IBAction) changePage;

- (IBAction) rightarraowBtnAction:(id)sender;
- (IBAction) leftarraowBtnAction:(id)sender;
- (IBAction) locationSearchAction:(id)sender;
- (IBAction) normalSearchAction:(id)sender;

- (void) sendRequestToGetBeaconBusiness:(NSString*)businessId;


@end
