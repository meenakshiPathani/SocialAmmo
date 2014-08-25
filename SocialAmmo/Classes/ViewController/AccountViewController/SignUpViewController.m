//
//  NewSignUpViewController.m
//  SocialAmmo
//
//  Created by Rupesh Kumar on 6/30/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "AddPaypalInfoViewController.h"
#import "AppPrefData.h"
#import "HomeViewController.h"
#import "LinkedInCompanyListVC.h"
#import "AFHTTPRequestOperation.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"

#import "CreatorLocationViewController.h"
#import "BusinessLocationViewController.h"
#import "SignUpViewController.h"
#import "SCAFacebookSession.h"


#define  kValidImage [UIImage imageNamed:@"tick.png"]
#define  kInvalidImage [UIImage imageNamed:@"x.png"]

#define KLinkedInAlert 100

@interface SignUpViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
	LIALinkedInHttpClient*		_client;
	LinkedInCompanyListVC*	_companyListVC;

	UIGestureRecognizer*	_touchRecognizer;
	NSString*	_linkedInEmail;

	BOOL	_signUpUsingLinkedIn;
}
@end

@implementation SignUpViewController

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
	[self setUpDesignForUserType:self.userInfo.userType];

	[self addGestureRecognizer];
	if(kIPhone5)
		_scrollView.scrollEnabled = NO;
	else
		_scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width,
											 _scrollView.frame.size.height+10);
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleDefault ;
}

- (void) dealloc
{
	_scrollView.delegate = nil;
}

#pragma mark-

-(void) addGestureRecognizer
{
	if (_touchRecognizer == nil)
		_touchRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
	[self.view addGestureRecognizer:_touchRecognizer];
}

