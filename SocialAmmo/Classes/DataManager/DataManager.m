//
//  DataManager.m
//  Social Ammo
//
//  Created by Meenakshi on 20/01/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "NSData+Base64.h"
#import "PackInfo.h"
#import "CanvasInfo.h"
#import "PrivateMessageInfo.h"
#import "SearchUserInfo.h"
#import "ContentInfo.h"
#import "BusinessInfo.h"
#import "AppPrefData.h"
#import "InterestInfo.h"
#import "MessageInfo.h"
#import "BriefContentInfo.h"
#import "DataManager.h"

static DataManager* gDataMgr = nil;

@implementation DataManager

+ (DataManager*) sharedObject
{
	if (!gDataMgr)
	{
		gDataMgr = [[DataManager alloc] init];
	}
	return gDataMgr;
}

- (id) init
{
	if(self = [super init])
	{
		self.deviceToken = (_gAppPrefData.deviceToken.length > 0)? _gAppPrefData.deviceToken: @"";
		NSMutableArray* facebookDataArray = [[NSMutableArray alloc] initWithArray:kFaceBookSignUpArray];
		self.facebookSignUpArray = facebookDataArray;
		
		_webserviceM = [[WebServiceManager alloc] init];
		_webserviceM.delegate = self;
	}
	return self;
}

- (void) dealloc
{
	_webserviceM = nil;
}

#pragma mark-

-(NSDictionary*) getResponseFromData:(NSData*)data
{
	NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

	DLog(@"%@",str);
	NSDictionary* dict = (NSDictionary*)[UIUtils jsonFromData:data];
	DLog(@"%@",dict);
	NSDictionary* response = [dict objectForKey:@"response"];
	return response;
}

- (BOOL) checkResponseStatus:(NSDictionary*)dict
{
	return [[dict objectForKey:@"status"] boolValue];
}

- (void) callCompletionBlock:(NSDictionary*)dict withStatus:(BOOL)status
				 requestType:(ERequestType)requesType
{
	NSString* errorMessage = nil;

	if (!status)
		errorMessage = [dict objectForKey:@"err_message"];

	if (self.completion)
		self.completion(status, errorMessage, requesType);
}

- (void) callHomeDataCompletionBlock:(NSDictionary*)dict withStatus:(BOOL)status
				 requestType:(ERequestType)requesType
{
	NSString* errorMessage = nil;
	
	if (!status)
		errorMessage = [dict objectForKey:@"err_message"];
	
	if (self.homePageDataComplition)
		self.homePageDataComplition(status, errorMessage, requesType);
}

#pragma mark-

- (void) sendRequestForQuickInterestWithCompletion:(DataManagerCompletionBlock)completion
{
    [_gAppDelegate showLoadingView:YES];

	self.completion = completion;

	__block ERequestType requestType = ERequestTypeGetQuickInterest;

	NSURLRequest* request = [WebServiceManager requestWithService:kGetQuickInterestListService];
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
			NSDictionary* response = [self getResponseFromData:responseData];
			_Assert(response);

			BOOL status = [self checkResponseStatus:response];
			if (status)
			{
				NSArray* array = [response objectForKey:@"interests"];
				NSMutableArray* quickInterestArray = [[NSMutableArray alloc]
													  initWithCapacity:array.count];
				for (int i = 0; i < array.count; ++i)
				{
					InterestInfo* info = [[InterestInfo alloc]
										  initWithInterestInfo:[array objectAtIndex:i]];
					[quickInterestArray addObject:info];
				}
				self.interestList = [[NSArray alloc]initWithArray:quickInterestArray];
			}

			[self callCompletionBlock:response withStatus:status requestType:requestType];
		}

	}];
}

- (void) sendRequestForBusinessWithCompletion:(DataManagerCompletionBlock)completion
{
    [_gAppDelegate showLoadingView:YES];

	self.completion = completion;

	__block ERequestType requestType = ERequestTypeGetBusiness;

	NSURLRequest* request = [WebServiceManager requestWithService:kGetBusinessService];
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
			NSDictionary* response = [self getResponseFromData:responseData];
			_Assert(response);
			BOOL status = [self checkResponseStatus:response];
			if (status)
			{
				NSArray* array = [response objectForKey:@"industries"];
				NSMutableArray* industryArray = [[NSMutableArray alloc] initWithCapacity:array.count];
				for (int i = 0; i < array.count; ++i)
				{
					BusinessInfo* info = [[BusinessInfo alloc] initWithInfo:[array objectAtIndex:i]];
					[industryArray addObject:info];
				}
				self.businessList = [[NSArray alloc]initWithArray:industryArray];
			}
			[self callCompletionBlock:response withStatus:status requestType:requestType];
		}

	}];
}

#pragma mark-

- (void) sendRequestToGetUserInfoWithCompletion:(DataManagerCompletionBlock)completion
{
    [_gAppDelegate showLoadingView:YES];
	
	self.completion = completion;
	
	NSString* postString = [NSString stringWithFormat:@"token=%@", _gAppPrefData.sessionToken];
	__block ERequestType requestType = ERequestTypeGetUserInfo;
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kGetUserInfo
														   postString:postString];
	[WebServiceManager sendRequest:request
						completion:^ (NSData* responseData, NSError* error)
	 {
		 [_gAppDelegate showLoadingView:NO];
		 
		 if (error)
		 {
			 NSDictionary* dict = nil;
			 if (![error.domain caseInsensitiveCompare:@"NSPOSIXErrorDomain"] == NSOrderedSame)
			 {
				 dict = [NSDictionary dictionaryWithObjectsAndKeys:kNetworkErrorMessage,
									   @"err_message", nil];
			 }
			 
			 [self callCompletionBlock:dict withStatus:NO requestType:requestType];
		 }
		 else
		 {
			 _Assert(responseData);
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];
			 if (status)
			 {
				 NSDictionary* userData = [response objectForKey:@"userdata"];
				 [self parseUserInfoWithoutToken:userData];
			 }
			 [self callCompletionBlock:response withStatus:status requestType:requestType];
		 }
	 }];
}

- (void) sendRequestForLogin:(NSString*)username password:(NSString*)password
			  withCompletion:(DataManagerCompletionBlock)completion
{
    [_gAppDelegate showLoadingView:YES];

	self.completion = completion;

	NSString* deviceToken = self.deviceToken;
	NSString* postString = [NSString stringWithFormat:
							@"username=%@&password=%@&device_token=%@&device_type=%@",username,
							password, deviceToken, kDeviceTypeIphone];

	__block ERequestType requestType = ERequestTypeLogin;

	NSURLRequest* request = [WebServiceManager postRequestWithService:kLoginService
														   postString:postString];
	[WebServiceManager sendRequest:request
						completion:^ (NSData* responseData, NSError* error)
	{
        [_gAppDelegate showLoadingView:NO];

		if (error)
		{
			if (![error.domain caseInsensitiveCompare:@"NSPOSIXErrorDomain"]==NSOrderedSame)
			{
				NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:kNetworkErrorMessage,
									  @"err_message", nil];
				[self callCompletionBlock:dict withStatus:NO requestType:requestType];
			}
		}
		else
		{
			_Assert(responseData);
			NSDictionary* response = [self getResponseFromData:responseData];
			_Assert(response);

			BOOL status = [self checkResponseStatus:response];
			if (status)
			{
				NSDictionary* userData = [response objectForKey:@"userdata"];
				[self parseUserInfo:userData];
			}
			[self callCompletionBlock:response withStatus:status requestType:requestType];
		}

	}];
}

