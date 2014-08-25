//
//  NewHomeScreenViewController.m
//  SocialAmmo
//
//  Created by Rupesh Kumar on 6/30/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "NewHomeScreenViewController.h"
#import "UserTypeViewController.h"
#import "NewLogInViewController.h"
#import "UINavigationController+UINavigation.h"
#import "HomeViewController.h"
#import "AppPrefData.h"
#import "PagedFlowView.h"

@interface NewHomeScreenViewController ()<PagedFlowViewDataSource,PagedFlowViewDelegate>

@end

@implementation NewHomeScreenViewController

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
	self.navigationController.navigationBarHidden = YES;
	_listOfBusiness = [[NSArray alloc] init];
	
	UISwipeGestureRecognizer *upswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleUpSwipe:)];
	UISwipeGestureRecognizer *downswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDownSwipe:)];
	
	upswipe.direction = UISwipeGestureRecognizerDirectionUp;
	downswipe.direction = UISwipeGestureRecognizerDirectionDown;
	
	[self.view addGestureRecognizer:upswipe];
	[self.view addGestureRecognizer:downswipe];
	
	// Set up paged flow
	_pagedFlowView.delegate = self;
	_pagedFlowView.dataSource = self;
    _pagedFlowView.minimumPageAlpha = 1;
    _pagedFlowView.backgroundColor = [UIColor clearColor];
    _pagedFlowView.minimumPageScale = 0.5;
	_pagedFlowView.orientation = PagedFlowViewOrientationVertical;
	
	[self setNormalScreenData];

	[self autoLoginIntoapp];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationController.navigationBarHidden = YES;
}

- (void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
	
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleDefault ;
}


#pragma mark -
#pragma mark PagedFlowView Delegate

- (CGSize) sizeForPageInFlowView:(PagedFlowView *)flowView;
{
    CGFloat height = _pagedFlowView.frame.size.height;
    return CGSizeMake(128, height-45);
}

- (void)flowView:(PagedFlowView *)flowView didScrollToPageAtIndex:(NSInteger)index
{
    DLog(@"Scrolled to page # %ld", (long)index);
	
	[self updateIndustryData:index];
}

#pragma mark -
#pragma mark PagedFlowView Datasource

- (NSInteger) numberOfPagesInFlowView:(PagedFlowView *)flowView
{
    return [_listOfBusiness count];
}

- (UIView *) flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    UILabel *label = (UILabel*)[flowView dequeueReusableCell];
    if (!label)
    {
        label = [[UILabel alloc] init];
        label.layer.cornerRadius = 2;
        label.layer.masksToBounds = YES;
		label.textColor = [UIColor greenColor];
		
		label.font = [UIFont fontWithName:kFontRalewayBold size:18.0];
		label.textAlignment = NSTextAlignmentCenter;
        label.contentMode = UIViewContentModeScaleAspectFit;
    }

	
	BusinessInfo* businessInfo = [_listOfBusiness objectAtIndex:index];
	label.text = (_isIndustry)?@"dfdfdf": businessInfo.businessName;
	label.textColor = (_isIndustry)?[UIColor whiteColor]:kBlueColor;
    return label;
}

#pragma mark -- Button action

- (IBAction) loginButtonAction:(id)sender
{
	NewLogInViewController* viewCtrl = [[NewLogInViewController alloc]
										initWithNibName:@"NewLogInView" bundle:nil];
	[self.navigationController pushViewController:viewCtrl animated:YES];
}