#pragma mark-
#pragma mark TextField delegate methods-

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	_currentTextField = textField;
	if(!kIPhone5)
		_scrollView.contentInset = UIEdgeInsetsMake(0, 0,120 , 0);
	
	if (textField.tag ==  EuserIndustryType)
		[self displayPickerView];
	
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	//	CGPoint offset = CGPointMake(0, CGRectGetMaxY(textField.frame));
	if(!kIPhone5)
		[self setUpScrollViewOffSet:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	_scrollView.contentInset = UIEdgeInsetsZero;
	[_scrollView setContentOffset:CGPointZero animated:YES];
	
	if (![_gAppPrefData isLogin])
		[self validateQuickInfo:textField.tag withUniqueValidation:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
	[textField resignFirstResponder];
	
	return YES;
}

- (void) setUpScrollViewOffSet:(UITextField*)tField
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	NSLog(@"%f",tField.frame.origin.y);
	CGFloat hijj = tField.frame.origin.y;
	
	//	CGFloat hijj = tField.frame.origin.y-70;
	//	if(hijj < 0)
	//		 hijj = hijj + 70.0;
	//
	_scrollView.contentOffset = CGPointMake(0,hijj-10);
	NSLog(@"%f",hijj);
	[UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
	NSUInteger maxLength = kMaxLength;
	
	maxLength = [self getMaxLengthForFieldWithTag:textField.tag];
	
	NSUInteger oldLength = [textField.text length];
	NSUInteger replacementLength = [string length];
	NSUInteger rangeLength = range.length;
	
	NSUInteger newLength = oldLength - rangeLength + replacementLength;
	
	BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
	
	return newLength <= maxLength || returnKey;
}

- (NSInteger) getMaxLengthForFieldWithTag:(NSInteger)tag
{
	NSInteger maxLength = 0;
	switch (tag)
	{
		case EUserFirstName:
			maxLength = kFirstNameMaxlength;
			break;
			
		case EUserLastname:
			maxLength = kLastNameMaxLength;
			break;
			
		case EuserBusiness:
			maxLength = kBuisnessNameMaxLength;
			break;
			
		case EUserEmail:
			maxLength = kEmailMaxLength;
			break;
			
		case EUserPassword:
			maxLength = kPasswordMaxLength;
			break;
			
		case EUserDOB:
			maxLength = kDOBMaxLength;
			break;
			
		default:
			maxLength = kMaxLength;
			break;
	}
	
	return maxLength;
}


#pragma mark-
#pragma mark -- ButtonAction

- (IBAction) profilePicButtonaction:(id)sender
{
	if ([_currentTextField isFirstResponder] )
		[_currentTextField resignFirstResponder];
	
	[self displayActionSheet];
}

- (IBAction) nextbtnAction:(id)sender
{
	//	[self displayLocationScreen];
	[_currentTextField resignFirstResponder];
	
	if ( _signUpUsingLinkedIn || ([self checkForFinalValidation]))
	{
		[_currentTextField resignFirstResponder];
		
		[self setUserinfoForsignUp];
	}
}

- (IBAction) backButtonAction:(id)sender
{
	self.userInfo = nil;
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) signUpwithFaceBookAction:(id)sender
{
	[_currentTextField resignFirstResponder];
	
	[self logInToFacebookSignUp];
}

- (IBAction) signUpWithLinkdIn:(id)sender
{
	[_currentTextField resignFirstResponder];
	
	[self loginToLinkedIn];
}

- (IBAction) donebtnAction:(id)sender
{
	[_currentTextField resignFirstResponder];
	//	[self isValidateIndustry:_industrytextField.text];
}

#pragma  mark -- Valdation check methods

- (BOOL) validateQuickInfo:(NSInteger)currenttag withUniqueValidation:(BOOL)isUniqueValid
{
	// VALIDATE THE EACH TEXT FIELD
	BOOL isValidate = NO;
	
	UITextField* currentField = (UITextField*)[self.view viewWithTag:currenttag];
	NSString* currentStr = (currenttag == EUserProfilePic)?@"":[UIUtils checknilAndWhiteSpaceinString:currentField.text];
	
	switch (currenttag)
	{
			// Validate the first name field
		case EUserFirstName:
		{
			isValidate = (self.userInfo.userType == EUserTypeBuisness)
			?	YES:	[self isNameFieldValid:currentStr];
		}
			break;
			
		case EUserLastname:
		{
			isValidate =  (self.userInfo.userType == EUserTypeBuisness)
			? YES : [self isNameFieldValid:currentStr];
		}
			break;
			
			
		case EuserBusiness:
		{
			isValidate = (self.userInfo.userType == EUserTypeCreator)
			?YES:[self isNameFieldValid:currentStr];
			if (isValidate)
			{
				((self.userInfo.userType == EUserTypeBuisness) && isUniqueValid)?[self sendRequestToValidateToUniqueBusinessname]:NSLog(@"checked");
			}
		}
			break;
			
			
		case EUserEmail:
		{
			isValidate = [self isvalidateEmail:currentStr];
		}
			break;
			
			
		case EUserPassword:
		{
			isValidate = [self isvaldatePassword:currentStr];
			
		}
			break;
			
		case EUserDOB:
		{
			isValidate =  (self.userInfo.userType == EUserTypeBuisness)
			?YES:[self isValidateAge:currentStr];
		}
			break;
			
			
		case EuserIndustryType:
		{
			isValidate =  (self.userInfo.userType == EUserTypeCreator)
			?YES:[self isValidateIndustry:currentStr];
		}
			break;
			
		case EUserProfilePic:
		{
			isValidate = [self isvalidateProfilePic];
		}
			break;
			
		default:
			break;
	}
	
	return isValidate;
}

- (BOOL) isNameFieldValid:(NSString*)nameStr
{
	_firstRowCehckImageview.hidden = NO;
	return (nameStr.length <= 0)?[self firstRowDecrementCheck]:[self firstRowCheckCountCheck];
}

- (BOOL) isvalidateEmail:(NSString*)emailStr
{
	__block BOOL isValidate = NO;
	if (_signUpUsingLinkedIn)
		return isValidate;
	
	_secondRowCehckImageview.hidden = NO;
	isValidate = (emailStr.length <= 0)?NO:[UIUtils validateEmail:emailStr];
	if (isValidate)
	{
		[_gDataManager sendRequestValidateEmail:emailStr
								 withCompletion:^(BOOL status, NSString* message, ERequestType requestType)
		{
			
			if (status)
			{
				isValidate = YES;
				_isEmailVerified = YES;
			}
			else
			{
				_secondRowCehckImageview.image = kInvalidImage;
				_isEmailVerified = NO;
				if ([self.navigationController.topViewController  isKindOfClass:[SignUpViewController class]])
					[UIUtils messageAlert:message title:nil delegate:nil];
			}
		}];
	}
	_secondRowCehckImageview.image = (isValidate)?kValidImage:kInvalidImage;
	return isValidate;
}

- (BOOL) isvaldatePassword:(NSString*)passwordStr
{
	BOOL isValidate = NO;
	if (_signUpUsingLinkedIn)
		return isValidate;
	
	_thirdRowCehckImageview.hidden = NO;
	isValidate =  (passwordStr.length <= 0)?NO:[self checkPasswordLength:passwordStr];
	
	_thirdRowCehckImageview.image = (isValidate)?kValidImage:kInvalidImage;
	return isValidate;
}

- (BOOL) isValidateAge:(NSString*)ageStr
{
	BOOL isValid = NO;
	_fourthRowCheckImgV.hidden = NO;
	
	isValid = (ageStr.length <= 0)?NO:[self checkDOBLimit:ageStr];
	_fourthRowCheckImgV.image = (isValid)?kValidImage:kInvalidImage;
	
	return isValid;
}

- (BOOL) isValidateIndustry:(NSString*)industryStr
{
	BOOL isValid = NO;
	_fourthRowCheckImgV.hidden = NO;
	
	isValid = ([industryStr isEqualToString:@"Industry"])?NO:YES;
	_fourthRowCheckImgV.image = (isValid)?kValidImage:kInvalidImage;
	
	return isValid;
}

- (BOOL) isvalidateProfilePic
{
	BOOL isValid = NO;
	_fifthRowCheckImageV.hidden = NO;
	
	isValid = (self.userInfo.profileImage  == nil)?NO:YES;
	_fifthRowCheckImageV.image = (isValid)?kValidImage:kInvalidImage;
	
	return isValid;
}

- (BOOL) firstRowDecrementCheck
{
	_firstRowCehckImageview.image = kInvalidImage;
	_firstRowCheckCount = (_firstRowCheckCount > 0)?(_firstRowCheckCount-1): _firstRowCheckCount;
	return NO;
}

- (BOOL) firstRowCheckCountCheck
{
	NSInteger maxCount = (self.userInfo.userType == EUserTypeCreator)?2:1;
	_firstRowCheckCount =(_firstRowCheckCount == maxCount)?_firstRowCheckCount:_firstRowCheckCount+1;
	_firstRowCehckImageview.image = (_firstRowCheckCount == maxCount)?kValidImage:kInvalidImage;
	return YES;
}

- (BOOL) checkPasswordLength:(NSString*)passwordstr
{
	NSUInteger passwordLength =  passwordstr.length;
	if (passwordLength >= kPasswordMinLength && passwordLength <= kPasswordMaxLength)
		return YES;
	return NO;
}

- (BOOL) checkDOBLimit:(NSString*)str
{
	if([str integerValue] >= 13 && [str integerValue] <= 100)
		return YES;
	return NO;
}

- (BOOL) checkForFinalValidation
{
	BOOL isValidate = YES;
	for (int i = EUserFirstName; i <= EUserProfilePic; i ++)
	{
		// To stop second time validation for seervice
		BOOL fieldCheck = (((i == EUserEmail) && _isEmailVerified) || ( (i == EuserBusiness) &&
																	   _isBusinessVerifed));
		if (!fieldCheck)
		{
			BOOL isValid = [self validateQuickInfo:i withUniqueValidation:!fieldCheck];
			
			if (!isValid)
				isValidate = (!isValidate)?isValidate:isValid;
		}
		
	}
	
	return isValidate;
}

- (void) sendRequestToValidateToUniqueEmail:(NSString*)emailStr WithToken:(NSString*)tokenStr
{
	_secondRowCehckImageview.hidden = NO;
	
	[_gDataManager sendRequestValidateEmail:emailStr
							 withCompletion:^(BOOL status, NSString* message, ERequestType requestType)
	{
		
		if (status)
		{ if(tokenStr.length >0)
		{
			[self requestCompanyPageWithToken:tokenStr];
			_secondRowCehckImageview.image = kValidImage;
			_isEmailVerified  = YES;
		}
		}
		else
		{
			_secondRowCehckImageview.image = kInvalidImage;
			_isEmailVerified  = NO;
			if ([self.navigationController.topViewController  isKindOfClass:[SignUpViewController class]])
				[UIUtils messageAlert:message title:nil delegate:nil];
		}
	}];
}

- (void) sendRequestToValidateToUniqueBusinessname
{
	[_gDataManager sendRequestValidatebusinessName:_businessNametextfield.text andID:self.userInfo.userId withCompletion:^(BOOL status, NSString* message, ERequestType requestType)
	{
		
		if (status)
		{
			[self firstRowCheckCountCheck];
			_isBusinessVerifed = YES;
		}
		else
		{
			_firstRowCehckImageview.image = kInvalidImage;
			_isBusinessVerifed = NO;
			if ([self.navigationController.topViewController  isKindOfClass:[SignUpViewController class]])
				[UIUtils messageAlert:message title:nil delegate:nil];
		}
	}];
}

#pragma Mark --
#pragma Mark -- screend design setup method

- (void) setUpDesignForUserType:(EUserType)userType
{
	switch (userType)
	{
		case EUserTypeBuisness:
			[self setupDesignForBusiness];
			break;
			
		case EUserTypeCreator:
			[self setupDesignForCreator];
			break;
			
		default:
			[self setupDesignForCreator];
			break;
	}
}

- (void) setupDesignForBusiness
{
	_userTypeLabel.text = @"Business";
	_businessSignUPView.hidden = NO;
	_creatorsignUpView.hidden = YES;
	_ageView.hidden = YES;
	_industrytextField.hidden = NO;
	_industrytextField.text = @"Industry";
	[_emailtextField setPlaceholder:@"Enter your business email"];
	_signUpWithFacebookBtn.hidden = YES;
	_signUpWithLinkdInBtn.hidden = NO;
	[_profilePicButton setTitle:@"Logo" forState:UIControlStateNormal];
}

- (void) setupDesignForCreator
{
	NSMutableAttributedString* dbPlachodler  = [[NSMutableAttributedString alloc]
												initWithString:@"D.O.B" attributes:
  @{NSForegroundColorAttributeName:kBlueColor,
	NSFontAttributeName:
		[UIFont fontWithName:kFontRalewayLight
						size:15.0f]}];
	_userTypeLabel.text = @"Creator";
	_profilePicButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	_profilePicButton.titleLabel.numberOfLines = 2;
	[_profilePicButton setTitle:@"Profile \nPicture" forState:UIControlStateNormal];
	_businessSignUPView.hidden = YES;
	_creatorsignUpView.hidden = NO;
	_industrytextField.text = @"";
	_ageView.hidden = NO;
	[_ageTextField setAttributedPlaceholder:dbPlachodler];
	_industrytextField.hidden = YES;
	[_emailtextField setPlaceholder:@"Enter your email"];
	_signUpWithFacebookBtn.hidden = NO;
	_signUpWithLinkdInBtn.hidden = YES;
}

#pragma mark-

- (void) displayLocationScreen
{
	_gAppPrefData.isLogin = YES;
	_gAppPrefData.isFreshLogin = YES;
	_gAppPrefData.emailId = self.userInfo.email;
	[_gAppPrefData saveAllData];
	
	if (self.userInfo.userType == EUserTypeCreator)
	{
		//		if ([CLLocationManager locationServicesEnabled])
		//		{
		//			HomeViewController* viewCtrl = [[HomeViewController alloc] initWithNibName:kHomeViewNib bundle:nil];
		//			[_gAppDelegate initializeApplication:viewCtrl];
		//		}
		//		else
		//		{
		//			CreatorLocationViewController* viewCtrl = [[CreatorLocationViewController alloc] initWithNibName:kCreatorLocationViewNib bundle:nil];
		//			[self.navigationController pushViewController:viewCtrl animated:YES];
		//		}
		
		// Add paypal email for Creator
		
		AddPaypalInfoViewController* viewCtrl = [[AddPaypalInfoViewController alloc] initWithNibName:kAddPaypalInfoViewNib bundle:nil];
		viewCtrl.showLocationScreen = YES;
		[self.navigationController pushViewController:viewCtrl animated:YES];
		
	}
	else if (self.userInfo.userType == EUserTypeBuisness)
	{
		BusinessLocationViewController* viewCtrl = [[BusinessLocationViewController alloc] initWithNibName:kBusinessLocationViewNib bundle:nil];
		[self.navigationController pushViewController:viewCtrl animated:YES];
	}
}

- (void) displayActionSheet
{
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Library", nil];
	[actionSheet showInView:self.view];
}

- (void) displayPickerView
{
	UIPickerView* pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
	pickerView.showsSelectionIndicator = YES;
	pickerView.dataSource = self;
	pickerView.delegate = self;
	_currentTextField.inputView = pickerView;
	_currentTextField.inputAccessoryView = _inputAccsryview;
	
	[pickerView selectRow:0 inComponent:0 animated:YES];
}

#pragma mark --
#pragma mark -- Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex)
	{
		case 0:
			if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
				[self openImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
			break;
		case 1:
			if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
				[self openImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
			break;
		default:
			break;
	}
	[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark-

- (void) openImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
	UIImagePickerController* cameraCtrl = [[UIImagePickerController alloc] init];
	cameraCtrl.delegate = self;
	cameraCtrl.sourceType = sourceType;
	cameraCtrl.allowsEditing = NO;
	[self.navigationController presentViewController:cameraCtrl animated:YES completion:NULL];
}

#pragma mark UIImagePickerController delgate-

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage* chosenImage = info[UIImagePickerControllerOriginalImage];
	CGRect rect = [[UIScreen mainScreen] bounds];
	chosenImage = [UIUtils scaleImage:chosenImage inRect:rect proportionally:YES];
	
	if (chosenImage)
	{
		_profilePicButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
		_profilePicButton.layer.borderWidth = 2.0f;
		_profilePicButton.layer.cornerRadius = 12.0f;
		_profilePicButton.clipsToBounds = YES;
		self.userInfo.profileImage = chosenImage;
		[_profilePicButton setTitle:@"" forState:UIControlStateNormal];
		[_profilePicButton setBackgroundImage:chosenImage forState:UIControlStateNormal];
		[self isvalidateProfilePic];
	}
	
	[picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -
#pragma mark Notification

- (void) handleTapGesture:(id)sender
{
	if ([_currentTextField isFirstResponder] )
		[_currentTextField resignFirstResponder];
}

#pragma  mark -- Pickerview Data soruce

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return _gDataManager.businessList.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return kPickerViewRowHeight;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
		 forComponent:(NSInteger)component reusingView:(UIView *)view
{
	NSString* lablTextStr = (row == 0)? @"Scroll to select":[self getTitleForPickerRow:row-1];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width,kPickerViewRowHeight)];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor blackColor];
	label.textAlignment = NSTextAlignmentCenter;
	label.font = [UIFont fontWithName:kFontRalewayRegular size:16];
	label.numberOfLines = 0;
	label.text = lablTextStr;
	
	return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (row == 0)
		return;
	
	BusinessInfo* info = [_gDataManager.businessList objectAtIndex:row-1];
	self.userInfo.businessInfo = info;
	_industrytextField.text = info.businessName;
}

- (NSString*) getTitleForPickerRow:(NSUInteger)row
{
	NSString* pickerTitle= @"";
	if (_gDataManager.businessList.count > 0)
	{
		BusinessInfo* businessInfo = [_gDataManager.businessList objectAtIndex:row];
		pickerTitle = businessInfo.businessName;
	}
	
	return  pickerTitle;
}

- (void) setUserinfoForsignUp
{
	self.userInfo.firstname = [UIUtils checknilAndWhiteSpaceinString:_firstnametextField.text];
	self.userInfo.lastname = [UIUtils checknilAndWhiteSpaceinString:_lastnametextField.text];
	self.userInfo.email = [UIUtils checknilAndWhiteSpaceinString:_emailtextField.text];
	self.userInfo.password = [UIUtils checknilAndWhiteSpaceinString:_paswordtextField.text];
	self.userInfo.businessName = [UIUtils checknilAndWhiteSpaceinString:_businessNametextfield.text];
	self.userInfo.userDOB = [UIUtils checknilAndWhiteSpaceinString:_ageTextField.text];
	
	if (_signUpUsingLinkedIn)
	{
		if (_profileImageView.image != nil)
			self.userInfo.profileImage =  _profileImageView.image;
		[self sendRequestToSocialMediaSignUp:EUserSocialMediaTypeLinkedIn];
	}
	else
	{
		[self sendRequestToSignUp];
	}
}

- (void) parseFaceBookuserInfo:(NSDictionary*)dict
{
	self.userInfo.email = [UIUtils checknilAndWhiteSpaceinString:[dict objectForKey:@"email"]];
	self.userInfo.firstname = [UIUtils checknilAndWhiteSpaceinString:[dict objectForKey:@"first_name"]];
	self.userInfo.lastname = [UIUtils checknilAndWhiteSpaceinString:[dict objectForKey:@"last_name"]];
	
	NSString* dateStr = [UIUtils checknilAndWhiteSpaceinString:[dict objectForKey:@"birthday"]];
	if(dateStr.length > 0)
		self.userInfo.userDOB = [self convertDateStr:dateStr];
	
	//	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
	//							NO, @"redirect",
	//							@"600", @"height",
	//							@"normal", @"type",
	//							@"600", @"width",
	//							nil
	//							];
	//
	//	NSString* userID = [NSString stringWithFormat:@"/%@/?fields=picture",[dict objectForKey:@"id"]];
	//
	//
	//	/* make the API call */
	//	[FBRequestConnection startWithGraphPath:userID
	//								 parameters:params
	//								 HTTPMethod:@"GET"
	//						  completionHandler:^(
	//											  FBRequestConnection *connection,
	//											  id result,
	//											  NSError *error
	//											  )
	//	{
	//		if (error)
	//		{
	//			[UIUtils messageAlert:error.localizedDescription title:@"" delegate:nil];
	//		}
	//		else
	//		{
	//			NSDictionary* dict = [result objectForKey:@"picture"];
	//			if (dict.count > 0)
	//			{
	//				NSDictionary* dataDict = [dict objectForKey:@"data"];
	//				self.userInfo.profilePicURL = [UIUtils checknilAndWhiteSpaceinString:[dataDict objectForKey:@"url"]];
	//
	[self sendRequestToSocialMediaSignUp:EUserSocialMediaTypeFacebook];
	//			}
	//		}
	//	}];
}

- (NSString *)convertDateStr:(NSString *)strdate
{
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd/MM/yyyy"];
	NSDate * birthday = [formatter dateFromString:strdate];
	
	NSDate* now = [NSDate date];
	NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
									   components:NSYearCalendarUnit
									   fromDate:birthday
									   toDate:now
									   options:0];
	NSInteger age = [ageComponents year];
	
	return [NSString stringWithFormat:@"%ld",(long)age];
}

