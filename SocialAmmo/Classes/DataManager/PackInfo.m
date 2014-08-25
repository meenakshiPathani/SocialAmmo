//
//  PackInfo.m
//  SocialAmmo
//
//  Created by Meenakshi on 23/06/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "PackInfo.h"

@implementation PackInfo

- (id)initWithInfo:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
	{
		self.packId = [[dictionary objectForKey:@"id"] integerValue];
		self.coin = [[dictionary objectForKey:@"coins"] integerValue];
		self.cost = [[dictionary objectForKey:@"cost"] integerValue];
		
		self.packType = (EPackType)[[dictionary objectForKey:@"type"] integerValue];
		self.packName = [dictionary objectForKey:@"name"];
		self.brandName = [dictionary objectForKey:@"brand"];
		
		self.packContentUrl = [dictionary objectForKey:@"image"];
		self.packIconUrl = [dictionary objectForKey:@"icon"];
		
		self.purchase = [[dictionary objectForKey:@"purchased"] boolValue];
		self.free = [[dictionary objectForKey:@"free"] boolValue];

    }
    return self;
}


@end
