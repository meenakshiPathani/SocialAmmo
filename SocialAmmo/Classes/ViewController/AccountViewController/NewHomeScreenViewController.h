//
//  NewHomeScreenViewController.h
//  SocialAmmo
//
//  Created by Rupesh Kumar on 6/30/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PagedFlowView;

@interface NewHomeScreenViewController : UIViewController
{
	IBOutlet UITableView* _tableview;
	NSArray* _listOfBusiness;
	
	IBOutlet UIButton* _loginbutton;
	IBOutlet UIButton* _signUpButton;
	
	NSInteger _currentIndustryIndex;
	
	IBOutlet AsyncImageView* _indsutryImageView;
	IBOutlet UIImageView* _autoLoginImageView;
	
	IBOutlet UIImageView* _logoImageView;
	IBOutlet UIImageView* _loginSignUpButtonImgeView;
	IBOutlet UIImageView* _upWheelImageV;
	IBOutlet UIImageView* _downWheelImageV;
	
	IBOutlet UIImageView* _orImageV;
	IBOutlet UILabel*	_isForLable;
	IBOutlet UILabel*	_srollUpDownLabel;
	
	
	BOOL _isIndustry;


	IBOutlet PagedFlowView* _pagedFlowView;
}

- (IBAction) loginButtonAction:(id)sender;
- (IBAction) signUpButtonAction:(id)sender;

@end
