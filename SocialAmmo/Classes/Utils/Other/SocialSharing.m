//
//  SocialSharing.m
//  Social Ammo
//
//  Created by Rupesh Kumar on 5/5/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "SocialSharing.h"
#import "BriefContentInfo.h"
#import <Social/Social.h>
#import <Pinterest/Pinterest.h>
#import "GTMOAuth2Authentication.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTMOAuth2SignIn.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SCAFacebookSession.h"
#import "AppPrefData.h"
#import "FacebookPageDetail.h"
//#import "SelectFacebookPageViewController.h"

@implementation SocialSharing

- (id)initWithInfo:(NSDictionary*)dictionary andController:(UIViewController*)topController
{
    self = [super init];
    if (self)
	{
		self.thumbimageURl = [dictionary objectForKey:@"ThumbImageURl"];
		self.fullImageUrl = [dictionary objectForKey:@"FullImageURL"];
		self.sharedImage = [dictionary objectForKey:@"SharedImage"];
		self.userName = [dictionary objectForKey:@"UserName"];
		self.detailsTxt =  [dictionary objectForKey:@"Detail"];
		self.topController = topController;
    }
    return self;
}

- (void) shareOnFacebook
{
//	UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
//											 [NSURL URLWithString:self.thumbimageURl]]];
	UIImage* image = self.sharedImage;

	if(image == nil)
	{
		[UIUtils messageAlert:kWaitSaveMessage title:@"" delegate:nil];
		return;
	}
	
    SLComposeViewController* shareViewController = [SLComposeViewController
													composeViewControllerForServiceType:
													SLServiceTypeFacebook];
    [shareViewController setInitialText:[NSString stringWithFormat:kCaptionMessage,
										 [UIUtils checknilAndWhiteSpaceinString:self.userName]]];
	[shareViewController addImage:image];
	
    if ([SLComposeViewController isAvailableForServiceType:shareViewController.serviceType])
    {
        [self.topController presentViewController:shareViewController
                           animated:YES
                         completion: nil];
    }
    else
    {
        UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle: @"Settings Error"
                                                             message: kFaceBookErrorMessage
                                                            delegate: nil
                                                   cancelButtonTitle: @"Ok"
                                                   otherButtonTitles: nil];
        [errorAlert show];
    }
//	if (_gAppPrefData.fbToken.length > 0)
//	{
//		[self sendRequestToGetFacebookPage];
//	}
//	else
//	{
//		[SCAFacebookSession closeSession];
//		NSArray *permissions =  [NSArray arrayWithObjects:@"publish_stream", @"manage_pages",
//								 nil];
//		[SCAFacebookSession openSessionWithPermissions:permissions block:^(id result, NSError *error) {
//			
//			if (error)
//			{
//				(error.code == 2)? NSLog(@"Error duriong facebook"):[UIUtils messageAlert:
//																	 error.description title:nil
//																				 delegate:nil];
//			}
//			else
//			{
//				[self sendRequestToGetFacebookPage];
//			}
//		}];
//	}
}

- (void) sendRequestToGetFacebookPage
{
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:_gAppPrefData.fbToken,
						  @"access_token", nil];
	
	if ([UIUtils isConnectedToNetwork] == NO)
	{
		[UIUtils messageAlert:kNetworkErrorMessage title:@"" delegate:nil];
		return;
	}
	
	[_gAppDelegate showLoadingView:YES];
	
	[FBRequestConnection startWithGraphPath:@"/me/accounts"
								 parameters:dict
								 HTTPMethod:@"GET"
						  completionHandler:^(
											  FBRequestConnection *connection,
											  id result,
											  NSError *error
											  ) {
							  [_gAppDelegate showLoadingView:NO];
							  if (!error)
							  {
								  /* handle the result */
								  NSArray* pageList = [result objectForKey:@"data"];
								  if (pageList.count > 0)
									  [self parseFacebooKPage:pageList];
								  else
									  [UIUtils messageAlert:@"No facebook page found."
													  title:@"" delegate:nil];
							  }
						  }];
}

- (void) parseFacebooKPage:(NSArray*)pageList
{
	NSMutableArray* facebooKPageList = [[NSMutableArray alloc] initWithCapacity:pageList.count];
	for (NSDictionary* dict in pageList)
	{
		FacebookPageDetail* fbPage = [[FacebookPageDetail alloc] initWithInfo:dict];
		[facebooKPageList addObject:fbPage];
	}
	
	[self gotoPageSelctScreen:facebooKPageList];
}

