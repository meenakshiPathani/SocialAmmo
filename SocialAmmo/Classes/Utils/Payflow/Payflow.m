//
//  eWAY.m
//  EWAYTest
//


#import "PaymentInfo.h"
#import "Payflow.h"
#import "PayflowPaymentGateWay.h"
#import "CardInfoViewController.h"

@implementation Payflow

+ (void)payFlowPaymentGateWayEnvironment:(payflowEnvironment)environment paymentInfo:(PaymentInfo*)info
{
	PayflowPaymentGateWay *obj = [PayflowPaymentGateWay payflowPaymentGateWayInstance];
	obj.environment = environment;
	obj.paymentInfo = info;
}

+ (void)presentPayflowPaymentGateWayFromController:(UIViewController *)controller paymentInfo:(PaymentInfo*)info withCompletionBlock:(CreditCardPaymentCompletedSucessfully)block
{
	CardInfoViewController *viewC = [[CardInfoViewController alloc] initWithCompletionBlock:^(NSString* recipt, BOOL paymentSucessful){
				block(recipt);
			}];
	viewC.paymentInfo = info;
	UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:viewC];
	navC.navigationBar.barStyle = UIBarStyleBlack;
	[controller presentViewController:navC animated:YES completion:NO];
}

@end
