//
//  BusinessLocationViewController.m
//  SocialAmmo
//
//  Created by Meenakshi on 02/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "HomeViewController.h"
#import "PlaceTableViewCell.h"
#import "GooglePlaceInfo.h"
#import "BusinessLocationViewController.h"

@interface BusinessLocationViewController ()
{
	NSArray*	_searchList;
	
	CLLocation* _userCurrentLocation;
	
	GooglePlaceInfo*	_selectedPlace;
}

@end

@implementation BusinessLocationViewController

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
	
	UINib* nib = [UINib nibWithNibName:kPlaceTableCellNib bundle:[NSBundle mainBundle]];
	[_tableView registerNib:nib forCellReuseIdentifier:@"PlaceTableCell"];
	
	UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
	tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
	
	[self initializeLocationManager];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self initializeLocationManager];

	if (![CLLocationManager locationServicesEnabled] || !([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized))
	{
		[UIUtils messageAlert:@"Please enable the location for SocialAmmo by going to your device Settings > Privacy > Location > Turn on for Social Ammo." title:nil delegate:nil];
	}
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

- (IBAction) nextButtonPressed:(id)sender
{
	if (_selectedPlace == nil)
	{
		[UIUtils messageAlert:@"Please select the location for business." title:nil delegate:nil];
//		NSString* message = [NSString stringWithFormat:@"Are you sure you want to continue without adding the buisness location?"];
//		[UIUtils messageAlert:message title:nil delegate:self withCancelTitle:@"No" otherButtonTitle:@"Yes" tag:0];
		
		return;
	}
	
	NSString* message = [NSString stringWithFormat:@"Are you sure you want to add %@ as your buisness location?",_selectedPlace.name];
	[UIUtils messageAlert:message title:nil delegate:self withCancelTitle:@"No" otherButtonTitle:@"Yes" tag:1];
}

#pragma mark- Tableview method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _searchList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* cellIdentifier = @"PlaceTableCell";
	PlaceTableViewCell* cell = (PlaceTableViewCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	cell.backgroundColor = [UIColor clearColor];
	
	GooglePlaceInfo* info = [_searchList objectAtIndex:indexPath.row];
	[cell initiateCellWithPlaceInfo:info];
	
	return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	_selectedPlace = [_searchList objectAtIndex:indexPath.row];
	
	_searchBar.text = _selectedPlace.formattedAddress;
}

#pragma mark-

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	_selectedPlace = nil;
	
	searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if (searchText.length > 0)
		[self findPlacesbyAddress:searchText];
	else
		[self findNearByPlaces:_userCurrentLocation];

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	_selectedPlace = nil;

	NSString* searchText = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	[self findPlacesbyAddress:searchText];
	[searchBar resignFirstResponder];
}

#pragma mark-

- (void) findNearByPlaces:(CLLocation*)location
{
	[_gAppDelegate showLoadingView:YES];
	
	NSString* urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=1000&key=%@", location.coordinate.latitude, location.coordinate.longitude, kGooglePlaceApiKey];
	
	NSURL* url = [[NSURL alloc] initWithString:urlString];
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
	
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError){
		
		[_gAppDelegate showLoadingView:NO];

		if (connectionError)
		{
			[UIUtils messageAlert:kNetworkErrorMessage title:nil delegate:nil];
			return;
		}
		
		NSError *error;
		NSMutableDictionary *responseDictionary = [NSJSONSerialization
												   JSONObjectWithData:data
												   options:NSJSONReadingMutableContainers
												   error:&error];
		
		if( error )
			NSLog(@"%@", [error localizedDescription]);
		else
			[self parseGooglePlaceObjects:[responseDictionary objectForKey:@"results"]];
		
	}];
}

- (void) findPlacesbyAddress:(NSString*)address
{
	[_gAppDelegate showLoadingView:YES];

	NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSString* urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&key=%@", esc_addr, kGooglePlaceApiKey];
	
	NSURL* url = [[NSURL alloc] initWithString:urlString];
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
	
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError){
		
		[_gAppDelegate showLoadingView:NO];

		if (connectionError)
		{
			[UIUtils messageAlert:kNetworkErrorMessage title:nil delegate:nil];
			return;
		}
		
		NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@",str);
		
		NSError *error;
		NSMutableDictionary *responseDictionary = [NSJSONSerialization
												   JSONObjectWithData:data
												   options:NSJSONReadingMutableContainers
												   error:&error];
		
		if( error )
			NSLog(@"%@", [error localizedDescription]);
		else
			[self parseGooglePlaceObjects:[responseDictionary objectForKey:@"results"]];
		
	}];
}

#pragma mark-

- (void) parseGooglePlaceObjects:(NSArray*)results
{
	NSMutableArray* placeArray = [[NSMutableArray alloc] initWithCapacity:results.count];
	for (int i = 0; i < results.count ; ++i)
	{
		NSDictionary* dict = [results objectAtIndex:i];
		GooglePlaceInfo* info = [[GooglePlaceInfo alloc] initWithJsonResultDict:dict searchTerms:_searchBar.text andUserCoordinates:_userCurrentLocation.coordinate];
		[placeArray addObject:info];
	}
	
	_searchList = [[NSArray alloc] initWithArray:placeArray];
	[_tableView reloadData];
}

#pragma mark-

- (void) initializeLocationManager
{
	if (_locationManager == nil)
		_locationManager = [[LocationManager alloc] init];
    _locationManager.delegate = self;
	
}

#pragma mark - LocationManagerDelegate

- (void) locationManger:(LocationManager*)manager didFailToUpdateWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}

- (void) locationManger:(LocationManager*)manager didupdateNewLoaction:(CLLocation *)location
{
    NSLog(@"didUpdateToLocation: %@", location);
    _userCurrentLocation = location;
	
	[self findNearByPlaces:_userCurrentLocation];
	[_locationManager stopUpdatingLocation];
}

#pragma mark-

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1)
	{
		if (alertView.tag == 0)
			[self showHomeScreen];
		else if (alertView.tag == 1)
			[self sendRequestToAddBusinessLocation];
	}
}

- (void) sendRequestToAddBusinessLocation
{
	CLLocationCoordinate2D location = _selectedPlace.coordinate;
	[_gDataManager sendRequestToAddLocation:location withCompletion:^(BOOL status, NSString* message, ERequestType requestType){
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
	}];
}

#pragma mark-

- (void) showHomeScreen
{
	HomeViewController* viewCtrl = [[HomeViewController alloc] initWithNibName:kHomeViewNib bundle:nil];
	[_gAppPrefData saveAllData];
	
	[_gAppDelegate initializeApplication:viewCtrl];
}


- (void) handleTapGesture:(UITapGestureRecognizer*)gesture
{
	[_searchBar resignFirstResponder];
}

@end