- (void) gotoPageSelctScreen:(NSArray*) pageList
{
//	NSString* message = [NSString stringWithFormat:kCaptionMessage,
//						 [UIUtils checknilAndWhiteSpaceinString:self.userName]];
//	
//	SelectFacebookPageViewController* fbPageSelectVC = [[SelectFacebookPageViewController alloc]
//														initWithNibName:kSelectFacebookPageNib bundle:nil];
//	fbPageSelectVC.facebookPageList = pageList;
//	fbPageSelectVC.sharedImage = self.sharedImage;
//	fbPageSelectVC.sharedMessage =  message;
//	
//	UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:
//									 fbPageSelectVC];
//	
//	[self.topController presentViewController:navVC animated:YES completion:NULL];
//	[_gAppDelegate showTopBar:NO];
}

- (void) shareOnTwitter
{
	UIImage* image = self.sharedImage;
	if(image == nil)
	{
		[UIUtils messageAlert:kWaitSaveMessage title:@"" delegate:nil];
		return;
	}
	
    SLComposeViewController* shareViewController = [SLComposeViewController
													composeViewControllerForServiceType:
													SLServiceTypeTwitter];
    [shareViewController setInitialText:[NSString stringWithFormat:kCaptionMessage,
										 [UIUtils checknilAndWhiteSpaceinString:self.userName]]];
	[shareViewController addImage:image];
	
    if ([SLComposeViewController isAvailableForServiceType:shareViewController.serviceType])
    {
        [self.topController presentViewController:shareViewController
                           animated:YES
                         completion: nil];
    }
    else
    {
        UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle: @"Settings Error"
                                                             message: kTwitterErrorMessage
                                                            delegate: nil
                                                   cancelButtonTitle: @"Ok"
                                                   otherButtonTitles: nil];
        [errorAlert show];
    }
}

- (void) shareOnLinkdIn
{
	GTMOAuth2Authentication * auth = [self authForLinkedin];
	auth.scope = @"rw_nus";
	NSString* auth_string = @"https://www.linkedin.com/uas/oauth2/authorization";
	NSURL * authURL = [NSURL URLWithString:auth_string];
	
	// Display the authentication view
	GTMOAuth2ViewControllerTouch * outhVC;
	outhVC = [[GTMOAuth2ViewControllerTouch alloc] initWithAuthentication:auth
																 authorizationURL:authURL
																 keychainItemName:@"The Social Ammo"
																		 delegate:self
																 finishedSelector:
					  @selector(outhVC: finishedWithAuth: error:)];
	
	NSDictionary* additionalParamater = [[NSDictionary alloc] initWithObjectsAndKeys
										 :kLinkeDinStates,@"state", nil];
	outhVC.signIn.additionalAuthorizationParameters = additionalParamater;
	
//	AppDelegate* appdelegate = _gAppDelegate;
//	[appdelegate showTopBar:NO];
	self.topController.navigationController.navigationBarHidden = NO;
	[self.topController.navigationController pushViewController:outhVC animated:YES];
}

/*
- (void) shareOnInstagram
{
	NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
	
	if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
	{
		NSURL* url = [NSURL URLWithString:self.fullImageUrl];
		UIImage* sharedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
		if (sharedImage)
		{
			NSData* imageData = UIImagePNGRepresentation(sharedImage);
			NSString* imagePath = [UIUtils documentDirectoryWithSubpath:@"image.igo"];
			[imageData writeToFile:imagePath atomically:NO];
			NSURL* fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"file://%@",
													 imagePath]];
			NSString* captionStr = [NSString stringWithFormat:kCaptionMessage,
									[UIUtils checknilAndWhiteSpaceinString:self.userName]];
			
			self.docController = [self setupControllerWithURL:fileURL usingDelegate:self];
			self.docController.annotation = [NSDictionary dictionaryWithObject:captionStr
																		   forKey:@"InstagramCaption"];
			self.docController.UTI = @"com.instagram.photo";
			[self.docController  presentOpenInMenuFromRect:self.topController.view.frame inView:
			 self.topController.view animated:YES];
		}
		else
			[UIUtils messageAlert:kWaitSaveMessage title:@"" delegate:nil];
	}
	else
		[UIUtils messageAlert:kInstagramErrormessage title:@"" delegate:nil];
}
 */

- (void) shareOnPinInterest
{
	NSString* captionStr = [NSString stringWithFormat:kCaptionMessage,
							[UIUtils checknilAndWhiteSpaceinString:self.userName]];
	
	Pinterest* pinInterest = [[Pinterest alloc] initWithClientId:kPinInterestClientID];
	
	if ([pinInterest canPinWithSDK])
	{
		[pinInterest createPinWithImageURL:[NSURL URLWithString:self.fullImageUrl]
								 sourceURL:nil description:captionStr];
	}
	else
	{
		[UIUtils messageAlert:kPininterestErrormessage title:@"" delegate:nil];
	}
}