- (void) sendRequestToAddLocation:(CLLocationCoordinate2D)coordinate withCompletion:(DataManagerCompletionBlock)completion
{
	self.completion = completion;
	
//	NSString* deviceToken = self.deviceToken;
	NSString* postString = [NSString stringWithFormat:
							@"token=%@&latitude=%f&longitude=%f",
							_gAppPrefData.sessionToken, coordinate.latitude, coordinate.longitude];
	
	__block ERequestType requestType = ERequestTypeLogin;
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kAddLocationService
														   postString:postString];
	[WebServiceManager sendRequest:request
						completion:^ (NSData* responseData, NSError* error)
	 {
		
		 [_gAppDelegate showLoadingView:NO];

		 if (error)
		 {
			 if (![error.domain caseInsensitiveCompare:@"NSPOSIXErrorDomain"]==NSOrderedSame)
			 {
				 NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:kNetworkErrorMessage,
									   @"err_message", nil];
				 [self callCompletionBlock:dict withStatus:NO requestType:requestType];
			 }
		 }
		 else
		 {
			 _Assert(responseData);
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];
			 if (status)
			 {
				 self.userInfo.userLocation = coordinate;
				 self.userInfo.locationEnabled = YES;
			 }
			 
			 [self callCompletionBlock:response withStatus:status requestType:requestType];
		 }
		 
	 }];
}


- (void) parseUserInfoWithoutToken:(NSDictionary*)info
{
	_Assert(info);
	self.userInfo = [[UserInfo alloc] initWithInfo:info];
}

- (void) parseUserInfo:(NSDictionary*)info
{
	_Assert(info);
	self.userInfo = [[UserInfo alloc] initWithInfo:info];
	_gAppPrefData.sessionToken = [info objectForKey:@"token"];
	[_gAppPrefData saveAllData];
}

- (void) sendRequestForSignUp:(UserInfo*)userInfo withCompletion:
(SignUpCompletionBlock)signUpCompletion;
{
    [_gAppDelegate showLoadingView:YES];

	self.signUpCompletion = signUpCompletion;
	
	/* Stop old Sign Up service
	NSString* postString = [self createPostStringForSignUp:userInfo];
	 */
	
	NSString* postString = [self createPostStringForNewSignUp:userInfo];

	__block ERequestType requestType = ERequestTypeLogin;

	NSURLRequest* request = [WebServiceManager postRequestWithService:kSignUpService
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
			self.userInfo = userInfo;

			_Assert(responseData);
			NSDictionary* response = [self getResponseFromData:responseData];
			_Assert(response);

			BOOL status = [self checkResponseStatus:response];
			NSString* message = nil;
			NSString* errorType = @"";
			if (status)
			{
				message = [response objectForKey:@"message"];
				NSDictionary* userData = [response objectForKey:@"userdata"];
				[self parseUserInfo:userData];
			}
			else
			{
				message = [response objectForKey:@"err_message"];
				errorType = [response objectForKey:@"err_type"];
			}

			if (self.signUpCompletion)
				self.signUpCompletion(status, message,errorType,requestType);
		}

	}];
}

- (void) sendRequestForTermsAndConditionswithCompletion:(DataManagerCompletionBlock)completion
{
    [_gAppDelegate showLoadingView:YES];

	self.completion = completion;

	__block ERequestType requestType = ERequestTypeGetTermsAndCondition;

	NSURLRequest* request = [WebServiceManager requestWithService:kGetTermsAndConditionService];
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
			NSDictionary* response = [self getResponseFromData:responseData];
			_Assert(response);

			BOOL status = [self checkResponseStatus:response];
			NSString* message = nil;
			if (status)
				message = [response objectForKey:@"message"];
			else
				message = [response objectForKey:@"err_message"];

			if (self.completion)
				self.completion(status, message, requestType);
		}
	} ];
}

- (NSString*) createPostStringForNewSignUp:(UserInfo*)userInfo
{
	NSString* deviceToken = self.deviceToken;
	
	NSUInteger businessId = userInfo.businessInfo.businessId;
	
	NSString* profileImageString = [self getImageStringFromImage:userInfo.profileImage];
	
	NSString* postString = nil;
	if (userInfo.userType == EUserTypeBuisness)
	{
		postString = [NSString stringWithFormat:@"user_type=%d&name=%@&industry_id=%lu&",
					  userInfo.userType, userInfo.businessName, (unsigned long)businessId];
	}
	else
	{
		postString = [NSString stringWithFormat:@"user_type=%d&first_name=%@&last_name=%@&",
					  userInfo.userType,userInfo.firstname, userInfo.lastname];
	}
	
	NSString* postStringPart2 = [NSString stringWithFormat:
								 @"age=%@&device_token=%@&device_type=%@&email=%@&password=%@&profile_pic=%@",userInfo.userDOB,deviceToken,kDeviceTypeIphone, userInfo.email,userInfo.password,profileImageString];
	
	postString = [postString stringByAppendingString:postStringPart2];
	
	return postString;
}

- (NSString*) createPostStringForSocialMedia:(EUserSocialMediaType)socialMediaType signUp:(UserInfo*)userInfo
{
	NSString* deviceToken = self.deviceToken;
	NSUInteger businessId = userInfo.businessInfo.businessId;
	NSString* profileImageString = [self getImageStringFromImage:userInfo.profileImage];
	
	if (profileImageString.length < 1)
		profileImageString = userInfo.profilePicURL;
	
	NSString* postString = nil;
	if (socialMediaType == EUserSocialMediaTypeLinkedIn)
	{
		postString = [NSString stringWithFormat:@"user_type=%d&name=%@&industry_id=%lu&linkedin_token=%@&",
					  userInfo.userType, userInfo.businessName, (unsigned long)businessId, _gAppPrefData.linkedInToken];
	}
	else
	{
		postString = [NSString stringWithFormat:@"user_type=%d&first_name=%@&last_name=%@&age=%@&fb_token=%@&",
					  userInfo.userType,userInfo.firstname, userInfo.lastname, userInfo.userDOB,_gAppPrefData.fbToken];
	}
	
	NSString* postStringPart2 = [NSString stringWithFormat:
								 @"device_token=%@&device_type=%@&email=%@&profile_pic=%@",deviceToken,kDeviceTypeIphone, userInfo.email, profileImageString];
	
	postString = [postString stringByAppendingString:postStringPart2];
	
	return postString;
}

- (NSString*) getImageStringFromImage:(UIImage*)image
{
	NSString* imageString = @"";
	if (image == nil)
		return imageString;

	NSData* imageData = UIImageJPEGRepresentation(image ,1.0);
	
	if (imageData != nil)
	{
		imageString = [imageData base64EncodedString];
		NSString* imageHeaderInfo = @"image/jpg;base64,";
		imageString = [imageHeaderInfo stringByAppendingString:imageString];
	}

	return imageString;
}

