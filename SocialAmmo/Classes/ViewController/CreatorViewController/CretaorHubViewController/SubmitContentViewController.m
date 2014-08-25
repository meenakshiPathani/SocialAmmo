//
//  SubmitContentViewController.m
//  SocialAmmo
//
//  Created by Meenakshi on 22/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "AddPaypalInfoViewController.h"
#import "SubmitContentViewController.h"

#define kSaveAlertTag	100
#define kSubmitContentAlertTag 200
#define kImageFileExistAlertTag 300
#define kAddPaypalAlertTag 400

@interface SubmitContentViewController ()
{
	NSString* _imageCaption;
}

@end

@implementation SubmitContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.title = @"Submit";
	[super addBackButton];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSucessPost:) name:kSubmitNotfication object:nil];
	
	if (_gDataManager.createContentForSubmission)
	{
		_submitToCompany.frame = CGRectMake(106, 168, 109, 114);
		_submitToProfile.hidden= YES;
	}
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark- Button actions

- (IBAction) submitToProfileButtonPressed:(id)sender
{
	[self submitContentForCompany:NO];
}

- (IBAction) submitToCompanyButtonPressed:(id)sender
{
	if (_gDataManager.createContentForSubmission)
		[self submitContentForCompany:YES];
	else
		[UIUtils messageAlert:@"Work In Progress" title:nil delegate:nil];
	
	//[self submitContent];
}

- (IBAction) savetoWIPButtonPressed:(id)sender
{
	NSString* message = @"Do you want to save this content in WIP?";
	[UIUtils messageAlertWithOkCancel:message title:nil delegate:self tag:kSaveAlertTag];
}

#pragma mark

- (void) submitContentForCompany:(BOOL)contentForCompany
{
	if ([_textField isFirstResponder])
	[_textField resignFirstResponder];
	
	if (_imageCaption.length > 0)
	{
		if (_gDataManager.userInfo.hasPaymentId)
			[self sendRequestToSubmitContentToCompany:contentForCompany];
		else
			[self displayAddPaypalEmailScreen];

//			[UIUtils messageAlert:@"Please enter the paypal mail to submit the conetnt to brief." title:nil delegate:self withCancelTitle:@"Cancel" otherButtonTitle:@"Continue" tag:kAddPaypalAlertTag];
	}
	else
	{
		[UIUtils messageAlert:@"Please enter the title for the image." title:nil delegate:nil];
	}
	
}

#pragma mark-
#pragma mark TextField delegate methods-

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if (textField.text.length > 0)
		_imageCaption = textField.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
	NSUInteger maxLength = kCaptionMaxLength;
	
	NSUInteger oldLength = [textField.text length];
	NSUInteger replacementLength = [string length];
	NSUInteger rangeLength = range.length;
	
	NSUInteger newLength = oldLength - rangeLength + replacementLength;
	
	BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
	
	return newLength <= maxLength || returnKey;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField;
{
	[textField resignFirstResponder];
	
	return YES;
}

#pragma mark-

#pragma mark-

- (void) sendRequestToSubmitContentToCompany:(BOOL)contentForCompany
{
	DataManager* dataManager = _gDataManager;
	NSUInteger briefId = 0;
	
	if (contentForCompany)
		briefId = dataManager.createContentForSubmissionInfo.submissionId;
	
	[dataManager sendRequestToSubmitContent:self.editedImage caption:_imageCaption forBrief:briefId];
}

#pragma mark-
#pragma mark UIAlertView delegate methods-

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (alertView.tag)
	{
		case kSaveAlertTag:
			if (buttonIndex == 1)
			{
				[_gAppDelegate saveImageInApplicationDirectory:self.editedImage withCaption:_imageCaption];
				[self.navigationController popViewControllerAnimated:YES];
			}
		break;
		case kSubmitContentAlertTag:
			[self.navigationController popToRootViewControllerAnimated:YES];
			break;
		case kAddPaypalAlertTag:
			[self displayAddPaypalEmailScreen];
			break;
	}
}

#pragma  mark -- Notification

- (void) handleSucessPost:(NSNotification*)notifiy
{
	BOOL status = [[notifiy object] boolValue];
	NSDictionary* dict = [notifiy userInfo];
	NSString* message = [dict objectForKey:@"Message"];
	
	if (status)
		[UIUtils messageAlert:message title:nil delegate:self tag: kSubmitContentAlertTag];
	else
		[UIUtils messageAlert:message title:nil delegate:nil];
}

- (void) displayAddPaypalEmailScreen
{
	AddPaypalInfoViewController* viewCtrl = [[AddPaypalInfoViewController alloc]
											 initWithNibName:kAddPaypalInfoViewNib bundle:nil];
	[self.navigationController pushViewController:viewCtrl animated:YES];
}

@end
