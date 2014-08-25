//
//  ProfileInfo.m
//  Social Ammo
//
//  Created by Meenakshi on 19/03/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "ContentInfo.h"
#import "ProfileInfo.h"

@implementation ProfileInfo

- (id)initWithInfo:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
	{
		self.userType = [[dictionary objectForKey:@"user_type"] integerValue];
		
		self.name = [dictionary objectForKey:@"name"];
		self.businessType = [dictionary objectForKey:@"industry_name"];
		self.profileImageUrl = [dictionary objectForKey:@"profile_url"];
		self.lastImageUrl = [dictionary objectForKey:@"last_post_image"];
		self.lastPostDate = [dictionary objectForKey:@"last_post_date"];
		
		self.posts = [[dictionary objectForKey:@"posts"] integerValue];
		self.pastBriefsCount = [[dictionary objectForKey:@"past_breifs"] integerValue];
		self.activeBriefsCount = [[dictionary objectForKey:@"active_breifs"] integerValue];
		
		self.messageThreadUnlock = [[dictionary objectForKey:@"unlock_message_thread"] boolValue];
		
		NSDictionary* badgesDict = [dictionary objectForKey:@"badges"];
		self.badges = [[BadgesInfo alloc] initWithInfo:badgesDict];
		
		// parse ContentInfo
		
		NSArray* array = [dictionary objectForKey:@"contents"];
		NSMutableArray* contentArray = [[NSMutableArray alloc] initWithCapacity: array.count];
		for (int i = 0; i < array.count; ++i)
		{
			ContentInfo* info = [[ContentInfo alloc] initWithInfo:[array objectAtIndex:i]];
			[contentArray addObject:info];
		}
		self.contentList = [[NSArray alloc]initWithArray:contentArray];
    }
    return self;
}

@end
