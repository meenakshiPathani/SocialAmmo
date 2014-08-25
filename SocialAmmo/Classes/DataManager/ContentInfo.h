//
//  ContentInfo.h
//  Social Ammo
//
//  Created by Meenakshi on 18/02/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "BadgesInfo.h"

@interface ContentInfo : NSObject
{
	
}
@property (nonatomic, assign)NSUInteger contentId;

@property (nonatomic, strong)NSString* thumbnailUrl;
@property (nonatomic, strong)NSString* caption;

@property (nonatomic, strong)NSString* firstName;
@property (nonatomic, strong)NSString* lastName;
@property (nonatomic, strong)NSString* buisnessName;

@property (nonatomic, assign)NSUInteger likeCount;
@property (nonatomic, assign)NSUInteger commentCount;

@property (nonatomic, assign)NSUInteger userId;
@property (nonatomic, assign)NSUInteger businessId;

@property (nonatomic, strong)NSString* contentImageUrl;
@property (nonatomic, strong)NSString* userImageUrl;
@property (nonatomic, strong)NSString* businesImageUrl;

@property (nonatomic, strong)BadgesInfo* badges;

- (id)initWithInfo:(NSDictionary*)dictionary;

@end
