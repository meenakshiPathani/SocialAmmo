//
//  PrivateMessageInfo.m
//  Social Ammo
//
//  Created by Meenakshi on 22/05/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "PrivateMessageInfo.h"

@implementation PrivateMessageInfo


- (id)initWithInfo:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
	{
		self.messageId = [[dictionary objectForKey:@"id_messages"] integerValue];
		self.messageSent = [[dictionary objectForKey:@"message_sent"] boolValue];

		self.message			= [dictionary objectForKey:@"message"];
		self.attachmentImageUrl = [dictionary objectForKey:@"attachment_image"];
		self.coins				= [[dictionary objectForKey:@"coins"] integerValue];
		
		self.messageType = (EPrivateMessageType)[[dictionary objectForKey:@"attachment_type"] integerValue];
		
		self.senderId				= [[dictionary objectForKey:@"sender_id"] integerValue];
		self.senderName				= [dictionary objectForKey:@"sender_name"];
		self.senderProfilePicUrl	= [dictionary objectForKey:@"sender_profile_pic"];
		
		self.receiverId				= [[dictionary objectForKey:@"receiver_id"] integerValue];
		self.receiverName				= [dictionary objectForKey:@"receiver_name"];
		self.receiverProfilePicUrl	= [dictionary objectForKey:@"receiver_profile_pic"];
				
		self.timeInterval = [[dictionary objectForKey:@"date"] doubleValue];
		self.dateAndTime = [NSDate dateWithTimeIntervalSince1970:self.timeInterval];;
    }
    return self;
}

@end
