//
//  BriefListDetailViewController.m
//  Social Ammo
//
//  Created by Rupesh Kumar on 3/20/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "PayPalAddress.h"
#import "PayPalReceiverAmounts.h"
#import "PayPalAmounts.h"
#import "PayPalAdvancedPayment.h"
#import "PayPalInvoiceItem.h"
#import "PayPalInvoiceData.h"
#import "PayPalReceiverPaymentDetails.h"
#import "PayPalPayment.h"

#import "BriefListDetailViewController.h"
#import "NewSubmissionTableCell.h"
#import "ZoomView.h"
#import "BriefContentInfo.h"
#import "ImageZoomViewController.h"

#define  kCellHeight 240.0
#define  kServicealerttag	800.0

// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
// - For testing, use PayPalEnvironmentNoNetwork.
#define kPayPalEnvironment PayPalEnvironmentProduction


typedef enum PaymentStatuses {
	PAYMENTSTATUS_SUCCESS,
	PAYMENTSTATUS_FAILED,
	PAYMENTSTATUS_CANCELED,
} PaymentStatus;


@interface BriefListDetailViewController ()<NewSubmissionTableCellDelegate, PayPalPaymentDelegate>
{
	PaymentStatus _paymentStatus;
	
	BriefContentInfo*	_contentInfo;
	
	NSString*	_paymentKey;
}


@end

@implementation BriefListDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCompletionBlock:(BriefListDetailCompletionBlock)block
{
    self = [super initWithNibName:kBriefListDetailViewNib bundle:nil];
    if (self) {
        // Custom initialization
		self.completion = block;
    }
    return self;
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	[super addBackButton];
	
	[PayPal initializeWithAppID:kPaypalSandboxAppID forEnvironment:ENV_SANDBOX];
	
	self.title = @"New Submission";
	
	UINib* nib = [UINib nibWithNibName:kNewSubmissionTableCellNib bundle:nil];
	[_listTableView registerNib:nib forCellReuseIdentifier:@"NewSubmissionCell"];
	
	if ([_listTableView respondsToSelector:@selector(setSeparatorInset:)])
        [_listTableView setSeparatorInset:UIEdgeInsetsZero];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
	
}

- (void) dealloc
{
	
}
#pragma mark-back button action

-(void) backButtonAction:(UIButton*)sender
{
	self.completion();
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) paymentCancelButtonPressed:(id)sender
{
	[self hidePaymentPopUp];
}

#pragma mark --
#pragma mark -- TableView Data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return _gDataManager.briefContentInfoList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	static NSString* cellIdentifier = @"NewSubmissionCell";
	
	NewSubmissionTableCell* cell = (NewSubmissionTableCell*) [tableView dequeueReusableCellWithIdentifier:
															  cellIdentifier];
	cell.delegate = self;
	cell.backgroundColor = [UIColor clearColor];
	cell.layer.cornerRadius = 10.0;
	
	BriefContentInfo* obj = [_gDataManager.briefContentInfoList objectAtIndex:indexPath.section];
	if (obj)
		[cell setUpInitial:obj];
	
		
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView* headerView = [[UIView alloc] initWithFrame:
						  CGRectMake(0, 0, 320, (section == 0) ? 20:5)];
	headerView.backgroundColor = [UIColor clearColor];
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	// To provide gap between top and other section
    return (section == 0) ? 20:5;
}

#pragma mark -- NewSubmission cell delegate

- (void) handleAcceptAction:(BriefContentInfo*)obj
{
	_contentInfo = obj;
	
	[self showPaymentPopUp];
	
//	[self parallelPaymentWithBriefContentInfo:obj];
	
//	if (_gDataManager.userInfo.futurePaymentEnable)
//		[self sendRequestToAceeptContent:obj];
//	else
//		[self getAuthorizationForFuturePayments];
	
//	[_gDataManager sendRequestToUpdateBriefContent:EBriefPostForAccepted withId:obj.contentID
//									withCompletion:^(BOOL status, NSString* message, ERequestType
//													 requestType){
//								 if (status)
//									 [UIUtils messageAlert:@"Moved to Accepted!" title:@""
//												  delegate:self tag:kServicealerttag];
//								 else
//									 [UIUtils messageAlert:message title:nil delegate:nil];
//							 }];
}

- (void) handleDeclineAction:(BriefContentInfo*)obj
{
	[_gDataManager sendRequestToUpdateBriefContent:EBriefPostForDeclined withId:obj.contentID
									withPaymentKey:@""
									withCompletion:^(BOOL status, NSString* message, ERequestType
													 requestType){
										if (status)
											[UIUtils messageAlert:@"Moved to Decline!" title:@""
														 delegate:self tag:kServicealerttag];
										else
											[UIUtils messageAlert:message title:nil delegate:nil];
									}];
}

