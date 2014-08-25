//
//  CardInfoViewController.m
//  EWAYTest
//

#import "CardInfoViewController.h"
#import "PayflowDefines.h"
#import "PaymentHandler.h"
#import <QuartzCore/QuartzCore.h>

@interface CardInfoViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *cardHolderNameTF;
@property (strong, nonatomic) IBOutlet UITextField *cardNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *cardExpiryMonthTF;
@property (strong, nonatomic) IBOutlet UITextField *cardExpiryYearTF;
@property (strong, nonatomic) IBOutlet UITextField *cardCVVTF;
@property (strong, nonatomic) IBOutlet UILabel *amountValueLabel;
@property (strong, nonatomic) IBOutlet UIButton *payButton;

@property (strong, nonatomic) UITextField *currentTF;
@property (strong, nonatomic) NSArray *textFieldArray;

@property (strong, nonatomic) id keyBoardWillShowObserver;
@property (strong, nonatomic) id keyBoardWillHideObserver;

@end

@implementation CardInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCompletionBlock:(CreditCardPaymentCompletedBlock)block
{
    self = [super initWithNibName:@"CardInfoView" bundle:nil];
    if (self) {
        // Custom initialization
		self.title = @"Credit Card Info";
		self.completion = block;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	self.navigationItem.rightBarButtonItem = cancelButton;
	self.textFieldArray = @[self.cardNumberTF, self.cardExpiryMonthTF, self.cardExpiryYearTF];

	self.amountValueLabel.text = self.paymentInfo.amount; //[NSString stringWithFormat:@"%.2f",[self.paymentInfo.amount floatValue]];
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
	[self.view addGestureRecognizer:tapGesture];

	self.cardHolderNameTF.layer.cornerRadius = 5.0f;
	self.cardNumberTF.layer.cornerRadius = 5.0f;
	self.cardExpiryMonthTF.layer.cornerRadius = 5.0f;
	self.cardExpiryYearTF.layer.cornerRadius = 5.0f;
	self.cardCVVTF.layer.cornerRadius = 5.0f;
	self.payButton.layer.cornerRadius = 5.0f;

	[self addKeyBoardObserver];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	self.scrollView.contentSize = CGSizeMake(0.0f, CGRectGetMaxY(self.payButton.frame) + 20);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleDefault;
}

- (void)dealloc
{
	[self removeKeyBoardObserver];
}

- (void)tapGestureHandler:(UITapGestureRecognizer *)gesture
{
	[self allTextFieldResignFirstResponder];
}

- (void)allTextFieldResignFirstResponder
{
	[self.textFieldArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[(UITextField *)obj resignFirstResponder];
	}];
}

- (void)addKeyBoardObserver
{
	NSOperationQueue *queue = [NSOperationQueue mainQueue];

	self.keyBoardWillHideObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:queue usingBlock:^(NSNotification *note) {
		self.scrollView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame),
										   CGRectGetHeight(self.view.frame));
	}];

	self.keyBoardWillShowObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
		NSDictionary *dict = note.userInfo;
		CGRect rect = [[dict valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
		self.scrollView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame),
										   CGRectGetHeight(self.view.frame) - CGRectGetHeight(rect));
	}];
}

- (void)removeKeyBoardObserver
{
	if (self.keyBoardWillHideObserver)
	{
		[[NSNotificationCenter defaultCenter] removeObserver:self.keyBoardWillHideObserver];
	}

	if (self.keyBoardWillShowObserver)
	{
		[[NSNotificationCenter defaultCenter] removeObserver:self.keyBoardWillShowObserver];
	}
}

- (BOOL)validateUserInputs
{
//	if (!(self.cardHolderNameTF.text.length > 0))
//	{
//		[[[UIAlertView alloc] initWithTitle:nil message:@"Card holder name field can't be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
//		return NO;
//	}
	if (!(self.cardNumberTF.text.length >= 13  && self.cardNumberTF.text.length <= 20))
	{
		[[[UIAlertView alloc] initWithTitle:nil message:@"Please enter vaild card number" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
		return NO;
	}

	if (!(self.cardExpiryMonthTF.text.length > 0))
	{
		[[[UIAlertView alloc] initWithTitle:nil message:@"Card expiry date month field can't be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
		return NO;
	}
	else if(self.cardExpiryMonthTF.text.integerValue == 0)
	{
		[[[UIAlertView alloc] initWithTitle:nil message:@"Card expiry date month field can't be zero" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
		return NO;
	}

	if (!(self.cardExpiryYearTF.text.length > 0))
	{
		[[[UIAlertView alloc] initWithTitle:nil message:@"Card expiry date year can't be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
		return NO;
	}

//	if (!(self.cardCVVTF.text.length > 0))
//	{
//		[[[UIAlertView alloc] initWithTitle:nil message:@"Card cvv number field can't be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
//		return NO;
//	}

	return YES;
}

#pragma mark - Button Action
- (IBAction)payment:(id)sender
{
	if (![self validateUserInputs])
	{
		return;
	}
	
	NSString* expiryDate = [NSString stringWithFormat:@"%@%@",self.cardExpiryMonthTF.text,self.cardExpiryYearTF.text];
	
	self.paymentInfo.creditCardNumber = self.cardNumberTF.text;
	self.paymentInfo.expiryDate = expiryDate;

	PaymentHandler *paymentHandler = [[PaymentHandler alloc] initWithPaymentInfo:self.paymentInfo];
	[paymentHandler paymentWithCompletionBlock:^(NSString* receipt){
		NSLog(@"%@",receipt);
		self.completion(receipt, YES);

		[self dismissViewControllerAnimated:YES completion:nil];
		

	} failureBlock:^{
//		[self dismissViewControllerAnimated:YES completion:nil];
//
//		self.completion(nil, NO);

	}];
}

- (IBAction)cancel:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//	BOOL enablePayButton = NO;
//	enablePayButton = enablePayButton && (self.cardHolderNameTF.text.length > 0) && (self.cardExpiryMonthTF.text.length > 0) && (self.cardExpiryYearTF.text.length > 0)  && (self.cardNumberTF.text.length >= 13  && self.cardNumberTF.text.length <= 20) && (self.cardNumberTF.text.length >= 13  && self.cardNumberTF.text.length <= 20);

	switch (textField.tag) {
//		case kCardHholderNameTFTag :
//			if (range.location < 50)
//				return YES;
//			break;

		case kCardNumberTFTag :
			if (range.location < 20)
			{
				if (range.location == 0)
				{
					NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"3456"];
					if (string.length == 0 || [charSet isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:string]])
					{
						return YES;
					}
				}
				else
				{
					return  YES;
				}
			}

			break;

		case kCardExpiryMonthTFTag :
			if (range.location < 2)
			{
				NSString *month = [textField.text stringByReplacingCharactersInRange:range withString:string];
				if (0 <= month.integerValue && month.integerValue < 13)
					return YES;
			}
			break;

		case kCardExpiryYearTFTag :
			if (range.location < 2)
				return YES;
			break;

//		case kCardCVVTFTag :
//			if (range.location  < 4)
//				return YES;
//			break;

		default:
			return NO;
			break;
	}

	return NO;
}

@end
