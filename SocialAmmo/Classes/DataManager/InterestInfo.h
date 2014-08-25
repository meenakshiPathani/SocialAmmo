//
//  InterestInfo.h
//  Social Ammo
//
//  Created by Meenakshi on 28/01/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


@interface InterestInfo : NSObject

@property (nonatomic, assign)NSUInteger interestId;
@property (nonatomic, strong)NSString* name;

- (id)initWithInterestInfo:(NSDictionary*)dictionary;

@end