- (void) showProfileForId:(NSUInteger)userId
{
//	[super sendRequestToGetProfileInfo:userId userType:ESearchTypeUser];
}

- (void) handleZoomIngwithImage:(NSString*)imageUrl withSender:(UIButton*)sender
{
	if (imageUrl.length > 0)
	{
		ImageZoomViewController* zoomVC = [[ImageZoomViewController alloc] initWithNibName:
										   kImageZoomViewNib bundle :nil];
		UINavigationController* navC = [[UINavigationController alloc] initWithRootViewController:
										zoomVC];
		zoomVC.fullImageURL = imageUrl;

		// Button center animation
		navC.navigationBar.hidden = YES;
		CGPoint pt = [sender center];
		CGRect frame = [sender convertRect:sender.frame toView:self.view];
		pt.y += frame.origin.y;
		zoomVC.closeCenter = pt;
		
		[super popUpView:navC.view fromPoint:pt];
		[self addChildViewController:navC];
        
		/* Zoom by zoom view
		AppDelegate* appDelagte = _gAppDelegate;
		ZoomView* zoomview = [ZoomView zoomView];
		[zoomview showViewWithURL:imageUrl onView:appDelagte.window];
		 */
		
		/* Flip animation code
		zoomVC.fullImageURL = imageUrl;
		UINavigationController *navigationController = [[UINavigationController alloc]
														initWithRootViewController:zoomVC];
		navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
		navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
		[self presentViewController:navigationController animated:YES completion:nil];
		[self.navigationController pushViewController:zoomVC animated:YES];
		 */
	}
	else
		[UIUtils messageAlert:@"Image not available." title:@"" delegate:nil];
}

#pragma mark --
#pragma mark -- Alertview Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		self.completion();
		[self.navigationController popViewControllerAnimated:YES];
	}
}

#pragma mark-

- (void) sendRequestToAceeptContent:(BriefContentInfo*)obj withPaymentKey:(NSString*)key
{
	[_gDataManager sendRequestToUpdateBriefContent:EBriefPostForAccepted withId:obj.contentID
									withPaymentKey:key
									withCompletion:^(BOOL status, NSString* message, ERequestType
													 requestType){
										if (status)
											[UIUtils messageAlert:@"Moved to Accepted!" title:@""
														 delegate:self tag:kServicealerttag];
										else
											[UIUtils messageAlert:message title:nil delegate:nil];
									}];
}

- (void) parallelPayment
{
	//optional, set shippingEnabled to TRUE if you want to display shipping
	//options to the user, default: TRUE
	[PayPal getPayPalInst].shippingEnabled = FALSE;
	
	//optional, set dynamicAmountUpdateEnabled to TRUE if you want to compute
	//shipping and tax based on the user's address choice, default: FALSE
	[PayPal getPayPalInst].dynamicAmountUpdateEnabled = FALSE;
	
	//optional, choose who pays the fee, default: FEEPAYER_EACHRECEIVER
	[PayPal getPayPalInst].feePayer = FEEPAYER_SENDER;
	
	//for a payment with multiple recipients, use a PayPalAdvancedPayment object
	PayPalAdvancedPayment* payment = [[PayPalAdvancedPayment alloc] init] ;
	payment.paymentCurrency = @"AUD";
	
	NSString* ipnURL = [NSString stringWithFormat:@"http://trunk.theammoapp.com/notification?t=%@&c=%lu", _gAppPrefData.sessionToken, (unsigned long)_contentInfo.contentID];
	
	// live
//	NSString* ipnURL = [NSString stringWithFormat:@"http://uat.theammoapp.com/notification?t=%@&c=%lu", _gAppPrefData.sessionToken, (unsigned long)_contentInfo.contentID];
	
	payment.ipnUrl = ipnURL; //@"http://trunk.theammoapp.com/sa_adaptive_ipn.php";

    // A payment note applied to all recipients.
    payment.memo = @"A Note applied to all recipients";
    
	//receiverPaymentDetails is a list of PPReceiverPaymentDetails objects
	payment.receiverPaymentDetails = [NSMutableArray array];
	
	//Frank's Robert's Julie's Bear Parts;
	NSArray *nameArray = [NSArray arrayWithObjects:_contentInfo.creatorPaypalEmail, kSocialAmmoPaypalAccount ,nil];
	
//	NSArray *nameArray = [NSArray arrayWithObjects:@"supriti1111@gmail.com", kSocialAmmoPaypalAccount ,nil];
	
	for (int i = 1; i <= nameArray.count; i++)
	{
		PayPalReceiverPaymentDetails *details = [[PayPalReceiverPaymentDetails alloc] init];
		
        // Customize the payment notes for one of the three recipient.
        
		details.description = [NSString stringWithFormat:@"%@", _contentInfo.captionName];
		
        details.recipient = [nameArray objectAtIndex:i-1];
		details.merchantName = [NSString stringWithFormat:@"%@ Content",[nameArray objectAtIndex:i-1]];
		
		unsigned long long order, tax, shipping;
					
		order = (i==1) ? 5:1 ;//i * 100;
		tax = 0; //i * 7;
		shipping = 0; //i * 14;
		
		//subtotal of all items for this recipient, without tax and shipping
		details.subTotal = [NSDecimalNumber decimalNumberWithMantissa:order exponent:0 isNegative:FALSE];
		
		//invoiceData is a PayPalInvoiceData object which contains tax, shipping, and a list of PayPalInvoiceItem objects
		details.invoiceData = [[PayPalInvoiceData alloc] init] ;
		details.invoiceData.totalShipping = [NSDecimalNumber decimalNumberWithMantissa:shipping exponent:0 isNegative:FALSE];
		details.invoiceData.totalTax = [NSDecimalNumber decimalNumberWithMantissa:tax exponent:0 isNegative:FALSE];
		
		//invoiceItems is a list of PayPalInvoiceItem objects
		//NOTE: sum of totalPrice for all items must equal details.subTotal
		//NOTE: example only shows a single item, but you can have more than one
		details.invoiceData.invoiceItems = [NSMutableArray array];
		PayPalInvoiceItem *item = [[PayPalInvoiceItem alloc] init] ;
		item.totalPrice = details.subTotal;
		item.name = @"Content";
		[details.invoiceData.invoiceItems addObject:item];
				
		[payment.receiverPaymentDetails addObject:details];
	}
	
	[[PayPal getPayPalInst] advancedCheckoutWithPayment:payment];
}

