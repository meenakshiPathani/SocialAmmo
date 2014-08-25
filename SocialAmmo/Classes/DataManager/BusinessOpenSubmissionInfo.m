//
//  BusinessOpenSubmissionInfo.m
//  SocialAmmo
//
//  Created by Meenakshi on 01/08/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "BusinessOpenSubmissionInfo.h"

@implementation BusinessOpenSubmissionInfo

- (id)initWithInfo:(NSDictionary*)dict
{
    self = [super init];
    if (self)
	{
		self.businessId = [[dict objectForKey:@"user_id"] integerValue];
		self.submissionId = [[dict objectForKey:@"submission_id"] integerValue];
		
		self.distance = [[dict objectForKey:@"radius"] floatValue];
		
		self.isSeen = [[dict objectForKey:@"is_seen"] boolValue];
		
		self.name = [dict objectForKey:@"name"];
		self.description = [dict objectForKey:@"description"];

		self.email = [dict objectForKey:@"email"];
		self.profilePicUrl = [dict objectForKey:@"profile_pic"];
		
		self.specificSubmisisonCount = [[dict objectForKey:@"specific_submissions"] integerValue];
		self.unseenSpecificSubmisisonCount = [[dict objectForKey:@"specific_submissions_unseen"] integerValue];
	}
	
	return self;
}

@end
