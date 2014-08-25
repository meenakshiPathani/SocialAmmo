//
//  BriefInfo.m
//  Social Ammo
//
//  Created by Meenakshi on 11/02/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "BriefInfo.h"
 
@implementation BriefInfo

- (id)initWithInfo:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
	{
		self.briefId = [[dictionary objectForKey:@"brief_id"] integerValue];
		self.briefTitle = [dictionary objectForKey:@"title"];
		self.description = [dictionary objectForKey:@"info"];
		
//		NSTimeInterval startInterval = [[dictionary objectForKey:@"start"] floatValue];
//		self.startDate = [NSDate dateWithTimeIntervalSince1970:startInterval];
//		NSTimeInterval endInterval = [[dictionary objectForKey:@"end"] floatValue];
//		self.endDate = [NSDate dateWithTimeIntervalSince1970:endInterval];

		self.newSubmission	= [[dictionary objectForKey:@"new"] integerValue];
		self.accepted		= [[dictionary objectForKey:@"accepted"] integerValue];
		self.declined		= [[dictionary objectForKey:@"declined"] integerValue];
		self.credit			= [[dictionary objectForKey:@"credit"] integerValue];
		
		self.newSubmissionNotification		= [[dictionary objectForKey:@"submission_notify"] boolValue];
		self.acceptContentNotification		= [[dictionary objectForKey:@"accepted_notify"] boolValue];
		self.declineContentNotification		= [[dictionary objectForKey:@"declined_notify"] boolValue];
		self.creditNotification				= [[dictionary objectForKey:@"credits_notify"] boolValue];
		
		self.logoImageURL = [dictionary objectForKey:@"logo"];
		
		self.expired = [[dictionary objectForKey:@"expired"] boolValue];
		
		self.fontName = [dictionary objectForKey:@"font"];
		self.briefCreationDate = [dictionary objectForKey:@"creation_date"];
		
		NSDictionary* badges = [dictionary objectForKey:@"badges"];
		NSString* interestList = [badges objectForKey:@"interest_badges"];
		self.interestArray = [interestList componentsSeparatedByString:@","];

		NSString* worldBadge	= [badges objectForKey:@"world_badge"];
		
		NSString* countryBadge	= [badges objectForKey:@"country_badge"];

		NSString* stateBadge	= [badges objectForKey:@"state_badge"];
	
		NSString* suburbBadge	= [badges objectForKey:@"suburb_badge"];
		
		self.locationArray = [[NSArray alloc] initWithObjects:worldBadge, countryBadge, stateBadge, suburbBadge, nil];

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
	{
        //decode properties, other class vars
        self.briefId = [decoder decodeIntForKey:@"briefId"];
        self.briefTitle = [decoder decodeObjectForKey:@"briefTitle"];
        self.description = [decoder decodeObjectForKey:@"description"];
		self.fontName = [decoder decodeObjectForKey:@"fontName"];
		self.logoImage = [decoder decodeObjectForKey:@"logoImage"];
		
		self.interestArray = [decoder decodeObjectForKey:@"interestArray"];
		self.locationArray = [decoder decodeObjectForKey:@"locationArray"];
		
		self.credit = [decoder decodeIntForKey:@"credit"];
		self.cost = [decoder decodeFloatForKey:@"cost"];
		self.noOfContents = [decoder decodeIntForKey:@"noOfContents"];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeInt:(int)self.briefId forKey:@"briefId"];
    [encoder encodeObject:self.briefTitle forKey:@"briefTitle"];
    [encoder encodeObject:self.description forKey:@"description"];
	[encoder encodeObject:self.fontName forKey:@"fontName"];
	[encoder encodeObject:self.logoImage forKey:@"logoImage"];
	
	[encoder encodeObject:self.interestArray forKey:@"interestArray"];
	[encoder encodeObject:self.locationArray forKey:@"locationArray"];
	
	[encoder encodeInt:(int)self.credit forKey:@"credit"];

	[encoder encodeFloat:self.cost forKey:@"cost"];
	[encoder encodeInt:(int)self.noOfContents forKey:@"noOfContents"];
}


@end