#pragma mark- SaveBrief

- (NSString*) createPostRequestToSaveBrief:(BriefInfo*)info
{
	// converting the multiple location with single '||' seprated string
	NSString* locations = [info.locationArray componentsJoinedByString:@"||"];

	// converting the multiple location with single ';;' seprated string
	NSString* interest = [info.interestArray componentsJoinedByString:@";;"];
	NSTimeInterval startTimeInterval = [info.startDate timeIntervalSince1970];
	NSTimeInterval endTimeInterval = [info.endDate timeIntervalSince1970];

	NSString* logoImageString = [self getImageStringFromImage:info.logoImage];

	NSString* postString = [NSString stringWithFormat:
							@"token=%@&brief_id=%lu&title=%@&info=%@&date_from=%d&date_to=%d&locations=%@&interests=%@&font=%@&logo=%@",
							_gAppPrefData.sessionToken, (unsigned long)info.briefId, info.briefTitle, info.description,
							(int)startTimeInterval,(int)endTimeInterval,
							locations, interest,[UIUtils checknilAndWhiteSpaceinString:info.fontName], logoImageString];
	
	return  postString;
}

- (void) sendRequestToSaveBrief:(BriefInfo*)briefInfo
{
	self.createBriefInfo = briefInfo;
	
	BOOL isImageAttached = (briefInfo.logoImage == nil)? NO:YES;
	
	NSString* postString = [self createPostRequestToSaveBrief:briefInfo];
	DLog(@"%@",postString);
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kSaveBriefService
														   postString:postString];
	[_webserviceM sendrequest:request requesttype:ERequestTypeSaveBrief withProgress:isImageAttached];
}

- (void) sendRequestToSaveBrief:(BriefInfo*)briefInfo withCompletion:(DataManagerCompletionBlock)completion failure:(DataManagerFailureBlock)failureBlock
{
	self.createBriefInfo = briefInfo;
	
   [_gAppDelegate showLoadingView:YES];

	self.completion = completion;
	NSString* postString = [self createPostRequestToSaveBrief:briefInfo];
	DLog(@"%@",postString);

	__block ERequestType requestType = ERequestTypeSaveBrief;

	NSURLRequest* request = [WebServiceManager postRequestWithService:kSaveBriefService
														   postString:postString];
	[WebServiceManager sendRequest:request
						completion:^ (NSData* responseData, NSError* error)
	{
        [_gAppDelegate showLoadingView:NO];

		if (error)
		{
			if (![error.domain caseInsensitiveCompare:@"NSPOSIXErrorDomain"]==NSOrderedSame)
			{
				[UIUtils messageAlert:kNetworkErrorMessage title:kNetworkError delegate:nil];

//				if (failureBlock)
//					failureBlock();
			}
			//[UIUtils messageAlert:kNetworkErrorMessage title:kNetworkError delegate:nil];
		}
		else
		{
			_Assert(responseData);
			NSDictionary* response = [self getResponseFromData:responseData];
			_Assert(response);

			BOOL status = [self checkResponseStatus:response];
			NSString* message = nil;
			if (status)
			{
				message = [response objectForKey:@"message"];
				self.createBriefInfo.briefId = [[response objectForKey:@"brief_id"] integerValue];
			}
			else
			{
				message = [response objectForKey:@"err_message"];
			}

			if (self.completion)
				self.completion(status, message, requestType);
		}
	}];
}

#pragma mark AddCredit-

- (void) sendRequestToAddCredit:(BriefInfo*)info recipt:(id)receipt receiptType:(EReciptType)receiptType withCompletion:(DataManagerCompletionBlock)completion failure:(DataManagerFailureBlock)failureBlock
{
    //[_gAppDelegate showLoadingView:YES];

	self.completion = completion;
	
//	NSUInteger type = 2; // 1 for redeem, 2 - for Purchase
	if (receiptType == EReciptTypeCreditCard)
	{
		NSData* data = [receipt dataUsingEncoding:NSUTF8StringEncoding];
		receipt = [data base64EncodedString];
	}
	
	NSString* postString = [NSString stringWithFormat:@"token=%@&brief_id=%lu&credits=%lu&cost=%.2f&no_of_contents=%lu&receipt_type=%d&receipt=%@",_gAppPrefData.sessionToken, (unsigned long)info.briefId, (unsigned long)info.credit, info.cost, (unsigned long)info.noOfContents, receiptType,receipt];
	
	__block ERequestType requestType = ERequestTypeAddCreditToBrief;
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kAddCreditToBriefService
														   postString:postString];
	[WebServiceManager sendRequest:request
						completion:^ (NSData* responseData, NSError* error)
	{
         [_gAppDelegate showLoadingView:NO];

		 if (error)
		 {
			 if (![error.domain caseInsensitiveCompare:@"NSPOSIXErrorDomain"]==NSOrderedSame)
			 {
				 if (failureBlock)
					 failureBlock();
			 }
			 //[UIUtils messageAlert:kNetworkErrorMessage title:kNetworkError delegate:nil];
		 }
		 else
		 {
			 _Assert(responseData);
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 NSString* message = nil;
			 BOOL status = [self checkResponseStatus:response];
			 if (status)
			 {
				 self.userCredits = [[response objectForKey:@"user_credits"] integerValue];
				 message = [response objectForKey:@"message"];
			 }
			 else
			 {
				 message = [response objectForKey:@"err_message"];
			 }
			 
			 if (self.completion)
				 self.completion(status, message, requestType);
		 }
	}];
}

#pragma mark GetBriefs-

- (void) sendRequestToGetBriefForBuisness:(NSUInteger)businessId WithCompletion:(DataManagerCompletionBlock)completion failure:(DataManagerFailureBlock)failureBlock
{
	self.completion = nil;
	__block DataManagerCompletionBlock complitionBlock = completion;

	NSString* postString = [NSString stringWithFormat:@"token=%@&business_id=%lu", _gAppPrefData.sessionToken,(unsigned long)businessId];

	__block ERequestType requestType = ERequestTypeGetBriefs;

	NSURLRequest* request = [WebServiceManager postRequestWithService:kGetBriefService
														   postString:postString];
	[WebServiceManager sendRequest:request
						completion:^ (NSData* responseData, NSError* error)
	{

		[_gAppDelegate showLoadingView:NO];

		if (error)
		{
			if (![error.domain caseInsensitiveCompare:@"NSPOSIXErrorDomain"]==NSOrderedSame)
			{
				if (failureBlock)
					failureBlock();
			}
		}
		else
		{
			_Assert(responseData);
			NSDictionary* response = [self getResponseFromData:responseData];
			_Assert(response);

			BOOL status = [self checkResponseStatus:response];
			if (status)
			{
				NSArray* array = [response objectForKey:@"briefs"];
				NSMutableArray* briefArray = [[NSMutableArray alloc] initWithCapacity:array.count];
				for (int i = 0; i < array.count; ++i)
				{
					BriefInfo* info = [[BriefInfo alloc] initWithInfo:[array objectAtIndex:i]];
					[briefArray addObject:info];
				}
				self.briefList = [[NSArray alloc]initWithArray:briefArray];
			}

			self.completion = complitionBlock;
			[self callCompletionBlock:response withStatus:status requestType:requestType];
		}
	}];
}

