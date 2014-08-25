//
//  BriefContentInfo.m
//  Social Ammo
//
//  Created by Rupesh Kumar on 3/20/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "BriefContentInfo.h"

@implementation BriefContentInfo

- (id)initWithInfo:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
	{
		self.contentID = [[dictionary objectForKey:@"content_id"] integerValue];
		self.status = [[dictionary objectForKey:@"status"] integerValue];
		self.userId = [[dictionary objectForKey:@"user_id"] integerValue];
		
		self.creatorPaypalEmail = [dictionary objectForKey:@"paypal_email"];
		
		self.captionName = [dictionary objectForKey:@"caption"];
		self.thumbnilUrl = [dictionary objectForKey:@"thumbnail"];
		
		NSString* firstName = [UIUtils checknilAndWhiteSpaceinString:
							   [dictionary objectForKey:@"first_name"]];
		
		NSString* lastName = [UIUtils checknilAndWhiteSpaceinString:
							   [dictionary objectForKey:@"last_name"]];
		self.userName = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
		
		self.fullImageUrl = [dictionary objectForKey:@"image"];
		self.countryName = [dictionary objectForKey:@"country"];
		self.stateName = [dictionary objectForKey:@"state"];
		self.profilePicUrl = [dictionary objectForKey:@"profile_url"];
		
		self.messageThreadUnlock = [[dictionary objectForKey:@"unlock_message_thread"] boolValue];

    }
    return self;
}

@end
