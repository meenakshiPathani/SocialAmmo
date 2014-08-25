//
//  Defines.h
//  Social Ammo
//
//  Created by Meenakshi on 06/01/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

#define kImageFileSeparator		@"_"


#define KVersion                [[[UIDevice currentDevice] systemVersion] intValue]
#define kIPhone5				([[UIScreen mainScreen] bounds].size.height == 568.0)
#define kFaceBookSignUpArray    @[@"Country", @"State", @"Suburb"]

#define kPushNotification		@"PushNotification"

#define kCountryFileName	@"CountryList.txt"

#define kRememberUserDefaultKey @"RememberDefaultKey"
#define kUsernameDefaultKey @"UsernameDefaultKey"
#define kPasswordDefaultKey @"PasswordDefaultKey"

//#define kServerUrl		@"https://uat.theammoapp.com/services/"

#define kServerUrl @"http://trunk.theammoapp.com/index.php/services/"		//test url

#define kGooglePlaceApiKey	@"AIzaSyBRFT0EF-pgdr1aRyDPOY-bTyrAR0zpFpc"

#define kPinInterestClientID @"1437675"

#define kPaypalSandboxAppID		@"APP-80W284485P519543T"
#define kPaypalLiveAppID	@"APP-6JB59734WH4068347"

#define kSocialAmmoPaypalAccount	@"info-facilitator@thesocialammo.com"
//#define kSocialAmmoPaypalAccount	@"info@thesocialammo.com" // live

#define kLinkedInClientID @"75hf22p6wi9v7i"
#define kLinkedInSecretAppKey @"85kETK7ipc7KWrbR"
#define kLinkeDinStates @"ECEEFWF45453sdffef696"
#define kLinkedInRedirectURL @"http://www.socialammo.com/"

#define kPartner	@"VSA"
#define kPassword	@"vansah123"
#define kVendor		@"socialammo"

//pop view appear/disappear delay - to change pop up delay
#define KDEFAULT_FRAME              [[UIScreen mainScreen] bounds]
#define KPOP_UP_IN_ICONS_DELAY       0.4
#define KPOP_OUT_IN_ICONS_DELAY      0.4

#define kCaptionMessage @"Social Ammo content by %@"

#define kDeviceTypeIphone @"1"

#define _gAppDelegate  (AppDelegate*)[[UIApplication sharedApplication] delegate]
#define _gDataManager [DataManager sharedObject]

#define kSubmitNotfication @"SubmitContentNotiifaction"
#define kSaveBriefNotification @"SaveBriefNotifcation"
#define kSendPrivatemessageNotifi @"SendPrivateMessagenotifi"

#define kWorkInProgressDir @"WorkInProgress/"
#define kPackDir @"Pack/"

#define kLogoDirectory	   @"Logo/"
#define kBriefDirectory	   @"UserBrief/"
#define kTextviewText	   @"Double tap to enter text"

#define kWaitSaveMessage	@"Please wait, loading image..."
#define kWorkInProgress		@"Work in progress."

#define kNetworkError				@"Network Connection Error"
#define kNetworkErrorMessage		@"Network not Available. Please check your network settings!"
#define kBlankDataMessage			@"Please enter the %@."
#define kFaceBookErrorMessage		@"Your Facebook account is not setup in the settings section of your iPhone."
#define kTwitterErrorMessage		@"Your Twitter account is not setup in the settings section of your iPhone."
#define kInstagramErrormessage		@"Instagram is not installed in this device!\nTo share content please install Instagram."
#define kPininterestErrormessage	@"Pinterest is not installed in this device!\nTo share content please install Pinterest."
#define kRequestFinishedSucessfullyNotification     @"kRequestFinishedSucessfullyNotification"
#define kRequestFailedNotification                  @"kRequestFailedNotification"


#pragma mark-

#define kBlueColor [UIColor colorWithRed:52/255.0 green:206/255.0 blue:231/255.0 alpha:0.95]
#define kWhiteColor [UIColor colorWithWhite:1.0 alpha:0.9]