- (void) sendRequestToGetHomepageContentWithCompletion:(HomePageDataComplitionBlock)completion
{
	self.homePageDataComplition = completion;

	NSString* postString = [NSString stringWithFormat:@"token=%@", _gAppPrefData.sessionToken];

	__block ERequestType requestType = ERequestTypeHomepageContent;

	NSURLRequest* request = [WebServiceManager postRequestWithService:kHomepageContentService
														   postString:postString];
	[WebServiceManager sendRequest:request
						completion:^ (NSData* responseData, NSError* error)
	{
		if (error)
		{
			if (![error.domain caseInsensitiveCompare:@"NSPOSIXErrorDomain"]==NSOrderedSame)
				[UIUtils messageAlert:kNetworkErrorMessage title:kNetworkError delegate:nil];
		}
		else
		{
			_Assert(responseData);
			NSDictionary* response = [self getResponseFromData:responseData];
			_Assert(response);

			BOOL status = [self checkResponseStatus:response];
			if (status)
			{
				NSArray* array = [response objectForKey:@"contents"];
				NSMutableArray* contentArray = [[NSMutableArray alloc] initWithCapacity:array.count];
				for (int i = 0; i < array.count; ++i)
				{
					ContentInfo* info = [[ContentInfo alloc] initWithInfo:[array objectAtIndex:i]];
					[contentArray addObject:info];
				}
				self.homepageContentList = [[NSArray alloc]initWithArray:contentArray];
			}
			self.messageNotification = [[response objectForKey:@"message_notify"] boolValue];
			self.submissionNotification = [[response objectForKey:@"submission_notify"] boolValue];
			
			[self callHomeDataCompletionBlock:response withStatus:status requestType:requestType];
		}
	}];
}

- (void) sendRequestToSubmitContent:(UIImage *)image caption:(NSString *)caption forBrief:(NSUInteger)briefId
{
	NSString* imageString = [self getImageStringFromImage:image];
	
	NSString* postString = [NSString stringWithFormat:@"token=%@&brief_id=%lu&caption=%@&image=%@",
							_gAppPrefData.sessionToken,(unsigned long)briefId, caption, imageString];
		
	NSURLRequest* request = [WebServiceManager postRequestWithService:kSubmitContentService
														   postString:postString];
	
	[_webserviceM sendrequest:request requesttype:ERequestTypeSubmitContent withProgress:YES];
}

- (void) sendRequestToSubmitContent:(UIImage*)image caption:(NSString*)caption forBrief:(NSUInteger)
briefId withCompletion:(DataManagerCompletionBlock)completion
{
    [_gAppDelegate showProgressView:YES];
	[_gAppDelegate setProgressData:0.0];
	[_gAppDelegate setLoadingViewTitle:@"Saving..."];
	
	self.completion = completion;
	
	NSString* imageString = [self getImageStringFromImage:image];
	
	NSString* postString = [NSString stringWithFormat:@"token=%@&brief_id=%lu&caption=%@&image=%@",
							_gAppPrefData.sessionToken,(unsigned long)briefId, caption, imageString];
	
	__block ERequestType requestType = ERequestTypeSubmitContent;
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kSubmitContentService
														   postString:postString];
	[WebServiceManager sendRequest:request
						completion:^ (NSData* responseData, NSError* error)
	{
        [_gAppDelegate showProgressView:NO];
		[_gAppDelegate setLoadingViewTitle:@"Loading..."];
		
		if (error)
		{
			if (![error.domain caseInsensitiveCompare:@"NSPOSIXErrorDomain"]==NSOrderedSame)
				[UIUtils messageAlert:kNetworkErrorMessage title:kNetworkError delegate:nil];
		}
		else
		{
			
			_Assert(responseData);
			NSDictionary* response = [self getResponseFromData:responseData];
			_Assert(response);
						
			NSString* message = nil;
			BOOL status = [self checkResponseStatus:response];
			if (status)
				message = [response objectForKey:@"message"];
			else
				message = [response objectForKey:@"err_message"];
			
			if (self.completion)
				self.completion(status, message, requestType);
		}
	}];
}

- (NSString*) getWIPDirecory
{
	NSString* directory = [UIUtils documentDirectoryWithSubpath:kWorkInProgressDir];
	directory = [directory stringByAppendingString:[NSString stringWithFormat:
													@"%lu/",(unsigned long)self.userInfo.userId]];
	return directory;
}

- (NSString*) getPackDirectory
{
	NSString* directory = [UIUtils documentDirectoryWithSubpath:kPackDir];
	directory = [directory stringByAppendingString:[NSString stringWithFormat:
													@"%lu/",(unsigned long)self.userInfo.userId]];
	return directory;
}


- (NSString*) getBriefDirectory
{
	NSString* directory = [UIUtils documentDirectoryWithSubpath:kBriefDirectory];
	directory = [directory stringByAppendingString:[NSString stringWithFormat:
													@"%lu/",(unsigned long)self.userInfo.userId]];
	return directory;
}

- (NSString*) getLogoDirectory
{
	NSString* directory = [UIUtils documentDirectoryWithSubpath:kLogoDirectory];
	directory = [directory stringByAppendingString:[NSString stringWithFormat:
													@"%lu/",(unsigned long)self.userInfo.userId]];
	return directory;
}

#pragma mark-

- (void) sendRequestToGetBuisnessRulesWithCompletion:(DataManagerCompletionBlock)completion
{
    [_gAppDelegate showLoadingView:YES];

	self.completion = completion;
	__block ERequestType requestType = ERequestTypeGetBuisnesSettings;
	
	NSURLRequest* request = [WebServiceManager requestWithService:kGetBusinessSettingService];
	[WebServiceManager sendRequest:request
						completion:^ (NSData* responseData, NSError* error)
	 {
         [_gAppDelegate showLoadingView:NO];
		 if (error)
		 {
			 NSDictionary* dict = nil;
			 if (![error.domain caseInsensitiveCompare:@"NSPOSIXErrorDomain"] == NSOrderedSame)
			 {
				 dict = [NSDictionary dictionaryWithObjectsAndKeys:kNetworkErrorMessage,
						 @"err_message", nil];
			 }
			 
			 [self callCompletionBlock:dict withStatus:NO requestType:requestType];
		 }
		 else
		 {
			 _Assert(responseData);
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];
			 if (status)
			 {
				 NSDictionary* businessRule = [response objectForKey:@"businessRule"];
				 self.oneAmmoCoinInAUD	= [[businessRule objectForKey:@"OneAmmoCoinCostInAUD"] floatValue];
				 self.oneContentCost		= [[businessRule objectForKey:@"OneContentCost"] integerValue];
			 }
			 [self callCompletionBlock:response withStatus:status requestType:requestType];
		 }
	}];
}

