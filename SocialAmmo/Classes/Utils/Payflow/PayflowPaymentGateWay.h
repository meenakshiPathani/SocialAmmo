//
//  EWAYPaymentGateWay.h
//  EWAYTest
//
//  Created by Meenakshi on 08/04/14.
//  Copyright (c) 2014  The Social Ammo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayflowDefines.h"
#import "PaymentInfo.h"


@interface PayflowPaymentGateWay : NSObject

@property (nonatomic) payflowEnvironment environment;
@property (nonatomic, strong)PaymentInfo* paymentInfo;

+ (PayflowPaymentGateWay *)payflowPaymentGateWayInstance;

@end