- (IBAction) signUpButtonAction:(id)sender
{
	UserTypeViewController* viewCtrl = [[UserTypeViewController alloc] initWithNibName:kUserTypeViewNib bundle:nil];
	[self.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark -- AutoLogin imple,entation

- (void) autoLoginIntoapp
{
	_autoLoginImageView.image = [UIImage imageNamed:[UIUtils iPhone5ImageName:@"Default.png"]];
	
	if (/*( _gAppPrefData.fbToken.length > 0) &&*/ _gAppPrefData.isLogin)
	{
		[self handleAutoLoginSetUp:NO];
		
		[_gDataManager sendRequestToGetUserInfoWithCompletion:^(BOOL status, NSString* errorMessage,
																ERequestType requestType){
			if (status)
				[self sendRequestForBusinessSettings];
			else
				[UIUtils messageAlert:errorMessage title:@"Login failed" delegate:self];
		}];
	}
	else
		[self handleAutoLoginSetUp:YES];
}

- (void) handleAutoLoginSetUp:(BOOL) isLogin
{
	if (isLogin)
		[self sendRequestForBusinessList];
	
	_autoLoginImageView.hidden = isLogin;
	_loginbutton.enabled = isLogin;
	_signUpButton.enabled = isLogin;
	
	_gAppPrefData.isLogin = !isLogin;
	[_gAppPrefData saveAllData];
}

- (void) sendRequestForBusinessList
{
	[_gDataManager sendRequestForBusinessWithCompletion:^(BOOL status, NSString* errorMesasge,
														  ERequestType requestType){
		
		if (status)
		{
			_listOfBusiness	= _gDataManager.businessList;
			[_pagedFlowView reloadData];
			
//			[_gAppDelegate initializeLocationManager];
		}
		else
		{
			[UIUtils messageAlert:errorMesasge title:nil delegate:self];
		}
	}];
}

#pragma mark-
#pragma mark UIAlertViewDelegate methods-

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (!_autoLoginImageView.hidden)
		[self handleAutoLoginSetUp:YES];
}

#pragma mark-

- (void) displayHomeScreen
{
	[_gAppDelegate initializeLocationManager];
	
	 HomeViewController* viewCtrl = [[HomeViewController alloc] initWithNibName:kHomeViewNib
	 bundle:nil];

	_gAppPrefData.isLogin = YES;
	[_gAppPrefData saveAllData];
	
	UserInfo* userInfo = [_gDataManager userInfo];
	if (userInfo.userType == EUserTypeCreator)
		 [_gAppDelegate initializeApplication:viewCtrl];
	else if (userInfo.userType == EUserTypeBuisness)
		 [_gAppDelegate initializeApplication:viewCtrl];
	else if (userInfo.userType == EUserTypeCharity)
		[UIUtils messageAlert:@"Designs not provided for Charity user." title:nil delegate:nil];
}

- (void) sendRequestForBusinessSettings
{
	[_gDataManager sendRequestToGetBuisnessRulesWithCompletion:^(BOOL status, NSString* message,
																 ERequestType requestType){
		if (status)
			[self displayHomeScreen];
		else
			[UIUtils messageAlert:message title:@"Login failed" delegate:self];
	}];
}

#pragma  mark -- Gesture recogniser

- (void) handleUpSwipe:(UISwipeGestureRecognizer *)swipe
{
	if (_currentIndustryIndex < _listOfBusiness.count)
			[self updateIndustryData:_currentIndustryIndex +1];
}

- (void) handleDownSwipe:(UISwipeGestureRecognizer *)swipe
{
	if (_currentIndustryIndex > 0)
		[self updateIndustryData: _currentIndustryIndex -1];
}

- (void) updateIndustryData:(NSInteger)industryIndex
{
	if (industryIndex <0 || industryIndex >= _listOfBusiness.count)
		return;
	BusinessInfo* info = [_listOfBusiness objectAtIndex:industryIndex];
	
	NSString* imageURl = (kIPhone5)?info.iPhone5ImageURl:info.highImageURL;
	
	_indsutryImageView.image = nil;
	_indsutryImageView.imageUrl = imageURl;
	[_indsutryImageView becomeActive];
	
	[self setIndusstryScreenData];
	
	[_pagedFlowView scrollToPage:industryIndex];
	_currentIndustryIndex = industryIndex;
}

- (void) setNormalScreenData
{
	_isIndustry = NO;
	
	_loginSignUpButtonImgeView.image = [UIImage imageNamed:@"top bar blue.png"];
	_logoImageView.image = [UIImage imageNamed:@"logo blue.png"];
	_isForLable.textColor = kBlueColor;
	_srollUpDownLabel.hidden = NO;
	_orImageV.image = [UIImage imageNamed:@"white or.png"];
	_upWheelImageV.image = [UIImage imageNamed:@"blue arrow up.png"];
	_downWheelImageV.image = [UIImage imageNamed:@"blue arrow down.png"];
	[_pagedFlowView reloadData];
}

- (void) setIndusstryScreenData
{
	_isIndustry = YES;
	_loginSignUpButtonImgeView.image = [UIImage imageNamed:@"top bar.png"];
	_logoImageView.image = [UIImage imageNamed:@"white logo.png"];
	_isForLable.textColor = [UIColor whiteColor];;
	_srollUpDownLabel.hidden = YES;
	_orImageV.image = [UIImage imageNamed:@"or.png"];
	_upWheelImageV.image = [UIImage imageNamed:@"bullet wheel arrow white.png"];
	_downWheelImageV.image = [UIImage imageNamed:@"bullet wheel down arrow.png"];
	[_pagedFlowView reloadData];
}

@end
