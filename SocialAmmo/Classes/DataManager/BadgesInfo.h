//
//  BadgesInfo.h
//  Social Ammo
//
//  Created by Meenakshi on 24/03/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


@interface BadgesInfo : NSObject
{
	
}

@property(nonatomic, strong)NSArray* interestBadgesArray;
@property(nonatomic, strong)NSArray* interestBadgesCountArray;

@property(nonatomic, strong)NSArray* locationBadgeList;

@property(nonatomic, strong)NSArray* locationBadgesArray;
@property(nonatomic, strong)NSArray* locationBadgesCountArray;

@property(nonatomic, assign)BOOL locationBadgesExist;


- (id)initWithInfo:(NSDictionary*)dictionary;

@end


@interface LocationBadgeInfo : NSObject
{
	
}

@property(nonatomic, assign)ELocationType locationType;
@property(nonatomic, assign)NSUInteger locationId;
@property(nonatomic, assign)NSUInteger count;

- (id)initWithLocationType:(ELocationType)type locationId:(NSUInteger)locationId count:(NSUInteger)count;

@end