#pragma mark -
#pragma mark PayPalPaymentDelegate methods

-(void)RetryInitialization
{
    [PayPal initializeWithAppID:kPaypalSandboxAppID forEnvironment:ENV_SANDBOX];
	
    //DEVPACKAGE
    //	[PayPal initializeWithAppID:@"your live app id" forEnvironment:ENV_LIVE];
    //	[PayPal initializeWithAppID:@"anything" forEnvironment:ENV_NONE];
}

//paymentSuccessWithKey:andStatus: is a required method. in it, you should record that the payment
//was successful and perform any desired bookkeeping. you should not do any user interface updates.
//payKey is a string which uniquely identifies the transaction.
//paymentStatus is an enum value which can be STATUS_COMPLETED, STATUS_CREATED, or STATUS_OTHER
- (void)paymentSuccessWithKey:(NSString *)payKey andStatus:(PayPalPaymentStatus)paymentStatus
{
	NSLog(@"%@", payKey);
	_paymentKey = payKey;
	
	[self hidePaymentPopUp];

	NSMutableDictionary* response = [PayPal getPayPalInst].responseMessage;
	NSLog(@"%@", response);
	
    NSString *severity = [[PayPal getPayPalInst].responseMessage objectForKey:@"severity"];
	NSLog(@"severity: %@", severity);
	NSString *category = [[PayPal getPayPalInst].responseMessage objectForKey:@"category"];
	NSLog(@"category: %@", category);
	NSString *errorId = [[PayPal getPayPalInst].responseMessage objectForKey:@"errorId"];
	NSLog(@"errorId: %@", errorId);
	NSString *message = [[PayPal getPayPalInst].responseMessage objectForKey:@"message"];
	NSLog(@"message: %@", message);
    
	_paymentStatus = PAYMENTSTATUS_SUCCESS;
	
}

//paymentFailedWithCorrelationID is a required method. in it, you should
//record that the payment failed and perform any desired bookkeeping. you should not do any user interface updates.
//correlationID is a string which uniquely identifies the failed transaction, should you need to contact PayPal.
//errorCode is generally (but not always) a numerical code associated with the error.
//errorMessage is a human-readable string describing the error that occurred.
- (void)paymentFailedWithCorrelationID:(NSString *)correlationID
{
	_paymentKey = nil;
	
	[self hidePaymentPopUp];

    NSString *severity = [[PayPal getPayPalInst].responseMessage objectForKey:@"severity"];
	NSLog(@"severity: %@", severity);
	NSString *category = [[PayPal getPayPalInst].responseMessage objectForKey:@"category"];
	NSLog(@"category: %@", category);
	NSString *errorId = [[PayPal getPayPalInst].responseMessage objectForKey:@"errorId"];
	NSLog(@"errorId: %@", errorId);
	NSString *message = [[PayPal getPayPalInst].responseMessage objectForKey:@"message"];
	NSLog(@"message: %@", message);
    
	_paymentStatus = PAYMENTSTATUS_FAILED;
}

