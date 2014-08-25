//
//  UserBusinessInfo.h
//  Social Ammo
//
//  Created by Meenakshi on 12/03/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "BadgesInfo.h"

@interface SearchUserInfo : NSObject

//buisnessInfo
@property (nonatomic, assign)NSUInteger userRank;

@property (nonatomic, assign)NSUInteger businessId;
@property (nonatomic, assign)NSUInteger activeBriefs;

@property (nonatomic, strong)NSString* businessName;
@property (nonatomic, strong)NSString* businessType;
@property (nonatomic, strong)NSString* buisnessImageUrl;

//userInfo
@property (nonatomic, assign)NSUInteger userId;
@property (nonatomic, assign)NSUInteger postCount;

@property (nonatomic, strong)NSString* userName;
@property (nonatomic, strong)NSString* firstName;
@property (nonatomic, strong)NSString* lastName;

@property (nonatomic, strong)NSString* lastPostDate;
@property (nonatomic, strong)NSString* profileImageUrl;


//common
@property (nonatomic, strong)BadgesInfo* badges;




- (id)initWithInfo:(NSDictionary*)dictionary;

@end