#define kLightBlueColor [UIColor colorWithRed:185/255.0 green:215/255.0 blue:226/255.0 alpha:1.0]

#define kSeparatorLineColor [UIColor colorWithRed:108/255.0 green:184/255.0 blue:177/255.0 alpha:1.0]

//#define kRegularUserBlueColor [UIColor colorWithRed:9/255.0 green:180/255.0 blue:219/255.0 alpha:1.0] // #09b4db
#define kBusinessUserBlueColor [UIColor colorWithRed:92/255.0 green:235/255.0 blue:235/255.0 alpha:1.0]//#5cebff
#define kRegularUserBlueColor [UIColor colorWithRed:92/255.0 green:235/255.0 blue:235/255.0 alpha:1.0]

#define GET_COLOR(r,g,b,a)      [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:a]


#define kPickerViewRowHeight 50.0f


#define kMaxLength 100

#define kCanvasMaxLength 30

#define kCaptionMaxLength 30
#define kTitleMaxLength 30

#define kMinCreditLimit				3
#define kMaxCreditLimit				10000 //10000000

#define kMaxRedeemCoinLimit			100

#define kPasswordMinLength			6
#define kPasswordMaxLength			25

#define kUsernameMaxLength			30

#define kBuisnessNameMaxLength		50
#define kBuisnessDescriptionMaxLength		70


#define kAccountNameMaxLength		30
#define kFirstNameMaxlength			50
#define kLastNameMaxLength			50
#define kEmailMaxLength				100
#define kLocationMaxLength			255
#define kPhoneMaxLength				20
#define kSecurityAnswerMaxlength	255
#define kDOBMaxLength				3

#define kBriefDescriptionMaxLength	200


#define kUserBackgroundOpacity		0.3
#define kBuisnessBackgroundOpacity	0.15


#define kPrivateMessageCellDefaultHeight		140
#define kMessageBoxDefaultHeight 90
#define kMessageBoxDefaultWidth 160
#define kImageAttachmentwidth 70

#pragma mark Font-

// custom Font
//#define kFontMontserratAlternatesRegular	@"MontserratAlternates-Regular"
//#define kFontMontserratAlternatesBold		@"MontserratAlternates-Bold"
//
//#define kFontMontserratRegular  @"Montserrat-Regular"
//#define kFontMontserratBold		@"Montserrat-Bold"
//
//#define kFontMagraRegular		@"Magra"
//#define kFontMagraBold			@"Magra Bold"

#define kFontRalewayLight     @"Raleway-Light"
#define kFontRalewayMedium     @"Raleway-Medium"
#define kFontRalewayRegular     @"Raleway-Regular"
#define kFontRalewayBold     @"Raleway-Bold"
#define kFontRalewayExtraBold @"Raleway-ExtraBold"

// Apple font
#define kFontNoteworthyRegular	@"Noteworthy"
#define kFontNoteworthyBold		@""


#define GET_FONT(name,size)         [UIFont fontWithName:name size:size]
#define kFontArray                  [UIFont familyNames]


#pragma mark PayPal-
//Paypal live
#define kPayPalLiveClientId			@"Ae0zlxBsjqXBebcGrut5ydmhsS7uRfo35u75WJ39CDggEb49XrnnVxAW0Qft"
//#define kPayPalReceiverEmail	@"info@thesocialammo.com"

//sandbox
#define kPayPalSandboxClientId			@"AXWophB_JBSF-IzM4l4_7p6NMU0c7X6mMFnCJsj5G-rQtQEK5VquRWORh_Oi"
#define kPayPalReceiverEmail	@"info-facilitator@thesocialammo.com"

#pragma mark enum-

typedef enum serverResponseFileType
{
    EXmlFile = 500,
    EJsonFile
} EResponseFileType;

typedef enum userSearchType
{
    ESearchTypeUser = 1,
    ESearchTypeBusiness
} EUserSearchType;

