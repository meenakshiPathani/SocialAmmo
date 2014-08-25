//
//  BadgesInfo.m
//  Social Ammo
//
//  Created by Meenakshi on 24/03/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "BadgesInfo.h"

#define kSeparator			@"|"

@implementation BadgesInfo

- (id)initWithInfo:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
	{
		NSString* badges = [dictionary objectForKey:@"interest_badges"];
		if (badges.length > 0)
			self.interestBadgesArray = [badges componentsSeparatedByString:kSeparator];
		
		badges = [dictionary objectForKey:@"interest_badges_count"];
		if (badges.length > 0)
			self.interestBadgesCountArray = [badges componentsSeparatedByString:kSeparator];
		
		NSArray* locationBadgeList = nil;
		NSArray* locationBadgeCountList = nil;

		badges = [dictionary objectForKey:@"location_badges"];
		if (badges.length > 0)
			locationBadgeList = [badges componentsSeparatedByString:kSeparator];
		
		badges = [dictionary objectForKey:@"location_badges_count"];
		if (badges.length > 0)
			locationBadgeCountList = [badges componentsSeparatedByString:kSeparator];
		
		NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:locationBadgeList.count];
		for (int i = 0; i < locationBadgeList.count; ++i)
		{
			ELocationType locationType = i + ELocationTypeWorld;
			NSUInteger locationId = [[locationBadgeList objectAtIndex:i] integerValue];
			NSUInteger count = [[locationBadgeCountList objectAtIndex:i] integerValue];
			
			LocationBadgeInfo* info = [[LocationBadgeInfo alloc] initWithLocationType:locationType locationId:locationId count:count];
			
			[array addObject:info];
		}
		NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"count"
													  ascending:NO];
		NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
		// sorted location list
		self.locationBadgeList = [array sortedArrayUsingDescriptors:sortDescriptors];

		self.locationBadgesExist = [self isLocationBadges];		
    }
    return self;
}

- (BOOL) isLocationBadges
{
	for (LocationBadgeInfo* info in self.locationBadgeList)
	{
		if (info.locationId != 0)
			return YES;
	}
	return NO;
}

@end

@implementation LocationBadgeInfo

- (id)initWithLocationType:(ELocationType)type locationId:(NSUInteger)locationId count:(NSUInteger)count
{
    self = [super init];
    if (self)
	{
		self.locationType = type;
		self.locationId = locationId;
		self.count = count;
    }
    return self;
}

@end