//- (BOOL) checkLocationFileExistWithVersion:(CGFloat)version
//{
//	 BOOL countryListExist = [self checkCountryListExistAndParseCountryInfo];
//	
//	if ((countryListExist) && (self.locationVersionNr == version))
//		return NO;
//	else
//		return YES;
//}

- (void) sendRequestToSearchText:(NSString*)searchText withCompletion:(DataManagerCompletionBlock)completion
{
    [_gAppDelegate showLoadingView:YES];
	
	self.completion = completion;

	NSString* postString = [NSString stringWithFormat:@"token=%@&search_text=%@", _gAppPrefData.sessionToken, searchText];
	
	__block ERequestType requestType = ERequestTypeBuisnessSearch;
	
	NSString* serviceName = (self.searchType == ESearchTypeUser) ?  kUserSearchService : kBusinessSearchService;
	NSURLRequest* request = [WebServiceManager postRequestWithService:serviceName
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
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];
			 if (status)
				 [self parseSearchResponse:response];

			 [self callCompletionBlock:response withStatus:status requestType:requestType];
			 
		 }
	 }];
}

- (void) sendRequestToGetProfile:(EUserSearchType)userType withId:(NSUInteger)userId  withCompletion:(DataManagerCompletionBlock)completion
{
    [_gAppDelegate showLoadingView:YES];
	
	self.completion = completion;
	
	NSString* postString = [NSString stringWithFormat:@"token=%@&type=%d&user_id=%lu", _gAppPrefData.sessionToken, userType, (unsigned long)userId];
	
	__block ERequestType requestType = ERequestTypeGetProfile;
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kGetProfileService
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
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];
			 if (status)
			 {
				 NSDictionary* profileDict = [response objectForKey:@"profile_info"];
				
				 self.userProfileInfo = [[ProfileInfo alloc] initWithInfo:profileDict];
				 self.userProfileInfo.userId = userId;
				 
			 }
			 [self callCompletionBlock:response withStatus:status requestType:requestType];
			 
		 }
	 }];
}

- (void) sendRequestToGetbriefContent:(EBriefType)brieftype withId:(NSUInteger)briefID
					   withCompletion:(DataManagerCompletionBlock)completion
{
	[_gAppDelegate showLoadingView:YES];
	
	self.completion = completion;
	
	NSString* postString = [NSString stringWithFormat:@"token=%@&brief_id=%lu&type=%d", _gAppPrefData.sessionToken,(unsigned long)briefID, brieftype];
	
	__block ERequestType requestType = ERequestTypeGetbriefContent;
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kGetBriefContentService
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
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];
			 if (status)
			 {
				 NSArray* array = [response objectForKey:@"briefs"];
				 NSMutableArray* briefInfoArray = [[NSMutableArray alloc] initWithCapacity:
															array.count];
				 for (int i = 0; i < array.count; ++i)
				 {
					 BriefContentInfo* info = [[BriefContentInfo alloc] initWithInfo:
													 [array objectAtIndex:i]];
					 [briefInfoArray addObject:info];
				 }
				 self.briefContentInfoList = [[NSArray alloc]initWithArray:briefInfoArray];
			 }
			 [self callCompletionBlock:response withStatus:status requestType:requestType];
		 }
	 }];
}

- (void) sendRequestToUpdateBriefContent:(EBriefPostForType)briefPostType withId:(NSUInteger)contentID
						withPaymentKey:(NSString*)paymentKey
						  withCompletion:(DataManagerCompletionBlock)completion
{
	[_gAppDelegate showLoadingView:YES];
	[_gAppDelegate setLoadingViewTitle:@"Please wait..."];
	
	self.completion = completion;
	
	NSString* postString = [NSString stringWithFormat:@"token=%@&content_id=%lu&type=%d&pay_key=%@",
							_gAppPrefData.sessionToken,(unsigned long)contentID, briefPostType, paymentKey];
	
	__block ERequestType requestType = ERequestTypeUpdateBriefContent;
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kUpdateBriefContentService
														   postString:postString];
	[WebServiceManager sendRequest:request
						completion:^ (NSData* responseData, NSError* error)
	 {
		 [_gAppDelegate showLoadingView:NO];
		 [_gAppDelegate setLoadingViewTitle:@"Loading..."];
		 
		 if (error)
		 {
			 if (![error.domain caseInsensitiveCompare:@"NSPOSIXErrorDomain"]==NSOrderedSame)
				 [UIUtils messageAlert:kNetworkErrorMessage title:kNetworkError delegate:nil];
		 }
		 else
		 {
			 _Assert(responseData);
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];
			 NSString* message = nil;
			 if (status)
			 {
				 message = [response objectForKey:@"message"];
				_gDataManager.userCredits = [[response objectForKey:@"user_credits"]
												   integerValue];
			 }
			 else
				 message = [response objectForKey:@"err_message"];
			 
			 if (self.completion)
				 self.completion(status, message, requestType);
		 }
	 }];
}

#pragma mark-

- (void) sendRequestToSearchType:(ESearchType)searchType locationType:(NSString*)locationType withLocationId:(NSUInteger)locationId  withCategoryId:(NSUInteger)categoryId searchText:(NSString*)searchText withCompletion:(DataManagerCompletionBlock)completion
{
	[_gAppDelegate showLoadingView:YES];
	
	self.completion = completion;
	
	NSString* filterType = (searchType == ESearchTypeCategory) ? @"Category" : @"Location";
	
	NSString* postString = [NSString stringWithFormat:@"token=%@&search_type=%@&location_type=%@&location_id=%lu&category_id=%lu&search_text=%@", _gAppPrefData.sessionToken, filterType, locationType, (unsigned long)locationId, (unsigned long)categoryId, searchText];
	
	DLog(@"%@",postString);
	
	__block ERequestType requestType = ERequestTypeUpdateBriefContent;
	
	NSString* serviceName = (self.searchType == ESearchTypeUser) ?  kUserLocationSearchService : kBusinessLocationSearchService;

	NSURLRequest* request = [WebServiceManager postRequestWithService:serviceName
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
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];
			 if (status)
				 [self parseSearchResponse:response];

			 [self callCompletionBlock:response withStatus:status requestType:requestType];
		 }
	 }];
}

- (void) sendRequestToGetuserCreditWithCompletion:(DataManagerCompletionBlock)completion
{
    [_gAppDelegate showLoadingView:YES];
	
	self.completion = completion;
	
	NSString* postString = [NSString stringWithFormat:@"token=%@",_gAppPrefData.sessionToken];
	
	DLog(@"%@",postString);
	
	__block ERequestType requestType = ERequestTypeGetUserCredit;
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kGetCreditService
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
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];
			 if (status)
			 {
				 self.userCreditInfoObj = [[UserCreditInfo alloc] initWithInfo:response];
			 }
			 
			 [self callCompletionBlock:response withStatus:status requestType:requestType];
		 }
		 
	 }];
}

