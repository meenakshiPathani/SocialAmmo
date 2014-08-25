//
//  AddPaypalInfoViewController.m
//  SocialAmmo
//
//  Created by Meenakshi on 11/08/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "HomeViewController.h"
#import "CreatorLocationViewController.h"
#import "AddPaypalInfoViewController.h"

@interface AddPaypalInfoViewController ()

@end

@implementation AddPaypalInfoViewController

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
	
	if (!self.showLocationScreen)
		[super addBackButton];
	
	[_paypalEmailField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Button Action

- (IBAction) submitPayPalId:(id)sender
{
	NSString* email = [_paypalEmailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if (email.length > 0)
	{
		BOOL validationResult = [UIUtils validateEmail:email];
		if (validationResult)
			[self sendRequestToAddPaypalEmail:email];
		else
			[UIUtils messageAlert:@"Please enter valid email." title:nil delegate:nil];
	}
	else
	{
		[UIUtils messageAlert:@"Please enter paypal email." title:nil delegate:nil];
	}
}

#pragma mark-
#pragma mark TextField delegate methods-

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
	NSUInteger maxLength = kEmailMaxLength;
	
	NSUInteger oldLength = [textField.text length];
	NSUInteger replacementLength = [string length];
	NSUInteger rangeLength = range.length;
	
	NSUInteger newLength = oldLength - rangeLength + replacementLength;
	
	BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
	
	return newLength <= maxLength || returnKey;
}

#pragma mark-
#pragma mark-

- (void) sendRequestToAddPaypalEmail:(NSString*)email
{
	[_gAppDelegate showLoadingView:YES];
	
	NSString* postString = [NSString stringWithFormat:@"token=%@&paypal_email=%@", _gAppPrefData.sessionToken, email];
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kAddPaypalEmailService
														   postString:postString];
	[WebServiceManager sendRequest:request
						completion:^ (NSData* responseData, NSError* error)
	 {
		 [_gAppDelegate showLoadingView:NO];
		 
		 if (error)
		 {
			 if (![error.domain caseInsensitiveCompare:@"NSPOSIXErrorDomain"]==NSOrderedSame)
				 [UIUtils messageAlert:kNetworkErrorMessage title:kNetworkError delegate:nil];
		 }
		 else
		 {
			 _Assert(responseData);
			 
			 DataManager* dataManager = _gDataManager;
			 NSDictionary* response = [dataManager getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [dataManager checkResponseStatus:response];
			 
			 if (status)
			 {
				 _gDataManager.userInfo.hasPaymentId = YES;
				 
				 if (self.showLocationScreen)
					 [self displayCreatorLocationScreen];
				 else
					 [self.navigationController popViewControllerAnimated:YES];
					 
			 }
			 else
			 {
				 NSString* message = [response objectForKey:@"err_message"];
				 [UIUtils messageAlert:message title:nil delegate:nil];
			 }
		 }
	 }];
}

- (void) displayCreatorLocationScreen
{
	if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) )
	{
		HomeViewController* viewCtrl = [[HomeViewController alloc] initWithNibName:kHomeViewNib bundle:nil];
		[_gAppDelegate initializeApplication:viewCtrl];
	}
	else
	{
		CreatorLocationViewController* viewCtrl = [[CreatorLocationViewController alloc] initWithNibName:kCreatorLocationViewNib bundle:nil];
		[self.navigationController pushViewController:viewCtrl animated:YES];
	}
}

@end