/*
 #pragma mark-
#pragma mark UIDocumentInteractionController delegate

- (UIDocumentInteractionController *) setupControllerWithURL:(NSURL*)fileURL
                                               usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate
{
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController
															  interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}
*/

#pragma  mark --
#pragma  mark -- linkdIn interaction

- (void)outhVC:(GTMOAuth2ViewControllerTouch * )viewController
	  finishedWithAuth:(GTMOAuth2Authentication * )auth
				 error:(NSError * )error
{
	[viewController.navigationController popToViewController:self.topController animated:YES];
	
	AppDelegate* appdelegate = _gAppDelegate;
//	[appdelegate showTopBar:YES];
	self.topController.navigationController.navigationBarHidden = YES;

	if (error != nil)
	{
		if([error code] != -1000)
			[UIUtils messageAlert:[error localizedDescription] title:@"Error Authorizing with Linkedin"
					 delegate:nil];
	}
	else
	{
		self.tokenStr = [auth accessToken];
		
		NSMutableDictionary* postData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
										 @"Social Ammo Updates",@"comment", nil];
		NSMutableDictionary* content = [[NSMutableDictionary alloc] init];
		
		// Set data detail to post
		NSString* initialMesgae = [NSString stringWithFormat:kCaptionMessage,
								   [UIUtils checknilAndWhiteSpaceinString:self.userName]];
		
		NSString* imeURl = [UIUtils checknilAndWhiteSpaceinString:self.fullImageUrl];
		if (imeURl.length < 1)
			imeURl = [UIUtils checknilAndWhiteSpaceinString:self.thumbimageURl];
		
		[content setObject:initialMesgae forKey:@"title"];
		[content setObject:imeURl forKey:@"submitted-image-url"];
		[content setObject:@"http://www.socialammo.com/" forKey:@"submitted-url"];
		
		// Set permisions and other visibilty setting to linkdin
		[postData setObject:content forKey:@"content"];
		NSDictionary* visiblity = [[NSDictionary alloc] initWithObjectsAndKeys:@"anyone", @"code", nil];
		[postData setObject:visiblity forKey:@"visibility"];
		[appdelegate showLoadingView:YES];
		[appdelegate setLoadingViewTitle:@"Sharing..."];

		// sending request to post
		NSMutableURLRequest* request = [self makeRequest:postData];
		[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
							   completionHandler:^(NSURLResponse *response, NSData *data,
												   NSError *connectionError)
		{
			if(connectionError != nil)
				[UIUtils messageAlert:connectionError.description title:@"" delegate:nil];
//			else
//				[UIUtils messageAlert:@"Shared succesfully" title:@"" delegate:nil];

			NSLog(@"Data : %@ ",[[NSString alloc] initWithData:data encoding:
														NSUTF8StringEncoding]);
			NSLog(@"Error : %@ ",connectionError);
			[appdelegate showLoadingView:NO];
			[appdelegate setLoadingViewTitle:@"Loading..."];
		}];
	}
	
}


#pragma  mark -- 
#pragma mark  -- Authorigation for likndin

- (GTMOAuth2Authentication * ) authForLinkedin
{
	//This URL is defined by the individual 3rd party APIs, be sure to read their documentation
	NSString * url_string = @"https://www.linkedin.com/uas/oauth2/accessToken";
	
	NSURL * tokenURL = [NSURL URLWithString:url_string];
	// We'll make up an arbitrary redirectURI.  The controller will watch for
	// the server to redirect the web view to this URI, but this URI will not be
	// loaded, so it need not be for any actual web page. This needs to match the URI set as the
	// redirect URI when configuring the app with Instagram.
	NSString * redirectURI = kLinkedInRedirectURL;
	GTMOAuth2Authentication * auth;
	auth = [GTMOAuth2Authentication authenticationWithServiceProvider:@"The Social Ammo"
															 tokenURL:tokenURL
														  redirectURI:redirectURI
															 clientID:kLinkedInClientID
														 clientSecret:kLinkedInSecretAppKey];
	auth.scope = @"rw_nus";
	return auth;
}

- (NSMutableURLRequest*) makeRequest:(NSDictionary*) post
{
	NSString* theTempURL = [NSString stringWithFormat:
							@"https://api.linkedin.com/v1/people/~/shares?oauth2_access_token=%@",
							self.tokenStr];
	NSURL* url = [NSURL URLWithString:theTempURL];
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	NSError *error;
	NSData* jsonData = [NSJSONSerialization dataWithJSONObject:post options:
						NSJSONWritingPrettyPrinted error:&error];
	if (error)
		NSLog(@"%@",error.description);
	
	[request setHTTPBody:jsonData];
	return request;
}

@end
