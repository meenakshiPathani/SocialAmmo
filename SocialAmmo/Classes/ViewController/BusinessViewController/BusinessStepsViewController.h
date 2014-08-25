//
//  BusinessStepsViewController.h
//  SocialAmmo
//
//  Created by Meenakshi on 14/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "BusinessStepsScrollView.h"

#import "HomeViewController.h"
#import "BusinessView.h"
#import <MapKit/MapKit.h>

typedef void (^BusinessStepsCompletionBlock) (void);


@interface BusinessStepsViewController : UIViewController
{
	IBOutlet UIView* _contentView;
	IBOutlet BusinessStepsScrollView* _pageOne;
	IBOutlet BusinessStepsScrollView* _pageTwo;
	IBOutlet BusinessStepsScrollView* _pageThree;

//	IBOutlet UIScrollView* _scrollView;
	
	IBOutlet UIScrollView*	_interestScrollView;
	
	IBOutlet MKMapView*		_mapView;
	IBOutlet UIView*		_mapBackgroundView;
	IBOutlet UISlider*		_slider;

	IBOutlet BusinessView*	_businessView;
	
	IBOutlet UILabel*		_businessIndustryLabel;
	IBOutlet UILabel*		_creatorCountLabel;
	IBOutlet UILabel*		_selectedRadiusLabel;

}

@property (nonatomic, strong)HomeViewController* homeVC;
@property (nonatomic, copy) BusinessStepsCompletionBlock completion;

- (id)initWithCompletionBlock:(BusinessStepsCompletionBlock)block;

- (IBAction) radiusSliderValueChanged:(id)sender;

- (IBAction) nextButtonOfStep1Pressed:(id)sender;
- (IBAction) nextButtonOfStep2Pressed:(id)sender;
- (IBAction) beginButtonPressed:(id)sender;


@end
