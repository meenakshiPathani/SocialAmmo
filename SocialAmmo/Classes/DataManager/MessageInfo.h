//
//  MessageInfo.h
//  Social Ammo
//
//  Created by Rupesh Kumar on 5/1/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageInfo : NSObject
{
	
}

@property (nonatomic, assign) NSUInteger	messageID;
@property (nonatomic, strong) NSString*		messageStr;
@property (nonatomic, strong) NSString*		messageType;
@property (nonatomic, strong) NSNumber*		messageRead;
@property (nonatomic, assign) NSUInteger	contentID;
@property (nonatomic, strong) NSString*		contentTitle;
@property (nonatomic, assign) NSUInteger    userID;
@property (nonatomic, strong) NSString*		userName;
@property (nonatomic, strong) NSString*		profilePicURl;
@property (nonatomic, strong) NSString*		contentUrl;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) NSDate*		dateAndTime;


- (id)initWithInfo:(NSDictionary*)dictionary;

@end