typedef enum packType
{
    EPackTypeImage = 1,
    EPackTypeText
} EPackType;

typedef enum
{
	ESpecificSubmission = 0,
	EOpenSubmission = 1
} ESubmissionType;

typedef enum {
	ENextButton = 1000,
	EPreviousButton,
} EInputAcessoryButton;

typedef enum serverRequestType{
	ERequestTypeLogin = 2000,
	ERequestTypeRegistration,
	ERequestTypeGetTermsAndCondition,
	ERequestTypeGetQuickInterest,
	ERequestTypeGetBusiness,
	ERequestTypeSaveBrief,
	ERequestTypeGetBriefs,
	ERequestTypeHomepageContent,
	ERequestTypeSubmitContent,
	ERequestTypeAddCreditToBrief,
	ERequestTypeGetBuisnesSettings,
	ERequestTypeBuisnessSearch,
	ERequestTypeCreatorSearch,
	ERequestTypeLogout,
	ERequestTypeGetUserInfo,
	ERequestTypeGetProfile,
	ERequestTypeGetbriefContent,
	ERequestTypeUpdateBriefContent,
	ERequestTypeSecurityQuestionForEmail,
	ERequestTypeValidateSecurityAnswer,
	ERequestTypeChangePassword,
	ERequestTypeGetUserCredit,
	ERequestTypeGetMessageList,
	ERequestTypeRedeemCoin,
	ERequestTypeFacebookLogIn,
	ERequestTypeFaceBookSignup,
	ERequestTypeLinkedInSignUp,
	ERequestTypeLinkedInLogin,
	ERequestTypeGetSuburb,
	ERequestTypeGetUserUpdates,
	ERequestTypeUnlockMessageThread,
	ERequestTypeGetPrivateMessage,
	ERequestTypeSendPrivateMessage,
	ERequestTypeGetAmmoCoinPacks,
	ERequestTypeGetCanvas,
	ERequestTypeReadMessage,
	ERequestTypeGetPacksFromMarketPlace,
	ERequestTypeSaveSubmission,
	ERequestTypeGetAllSubmission,
	ERequestTypeValidateEmail,
	ERequestTypeValidateBusinessname,
	ERquestTypeLoadLogoImage
} ERequestType;

typedef enum {
	EUserTypeCreator = 1,
	EUserTypeBuisness,
	EUserTypeCharity
} EUserType;

typedef enum {
	EUserSocialMediaTypeFacebook = 1,
	EUserSocialMediaTypeLinkedIn,
} EUserSocialMediaType;


typedef enum {
	ETopHomeButtonTypeBack = 200,
	ETopHomeButtonTypeNotif,
	ETopHomeButtonTypeMessage,
	ETopHomeButtonTypeCenter,
	ETopHomeButtonTypeCredit,
	ETopHomeButtonTypeMenu
} ETopHomeButtonType;

typedef enum {
	EHomeTopButtonTypeRevel = 200,
	EHomeTopButtonTypeHome,
	EHomeTopButtonTypeBecaon,
	EHomeTopButtonTypeMessage
} EHomeTopButtonType;

typedef enum {
	ELocationTypeWorld = 3000,
	ELocationTypeCountry,
	ELocationTypeState,
	ELocationTypeSuburb
} ELocationType;

typedef enum {
	EReciptTypePaypal = 0,
	EReciptTypeCreditCard
} EReciptType;

typedef enum {
	EInterestTypePureAdd = 1,
	EInterestTypeCharity,
	EInterestTypeComedy,
	EInterestTypeFamilyAndFriends,
	EInterestTypeHealthAndFitness,
	EInterestTypeEducation,
	EInterestTypeEntertainment,
	EInterestTypeHowTo,
	EInterestTypeNews,
	EInterestTypeSports,
	EInterestTypeScience,
	EInterestTypePets,
	EInterestTypeTravel,
	EInterestTypeArts,
	EInterestTypeWriting,
	EInterestTypeGaming,
} EInterestType;

