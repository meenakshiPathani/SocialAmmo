//
//  SubmitContentViewController.h
//  SocialAmmo
//
//  Created by Meenakshi on 22/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


@interface SubmitContentViewController : BaseViewController
{
	IBOutlet UIButton*	_submitToProfile;
	IBOutlet UIButton*	_submitToCompany;

	IBOutlet UITextField* _textField;
}

@property(nonatomic, strong)UIImage* editedImage;

- (IBAction) submitToProfileButtonPressed:(id)sender;
- (IBAction) submitToCompanyButtonPressed:(id)sender;
- (IBAction) savetoWIPButtonPressed:(id)sender;

@end
