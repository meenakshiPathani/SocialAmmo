//
//  NewLogInViewController.m
//  SocialAmmo
//
//  Created by Rupesh Kumar on 7/1/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "AFHTTPRequestOperation.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"
#import "HomeViewController.h"
#import "NewLogInViewController.h"
#import "AppPrefData.h"
#import "SCAFacebookSession.h"

@interface NewLogInViewController ()
{
	LIALinkedInHttpClient*		_client;
	
}

@end

@implementation NewLogInViewController

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

	UIGestureRecognizer* touchRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:touchRecognizer];
	
	if(kIPhone5)
		_scrollView.scrollEnabled = NO;
//	else
//		_scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width,
//												  _scrollView.frame.size.height+10);
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self setIntitaluserDefault];
}

- (void) dealloc
{
	_scrollView.delegate = nil;
	[_gAppDelegate unregisterKeyboardNotifications:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleDefault ;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma  mark --
#pragma mark -- Button action

- (IBAction) loginWithFacebookBtnAction:(id)sender
{
	[self logInWithFacebook];
}

- (IBAction) logInWithLinkdInButtonAction:(id)sender
{
	[self loginToLinkedIn];
}

- (IBAction) backButtonAction:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) goBttnAction:(id)sender
{
	[self sendRequestForLogin];
}


#pragma mark-
#pragma mark TextField delegate methods-

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	if(!kIPhone5)
		_scrollView.contentInset = UIEdgeInsetsMake(0, 0, 248, 0);
	
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	CGPoint offset = CGPointMake(0, CGRectGetMaxY(textField.frame));
	
	if(!kIPhone5)
		[_scrollView setContentOffset:offset animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	_scrollView.contentInset = UIEdgeInsetsZero;
	[_scrollView setContentOffset:CGPointZero animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
	NSUInteger maxLength = kMaxLength;
	if (textField.tag == _usernameTextField.tag)
		maxLength = kEmailMaxLength;
	else
		maxLength = kPasswordMaxLength;
	
	NSUInteger oldLength = [textField.text length];
	NSUInteger replacementLength = [string length];
	NSUInteger rangeLength = range.length;
	
	NSUInteger newLength = oldLength - rangeLength + replacementLength;
	
	BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
	
	return newLength <= maxLength || returnKey;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
	switch (textField.tag)
	{
		case ENewLoginFieldUsername:
		{
			[_passwordTextField becomeFirstResponder];
			break;
		}
		case ENewLoginFieldPassword:
		{
			[textField resignFirstResponder];
			[self sendRequestForLogin];
			break;
		}
	}
	return YES;
}

#pragma mark -
#pragma mark Notification

- (void) handleTapGesture:(id)sender
{
	if ([_passwordTextField isFirstResponder] )
		[_passwordTextField resignFirstResponder];
	else if ([_usernameTextField isFirstResponder])
		[_usernameTextField resignFirstResponder];
}

#pragma mark -- Private methods

- (void) logInWithFacebook
{
	NSArray* permissionArray = [NSArray arrayWithObjects:@"user_birthday",@"email",@"user_location",
								@"public_profile",@"user_photos",@"publish_stream", @"manage_pages",nil];
	[SCAFacebookSession openSessionWithPermissions:permissionArray block:^(id result, NSError *error) {
		if (error)
		{
			(error.code == 2)? NSLog(@"Error duriong facebook"):[UIUtils messageAlert:
																 error.description title:nil
																			 delegate:nil];
		}
		else
		{
			NSDictionary* dict = (NSDictionary*)result;
			[self parseFaceBookuserInfo:dict];
		}
	}];
}

- (void) parseFaceBookuserInfo:(NSDictionary*)dict
{
	UserInfo* userInfo = [[UserInfo alloc] init];
	
	userInfo.email = [UIUtils checknilAndWhiteSpaceinString:[dict objectForKey:@"email"]];
	userInfo.firstname = [UIUtils checknilAndWhiteSpaceinString:[dict objectForKey:@"first_name"]];
	userInfo.lastname = [UIUtils checknilAndWhiteSpaceinString:[dict objectForKey:@"last_name"]];
	
	// facebook login
	[self sendRequestForSocialMediaLogin:EUserSocialMediaTypeFacebook user:userInfo];
}

- (void) displayHomeScreen
{
	HomeViewController* viewCtrl = [[HomeViewController alloc] initWithNibName:@"HomeView"
																		bundle:nil];
	
	_gAppPrefData.isLogin = YES;
	_gAppPrefData.isFreshLogin = YES;
	
	[_gAppPrefData saveAllData];
	
	[_gAppDelegate initializeApplication:viewCtrl];
}

- (void) cacheCredentialInUserDefaults
{
	_gAppPrefData.emailId = _usernameTextField.text;
	_gAppPrefData.password = _passwordTextField.text;
	[_gAppPrefData saveAllData];
}

- (void) setIntitaluserDefault
{
	_usernameTextField.text = _gAppPrefData.emailId;
}

#pragma mark - Services

- (void) sendRequestForLogin
{
	if ([UIUtils isEmptyString:_usernameTextField.text])
	{
		[UIUtils messageAlert:@"Please enter the email." title:nil delegate:nil];
		[_usernameTextField becomeFirstResponder];
		return;
	}
	else if ([UIUtils isEmptyString:_passwordTextField.text])
	{
		[UIUtils messageAlert:@"Please enter the password." title:nil delegate:nil];
		[_passwordTextField becomeFirstResponder];
		return;
	}
	
	[self cacheCredentialInUserDefaults];
	
	[_gDataManager sendRequestForLogin:_usernameTextField.text password:_passwordTextField.text
						withCompletion:^(BOOL status, NSString* errorMessage, ERequestType requestType){
							if (status)
								[self sendRequestForBusinessSettings];
							else
								[UIUtils messageAlert:errorMessage title:@"Login failed" delegate:self];
						}];
}

- (void) sendRequestForBusinessSettings
{
	[_gDataManager sendRequestToGetBuisnessRulesWithCompletion:^(BOOL status, NSString* message,
																 ERequestType requestType){
		if (status)
		{
			[_gAppDelegate initializeLocationManager];
			[self displayHomeScreen];
		}
		else
		{
			[UIUtils messageAlert:message title:nil delegate:nil];
		}
	}];
}


//- (void) sendRequestToFacebookLogIn:(UserInfo*)userInfo
- (void) sendRequestForSocialMediaLogin:(EUserSocialMediaType)mediatype user:(UserInfo*)userInfo
{
	[_gDataManager sendRequestToSocialMediaLoginUser:mediatype withEmail:userInfo.email
										withCompletion:^(BOOL status, NSString* errorMessage,
														 ERequestType requestType)
	 {
		 if (status)
		 {
			 [self sendRequestForBusinessSettings];
		 }
		 else
		 {
			 if (mediatype == EUserSocialMediaTypeFacebook)
				 [SCAFacebookSession closeSession];
			 [UIUtils messageAlert:errorMessage title:@"" delegate:nil];
		 }
		 
	 }];
}

#pragma mark- LinkedIn login

- (void) loginToLinkedIn
{
	_client = [self client];
	
	[_gAppDelegate showLoadingView:YES];
	[self.client getAuthorizationCode:^(NSString *code) {
		
		[self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
			
			NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
			_gAppPrefData.linkedInToken = accessToken;

			[self requestMeWithToken:accessToken];
		}                   failure:^(NSError *error) {
			NSLog(@"Quering accessToken failed %@", error);
		}];
	}   cancel:^{
		[_gAppDelegate showLoadingView:NO];

		NSLog(@"Authorization was cancelled by user");
	}                     failure:^(NSError *error) {
		[_gAppDelegate showLoadingView:NO];

		NSLog(@"Authorization failed %@", error);
	}];
	
}

- (void)requestMeWithToken:(NSString *)accessToken
{
	[_gAppDelegate showLoadingView:YES];
	
	NSString* str = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~/email-address/?oauth2_access_token=%@&format=json", accessToken];
	NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError) {
		
		[_gAppDelegate showLoadingView:YES];
		
		if (connectionError)
		{
			NSLog(@"%@",connectionError.description);
			return ;
		}
		
		NSError* error= nil;
		NSString* email = (NSString*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		UserInfo* userInfo = [[UserInfo alloc] init];
		userInfo.email = [UIUtils checknilAndWhiteSpaceinString:email];
		if( error )
			NSLog(@"%@", [error localizedDescription]);
		else
			[self sendRequestForSocialMediaLogin:EUserSocialMediaTypeLinkedIn user:userInfo];
		
		NSLog(@"%@",email);
	}];
}

- (LIALinkedInHttpClient *)client
{
	LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:kLinkedInRedirectURL																					clientId:kLinkedInClientID
																				clientSecret:kLinkedInSecretAppKey
																					   state:kLinkeDinStates
																			   grantedAccess:@[@"r_fullprofile", @"r_emailaddress", @"rw_company_admin"]];
	return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}



@end
