//
//  FacebookPageDetail.m
//  Social Ammo
//
//  Created by Rupesh Kumar on 5/21/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "FacebookPageDetail.h"

@implementation FacebookPageDetail

- (id)initWithInfo:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
	{
		self.pageAccesToken = [dictionary objectForKey:@"access_token"];
		self.category = [dictionary objectForKey:@"category"];
		self.pageID = [dictionary objectForKey:@"id"];
		self.pageName = [dictionary objectForKey:@"name"];
    }
    return self;
}

@end
