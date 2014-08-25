//
//  ContentInfo.m
//  Social Ammo
//
//  Created by Meenakshi on 18/02/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "ContentInfo.h"

@implementation ContentInfo

- (id)initWithInfo:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
	{
		self.thumbnailUrl = [dictionary objectForKey:@"thumbnail"];
		self.contentImageUrl = [dictionary objectForKey:@"image"];

		self.firstName = [dictionary objectForKey:@"first_name"];
		self.lastName = [dictionary objectForKey:@"last_name"];
		self.userImageUrl = [dictionary objectForKey:@"profile_url"];
		self.userId = [[dictionary objectForKey:@"user_id"] integerValue];
		
		self.buisnessName = [dictionary objectForKey:@"business_name"];
		self.businessId = [[dictionary objectForKey:@"business_id"] integerValue];
		self.businesImageUrl = [dictionary objectForKey:@"business_profile_url"];

		self.likeCount = [[dictionary objectForKey:@"like_count"] integerValue];
		self.commentCount = [[dictionary objectForKey:@"comment_count"] integerValue];
		
		NSDictionary* badgesDict = [dictionary objectForKey:@"badges"];
		self.badges = [[BadgesInfo alloc] initWithInfo:badgesDict];

    }
    return self;
}


@end
