//
//  PaymentHandler.h
//  EWAYTest
//
//  Created by Meenakshi on 08/04/14.
//  Copyright (c) 2014  The Social Ammo. All rights reserved.
//

#import "PaymentInfo.h"
#import <Foundation/Foundation.h>


typedef void (^PaymentCompletedSucessfully) (NSString* receipt);
typedef void (^PaymentFailed) (void);

@interface PaymentHandler : NSObject

@property (strong, nonatomic) PaymentInfo *info;
@property (nonatomic, copy)PaymentCompletedSucessfully completionBlock;
@property (nonatomic, copy)PaymentFailed failureBlock;

- (instancetype)initWithPaymentInfo:(PaymentInfo *)info;

- (void)paymentWithCompletionBlock:(PaymentCompletedSucessfully)completionBlock failureBlock:(PaymentFailed)failBlock;

@end