#pragma  mark -- Services request

- (void) sendRequestToSignUp
{
	[_gDataManager sendRequestForSignUp:self.userInfo withCompletion:^(BOOL status, NSString* message,
																	   NSString* errortype,
																	   ERequestType requestType){
		if (status)
		{
			[self displayLocationScreen];
		}
		else
		{
			if ([errortype  caseInsensitiveCompare:@"email"] == NSOrderedSame)
			{
				[_emailtextField becomeFirstResponder];
				_secondRowCehckImageview.image = kInvalidImage;
			}
			
			[UIUtils messageAlert:message title:nil delegate:nil];
		}
	}];
}

- (void) sendRequestToSocialMediaSignUp:(EUserSocialMediaType)mediaType
{
	[_gDataManager sendRequestToSocialMediaSignUp:mediaType withUser:self.userInfo
								   withCompletion:^(BOOL status, NSString* message,
													NSString* errortype,
													ERequestType requestType)
	{
		if (status)
		{
			[self displayLocationScreen];
		}
		else
		{
			[UIUtils messageAlert:message title:nil delegate:nil];
			if (mediaType == EUserSocialMediaTypeFacebook)
				[SCAFacebookSession closeSession];
		}
	}];
}

- (void) logInToFacebookSignUp
{
	NSArray* permissionArray = [NSArray arrayWithObjects:@"user_birthday",@"email",@"user_location",
								@"public_profile",@"user_photos",@"publish_stream", @"manage_pages",nil];
	[SCAFacebookSession openSessionWithPermissions:permissionArray block:^(id result, NSError *error) {
		if (error)
		{
			(error.code == 2)? NSLog(@"Error duriong facebook"):[UIUtils messageAlert:
																 error.description title:nil
																			 delegate:nil];
		}
		else
		{
			NSDictionary* dict = (NSDictionary*)result;
			[self parseFaceBookuserInfo:dict];
		}
	}];
}

