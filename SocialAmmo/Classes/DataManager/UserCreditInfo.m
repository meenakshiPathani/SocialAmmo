//
//  UserCreditInfo.m
//  Social Ammo
//
//  Created by Rupesh Kumar on 4/4/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "UserCreditInfo.h"

@implementation UserCreditInfo

- (id)initWithInfo:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
	{
		self.userCredit = [[dictionary objectForKey:@"user_credits"] integerValue];
		_gDataManager.userCredits = self.userCredit;
		
		self.userPost = [[dictionary objectForKey:@"posts"] integerValue];
		self.weeklyCoins = [[dictionary objectForKey:@"weekly_coins"] integerValue];
		self.totalCoins = [[dictionary objectForKey:@"total_coins"] integerValue];
		self.userName = [dictionary objectForKey:@"name"];
    }
    return self;
}

@end
