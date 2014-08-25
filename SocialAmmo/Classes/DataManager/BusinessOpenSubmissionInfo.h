//
//  BusinessOpenSubmissionInfo.h
//  SocialAmmo
//
//  Created by Meenakshi on 01/08/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


@interface BusinessOpenSubmissionInfo : NSObject

@property (nonatomic, assign)NSUInteger businessId;
@property (nonatomic, assign)NSUInteger submissionId;
@property (nonatomic, assign)CGFloat distance;
@property (nonatomic, assign)NSUInteger specificSubmisisonCount;
@property (nonatomic, assign)NSUInteger unseenSpecificSubmisisonCount;

@property (nonatomic, strong)NSString* name;
@property (nonatomic, strong)NSString* description;

@property (nonatomic, strong)NSString* profilePicUrl;

@property (nonatomic, strong)NSString* email;
@property (nonatomic, strong)NSArray* contentList;

@property (nonatomic, assign)BOOL isSeen;


- (id)initWithInfo:(NSDictionary*)dict;

@end