- (void) sendRequestToGetuserMessageList:(ERequestMessage)requestMessage withCompletion:(DataManagerCompletionBlock)completion failure:(DataManagerFailureBlock)failureBlock
{
	self.completion = nil;
	
	__block DataManagerCompletionBlock complitionBlock = completion;
	
	NSString* postString = [NSString stringWithFormat:@"token=%@&all=%d",_gAppPrefData.sessionToken,requestMessage];
	
	DLog(@"%@",postString);
	
	__block ERequestType requestType = ERequestTypeGetMessageList;
	NSURLRequest* request = [WebServiceManager postRequestWithService:kGetMessgaeList
														   postString:postString];
	[WebServiceManager sendRequest:request
						completion:^ (NSData* responseData, NSError* error)
	 {
		 
		 if (error)
		 {
			 if (![error.domain caseInsensitiveCompare:@"NSPOSIXErrorDomain"]==NSOrderedSame)
			 {
				if (failureBlock)
						failureBlock();
			 }
		 }
		 else
		 {
			 _Assert(responseData);
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];
			 if (status)
			 {
				 NSArray* array = [response objectForKey:@"messages"];
				 NSMutableArray* messageInfoArray = [[NSMutableArray alloc] initWithCapacity:
												   array.count];
				 for (int i = 0; i < array.count; ++i)
				 {
					 MessageInfo* info = [[MessageInfo alloc] initWithInfo:[array objectAtIndex:i]];
					 [messageInfoArray addObject:info];
				 }
				 self.messageinfoList = [[NSArray alloc]initWithArray:messageInfoArray];
			 }
			 else
			 {
				 self.messageinfoList = [[NSArray alloc]init];
			 }
			 
			 self.completion = complitionBlock;
			 [self callCompletionBlock:response withStatus:status requestType:requestType];
		 }
	 }];
}

- (void) sendRequestToReadMessage:(NSUInteger)messageID withCompletion:(DataManagerCompletionBlock)completion
						  failure:(DataManagerFailureBlock)failureBlock
{
	[_gAppDelegate showLoadingView:YES];
	
	self.completion = nil;

	__block DataManagerCompletionBlock complitionBlock = completion;
	
	NSString* postString = [NSString stringWithFormat:@"token=%@&message_id=%lu",
							_gAppPrefData.sessionToken,(unsigned long)messageID];
	
	DLog(@"%@",postString);
	
	__block ERequestType requestType = ERequestTypeReadMessage;
	NSURLRequest* request = [WebServiceManager postRequestWithService:kReadMessageService
														   postString:postString];
	[WebServiceManager sendRequest:request
						completion:^ (NSData* responseData, NSError* error)
	 {
		 [_gAppDelegate showLoadingView:NO];

		 if (error)
		 {
			 if (![error.domain caseInsensitiveCompare:@"NSPOSIXErrorDomain"]==NSOrderedSame)
			 {
				 if (failureBlock)
					 failureBlock();
			 }
		 }
		 else
		 {
			 _Assert(responseData);
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];

			 self.completion = complitionBlock;
			 [self callCompletionBlock:response withStatus:status requestType:requestType];
		 }
	 }];
}

- (void) parseSearchResponse:(NSDictionary*)response
{
//	NSString* responseKey = (self.searchType == ESearchTypeUser)  ? @"user_data" : @"business_data";
	
	NSString* responseKey = @"user_data";
	NSArray* array = [response objectForKey:responseKey];
	NSMutableArray* serachArray = [[NSMutableArray alloc] initWithCapacity:array.count];
	for (int i = 0; i < array.count; ++i)
	{
		SearchUserInfo* info = [[SearchUserInfo alloc] initWithInfo:[array objectAtIndex:i]];
		[serachArray addObject:info];
	}
	self.searchList = [[NSArray alloc]initWithArray:serachArray];
}

#pragma mark-

- (void) sendRequestToRedeemCoin:(NSUInteger)coin cost:(CGFloat)cost forEmail:(NSString*)
email password:(NSString*)password withCompletion:(DataManagerCompletionBlock)completion
{
    [_gAppDelegate showLoadingView:YES];
	
	self.completion = completion;
		
	NSString* postString = [NSString stringWithFormat:@"token=%@&email=%@&socialammo_coins=%lu&cost=%.2f&password=%@",
							_gAppPrefData.sessionToken, email, (unsigned long)coin, cost, password];
	
	__block ERequestType requestType = ERequestTypeRedeemCoin;
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kRedeemCoinService
														   postString:postString];
	[WebServiceManager sendRequest:request
						completion:^ (NSData* responseData, NSError* error)
	 {
		 [_gAppDelegate showLoadingView:NO];
		 [_gAppDelegate setLoadingViewTitle:@"Loading..."];
		 
		 if (error)
		 {
			 if (![error.domain caseInsensitiveCompare:@"NSPOSIXErrorDomain"]==NSOrderedSame)
				 [UIUtils messageAlert:kNetworkErrorMessage title:kNetworkError delegate:nil];
		 }
		 else
		 {
			 _Assert(responseData);
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 NSString* message = nil;
			 BOOL status = [self checkResponseStatus:response];
			 if (status)
			 {
				 message = [response objectForKey:@"message"];
				 self.userCredits = [[response objectForKey:@"user_credits"] integerValue];
			 }
			 else
				 message = [response objectForKey:@"err_message"];
			 
			 if (self.completion)
				 self.completion(status, message, requestType);
		 }
	 }];
}

#pragma mark- Facebook login

- (void) sendRequestToSocialMediaLoginUser:(EUserSocialMediaType)socialmediaType withEmail:(NSString*)email
							  withCompletion:(DataManagerCompletionBlock)completion
{
    [_gAppDelegate showLoadingView:YES];
	
	self.completion = completion;
	
	NSString* postString = [NSString stringWithFormat:@"device_token=%@&device_type=%@&username=%@&",
							_gAppPrefData.deviceToken, kDeviceTypeIphone,email];
	NSString* subString = nil;
	if (socialmediaType == EUserSocialMediaTypeFacebook)
		subString = [NSString stringWithFormat:@"fb_token=%@", _gAppPrefData.fbToken];
	else
		subString = [NSString stringWithFormat:@"linkedin_token=%@", _gAppPrefData.linkedInToken];

	postString = [postString stringByAppendingString:subString];
	
	__block ERequestType requestType = (socialmediaType == EUserSocialMediaTypeFacebook) ?ERequestTypeFacebookLogIn : ERequestTypeLinkedInLogin;
	
	NSString* service = (socialmediaType == EUserSocialMediaTypeFacebook) ? kFaceBookLoginService : kLinkedInLoginService;
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:service
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
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];
			 if (status)
			 {
				 NSDictionary* userData = [response objectForKey:@"userdata"];
				 [self parseUserInfo:userData];
			 }
			 [self callCompletionBlock:response withStatus:status requestType:requestType];
		 }
	 }];
}

