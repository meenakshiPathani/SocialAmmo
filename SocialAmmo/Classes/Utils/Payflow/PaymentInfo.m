//
//  PaymentInfo.m
//  PayflowTest
//
//  Created by Meenakshi on 13/05/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "PaymentInfo.h"

@implementation PaymentInfo

- (id)initWithPartner:(NSString*)partner vendor:(NSString*)vendor passoword:(NSString*)password
 {
    self = [super init];
    if (self)
	{
		self.partner = partner;
		self.vendor = vendor;
		self.user = vendor;
		self.password = password;
	}
	return self;
}

@end
