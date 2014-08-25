//
//  UserBusinessInfo.m
//  Social Ammo
//
//  Created by Meenakshi on 12/03/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "SearchUserInfo.h"

@implementation SearchUserInfo

- (id)initWithInfo:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
	{
		self.userRank = [[dictionary objectForKey:@"rank"] integerValue];
		
		//buisnesInfo
		self.businessId = [[dictionary objectForKey:@"business_id"] integerValue];
		self.activeBriefs = [[dictionary objectForKey:@"active_breifs"] integerValue];
		
		self.businessName = [dictionary objectForKey:@"business_name"];
		self.businessType = [dictionary objectForKey:@"industry_name"];
		self.buisnessImageUrl = [dictionary objectForKey:@"business_image"];
		
		//userInfo
		self.userId = [[dictionary objectForKey:@"user_id"] integerValue];
		self.postCount = [[dictionary objectForKey:@"posts"] integerValue];

		self.userName = [dictionary objectForKey:@"user_name"];
		self.firstName = [dictionary objectForKey:@"first_name"];
		self.lastName = [dictionary objectForKey:@"last_name"];
		
		self.lastPostDate = [dictionary objectForKey:@"last_post"];
		self.profileImageUrl = [dictionary objectForKey:@"profile_image"];

		//common
		NSDictionary* badgesDict = [dictionary objectForKey:@"badges"];
		self.badges = [[BadgesInfo alloc] initWithInfo:badgesDict];
		
    }
    return self;
}

@end
