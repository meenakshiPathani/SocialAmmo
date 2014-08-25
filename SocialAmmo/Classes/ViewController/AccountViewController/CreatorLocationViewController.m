//
//  CreatorLocationViewController.m
//  SocialAmmo
//
//  Created by Meenakshi on 02/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "HomeViewController.h"
#import "CreatorLocationViewController.h"

@interface CreatorLocationViewController ()
{
	UIAlertView*	_locationAlertview;
}

@end

@implementation CreatorLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	_locationTitleLabel.frame = (kIPhone5) ? CGRectMake(20, 156, 280, 58) : CGRectMake(20, 125, 280, 58);
	_descriptionLabel.frame = (kIPhone5) ? CGRectMake(35, 419, 149, 100) : CGRectMake(35, 425, 149, 100);

}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self initializeLocationManager];
}


- (void) viewWillDisappear:(BOOL)animated
{
	_locationManager.delegate = nil;
	_locationManager = nil;
	
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleDefault ;
}

#pragma mark - Button action

- (IBAction) backButtonAction:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-

- (void) initializeLocationManager
{
	if (_locationManager == nil)
		_locationManager = [[LocationManager alloc] init];
    _locationManager.delegate = self;
}

#pragma mark - CLLocationManagerDelegate

- (void) locationManger:(LocationManager*)manager didFailToUpdateWithError:(NSError *)error;
{
	NSString* message = nil;
	id delegate = nil;
    if ([error domain] == kCLErrorDomain)
	{
        // We handle CoreLocation-related errors here
		switch ([error code]) {
				// "Don't Allow" on two successive app launches is the same as saying "never allow". The user
				// can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
			case kCLErrorDenied:
			{
				message = @"Please enable the location for SocialAmmo by going to your device Settings > Privacy > Location > Turn on for Social Ammo.";
				delegate = self;
				break;
			}
			case kCLErrorLocationUnknown:
				message = @"There is some issue in updating the location. App will update the location later. ";
				delegate = self;
				break;
			default:
				break;
        }
    } else {
        // We handle all non-CoreLocation errors here
    }
	
	if (_locationAlertview == nil)
		_locationAlertview = [[UIAlertView alloc] initWithTitle:nil message:message delegate:delegate cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[_locationAlertview show];

}

- (void) locationManger:(LocationManager*)manager didupdateNewLoaction:(CLLocation *)location;
{
	[_locationAlertview dismissWithClickedButtonIndex:0 animated:YES];
	_locationAlertview = nil;
	
    NSLog(@"didUpdateToLocation: %@", location);
    CLLocation* currentLocation = location;
	
	[self sendRequestToAddLocation:currentLocation];
	[_locationManager stopUpdatingLocation];
}

#pragma mark-

- (void) sendRequestToAddLocation:(CLLocation*)location
{
	[_gAppDelegate showLoadingView:YES];
	[_gDataManager sendRequestToAddLocation:location.coordinate withCompletion:^(BOOL status, NSString* message, ERequestType requestType){

		if (status)
		{
			_gAppPrefData.islocationEnabled = YES;
			[_gAppPrefData saveAllData];
			[self showHomeScreen];
		}
		else
		{
			_gAppPrefData.islocationEnabled = NO;
			[UIUtils messageAlert:message title:nil delegate:nil];
		}
		
		[_gAppPrefData saveAllData];
	}];
}

#pragma mark-

- (void) showHomeScreen
{
	HomeViewController* viewCtrl = [[HomeViewController alloc] initWithNibName:kHomeViewNib bundle:nil];
	[_gAppPrefData saveAllData];
	
	[_gAppDelegate initializeApplication:viewCtrl];
}

#pragma mark-

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
	_locationAlertview = nil;

	[self showHomeScreen];
}

@end
