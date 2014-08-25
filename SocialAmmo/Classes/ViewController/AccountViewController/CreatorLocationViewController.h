//
//  CreatorLocationViewController.h
//  SocialAmmo
//
//  Created by Meenakshi on 02/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "LocationManager.h"

@interface CreatorLocationViewController : UIViewController <LocationManagerDelegate>
{
	LocationManager*		_locationManager;
	
	IBOutlet UILabel*		_locationTitleLabel;
	IBOutlet UILabel*		_descriptionLabel;

}
@property (nonatomic, strong)IBOutlet UIButton* backButton;

- (IBAction) backButtonAction:(id)sender;

@end
