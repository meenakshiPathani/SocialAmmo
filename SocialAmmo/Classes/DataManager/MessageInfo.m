//
//  MessageInfo.m
//  Social Ammo
//
//  Created by Rupesh Kumar on 5/1/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "NSDate+DateConversions.h"
#import "MessageInfo.h"

@implementation MessageInfo

- (id)initWithInfo:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
	{
		self.messageID = [[dictionary objectForKey:@"id_messages"] integerValue];
		self.userID = [[dictionary objectForKey:@"user_id"] integerValue];
		
		self.contentID = [[dictionary objectForKey:@"content_id"] integerValue];
		self.messageRead = [NSNumber numberWithInteger:
						  [[dictionary objectForKey:@"message_read"]integerValue]];

		self.messageStr = [dictionary objectForKey:@"message"];
		self.messageType = [dictionary objectForKey:@"message_type"];
		self.contentTitle = [dictionary objectForKey:@"content_title"];
		self.userName = [dictionary objectForKey:@"user_name"];
		self.profilePicURl = [dictionary objectForKey:@"profile_pic"];
		self.contentUrl = [dictionary objectForKey:@"content_url"];
		
		self.timeInterval = [[dictionary objectForKey:@"date"] doubleValue];
		self.dateAndTime = [NSDate dateWithTimeIntervalSince1970:self.timeInterval];;
    }
    return self;
}

@end
