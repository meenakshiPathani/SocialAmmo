//
//  PrivateMessageInfo.h
//  Social Ammo
//
//  Created by Meenakshi on 22/05/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


@interface PrivateMessageInfo : NSObject
{
	
}
@property (nonatomic, assign)NSUInteger messageId;
@property (nonatomic, assign)BOOL messageSent;

@property (nonatomic, strong)NSString* message;
@property (nonatomic, assign)NSUInteger coins;
@property (nonatomic, strong)NSString* attachmentImageUrl;

@property (nonatomic, assign)EPrivateMessageType messageType;

@property (nonatomic, assign)NSUInteger senderId;
@property (nonatomic, strong)NSString* senderName;
@property (nonatomic, strong)NSString* senderProfilePicUrl;

@property (nonatomic, assign)NSUInteger receiverId;
@property (nonatomic, strong)NSString* receiverName;
@property (nonatomic, strong)NSString* receiverProfilePicUrl;

@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) NSDate*		dateAndTime;

- (id)initWithInfo:(NSDictionary*)dictionary;

@end
