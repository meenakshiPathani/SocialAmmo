//
//  UserInfo.m
//  Social Ammo
//
//  Created by Meenakshi on 22/01/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "UserInfo.h"
#import "AppPrefData.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SCAFacebookSession.h"

@implementation UserInfo

- (id)initWithUserType:(EUserType)userType
{
    self = [super init];
    if (self)
	{
        self.userType = userType;
    }
    return self;
}

- (id)initWithInfo:(NSDictionary*)dict
{
    self = [super init];
    if (self)
	{
		self.facebookLogin = [[dict objectForKey:@"is_fb_login"] boolValue];
		self.messageNotify = [[dict objectForKey:@"message_notify"] boolValue];
		self.submissionNotify = [[dict objectForKey:@"submission_notify"] boolValue];

		self.hasPaymentId = [[dict objectForKey:@"has_paypal"] boolValue];

		self.userId = [[dict objectForKey:@"user_id"] integerValue];
		self.credit = [[dict objectForKey:@"credits"] integerValue];
		_gDataManager.userCredits = self.credit;
		
		self.firstname = [dict objectForKey:@"first_name"];
		self.lastname = [dict objectForKey:@"last_name"];
		
		self.businessName = [dict objectForKey:@"name"];

		self.email = [dict objectForKey:@"email"];
		self.profilePicURL = [dict objectForKey:@"profile_pic"];
		self.userType = (EUserType)[[dict objectForKey:@"user_type"] integerValue];
				
		CGFloat latitude = [[dict objectForKey:@"latitude"] floatValue];
		CGFloat longitude = [[dict objectForKey:@"longitude"] floatValue];
		self.userLocation = CLLocationCoordinate2DMake(latitude, longitude);
		
		self.locationEnabled = [[dict objectForKey:@"location_enabled"] boolValue];
		
		self.hasOpenSubmission = [[dict objectForKey:@"open_submission"] boolValue];
		
		[self parsePacks:dict];
		
		self.businessInfo = [[BusinessInfo alloc] init];
		self.businessInfo.businessId = [[dict objectForKey:@"industry_id"] integerValue];
		self.businessInfo.businessName = [dict objectForKey:@"industry_name"];

    }
    return self;
}

- (id)initWithUserInfo:(UserInfo*)userInfo
{
	UserInfo* obj = [[UserInfo alloc] init];
	if (userInfo)
	{
		obj.userType = userInfo.userType;
		obj.facebookLogin = userInfo.facebookLogin;
		
		obj.userId = userInfo.userId;
		obj.credit = userInfo.credit;
		obj.firstname = userInfo.firstname;
		obj.lastname = userInfo.lastname;
		obj.businessName = userInfo.businessName;
		obj.userDOB = userInfo.userDOB;
		obj.email = userInfo.email;
		obj.password = userInfo.password;
		obj.userBusiness = userInfo.userBusiness;
		obj.profilePicURL = userInfo.profilePicURL;
		obj.businessInfo = userInfo.businessInfo;
		obj.profileImage = userInfo.profileImage;
	}
		
	return obj;
}

- (void) logout
{
	self.userType = 0;

	_gAppPrefData.password = @"";
	_gAppPrefData.isLogin = NO;
	_gAppPrefData.sessionToken = @"";
	
	_gAppPrefData.fbToken = @"";
	_gAppPrefData.linkedInToken = @"";

	[SCAFacebookSession closeSession];
	
	[_gAppPrefData saveAllData];
	
	_gDataManager.homepageContentList = nil;
	_gDataManager.messageinfoList = nil;
}

- (void) parsePacks:(NSDictionary*)dict
{
	NSString* packList = [dict objectForKey:@"packs"];
	packList = [packList stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if (packList.length > 0)
		self.packIdArray = [packList componentsSeparatedByString:@","];
	else
		self.packIdArray = nil;
}

@end
