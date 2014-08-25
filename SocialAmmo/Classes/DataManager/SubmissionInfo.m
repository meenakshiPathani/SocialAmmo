//
//  SubmissionInfo.m
//  SocialAmmo
//
//  Created by Meenakshi on 17/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "SubmissionInfo.h"

@implementation SubmissionInfo

- (id)initWithSubmissionType:(ESubmissionType)type
{
    self = [super init];
    if (self)
	{
        self.submissionType = type;
    }
    return self;
}

- (id)initWithInfo:(NSDictionary*)dict
{
    self = [super init];
    if (self)
	{
		self.submisionId = [[dict objectForKey:@"brief_id"] integerValue];
		self.submissionName = [dict objectForKey:@"title"];
		
		self.submittedContentCount = [[dict objectForKey:@"contents"] integerValue];
		self.radius = [[dict objectForKey:@"radius"] integerValue];
		
		self.viewCount = [[dict objectForKey:@"viewers"] integerValue];;
		
		// 0 for open 1 for Specific
		NSUInteger type = [[dict objectForKey:@"type"] integerValue];
		self.isOpenSubmission = (type == 0) ? YES : NO;
	}
	return self;
}

@end
