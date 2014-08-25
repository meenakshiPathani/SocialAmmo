//
//  NewSignUpViewController.h
//  SocialAmmo
//
//  Created by Rupesh Kumar on 6/30/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


typedef enum userInfoType
{
    EUserFirstName = 50,  // For RU- FirstName  BU - BusinessName
    EUserLastname,
	EuserBusiness,// For RU- secondName  BU - BusinessType(Industry)
	EUserEmail,
	EUserPassword,
	EUserDOB,
	EuserIndustryType,
	EUserProfilePic
} EUserInfoType;

@interface SignUpViewController : UIViewController
{
	IBOutlet UIScrollView* _scrollView;
	
	IBOutlet UITextField* _firstnametextField;
	IBOutlet UITextField* _lastnametextField;
	IBOutlet UITextField* _emailtextField;
	IBOutlet UITextField* _paswordtextField;
	IBOutlet UITextField* _businessNametextfield;
	IBOutlet UITextField* _ageTextField;
	IBOutlet UITextField* _industrytextField;
	
	IBOutlet AsyncImageView* _profileImageView;
	
	IBOutlet UIButton* _profilePicButton;
	IBOutlet UIButton* _signUpWithFacebookBtn;
	IBOutlet UIButton* _signUpWithLinkdInBtn;
	
	IBOutlet UIImageView* _firstRowCehckImageview;
	IBOutlet UIImageView* _secondRowCehckImageview;
	IBOutlet UIImageView* _thirdRowCehckImageview;
	IBOutlet UIImageView* _fourthRowCheckImgV;;
	IBOutlet UIImageView* _fifthRowCheckImageV;
	
	NSInteger _firstRowCheckCount;
	BOOL _isEmailVerified;
	BOOL _isBusinessVerifed;
	
	IBOutlet UIImageView* _passwordImageview;
	
	IBOutlet UIView* _businessSignUPView;
	IBOutlet UIView* _creatorsignUpView;
	IBOutlet UIView* _ageView;
	IBOutlet UIView* _inputAccsryview;
	IBOutlet UILabel* _userTypeLabel;
	
	UITextField* _currentTextField;
}
@property (nonatomic, strong)UserInfo* userInfo;

- (IBAction) profilePicButtonaction:(id)sender;
- (IBAction) nextbtnAction:(id)sender;
- (IBAction) backButtonAction:(id)sender;
- (IBAction) signUpwithFaceBookAction:(id)sender;
- (IBAction) signUpWithLinkdIn:(id)sender;

@end
