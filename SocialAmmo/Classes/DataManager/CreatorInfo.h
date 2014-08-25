//
//  CreatorInfo.h
//  SocialAmmo
//
//  Created by Meenakshi on 31/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


@interface CreatorInfo : NSObject

@property (nonatomic, assign)NSUInteger creatorId;
@property (nonatomic, assign)NSUInteger age;
@property (nonatomic, assign)NSUInteger viewersCount;

@property (nonatomic, assign)CGFloat distance;

@property (nonatomic, strong)NSString* name;
@property (nonatomic, strong)NSString* profilePicUrl;

@property (nonatomic, strong)NSString* email;
@property (nonatomic, strong)NSArray* contentList;

@property (nonatomic, assign)BOOL isSeen;


- (id)initWithInfo:(NSDictionary*)dict;

@end
