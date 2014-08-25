//
//  CreatorViewController.m
//  SocialAmmo
//
//  Created by Rupesh Kumar on 7/11/14.
//  Copyright (c) 2014 //  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "CreatorCanvasViewController.h"
#import "CreatorToolViewController.h"
#import "CreatorHubViewController.h"

@interface CreatorHubViewController () <CreatorToolViewDelegate>
{
	CreatorToolViewController*	_creatorToolViewC;
	
	PackInfo*	_purchasePackInfo;
}

@end

@implementation CreatorHubViewController

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
	
	// Add Revel view Controller
	if(!_gDataManager.createContentForSubmission)
	{
		UIButton* barButton = [UIUtils getRevelButtonItem:self];
		UIBarButtonItem* revealbuttonItem =[[UIBarButtonItem alloc] initWithCustomView:barButton];
		self.navigationItem.leftBarButtonItem = revealbuttonItem;
	}
	else
		[super addBackButton];
	
	self.title = @"Content Creator Hub";
	
	_creatorLabel.text = [NSString stringWithFormat:@"%@'s Creator Canvas", _gDataManager.userInfo.firstname];
	
	NSLog(@"%lu",(unsigned long)_gDataManager.userInfo.packIdArray.count);
//	_createCanvasButton.enabled = (_gDataManager.userInfo.packIdArray.count > 0) ? YES : NO;
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationController.navigationBarHidden = NO;

	[self sendRequestToGetPacksFromMarketplace];
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

#pragma mark-

- (IBAction) creatorCanvasButtonAction:(id)sender
{
	[self displayCreatorCanvasScreen: nil];
}

- (IBAction) ammoCoinBtnAction:(id)sender
{
	[self sendRequestToPurchasePack:_purchasePackInfo];
	//[UIUtils messageAlert:@"Work in Progress" title:nil delegate:nil];
}

- (IBAction) paymentBtnAction:(id)sender
{
	[self sendRequestToPurchasePack:_purchasePackInfo];
	
	//[UIUtils messageAlert:@"Work in Progress" title:nil delegate:nil];
}

- (IBAction) cancelPaymentBtnAction:(id)sender
{
	[self hidePaymentSheet];
}


#pragma mark-

- (void)sendRequestToGetPacksFromMarketplace
{
	[_gDataManager sendRequestToGetPacksFromMarketplaceWithCompletion:^(BOOL status, NSString* message, ERequestType requestType)
	 {
		 if (status)
			 [self setUpCreatorTool];
		 else
			 [UIUtils messageAlert:message title:nil delegate:nil];
	 }];
}

- (void) setUpCreatorTool
{
	[self cleanCreatorTool];
	
	if (_creatorToolViewC == nil)
		_creatorToolViewC = [[CreatorToolViewController alloc] initWithNibName:kCreatorToolViewNib
																		bundle:nil];
	_creatorToolViewC.observer = self;
	CGRect rect = _creatorToolViewC.view.frame;
	rect.size.height = (kIPhone5) ? 320 : 230.0;
	rect.origin.y = [[UIScreen mainScreen] bounds].size.height - rect.size.height;

	_creatorToolViewC.view.frame = rect;
		
	[self.view addSubview:_creatorToolViewC.view];
}

- (void) cleanCreatorTool
{
	for (UIView* view in _creatorToolViewC.view.subviews)
	{
		[view removeFromSuperview];
	}
	
	_creatorToolViewC = nil;
}

#pragma mark- CreatorToolViewDelegate methods

- (void) displayCanvasForPack:(PackInfo*)pack
{
//	if ([self checkPackAddedInCanvas:pack])
	[self displayCreatorCanvasScreen:pack];
//	else
//		[self sendRequestToAddPack:pack];
	
//	[UIUtils messageAlert:@"Work in progres" title:nil delegate:nil];
//	[self sendRequestToFetchCanvasList:pack];
}

- (void) displayPurchaseSheetForPack:(PackInfo*)pack
{
	_purchasePackInfo = pack;
	
	[self showPaymentSheet];
}

- (void) installFreePack:(PackInfo*)pack;
{
	[self sendRequestToPurchasePack:pack];
}

#pragma mark-

- (BOOL) checkPackAddedInCanvas:(PackInfo*)pack
{
	for (NSString* packId in _gDataManager.userInfo.packIdArray)
	{
		if (pack.packId == [packId integerValue])
			return YES;
	}
	return NO;
}

#pragma mark- PaymentSheet method

- (void) showPaymentSheet
{
	_paymentActionView.hidden = NO;
	
	_paymentActionView.frame = self.view.frame;
	
	_paymentBackgroundView.backgroundColor = kBlueColor;
	_paymentBackgroundView.layer.cornerRadius = 4.0;
	
	_paymentActionView.alpha = 1.0;
	[self.view.window addSubview:_paymentActionView];
}

- (void) hidePaymentSheet
{
	_paymentActionView.hidden = YES;
	
	[UIView beginAnimations:@"hideAlert" context:nil];
	[UIView setAnimationDelegate:self];
	//	_paymentActionView.transform = CGAffineTransformMakeScale(0.1, 0.1);
	_paymentActionView.alpha = 0;
	[UIView commitAnimations];
	[_paymentActionView removeFromSuperview];
}

- (void) sendRequestToPurchasePack:(PackInfo*)pack
{
	[_gAppDelegate showLoadingView:YES];
	
	NSString* postString = [NSString stringWithFormat:@"token=%@&package_id=%lu", _gAppPrefData.sessionToken, (unsigned long)pack.packId];
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kPurchasePackService
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
				 [self hidePaymentSheet];
				 
				 [self sendRequestToAddPack:pack];
				 
				 _purchasePackInfo = nil;
				 pack.purchase = YES;
				 [_creatorToolViewC updateToolWithPackInfo:pack];
			 }
			 else
			 {
				 NSString* message = [response objectForKey:@"err_message"];
				 [UIUtils messageAlert:message title:nil delegate:nil];
			 }
		 }
	 }];
}

#pragma mark-

- (void) displayCreatorCanvasScreen:(PackInfo*)info
{
	CreatorCanvasViewController* viewCtrl = [[CreatorCanvasViewController alloc] initWithNibName:kCreatorCanvasViewNib bundle:nil];
	if (info != nil)
		viewCtrl.selectedPackId = info.packId;
	viewCtrl.logoURL = self.submissionInfo.profilePicUrl;
	[self.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark-

- (void) sendRequestToAddPack:(PackInfo*)pack
{
	[_gAppDelegate showLoadingView:YES];
	
	NSString* postString = [NSString stringWithFormat:@"token=%@&package_id=%lu", _gAppPrefData.sessionToken, (unsigned long)pack.packId];
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kAddPackToCanvasService
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
//				 [self displayCreatorCanvasScreen];

//				 _createCanvasButton.enabled = YES;
				 [_gDataManager.userInfo parsePacks:response];
			 }
			 else
			 {
				 NSString* message = [response objectForKey:@"err_message"];
				 [UIUtils messageAlert:message title:nil delegate:nil];
			 }
		 }
	 }];
}

@end
