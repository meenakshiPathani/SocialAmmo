//
//  AppDelegate.m
//  Social Ammo
//
//  Created by Meenakshi on 06/01/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "LocationManager.h"
#import "AppDelegate.h"
#import "AppPrefData.h"
#import "WebServiceManager.h"

#import "NewHomeScreenViewController.h"
#import "LeftViewController.h"

@interface AppDelegate () <SAMenuViewControllerDelegate, LocationManagerDelegate>
{
	UIView*				_blackStatusBar;
	LocationManager*	_locationManager;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

#if TARGET_IPHONE_SIMULATOR
	[_gDataManager setDeviceToken:@"Simulator1234"];
#else
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
#endif
	
	// Override point for customization after application launch.
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	_blackStatusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
	_blackStatusBar.backgroundColor = [UIColor whiteColor];
	[self showAccountScreen];
	[self.window makeKeyAndVisible];

	return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	self.appInBackgroundState = YES;
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	self.appInBackgroundState = NO;

	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	
	if ([_gAppPrefData isLogin])
	{
		[self sendRequestToUserUpdate];
	}
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    DLog(@"Opened by handling url: %@", [url absoluteString]);
    
    return YES;
}

#pragma mark-
#pragma mark PushNotification methods-

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    // send to server.
    NSString* tokenStr = [[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""];
    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSArray* words = [tokenStr componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    tokenStr = [words componentsJoinedByString:@""];
    
	_gAppPrefData.deviceToken = tokenStr;
    [_gDataManager setDeviceToken:tokenStr];
	[_gAppPrefData saveAllData];
	
	DLog(@"My token is: %@", tokenStr);

}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	DLog(@"Failed to get token, error: %@", error);
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
	NSUInteger badgeCount = [[UIApplication sharedApplication] applicationIconBadgeNumber];
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeCount+1];

	NSDictionary* dict = [userInfo objectForKey:@"aps"];
	if (dict)
	{
		NSString* userCredit = [dict objectForKey:@"user_credits"];
		_gDataManager.userCredits = (userCredit.length > 0)?[userCredit
															 integerValue]:_gDataManager.userCredits;
	}
	
	if (self.appInBackgroundState)
		[[NSNotificationCenter defaultCenter] postNotificationName:kPushNotification object:nil userInfo:userInfo];
}

#pragma mark-