#pragma mark- LinkedIn

- (void) loginToLinkedIn
{
	_client = [self client];
	
	[self.client getAuthorizationCode:^(NSString *code) {
		
		[self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
			
			NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
			_gAppPrefData.linkedInToken = accessToken;
			[self requestEmailWithToken:accessToken];
		}                   failure:^(NSError *error) {
			NSLog(@"Quering accessToken failed %@", error);
		}];
	}                      cancel:^{
		NSLog(@"Authorization was cancelled by user");
	}                     failure:^(NSError *error) {
		NSLog(@"Authorization failed %@", error);
	}];
	
}

- (void)requestEmailWithToken:(NSString *)accessToken
{
	[_gAppDelegate showLoadingView:YES];
	
	NSString* str = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~/email-address/?oauth2_access_token=%@&format=json", accessToken];
	NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError){
		
		[_gAppDelegate showLoadingView:YES];
		
		if (connectionError)
		{
			NSLog(@"%@",connectionError.description);
			return ;
		}
		
		NSError* error= nil;
		_linkedInEmail = (NSString*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		if( error )
			NSLog(@"%@", [error localizedDescription]);
		else
			[self sendRequestToValidateToUniqueEmail:_linkedInEmail WithToken:accessToken];
		
		NSLog(@"%@",_linkedInEmail);
	}];
}

