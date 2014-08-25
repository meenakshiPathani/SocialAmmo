//
//  CreatorInfo.m
//  SocialAmmo
//
//  Created by Meenakshi on 31/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "ContentInfo.h"
#import "CreatorInfo.h"

@implementation CreatorInfo

- (id)initWithInfo:(NSDictionary*)dict
{
    self = [super init];
    if (self)
	{
		self.creatorId = [[dict objectForKey:@"user_id"] integerValue];
		self.age = [[dict objectForKey:@"age"] integerValue];
		self.viewersCount = [[dict objectForKey:@"viewers"] integerValue];

		self.distance = [[dict objectForKey:@"radius"] floatValue];

		self.isSeen = [[dict objectForKey:@"is_seen"] boolValue];

		self.name = [dict objectForKey:@"name"];
		self.email = [dict objectForKey:@"email"];
		self.profilePicUrl = [dict objectForKey:@"profile_pic"];
		
		NSArray* array = [dict objectForKey:@"contents"];
		NSMutableArray* contentArray = [[NSMutableArray alloc] initWithCapacity:
										 array.count];
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