typedef enum {
	EBriefNewSubmission = 8000,
	EBriefCredit,
	EBriefAccepted,
	EBriefDecliend
} EBriefAction;


typedef enum {
	ESearchTypeCategory = 2000,
	ESearchTypeLocation,
	ESearchTypeFavorites,
	ESearchTypeNormal
} ESearchType;

typedef enum {
	EBriefTypeNew = 1,
	EBriefTypeAccepted,
	EBriefTypeDeclined,
	EBriefTypeCredited,
} EBriefType;

typedef enum {
	EFaceBookShare = 0,
	ETwitterShare,
	ELinkdInShare,
	EInstagramShare,
	EPinInterestShare
} EShareType;

typedef enum {
	EBriefPostForAccepted = 1,
	EBriefPostForDeclined,
	EBriefPostForDeleted,
	EBriefPostForReApprove
} EBriefPostForType;

typedef enum {
	EPrivateMessageText = 0,
	EPrivateMessageWIPIamge,
	EPrivateMessageCameraImage,
	EPrivateMessageAmmoCoin
} EPrivateMessageType;

typedef enum {
	ERequestTopTwentyMessage = 0,
	ERequestAllMessage,
} ERequestMessage;

typedef enum {
	ELayerTypeImportImage = 0,
	ELayerTypePackImage,
	ELayerTypePackText,
	ELayerTypeLogo
} ELayerType;

#pragma mark nib files-

#define kNewSignUpViewNib		@"NewSignUpView"
#define kUserTypeViewNib		@"UserTypeView"
#define kHomeViewNib			@"HomeView"

#define kCreatorLocationViewNib		@"CreatorLocationView"
#define kBusinessLocationViewNib	@"BusinessLocationView"

#define kPlaceTableCellNib			@"PlaceTableCell"
#define kLinkedInCompanyListViewNib	@"LinkedInCompanyListView"

#define kBuinessStepsViewNib		@"BuinessStepsView"

#define kCreatorHubViewNib	@"CreatorHubView"

#define kCreatorToolViewNib		@"CreatorToolView"

#define kCreatorCanvasViewNib	@"CreatorCanvasView"
#define kImportImageViewNib		@"ImportImageView"

#define kWIPViewNib				@"WIPView"
#define kWIPCollectionCellNib	@"WIPCollectionCell"

#define kSubmitContentViewNib	@"SubmitContentView"

#define kLayerTableCellNib		@"LayerTableCell"
#define kLayerListViewNib		@"LayerListView"
#define kLayerViewNib			@"LayerView"

#define kColorPickerViewNib		@"ColorPickerView"


#define kPageViewNib			@"PageView"

// old files
#define kMessageNotificationViewNib		@"MessageNotificationView"
#define kMessageNotifiCellNib		@"MessageNotificationTableCell"
#define kProfileViewNib			@"ProfileView"


#define kSubmissionListViewNib		@"SubmissionListView"
#define kOpenSubmissionViewNib		@"OpenSubmissionView"
#define kAcceptContentViewNib		@"AcceptContentView"
#define kDeclineContentViewNib		@"DeclineContentView"

// Submissions old flow xibs

#define kBriefListViewNib	@"BriefListView"
#define kBriefListDetailViewNib		@"BriefListDetailView"
#define kAcceptDeclineListViewNib	@"AcceptDeclineListView"
#define kAcceptBreifCellNib			@"AcceptBriefCell"
#define kDeclineTableCellNib		@"DeclineTableCell"
#define kDeclineListViewNib			@"DeclineListView"
#define kImageZoomViewNib			@"ImageZoomView"
#define kNewSubmissionTableCellNib	@"NewSubmissionTableCell"
#define kBusinessBriefTableCellNib	@"BusinessBriefTableCell"

#define kAddPaypalInfoViewNib	@"AddPaypalInfoView"


