//
//  PaymentHandler.m
//  EWAYTest
//
//  Created by Meenakshi on 08/04/14.
//  Copyright (c) 2014  The Social Ammo. All rights reserved.
//

#import "PaymentHandler.h"
#import "PayflowDefines.h"
#import "PayflowPaymentGateWay.h"
#import "PayflowActivityProgress.h"

@interface PaymentHandler ()

@end

@implementation PaymentHandler

- (instancetype)initWithPaymentInfo:(PaymentInfo *)info;
{
	self = [super init];
	if (self)
	{
		self.info = info;
	}

	return self;
}

- (void)paymentWithCompletionBlock:(PaymentCompletedSucessfully)completionBlock failureBlock:(PaymentFailed)failBlock
{
	if (self.info)
	{
		self.completionBlock = completionBlock;
		self.failureBlock = failBlock;
		
		NSURLRequest *request = [self urlRequest];

		[PayflowActivityProgress showActivityProgress];
		[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
			NSLog(@"Response : %@",[[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding]);
			[PayflowActivityProgress hideActivityProgress];
			if (connectionError)
			{
				NSLog(@"ERROR : %@",connectionError.userInfo);
				[[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",connectionError.userInfo] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
				
				if (self.failureBlock)
					self.failureBlock();
			}
			else
			{
				NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
				NSLog(@"%@",responseStr);
				
				NSError *parseError = nil;
				NSDictionary* dict =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
				
				NSUInteger result = [[dict objectForKey:@"RESULT"] integerValue];

				if (result != 0)
				{
					NSString* message = [dict objectForKey:@"RESPMSG"];
					[[[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
				}
				
				if (self.completionBlock)
					self.completionBlock(responseStr);
			}
		}];
	}
}

#pragma mark - Private Method

- (NSURLRequest *)urlRequest;
{
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

	NSString *urlString;
	PayflowPaymentGateWay *obj = [PayflowPaymentGateWay payflowPaymentGateWayInstance];
	if (obj.environment == payflowProduction)
	{
		urlString = Live_URL;
	}
	else
	{
		urlString = Test_URL;
	}

	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:[self postRequestHttpData]];

	return request;
}

- (NSData *)postRequestHttpData
{
	//PayflowPaymentGateWay *obj = [PayflowPaymentGateWay payflowPaymentGateWayInstance];
	PaymentInfo *paymentInfo = self.info;
//	paymentInfo.creditCardNumber = @"5105105105105100";
//	paymentInfo.expiryDate = @"1219";
	NSString* amount = [paymentInfo.amount stringByReplacingOccurrencesOfString:@"$" withString:@""];
	NSString *body = [NSString stringWithFormat:@"PARTNER=%@&PWD=%@&VENDOR=%@&USER=%@&TENDER=C&ACCT=%@&TRXTYPE=S&EXPDATE=%@&AMT=%@", paymentInfo.partner, paymentInfo.password, paymentInfo.vendor, paymentInfo.user, paymentInfo.creditCardNumber, paymentInfo.expiryDate, amount];
	NSLog(@"%@", body);
	return  [body dataUsingEncoding:NSUTF8StringEncoding];
}

@end
