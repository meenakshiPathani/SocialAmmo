//
//  CardInfoViewController.h
//  EWAYTest
//

#import "PaymentInfo.h"
#import <UIKit/UIKit.h>

typedef enum
{
	kCardNumberTFTag = 101,
	kCardExpiryMonthTFTag,
	kCardExpiryYearTFTag,
} CardInfoTextFieldTag;

typedef void (^CreditCardPaymentCompletedBlock) (NSString* recipt, BOOL status);


@interface CardInfoViewController : UIViewController

@property (nonatomic) CGFloat amount;
@property (nonatomic, strong) PaymentInfo* paymentInfo;

@property (nonatomic, copy) CreditCardPaymentCompletedBlock completion;

- (id)initWithCompletionBlock:(CreditCardPaymentCompletedBlock)block;

@end
