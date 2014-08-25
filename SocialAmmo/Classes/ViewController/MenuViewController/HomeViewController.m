//
//  HomeViewController.m
//  SocialAmmo
//
//  Created by Rupesh Kumar on 7/10/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "BriefListDetailViewController.h"
#import "AcceptDeclineListViewController.h"
#import "DeclineListViewController.h"

#import "CreatorHubViewController.h"
#import "BusinessLocationViewController.h"
#import "CreatorLocationViewController.h"

#import "LocationManager.h"
#import "BusinessStepsViewController.h"
#import "HomeViewController.h"

@interface HomeViewController ()<HomeTopBarViewDelegate, CreatorBeaconDelegate, BriefListDelegate>
{
	BusinessStepsViewController*	_businessStepsVC;
	LocationManager*				_locationManger;
	
	EHomeTopButtonType				_selectedHomeButton;
}

@end

@implementation HomeViewController

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
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScreen:) name:@"UpdateHomeScreen" object:nil];
	
	self.navigationController.navigationBarHidden = YES;
	_homeTopbar = [HomeTopBarView topBarView];
	_homeTopbar.delegate = self;
	[_homeTopbar prepareTopBarLayoutForUserType:_gDataManager.userInfo.userType andController:self];
	_homeTopbar.frame = CGRectMake(0, 24, 320, 44);
	
	[self.view addSubview:_homeTopbar];
	[self.view bringSubviewToFront:_homeTopbar];
	
	self.title = @"Home View";
	
	UserInfo* userInfo = _gDataManager.userInfo;
		
	if (!userInfo.locationEnabled)
	{
		NSString* message = nil;
		if (userInfo.userType == EUserTypeBuisness)
			message = @"Please select the location to use the app.";
		else
			message = @"Allow app to access your current location.";
		[UIUtils messageAlert:message title:nil delegate:self];
	}
	else
	{
		NSLog(@"%d",[CLLocationManager authorizationStatus]);
		if ((userInfo.userType == EUserTypeCreator) && (![CLLocationManager locationServicesEnabled] || !([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)))
		{
			[UIUtils messageAlert:@"Allow app to access your current location." title:nil delegate:self];
		}
	}
	
	if ((userInfo.userType == EUserTypeBuisness) && (userInfo.hasOpenSubmission == NO))
	{
		[self displayBusiness3Steps];
	}
	
	if (_gDataManager.userInfo.userType == EUserTypeCreator)
	{
		_creatorbeaconVC = [[CreatorBeaconViewController alloc] initWithNibName:[UIUtils iphoneScreenName:@"CreatorBeaconView"] bundle:nil];
		_creatorbeaconVC.delegate = self;
	}
	else
	{
		_businessBeaconVC = [[BusinessBeaconViewController alloc] initWithNibName:@"BusinessBeaconView"
																		   bundle:nil];
	}
	
	_messageNotifVC = [[MessageNotificationViewController alloc] initWithNibName:kMessageNotificationViewNib
																		  bundle:nil];
	
	_briefListVC = [[BriefListViewController alloc] initWithNibName:kBriefListViewNib
															 bundle:nil];
	_briefListVC.delegate = self;
	if (_gDataManager.userInfo.userType == EUserTypeBuisness)
	{
		if (userInfo.hasOpenSubmission)
			[self setUPFreshUser];
	}
	else if (_gDataManager.userInfo.userType == EUserTypeCreator)
		[self setUPFreshUser];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.navigationController.navigationBarHidden = YES;
	
	[self updateScreen:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent ;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark-

- (void) displayBusiness3Steps
{
	if (_businessStepsVC == nil)
	{
		_businessStepsVC = [[BusinessStepsViewController alloc] initWithCompletionBlock:^(){
					
			CGFloat height = [[UIScreen mainScreen] bounds].size.height - 80;
			_gAppPrefData.isFreshLogin = NO;
			[_gAppPrefData saveAllData];
			[self showBusinessBeaconScreen:height];
		}];
		_businessStepsVC.homeVC = self;
	}

	CGFloat y = CGRectGetMaxY(_homeTopbar.frame);

	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	CGFloat height = CGRectGetHeight(screenBounds) - y;
	_businessStepsVC.view.frame = CGRectMake(0, y, 320, height);
	[self.view addSubview:_businessStepsVC.view];
}

- (void) setUPFreshUser
{
	_selectedHomeButton = EHomeTopButtonTypeBecaon;
	
	if (_gAppPrefData.isFreshLogin)
	{
		CGFloat height = [[UIScreen mainScreen] bounds].size.height - 80;
		if((_gDataManager.userInfo.userType == EUserTypeBuisness) &&
		   (_gDataManager.userInfo.hasOpenSubmission == YES))
		{
			_gAppPrefData.isFreshLogin = NO;
			[_gAppPrefData saveAllData];
			[self showBusinessBeaconScreen:height];
		}
		else if (_gDataManager.userInfo.userType == EUserTypeCreator)
		{
			_gAppPrefData.isFreshLogin = NO;
			[_gAppPrefData saveAllData];
			
			[self showCreatorBeaconScreen:height];
		}
	}
}

#pragma mark-

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self displayLocationScreen];
}