//paymentCanceled is a required method. in it, you should record that the payment was canceled by
//the user and perform any desired bookkeeping. you should not do any user interface updates.
- (void)paymentCanceled {
	_paymentStatus = PAYMENTSTATUS_CANCELED;
}

//paymentLibraryExit is a required method. this is called when the library is finished with the display
//and is returning control back to your app. you should now do any user interface updates such as
//displaying a success/failure/canceled message.
- (void)paymentLibraryExit
{
	[self hidePaymentPopUp];

	UIAlertView *alert = nil;
	switch (_paymentStatus) {
		case PAYMENTSTATUS_SUCCESS:
			[self sendRequestToAceeptContent:_contentInfo withPaymentKey:_paymentKey];
			break;
		case PAYMENTSTATUS_FAILED:
			alert = [[UIAlertView alloc] initWithTitle:@"Order failed"
											   message:@"Your order failed. Touch \"Pay with PayPal\" to try again."
											  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			break;
		case PAYMENTSTATUS_CANCELED:
			alert = [[UIAlertView alloc] initWithTitle:@"Order canceled"
											   message:@"You canceled your order. Touch \"Pay with PayPal\" to try again."
											  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			break;
	}
	[alert show];
}

- (PayPalAmounts *)adjustAmountsForAddress:(PayPalAddress const *)inAddress andCurrency:(NSString const *)inCurrency andAmount:(NSDecimalNumber const *)inAmount
									andTax:(NSDecimalNumber const *)inTax andShipping:(NSDecimalNumber const *)inShipping andErrorCode:(PayPalAmountErrorCode *)outErrorCode {
	//do any logic here that would adjust the amount based on the shipping address
	PayPalAmounts *newAmounts = [[PayPalAmounts alloc] init] ;
	newAmounts.currency = @"AUD";
	newAmounts.payment_amount = (NSDecimalNumber *)inAmount;
	
	//change tax based on the address
	if ([inAddress.state isEqualToString:@"CA"]) {
		newAmounts.tax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[inAmount floatValue] * .1]];
	} else {
		newAmounts.tax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[inAmount floatValue] * .08]];
	}
	newAmounts.shipping = (NSDecimalNumber *)inShipping;
	
	//if you need to notify the library of an error condition, do one of the following
	//*outErrorCode = AMOUNT_ERROR_SERVER;
	//*outErrorCode = AMOUNT_CANCEL_TXN;
	//*outErrorCode = AMOUNT_ERROR_OTHER;
    
	return newAmounts;
}

//adjustAmountsAdvancedForAddress:andCurrency:andReceiverAmounts:andErrorCode: is optional. you only need to
//provide this method if you wish to recompute tax or shipping when the user changes his/her shipping address.
//for this method to be called, you must enable shipping and dynamic amount calculation on the PayPal object.
//the library will try to use this version first, but will use the simple one if this one is not implemented.
- (NSMutableArray *)adjustAmountsAdvancedForAddress:(PayPalAddress const *)inAddress andCurrency:(NSString const *)inCurrency
								 andReceiverAmounts:(NSMutableArray *)receiverAmounts andErrorCode:(PayPalAmountErrorCode *)outErrorCode {
	NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:[receiverAmounts count]];
	for (PayPalReceiverAmounts *amounts in receiverAmounts) {
		//leave the shipping the same, change the tax based on the state
		if ([inAddress.state isEqualToString:@"CA"]) {
			amounts.amounts.tax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[amounts.amounts.payment_amount floatValue] * .1]];
		} else {
			amounts.amounts.tax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[amounts.amounts.payment_amount floatValue] * .08]];
		}
		[returnArray addObject:amounts];
	}
	
	//if you need to notify the library of an error condition, do one of the following
	//*outErrorCode = AMOUNT_ERROR_SERVER;
	//*outErrorCode = AMOUNT_CANCEL_TXN;
	//*outErrorCode = AMOUNT_ERROR_OTHER;
	
	return returnArray;
}

#pragma mark-

- (void) showPaymentPopUp
{
	_paymentAlertLabel.text = @"Pay $6 to accept the content.";
	UIButton* button = [[PayPal getPayPalInst] getPayButtonWithTarget:self andAction:@selector(parallelPayment) andButtonType:BUTTON_152x33];
	CGRect frame = button.frame;
	frame.origin.x = 64;
	frame.origin.y = 40;
	button.frame = frame;
	[_paymentAlertView addSubview:button];
	
	[self.view addSubview:_paymentAlertBackgroundView];
}

- (void) hidePaymentPopUp
{
	[_paymentAlertBackgroundView removeFromSuperview];
}

@end
