//
//  AddPaypalInfoViewController.h
//  SocialAmmo
//
//  Created by Meenakshi on 11/08/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


@interface AddPaypalInfoViewController : BaseViewController
{
	IBOutlet UITextField*	_paypalEmailField;
}
@property(nonatomic, assign)BOOL showLocationScreen;

- (IBAction) submitPayPalId:(id)sender;

@end