#pragma mark-

- (void) displayLocationScreen
{
	if (_gDataManager.userInfo.userType == EUserTypeCreator)
	{
		CreatorLocationViewController* viewCtrl = [[CreatorLocationViewController alloc] initWithNibName:kCreatorLocationViewNib bundle:nil];
		viewCtrl.backButton.hidden = NO;
		[self.navigationController pushViewController:viewCtrl animated:YES];
	}
	else if (_gDataManager.userInfo.userType == EUserTypeBuisness)
	{
		BusinessLocationViewController* viewCtrl = [[BusinessLocationViewController alloc] initWithNibName:kBusinessLocationViewNib bundle:nil];
		viewCtrl.backButton.hidden = NO;
		[self.navigationController pushViewController:viewCtrl animated:YES];
	}
}

- (void) topBarButtonSelected:(UIButton*)sender
{
	_selectedHomeButton = (EHomeTopButtonType)sender.tag;
	
	if (_gDataManager.userInfo.userType == EUserTypeCreator)
		[self creatorFlow:sender];
	else
		[self businessFlow:sender];
}

- (void) businessFlow:(UIButton*)sender
{
	if (!_gDataManager.userInfo.hasOpenSubmission)
	{
		[UIUtils messageAlert:@"Please create the Open Submission." title:nil delegate:nil];
		return;
	}
	[self updateTopbarNotifyIcon];

	CGFloat height = [[UIScreen mainScreen] bounds].size.height - 80;

	_messageNotifVC.messageScreenVisible = NO;

	switch (sender.tag)
	{
		case EHomeTopButtonTypeHome:
		{
			[_homeTopbar showSubmissionSeleccted];
			[_businessBeaconVC.view removeFromSuperview];
			[_messageNotifVC.view removeFromSuperview];
			
			_briefListVC.view.frame = CGRectMake(0, 80, 320, height);
			[self.view addSubview:_briefListVC.view];
			
			[_briefListVC beginRefreshingTableView];
		}
			break;
			
		case EHomeTopButtonTypeBecaon:
		{
			[self showBusinessBeaconScreen:height];
		}
			break;
			
		case EHomeTopButtonTypeMessage:
		{
			[_homeTopbar showSelectedMessageBar];
			[_businessBeaconVC.view removeFromSuperview];
			[_briefListVC.view removeFromSuperview];
			
			_messageNotifVC.messageScreenVisible = YES;
			_messageNotifVC.view.frame = CGRectMake(0, 80, 320, height);
			[self.view addSubview:_messageNotifVC.view];
		}
			
		default:
			break;
	}
}

- (void) creatorFlow:(UIButton*)sender
{
	[self updateTopbarNotifyIcon];
	_messageNotifVC.messageScreenVisible = NO;

	CGFloat height = [[UIScreen mainScreen] bounds].size.height - 80;

	switch (sender.tag)
	{
		case EHomeTopButtonTypeHome:
		{
			[_messageNotifVC.view removeFromSuperview];
			[_creatorbeaconVC.view removeFromSuperview];
			[_homeTopbar showSubmissionSeleccted];
		}
			break;
			
		case EHomeTopButtonTypeBecaon:
		{
			[self showCreatorBeaconScreen:height];
		}
			break;
			
		case EHomeTopButtonTypeMessage:
		{
			[_homeTopbar showSelectedMessageBar];

			[_creatorbeaconVC.view removeFromSuperview];
			
			_messageNotifVC.messageScreenVisible = YES;

			_messageNotifVC.view.frame = CGRectMake(0, 80, 320, height);
			[self.view addSubview:_messageNotifVC.view];
		}
			
		default:
			break;
	}
}

- (void) showBusinessBeaconScreen:(CGFloat)height
{
	[_homeTopbar showBeaconbarSelcted];
	[_messageNotifVC.view removeFromSuperview];
	[_briefListVC.view removeFromSuperview];
	height = (kIPhone5)?height:height+80+20;
	_businessBeaconVC.view.frame = CGRectMake(0, 80, 320, 480);
	[self.view addSubview:_businessBeaconVC.view];
	
}

- (void) showCreatorBeaconScreen:(CGFloat)height
{
	[_messageNotifVC.view removeFromSuperview];
	height = (kIPhone5)?height:height+80+20;
	_creatorbeaconVC.view.frame = CGRectMake(0, 80, 320, height);
	[self.view addSubview:_creatorbeaconVC.view];
	[_homeTopbar showBeaconbarSelcted];
}

