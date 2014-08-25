//
//  LeftViewController.m
//  BidAbout
//
//  Created by     on 01/07/13.
//  Copyright (c) 2013 BolderImage. All rights reserved.
//

#import "LeftViewController.h"
#import "SAMenuViewController.h"
#import "LeftTableViewCell.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

@synthesize leftTableView = _leftTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];

	UINib* nib = [UINib nibWithNibName:@"LeftTableViewCell" bundle:[NSBundle mainBundle]];
	[_leftTableView registerNib:nib forCellReuseIdentifier:@"LeftTableCellID"];

//	_leftTableView.tableFooterView = _fotterView;
    
	NSString* menuFileName = (_gDataManager.userInfo.userType == EUserTypeCreator)?@"CreatorMenu.plist":@"BusinessMenu.plist";
	
    _menuList = [[NSArray alloc] initWithContentsOfFile:ResourcePath(menuFileName)];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	((_menuList.count > 5) && !kIPhone5)?[_leftTableView setScrollEnabled:YES]:[_leftTableView setScrollEnabled:NO];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void) dealloc
{
	self.leftTableView.delegate = nil;
	self.leftTableView = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleDefault ;
}

#pragma mark --
#pragma mark -- TableView Data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _menuList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	static NSString* cellIdentifier = @"LeftTableCellID";
	
	LeftTableViewCell* cell = (LeftTableViewCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	cell.backgroundColor = [UIColor clearColor];
	
	NSDictionary* obj = [_menuList objectAtIndex:indexPath.row];
	if (obj)
		[cell setUpInitial:obj];
	
	return cell;
}

#pragma mark --
#pragma mark -- TableView Delegate method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 56.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary* dict = [_menuList objectAtIndex:indexPath.row];
	if (dict)
	{
		NSString* viewControllerName = [dict objectForKey:@"ViewControllerName"];
		([viewControllerName caseInsensitiveCompare:@"LogoutViewController"] ==
		 NSOrderedSame)?[self logoutUser]:[self displayFrontViewController:viewControllerName];
		
		if ([viewControllerName caseInsensitiveCompare:@"CreatorHubViewController"] ==
		 NSOrderedSame)
		{
			_gDataManager.createContentForSubmission = NO;
			_gDataManager.createContentForSubmissionInfo = nil;
		}
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
	headerView.backgroundColor = [UIColor clearColor];
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 10.0;
}

#pragma mark --
#pragma mark Nevegation Logic

// This method is used to navigate the user to respective controller from menu list. Please add viewContrller name in menulist to navigate rather than useing using if-else or switch condition.

- (void) displayFrontViewController:(NSString*)viewControllerName
{
    NSString *classNameStr = viewControllerName;
    Class theClass = NSClassFromString(classNameStr);
    if (theClass)
    {
        id viewControllerObj = [[theClass alloc] init];
        
        SAMenuViewController *revealController = self.revealViewController;
        
        // we know it is a NavigationController
        UINavigationController *frontNavigationController = (id)revealController.frontViewController;
        
        if ( ![frontNavigationController.topViewController isKindOfClass:[viewControllerObj class]] )
        {
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewControllerObj];

            [revealController setFrontViewController:navigationController animated:YES];
        }
        // Seems the user attempts to 'switch' to exactly the same controller he came from!
        else
        {
            [revealController revealToggle:self];
        }
    }
}

- (void) logoutUser
{
	if (_gDataManager.userInfo.facebookLogin)
		[FBSession.activeSession closeAndClearTokenInformation];
	[self sendRequestToLogout];
}

- (void) sendRequestToLogout
{
	[_gAppDelegate showLoadingView:YES];
	
	NSString* postString = [NSString stringWithFormat:@"token=%@",_gAppPrefData.sessionToken];
	
	__block ERequestType requestType = ERequestTypeLogout;
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kLogoutService
														   postString:postString];
	[WebServiceManager sendRequest:request
						completion:^ (NSData* responseData, NSError* error)
	 {
		 [_gAppDelegate showLoadingView:NO];
		 
		 DataManager* dataManager = _gDataManager;
		 
		 if (error)
		 {
			 if (![error.domain caseInsensitiveCompare:@"NSPOSIXErrorDomain"]==NSOrderedSame)
				 [UIUtils messageAlert:kNetworkErrorMessage title:kNetworkError delegate:nil];
		 }
		 else
		 {
			 _Assert(responseData);
			 NSDictionary* response = [dataManager getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [dataManager checkResponseStatus:response];
			 if (status)
			 {
				 [dataManager.userInfo logout];
				 [_gAppDelegate showAccountScreen];
			 }
			 else
			 {
				 if(requestType == ERequestTypeLogout)
				 {
					 NSString* message = [response objectForKey:@"err_message"];
					 [UIUtils messageAlert:message title:nil delegate:self];
				 }
			 }
		 }
	 }];
}

@end
