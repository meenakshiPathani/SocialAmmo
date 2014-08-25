//
//  eWAY.h
//  EWAYTest
//


#import <Foundation/Foundation.h>
#import "PayflowDefines.h"

typedef void (^CreditCardPaymentCompletedSucessfully) (NSString* receipt);

@interface Payflow : NSObject

+ (void)payFlowPaymentGateWayEnvironment:(payflowEnvironment)environment paymentInfo:(PaymentInfo*)info;
+ (void)presentPayflowPaymentGateWayFromController:(UIViewController *)controller paymentInfo:(PaymentInfo*)info withCompletionBlock:(CreditCardPaymentCompletedSucessfully)block;

@property (nonatomic, assign) CreditCardPaymentCompletedSucessfully completion;

@end