#pragma mark-

- (void) displayCreatorHubForSubmssion:(BusinessOpenSubmissionInfo*)info
{
	CreatorHubViewController* viewCtrl = [[CreatorHubViewController alloc] initWithNibName:kCreatorHubViewNib
																					bundle:nil];
	_gDataManager.createContentForSubmission = YES;
	_gDataManager.createContentForSubmissionInfo = info;
	viewCtrl.submissionInfo = info;
	[self.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark- briefListDelegate

-(void) briefActionWithType:(EBriefAction)briefactiontype forBrief:(BriefInfo*)breifInfo
{
	switch (briefactiontype)
	{
		case EBriefNewSubmission:
			[self sendRequestToGetBreifContent:EBriefTypeNew andbriefID:breifInfo.briefId];
			break;
			
		case EBriefCredit:
			[self displayCreaditedBriefList:breifInfo];
			break;
			
		case EBriefAccepted:
			[self sendRequestToGetBreifContent:EBriefTypeAccepted andbriefID:breifInfo.briefId];
			break;
			
		case EBriefDecliend:
			[self sendRequestToGetBreifContent:EBriefTypeDeclined andbriefID:breifInfo.briefId];
			break;
			
		default:
			break;
	}

}

#pragma  mark -- Services for brief Detail

- (void) sendRequestToGetBreifContent:(EBriefType)briefType andbriefID:(NSUInteger)breifID
{
	[_gDataManager sendRequestToGetbriefContent:briefType withId:breifID
								 withCompletion:^(BOOL status, NSString* message, ERequestType
												  requestType){
									 if (status)
										 [self displayBriefDetail:briefType];
									 else
										 [UIUtils messageAlert:message title:@"" delegate:nil];
								 }];
}

#pragma mark -- Screen navigation method

- (void) displayBriefDetail:(EBriefType)briefType
{
	switch (briefType)
	{
		case EBriefTypeNew:
			[self displayNewSubmissionDetailList];
			break;
			
		case EBriefTypeAccepted:
			[self displayAcceptedBriefList];
			break;
			
		case EBriefTypeDeclined:
			[self displayDeclinedBriefList];
			break;
		default:
			break;
	}
}

- (void) displayNewSubmissionDetailList
{
	BriefListDetailViewController* briefListVC = [[BriefListDetailViewController alloc] initWithCompletionBlock:^(){
			[_briefListVC beginRefreshingTableView];
		}];
	[self.navigationController pushViewController:briefListVC animated:NO];
}

- (void) displayAcceptedBriefList
{
	AcceptDeclineListViewController* acceptedBLVC = [[AcceptDeclineListViewController alloc] initWithCompletionBlock:^(){
		[_briefListVC beginRefreshingTableView];
	}];
	[self.navigationController pushViewController:acceptedBLVC animated:NO];
}

- (void) displayDeclinedBriefList
{
	DeclineListViewController* acceptedBLVC = [[DeclineListViewController alloc] initWithCompletionBlock:^(){
		[_briefListVC beginRefreshingTableView];
	}];
	[self.navigationController pushViewController:acceptedBLVC animated:NO];
}

- (void) displayCreaditedBriefList:(BriefInfo*)info
{
	//	SubmitCreditViewController* creditVC = [[SubmitCreditViewController alloc] initWithNibName:kSubmitCreditViewNib bundle:nil];
	//	creditVC.briefInfo = info;
	//	creditVC.heading = @"Top up brief";
	//	creditVC.subHeading = @"Submit credit to the brief";
	//	[self.navigationController pushViewController:creditVC animated:NO];
}

- (void) updateTopbarNotifyIcon
{
	[_homeTopbar showMessageNotifyIcon:_gDataManager.userInfo.messageNotify];
	[_homeTopbar showSubmissionNotifyIcon:_gDataManager.userInfo.submissionNotify];
}

- (void) updateScreen:(NSNotification*)notif
{
	[self updateTopbarNotifyIcon];
	
	switch (_selectedHomeButton)
	{
		case EHomeTopButtonTypeHome:
		{
			if (_gDataManager.userInfo.userType == EUserTypeBuisness)
				[_briefListVC beginRefreshingTableView];
			break;
		}
		case EHomeTopButtonTypeBecaon:
		{
			if (_gDataManager.userInfo.userType == EUserTypeCreator)
				[_creatorbeaconVC sendRequestToGetBeaconBusiness:@""];
			else
				[_businessBeaconVC sendRequestToLoadBusinessBeaconData];
			break;
		}
		case EHomeTopButtonTypeMessage:
		{
			[_messageNotifVC beginRefreshingTableView];
			break;
		}
		default:
			break;

	}
}

@end