- (void) sendRequestToSocialMediaSignUp:(EUserSocialMediaType)socialmediaType withUser:(UserInfo*)userInfo
							  withCompletion:(SignUpCompletionBlock)signUpCompletion
{
	[_gAppDelegate showLoadingView:YES];
	
	self.signUpCompletion = signUpCompletion;
	
	/* Block old sign up
	 NSString* postString = [self createPostStringForFBSignUp:userInfo];
	 */
	NSString* postString = [self createPostStringForSocialMedia:socialmediaType signUp:userInfo];
	
	
	__block ERequestType requestType = (socialmediaType == EUserSocialMediaTypeFacebook)? ERequestTypeFaceBookSignup : ERequestTypeLinkedInSignUp;
	
	NSString* service = (socialmediaType == EUserSocialMediaTypeFacebook) ? kFaceBookSignUpService : kLinkedInSignUpService;

	NSURLRequest* request = [WebServiceManager postRequestWithService:service
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
			 self.userInfo = userInfo;
			 
			 _Assert(responseData);
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];
			 NSString* message = nil;
			 NSString* errorType = @"";
			 if (status)
			 {
				 message = [response objectForKey:@"message"];
				 NSDictionary* userData = [response objectForKey:@"userdata"];
				 [self parseUserInfo:userData];
			 }
			 else
			 {
				 message = [response objectForKey:@"err_message"];
				 errorType = [response objectForKey:@"err_type"];
			 }
			 
			 if (self.signUpCompletion)
				 self.signUpCompletion(status, message,errorType,requestType);
		 }
	 }];
}


#pragma  mark -- Send Private message

- (void) sendRequestTosendPrivateMessageWithRequest:(NSURLRequest*)request andIsprogress:(BOOL) isProgress
{
	[_webserviceM sendrequest:request requesttype:ERequestTypeSendPrivateMessage withProgress:isProgress];
}

#pragma mark- getPrivateMessage

- (void) sendRequestToGetPrivateMessageForUser:(NSUInteger)userId withCompletion:(DataManagerCompletionBlock)completion
{
	self.privateMessageArray = nil;
	
    [_gAppDelegate showLoadingView:YES];
	
	self.completion = completion;
	
	NSString* postString = [NSString stringWithFormat:@"token=%@&user_id=%lu",_gAppPrefData.sessionToken, (unsigned long)userId];
	
	__block ERequestType requestType = ERequestTypeGetPrivateMessage;
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kGetPrivateMessage
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
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];
			 if (status)
			 {
				 NSArray* array = [response objectForKey:@"messages"];
				 NSMutableArray* meesageList = [[NSMutableArray alloc] initWithCapacity:
											   array.count];
				 for (int i = 0; i < array.count; ++i)
				 {
					 NSDictionary* messageInfo = [array objectAtIndex:i];
					 PrivateMessageInfo* info = [[PrivateMessageInfo alloc] initWithInfo:messageInfo];
					 [meesageList addObject:info];
				 }
				 self.privateMessageArray = [[NSArray alloc]initWithArray:meesageList];
			 }
			 [self callCompletionBlock:response withStatus:status requestType:requestType];
		 }
	 }];
}

#pragma mark- getAmmoCoinPacks

- (void) sendRequestToGetAmmoCoinsPackWithCompletion:(DataManagerCompletionBlock)completion
{
    [_gAppDelegate showLoadingView:YES];
	
	self.completion = completion;
	
	NSString* postString = [NSString stringWithFormat:@"token=%@", _gAppPrefData.sessionToken];
	
	__block ERequestType requestType = ERequestTypeGetAmmoCoinPacks;
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kGetAmmoCoinPacks
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
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];
			 if (status)
			 {
				 NSString* coinPacks = [response objectForKey:@"ammo_coin_packs"];
				 if (coinPacks.length > 0)
					 self.ammoCoinPackArray = [coinPacks componentsSeparatedByString:@"|"];
			 }
			 [self callCompletionBlock:response withStatus:status requestType:requestType];
		 }
	 }];
}

#pragma mark- getCanvas

- (void) sendRequestToGetCanvasWithCompletion:(DataManagerCompletionBlock)completion
{
	self.canvasList = nil;
	
    [_gAppDelegate showLoadingView:YES];
	
	self.completion = completion;
	
	NSString* postString = [NSString stringWithFormat:@"token=%@",_gAppPrefData.sessionToken];
	
	__block ERequestType requestType = ERequestTypeGetCanvas;
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kGetCanvasService
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
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];
			 if (status)
			 {
				 NSArray* array = [response objectForKey:@"canvas"];
				 NSMutableArray* canvasArray = [[NSMutableArray alloc] initWithCapacity:
												array.count];
				 for (int i = 0; i < array.count; ++i)
				 {
					 NSDictionary* canvasInfo = [array objectAtIndex:i];
					 CanvasInfo* info = [[CanvasInfo alloc] initWithInfo:canvasInfo];
					 [canvasArray addObject:info];
				 }
				 self.canvasList = [[NSArray alloc]initWithArray:canvasArray];
			 }
			 [self callCompletionBlock:response withStatus:status requestType:requestType];
		 }
	 }];
}

#pragma mark- getPacksFromMarketPlace

- (void) sendRequestToGetPacksFromMarketplaceWithCompletion:(DataManagerCompletionBlock)completion
{
    [_gAppDelegate showLoadingView:YES];
	
	self.completion = completion;
	
	NSString* postString = [NSString stringWithFormat:@"token=%@", _gAppPrefData.sessionToken];
	
	__block ERequestType requestType = ERequestTypeGetPacksFromMarketPlace;
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kGetPacksFromMarketPlace
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
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];
			 if (status)
			 {
				 NSArray* array = [response objectForKey:@"packs"];
				 NSMutableArray* packInfoArray = [[NSMutableArray alloc] initWithCapacity:
													 array.count];
				 for (int i = 0; i < array.count; ++i)
				 {
					 PackInfo* info = [[PackInfo alloc] initWithInfo:[array objectAtIndex:i]];
					 [packInfoArray addObject:info];
				 }
				 self.packList = [[NSArray alloc]initWithArray:packInfoArray];
			 }
			 [self callCompletionBlock:response withStatus:status requestType:requestType];
		 }
	 }];
}

#pragma mark -- Web service delegate

- (void) getResponseFromServer: (NSData*) responseData
                   requestType: (ERequestType) theRequestType
                 requestStatus: (WEB_SERVICE_OPERATION_STATUS) theRequestStatus
{
	_Assert(responseData);
	NSDictionary* response = [self getResponseFromData:responseData];
	_Assert(response);
	
	if (WEB_SERVICE_STATUS_FAIL == theRequestStatus)
	{
		[UIUtils messageAlert:kNetworkError title:@"" delegate:nil];
	}
	else
	{
		switch(theRequestType)
		{
			case ERequestTypeSubmitContent:
			{
				[self parseSubmitContentServiceResponse:response];
			}
				break;
				
			case ERequestTypeSaveBrief:
			{
				[self parseSaveBriefResponse:response];
			}
				break;
				
			case ERequestTypeSendPrivateMessage:
			{
				[self parseSendMessageResponse:response];
			}
				break;
				
			default:
				break;
		}
	}
}

- (void) parseSubmitContentServiceResponse:(NSDictionary*)response
{
	NSString* message = nil;
	BOOL status = [self checkResponseStatus:response];
	if (status)
		message = [response objectForKey:@"message"];
	else
		message = [response objectForKey:@"err_message"];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kSubmitNotfication object:[NSNumber numberWithBool:status] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:message,@"Message", nil]];
}

