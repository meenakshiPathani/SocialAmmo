//
//  EWAYPaymentGateWay.m
//  EWAYTest
//
//  Created by Meenakshi on 08/04/14.
//  Copyright (c) 2014  The Social Ammo. All rights reserved.
//

#import "PayflowPaymentGateWay.h"
#import "CardInfoViewController.h"

@interface PayflowPaymentGateWay ()

@end

@implementation PayflowPaymentGateWay

+ (PayflowPaymentGateWay *)payflowPaymentGateWayInstance
{
	static PayflowPaymentGateWay *sSharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sSharedInstance = [[PayflowPaymentGateWay alloc] init];
		sSharedInstance.environment = payflowSandbox;
	});

	return sSharedInstance;
}

@end