- (void)requestMeWithToken:(NSString *)accessToken
{
	[_gAppDelegate showLoadingView:YES];
	
	NSString* requestString = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,formatted-name)/?oauth2_access_token=%@&format=json", accessToken];
	
	[self.client GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
		
		[_gAppDelegate showLoadingView:NO];
		
		NSLog(@"User's Company %@", result);
		
		[self requestpicturURLForId:[result objectForKey:@"id"] withDict:result];
		
	}   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[_gAppDelegate showLoadingView:NO];
		NSLog(@"failed to fetch current user %@", error);
	}];
	
}

- (void) requestpicturURLForId:(NSString*)userId withDict:(NSDictionary *)dict
{
	[_gAppDelegate showLoadingView:YES];
	
	//	NSString* requestString = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/%@/picture-urls::(original)/?oauth2_access_token=%@&format=json", userId,_gAppPrefData.linkedInToken];
	
	NSString* requestString = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/%@/picture-url/?oauth2_access_token=%@&format=json", userId,_gAppPrefData.linkedInToken];
	NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError){
		
		[_gAppDelegate showLoadingView:NO];
		
		if (connectionError)
		{
			NSLog(@"%@",connectionError.description);
			return ;
		}
		
		NSError* error= nil;
		NSString* pictureURL = (NSString*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		if( error )
			NSLog(@"%@", [error localizedDescription]);
		else
		{
			NSMutableDictionary* result = [[NSMutableDictionary alloc] initWithDictionary:dict];
			if ([pictureURL isKindOfClass:[NSString class]])
				[result setObject:pictureURL forKey:@"pictureURL"];
			[self showBusinessInfoFromLinkedInDictionary:result fromPersonalInfo:YES];
		}
		
		NSLog(@"%@",pictureURL);
	}];
	
}

