//
//  BusinessLocationViewController.h
//  SocialAmmo
//
//  Created by Meenakshi on 02/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "LocationManager.h"

//typedef enum
//{
//    EFieldTypeCountry = 1,
//    EFieldTypePostCode,
//	EFieldTypeSuburb
//} EBusinessLocationFieldType;


@interface BusinessLocationViewController : UIViewController <LocationManagerDelegate>
{
	IBOutlet UISearchBar*	_searchBar;
	
	IBOutlet UITableView*	_tableView;
	
	LocationManager*		_locationManager;
	
}
@property (nonatomic, strong)IBOutlet UIButton* backButton;

@property (nonatomic, strong)UserInfo* userInfo;
- (IBAction) nextButtonPressed:(id)sender;
- (IBAction) backButtonAction:(id)sender;

@end
