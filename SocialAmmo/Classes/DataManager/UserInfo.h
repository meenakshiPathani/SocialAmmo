//
//  UserInfo.h
//  Social Ammo
//
//  Created by Meenakshi on 22/01/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "BusinessInfo.h"

@interface UserInfo : NSObject
{
	
}
@property (nonatomic, assign)EUserType userType;
@property (nonatomic, assign)BOOL facebookLogin;

@property (nonatomic, assign)BOOL locationEnabled;
@property (nonatomic, assign)BOOL hasOpenSubmission;
@property (nonatomic, assign)BOOL futurePaymentEnable;
@property (nonatomic, assign)BOOL hasPaymentId;
@property (nonatomic, assign)BOOL messageNotify;
@property (nonatomic, assign)BOOL submissionNotify;

@property (nonatomic, assign)CLLocationCoordinate2D userLocation;

@property (nonatomic, assign)NSUInteger userId;
@property (nonatomic, assign)NSUInteger credit;

@property (nonatomic, strong)NSString* firstname;
@property (nonatomic, strong)NSString* lastname;
@property (nonatomic, strong)NSString* businessName;
@property (nonatomic, strong) NSString* userDOB;

@property (nonatomic, strong)NSString* email;
@property (nonatomic, strong)NSString* password;
@property (nonatomic, strong)NSString* userBusiness;
@property (nonatomic, strong)NSString* profilePicURL;


@property (nonatomic, strong)BusinessInfo* businessInfo;

@property (nonatomic, strong)UIImage* profileImage;

@property (nonatomic, strong)NSArray* packIdArray;


- (id)initWithUserType:(EUserType)userType;
- (id)initWithInfo:(NSDictionary*)dict;
- (id)initWithUserInfo:(UserInfo*)userInfo;

- (void) logout;
- (void) parsePacks:(NSDictionary*)dict;

@end