- (void) setNavigationBarTransparent:(UINavigationController*)navCtrl
{
	[navCtrl.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
	[navCtrl.navigationBar setShadowImage:[UIImage new]];
	[navCtrl.navigationBar setTranslucent:YES];
}

//- (void) setFontForNavigationBarItem
//{
//	[[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//														  [UIFont fontWithName:kFontMontserratRegular size:17.0f],UITextAttributeFont,
//														  nil] forState:UIControlStateNormal];
//}

- (void) showAccountScreen
{
	NewHomeScreenViewController* viewCtrl = [[NewHomeScreenViewController alloc] initWithNibName:@"NewHomeScreenView" bundle:nil];
	
	UINavigationController* navCtrl = [[UINavigationController alloc] initWithRootViewController:viewCtrl];
	[self setNavigationBarTransparent:navCtrl];
	self.window.rootViewController = navCtrl;
	[self.window.rootViewController.view addSubview:_blackStatusBar];
	
//	[self setFontForNavigationBarItem];
}

#pragma mark-

- (void) showLoadingView:(BOOL)show
{
	NSArray* windowsList = [[UIApplication sharedApplication] windows];
	UIWindow* loadinWindow = (windowsList.count > 1)?[windowsList objectAtIndex:1]:self.window;
	
	if(show)
	{
		if(_loadingView == nil)
			_loadingView = [UILoadingView loadingView];
		[_loadingView showViewAnimated:NO onView:loadinWindow];
	}
	else
	{
		[_loadingView removeViewAnimated:NO];
	}
}

- (void) showProgressView:(BOOL)show
{
	NSArray* windowsList = [[UIApplication sharedApplication] windows];
	UIWindow* loadinWindow = (windowsList.count > 1)?[windowsList objectAtIndex:1]:self.window;
	
	if(show)
	{
		if(_loadingView == nil)
			_loadingView = [UILoadingView loadingView];
		[_loadingView showProgressAnimated:NO onView:loadinWindow];
	}
	else
	{
		[_loadingView removeViewAnimated:NO];
	}
}

- (void) setLoadingViewTitle:(NSString*)title
{
	[_loadingView setLoadingTitle:title];
}

- (void) setProgressData:(float)dataValue
{
	[_loadingView setProgreesbarProgress:dataValue];
}

#pragma mark-

- (void)registerKeyboardNotifications:(id)observer
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterKeyboardNotifications:(id)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark-

- (void) keyboardWillShow:(NSNotification*)notif
{
	
}

- (void) keyboardWillHide:(NSNotification*)notif
{
	
}

#pragma mark-

- (void) initializeApplication:(UIViewController*)initialViewController
{
	UINavigationController *navigationController = [[UINavigationController alloc]
													initWithRootViewController:initialViewController];

	LeftViewController* rearViewController = [[LeftViewController alloc] init];
	
	SAMenuViewController* revealViewController = [[SAMenuViewController alloc] initWithRearViewController:rearViewController frontViewController:navigationController];
    revealViewController.delegate = self;
    
	self.viewController = revealViewController;
	
	self.window.rootViewController = self.viewController;
	[self.window.rootViewController.view addSubview:_blackStatusBar];
}

- (void) initializeLocationManager
{
	if (_locationManager == nil)
		_locationManager = [[LocationManager alloc] init];
	_locationManager.delegate = self;
	[_locationManager startUpdatingLocation];
}

- (void) updateLocation
{
	[_locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void) locationManger:(LocationManager*)manager didFailToUpdateWithError:(NSError *)error;
{
	
}

- (void) locationManger:(LocationManager*)manager didupdateNewLoaction:(CLLocation *)location;
{
    NSLog(@"didUpdateToLocation: %@", location);
    CLLocation* currentLocation = location;
	
	if (_gDataManager.userInfo.userType == EUserTypeCreator)
		[self sendRequestToAddLocation:currentLocation];
}

#pragma mark- UpdateCreatorLocation

- (void) sendRequestToAddLocation:(CLLocation*)location
{
	[_gDataManager sendRequestToAddLocation:location.coordinate withCompletion:^(BOOL status, NSString* message, ERequestType requestType){
//		if (status)
//			[_locationManager stopUpdatingLocation];
	}];
}

#pragma mark- save image in WIP

- (void) saveImageInApplicationDirectory:(UIImage*)image withCaption:(NSString*)caption
{
	NSString* directory = [_gDataManager getWIPDirecory];
	
	NSString* filepath = [UIUtils getUniqueImageNameForDirectory:directory withPrefix:caption];
	NSData* imageData = [NSData dataWithData:UIImageJPEGRepresentation(image, 0.5)];
	[UIUtils saveImageWithData:imageData forFilePath:filepath];
}

- (BOOL) checkWIPImageExistwithTitle:(NSString*)title
{
	NSString* directory = [_gDataManager getWIPDirecory];
	NSArray* fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil];
	for (NSString* fileName in fileList)
	{
		if ([title compare:fileName] == NSOrderedSame)
			return YES;
	}
	return NO;
}

#pragma mark --

// To handle background request for update credit without complitiopn

- (void) sendRequestToUserUpdate
{
	NSString* postString = [NSString stringWithFormat:@"token=%@",_gAppPrefData.sessionToken];
	
	[_gAppDelegate showLoadingView:YES];
	[_gAppDelegate setLoadingViewTitle:@"Updating..."];
	
	__block ERequestType requestType = ERequestTypeGetUserUpdates;
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kGetUserUpdates
														   postString:postString];
	[WebServiceManager sendRequest:request
						completion:^ (NSData* responseData, NSError* error)
	 {
		 [_gAppDelegate showLoadingView:NO];
		 [_gAppDelegate setLoadingViewTitle:@"Loading..."];
		 
		 DataManager* dataManager = _gDataManager;
		 
		 if (error)
		 {
			 NSLog(@"Request Type %d",requestType);
			 //			 if (![error.domain caseInsensitiveCompare:@"NSPOSIXErrorDomain"]==NSOrderedSame)
			 //				 [UIUtils messageAlert:kNetworkErrorMessage title:kNetworkError delegate:nil];
		 }
		 else
		 {
			 _Assert(responseData);
			 NSDictionary* response = [dataManager getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [dataManager checkResponseStatus:response];
			 if (status)
			 {
				 NSDictionary* userUpdateDict = [response objectForKey:@"userdata"];
				 
//				 dataManager.userCredits = [[userUpdateDict objectForKey:@"credits"] integerValue];
				 UserInfo* info = _gDataManager.userInfo;
				 info.submissionNotify = [[userUpdateDict objectForKey:@"submission_notify"] boolValue];
				 info.messageNotify = [[userUpdateDict objectForKey:@"message_notify"] boolValue];
				 
				 [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateHomeScreen" object:nil];
				 
//				 [self setUserCredits];
//				 [self showMessageNotificationOnTopBar:dataManager.messageNotification];
//				 [self showSubmissionNotificationOnTopBar:dataManager.submissionNotification];
			 }
		 }
	 }];
}

@end
