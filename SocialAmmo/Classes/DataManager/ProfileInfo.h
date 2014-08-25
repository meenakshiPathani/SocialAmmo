//
//  ProfileInfo.h
//  Social Ammo
//
//  Created by Meenakshi on 19/03/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "BadgesInfo.h"

@interface ProfileInfo : NSObject

@property (nonatomic, assign)NSUInteger userId;

@property (nonatomic, assign)NSUInteger userType;

@property (nonatomic, assign)NSUInteger activeBriefsCount;
@property (nonatomic, assign)NSUInteger pastBriefsCount;
@property (nonatomic, assign)NSUInteger posts;
@property (nonatomic, assign)NSUInteger friends;

@property (nonatomic, assign)BOOL messageThreadUnlock; // 0 for lock 1 for unlock


@property (nonatomic, strong)NSString* name;
@property (nonatomic, strong)NSString* businessType;
@property (nonatomic, strong)NSString* profileImageUrl;
@property (nonatomic, strong)NSString* lastPostDate;

@property (nonatomic, strong)NSString* lastImageUrl;

@property (nonatomic, strong)BadgesInfo* badges;

@property (nonatomic, strong)NSArray* contentList;

- (id)initWithInfo:(NSDictionary*)dictionary;

@end
