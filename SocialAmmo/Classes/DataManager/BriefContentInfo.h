//
//  BriefContentInfo.h
//  Social Ammo
//
//  Created by Rupesh Kumar on 3/20/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

@interface BriefContentInfo : NSObject
{
	
}

@property (nonatomic, assign)NSUInteger contentID;
@property (nonatomic, assign)NSUInteger status;
@property (nonatomic, assign)NSUInteger userId;

@property (nonatomic, strong)NSString* captionName;
@property (nonatomic, strong)NSString* fullImageUrl;
@property (nonatomic, strong)NSString* thumbnilUrl;
@property (nonatomic, strong)NSString* userName;
@property (nonatomic, strong)NSString* countryName;
@property (nonatomic, strong)NSString* profilePicUrl;
@property (nonatomic, strong)NSString* stateName;

@property (nonatomic, strong)NSString* creatorPaypalEmail;

@property (nonatomic, assign)BOOL messageThreadUnlock;


- (id)initWithInfo:(NSDictionary*)dictionary;

@end
