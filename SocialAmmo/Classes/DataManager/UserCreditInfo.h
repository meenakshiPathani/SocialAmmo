//
//  UserCreditInfo.h
//  Social Ammo
//
//  Created by Rupesh Kumar on 4/4/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCreditInfo : NSObject
{
	
}

@property (nonatomic, assign) NSUInteger userCredit;
@property (nonatomic, assign) NSUInteger userPost;
@property (nonatomic, assign) NSUInteger weeklyCoins;
@property (nonatomic, assign) NSUInteger totalCoins;
@property (nonatomic, strong) NSString*	 userName;

- (id)initWithInfo:(NSDictionary*)dictionary;

@end
