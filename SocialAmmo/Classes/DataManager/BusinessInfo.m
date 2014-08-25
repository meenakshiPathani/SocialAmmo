//
//  BusinessInfo.m
//  Social Ammo
//
//  Created by Meenakshi on 03/02/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "BusinessInfo.h"

@implementation BusinessInfo

- (id)initWithInfo:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
	{
		self.businessId = [[dictionary objectForKey:@"id"] integerValue];
		self.businessName = [dictionary objectForKey:@"name"];
		self.lowImageURL = [dictionary objectForKey:@"low_image"];
		self.highImageURL = [dictionary objectForKey:@"high_image"];
		self.iPhone5ImageURl = [dictionary objectForKey:@"iphone5_image"];
    }
    return self;
}

@end
