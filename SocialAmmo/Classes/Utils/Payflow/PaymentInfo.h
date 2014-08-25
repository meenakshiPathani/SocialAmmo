//
//  PaymentInfo.h
//  PayflowTest
//
//  Created by Meenakshi on 13/05/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentInfo : NSObject
{
	
}
@property (strong, nonatomic) NSString *partner;
@property (strong, nonatomic) NSString *vendor;
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSString *password;

@property (strong, nonatomic) NSString *creditCardNumber;
@property (strong, nonatomic) NSString *expiryDate;
@property (strong, nonatomic) NSString *cvv;
@property (strong, nonatomic) NSString *amount;

- (id)initWithPartner:(NSString*)partner vendor:(NSString*)vendor passoword:(NSString*)password;


@end
