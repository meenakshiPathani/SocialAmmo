//
//  SubmissionInfo.h
//  SocialAmmo
//
//  Created by Meenakshi on 17/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


@interface SubmissionInfo : NSObject

@property (nonatomic, assign)ESubmissionType submissionType;

@property (nonatomic, assign)NSUInteger businessId;

@property (nonatomic, assign)NSUInteger submisionId;
@property (nonatomic, assign)NSUInteger radius;
@property (nonatomic, assign)NSUInteger submittedContentCount;
@property (nonatomic, assign)NSUInteger viewCount;

@property (nonatomic, strong)NSString* submissionName;
@property (nonatomic, strong)NSString* submissionDescription;
@property (nonatomic, strong)NSString* font;

@property (nonatomic, strong)NSArray* selectedInterestIds;

@property (nonatomic, strong)UIImage* logoImage;
@property (nonatomic, assign)BOOL isOpenSubmission;

@property (nonatomic, assign)CGFloat distance;
@property (nonatomic, assign)NSUInteger specificSubmisisonCount;
@property (nonatomic, assign)NSUInteger unseenSpecificSubmisisonCount;

@property (nonatomic, strong)NSString* logoImageURL;

@property (nonatomic, strong)NSString* email;

@property (nonatomic, assign)BOOL isSeen;


- (id)initWithSubmissionType:(ESubmissionType)type;
- (id)initWithInfo:(NSDictionary*)dict;

@end