- (void) parseSaveBriefResponse:(NSDictionary*)response
{
	BOOL status = [self checkResponseStatus:response];
	NSString* message = nil;
	if (status)
	{
		message = [response objectForKey:@"message"];
		self.createBriefInfo.briefId = [[response objectForKey:@"brief_id"] integerValue];
	}
	else
	{
		message = [response objectForKey:@"err_message"];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kSaveBriefNotification object:[NSNumber numberWithBool:status] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:message,@"Message", nil]];
}

- (void) parseSendMessageResponse:(NSDictionary*)response
{
	BOOL status = [self checkResponseStatus:response];
	NSString* message = nil;
	if (status)
	{
		message = [response objectForKey:@"message"];
	}
	else
	{
		message = [response objectForKey:@"err_message"];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kSendPrivatemessageNotifi object:[NSNumber numberWithBool:status] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:message,@"Message", nil]];
}


- (PackInfo*) getPackForId:(NSUInteger)packId
{
	for (PackInfo* info in self.packList)
	{
		if (info.packId == packId)
			return info;
	}
	
	return nil;
}

#pragma mark- submission service

- (void) sendRequestToSaveSubmission:(SubmissionInfo*)info withCompletion:(DataManagerCompletionBlock)completion
{
    [_gAppDelegate showLoadingView:YES];
	
	self.completion = completion;
	
	NSString* logoImageString = [self getImageStringFromImage:info.logoImage];

	NSString* interest = [info.selectedInterestIds componentsJoinedByString:@";;"];
	CGFloat latitude = 0; //self.userInfo.userLocation.latitude;
	CGFloat longitude = 0; //self.userInfo.userLocation.longitude;

	NSString* postString = [NSString stringWithFormat:@"token=%@&open=%d&brief_id=%lu&title=%@&info=%@&latitude=%f&longitude=%f&radius=%lu&interests=%@&font=%@&logo=%@", _gAppPrefData.sessionToken, info.submissionType, (unsigned long)info.submisionId, info.submissionName, info.submissionDescription, latitude, longitude, (unsigned long)info.radius, interest, [UIUtils checknilAndWhiteSpaceinString:info.font], logoImageString];
	
	__block ERequestType requestType = ERequestTypeSaveSubmission;
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kSaveSubmissionService
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
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];
			 if (status)
			 {
				 self.userInfo.hasOpenSubmission = YES;
			 }
			 [self callCompletionBlock:response withStatus:status requestType:requestType];
		 }
	 }];
}

#pragma mark- SubmisisonList

- (void) sendRequestToGetAllSubmissionWithCompletion:(DataManagerCompletionBlock)completion
{
    [_gAppDelegate showLoadingView:YES];
	
	self.completion = completion;
	
	NSString* postString = [NSString stringWithFormat:@"token=%@", _gAppPrefData.sessionToken];
	
	__block ERequestType requestType = ERequestTypeGetAllSubmission;
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kGetAllSubmissionService
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
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];
			 if (status)
			 {
				  NSArray* array = [response objectForKey:@"submissions"];
				  NSMutableArray* packInfoArray = [[NSMutableArray alloc] initWithCapacity:
				 								  array.count];
				  for (int i = 0; i < array.count; ++i)
				  {
				 	 SubmissionInfo* info = [[SubmissionInfo alloc] initWithInfo:[array objectAtIndex:i]];
				 	 [packInfoArray addObject:info];
				  }
				  self.submissionList = [[NSArray alloc]initWithArray:packInfoArray];
			 }
			 [self callCompletionBlock:response withStatus:status requestType:requestType];
		 }
	 }];
}


#pragma mark- Ranking service

- (void) sendRequestToSearchUser:(EUserType)userType radius:(NSUInteger)radius categoryId:(NSArray*)categoryIds withCompletion:(DataManagerCompletionBlock)completion
{
    [_gAppDelegate showLoadingView:YES];
	
	self.completion = completion;
	
	NSString* postString = [self postStringToSearchUser:userType radius:radius categoryId:categoryIds];
	
	__block ERequestType requestType = (userType == EUserTypeCreator) ? ERequestTypeCreatorSearch : ERequestTypeBuisnessSearch;
	
	NSString* serviceName = (userType == EUserTypeCreator) ? kCreatorSearchService : kBusinessSearchService;
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:serviceName
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
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];
			 
			 self.searchCount = [[response objectForKey:@"count"] integerValue];
			 if (status)
				 [self parseSearchResponse:response];
			 
			 [self callCompletionBlock:response withStatus:status requestType:requestType];
		 }
	 }];
}

- (NSString*) postStringToSearchUser:(EUserType)userType radius:(NSUInteger)radius categoryId:(NSArray*)categoryIds
{
	NSString* categoryId = @"";
	CGFloat latitude = self.userInfo.userLocation.latitude;
	CGFloat longitude = self.userInfo.userLocation.longitude;
	
	NSString* postString = nil;
	
	if (userType == EUserTypeCreator)
	{
		postString = [NSString stringWithFormat:@"token=%@&latitude=%f&longitude=%f&radius=%lu&category_id=%@", _gAppPrefData.sessionToken, latitude, longitude, (unsigned long)radius, categoryId];
	}
	else if (userType == EUserTypeBuisness)
	{
		postString = [NSString stringWithFormat:@"token=%@&latitude=%f&longitude=%f&category_id=%@", _gAppPrefData.sessionToken, latitude, longitude, categoryId];
	}
	
	return postString;
}

#pragma mark- Validate

- (void) sendRequestValidateEmail:(NSString*)emailStr withCompletion:(DataManagerCompletionBlock)completion
{
    [_gAppDelegate showLoadingView:YES];
	
	self.completion = completion;
	
	NSString* postString = [NSString  stringWithFormat:@"email=%@",emailStr];
	
	__block ERequestType requestType = ERequestTypeValidateEmail;
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kValidateEmail
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
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];

			 [self callCompletionBlock:response withStatus:status requestType:requestType];
		 }
	 }];
}


- (void) sendRequestValidatebusinessName:(NSString*)businessName andID:(NSUInteger)userID withCompletion:(DataManagerCompletionBlock)completion
{
    [_gAppDelegate showLoadingView:YES];
	
	self.completion = completion;
	
	NSString* postString = [NSString  stringWithFormat:@"name=%@&user_id=%lu",businessName,(unsigned long)userID];
	
	__block ERequestType requestType = ERequestTypeValidateBusinessname;
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kValidateBusinessName
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
			 NSDictionary* response = [self getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [self checkResponseStatus:response];
			 
			 [self callCompletionBlock:response withStatus:status requestType:requestType];
		 }
	 }];
}


- (void) sendRequestToLoadLogoImageWithURL:(NSString*)logoURl
{
	NSURLRequest* request = [WebServiceManager requestWithUrlString:logoURl];
	[_webserviceM sendrequest:request requesttype:ERquestTypeLoadLogoImage withProgress:NO];
}

@end