- (void)requestCompanyPageWithToken:(NSString *)accessToken
{
	[_gAppDelegate showLoadingView:YES];
	
	[self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/companies:(id,name,logo-url,description)?is-company-admin=true&oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
		
		[_gAppDelegate showLoadingView:NO];
		
		NSLog(@"User's Company %@", result);
		
		NSArray* array = [result objectForKey:@"values"];
		if (array.count == 0)
		{
			NSString* message = [NSString stringWithFormat:@"You don't have any company page associated with this account. Do you want to continue with your profile information?"];
			[UIUtils messageAlert:message title:nil delegate:self withCancelTitle:@"Cancel" otherButtonTitle:@"Continue" tag:KLinkedInAlert];
		}
		else if (array.count == 1)
			[self showBusinessInfoFromLinkedInDictionary:[array objectAtIndex:0] fromPersonalInfo:NO];
		else
			[self showCompanyList:array withToken:accessToken];
		
	}        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[_gAppDelegate showLoadingView:NO];
		NSLog(@"failed to fetch current user %@", error);
	}];
}

- (LIALinkedInHttpClient *)client
{
	LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:kLinkedInRedirectURL																					clientId:kLinkedInClientID
																				clientSecret:kLinkedInSecretAppKey
																					   state:kLinkeDinStates
																			   grantedAccess:@[@"r_fullprofile", @"r_emailaddress", @"rw_company_admin"]];
	return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}

