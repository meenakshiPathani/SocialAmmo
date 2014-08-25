//
//  InterestInfo.m
//  Social Ammo
//
//  Created by Meenakshi on 28/01/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "InterestInfo.h"

@implementation InterestInfo

- (id)initWithInterestInfo:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
	{
		self.interestId = [[dictionary objectForKey:@"id"] integerValue];
		self.name = [dictionary objectForKey:@"name"];
    }
    return self;
}

@end