- (void) showCompanyList:(NSArray*)list withToken:(NSString*)accessToken
{
	[self.view removeGestureRecognizer:_touchRecognizer];
	
	if(_companyListVC == nil)
		_companyListVC = [[LinkedInCompanyListVC alloc] initWithCompletionBlock:^(NSUInteger index){
			
			[self addGestureRecognizer];
			NSDictionary* dict = [list objectAtIndex:index];
			[self showBusinessInfoFromLinkedInDictionary:dict fromPersonalInfo:NO];
		}];
	_companyListVC.companyList = list;
	_companyListVC.view.frame = [[UIScreen mainScreen] bounds];
	[self.view addSubview:_companyListVC.view];
}

- (void) showBusinessInfoFromLinkedInDictionary:(NSDictionary*)dict fromPersonalInfo:(BOOL)acessPersonalInfo
{
	NSString* logoURL  = nil;
	if (acessPersonalInfo)
	{
		_businessNametextfield.text = [dict objectForKey:@"formattedName"];
		logoURL = [dict objectForKey:@"pictureURL"];
	}
	else {
		_businessNametextfield.text = [dict objectForKey:@"name"];
		logoURL = [dict objectForKey:@"logoUrl"];
	}
	
	_firstRowCehckImageview.image = (logoURL.length > 0) ? kValidImage : kInvalidImage;
	
	if (logoURL.length > 0)
	{
		_profileImageView.layer.borderColor = kBlueColor.CGColor;
		_profileImageView.layer.borderWidth = 2.0f;
		_profileImageView.layer.cornerRadius = 12.0f;
		_profileImageView.clipsToBounds = YES;
		
		_profileImageView.imageUrl = logoURL;
		[_profileImageView becomeActive];
		_profilePicButton.hidden = YES;
	}
	
	_emailtextField.text = _linkedInEmail;
	
	_paswordtextField.hidden = YES;
	//	_profilePicButton.hidden = YES;
	_passwordImageview.hidden = YES;
	_thirdRowCehckImageview.hidden = YES;
	
	_businessNametextfield.userInteractionEnabled = NO;
	_emailtextField.userInteractionEnabled = NO;
	
	_signUpUsingLinkedIn = YES;
}

#pragma mark- AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == KLinkedInAlert)
	{
		if (buttonIndex)
			[self requestMeWithToken:_gAppPrefData.linkedInToken];
	}
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
	
	NSArray* arrra = navigationController.viewControllers;
	for (int i = 0 ; i< arrra.count ; i++)
	{
		if (KVersion < 7)
			[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
	}
}

@end
