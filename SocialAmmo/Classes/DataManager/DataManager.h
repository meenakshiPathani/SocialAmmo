//
//  DataManager.h
//  Social Ammo
//
//  Created by Meenakshi on 20/01/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "BusinessOpenSubmissionInfo.h"
#import "SubmissionInfo.h"
#import "PackInfo.h"
#import "ProfileInfo.h"
#import "UserCreditInfo.h"
#import "BriefInfo.h"
#import "UserInfo.h"
#import "WebServiceDefines.h"
#import "WebServiceManager.h"

typedef void(^DataManagerCompletionBlock)(BOOL status, NSString* message, ERequestType requestType);
typedef void(^SignUpCompletionBlock)(BOOL status, NSString* message,NSString* errortype,
									 ERequestType requestType);
typedef void(^HomePageDataComplitionBlock)(BOOL status, NSString* message,ERequestType requestType);
typedef void(^DataManagerFailureBlock)();

@interface DataManager : NSObject<WebServiceManagerDelegate>
{
	WebServiceManager* _webserviceM;
}
+ (DataManager*) sharedObject;

@property (nonatomic, copy)DataManagerCompletionBlock completion;
@property (nonatomic, copy)SignUpCompletionBlock signUpCompletion;
@property (nonatomic, copy)HomePageDataComplitionBlock homePageDataComplition;

@property (nonatomic, strong)NSString* session;
@property (nonatomic, strong)NSString* deviceToken;

@property (nonatomic, strong)NSArray* countryList;
@property (nonatomic, strong)NSArray* interestList;
@property (nonatomic, strong)NSArray* securityQuestionList;
@property (nonatomic, strong)NSArray* businessList;
@property (nonatomic, strong)NSArray* briefList;
@property (nonatomic, strong)NSArray* homepageContentList;
@property (nonatomic, strong)NSArray* searchList;
@property (nonatomic, strong)NSArray* briefContentInfoList;
@property (nonatomic, strong)NSArray* messageinfoList;

@property (nonatomic, strong)NSArray* filterSuburbList;
@property (nonatomic, strong)NSArray* privateMessageArray;
@property (nonatomic, strong)NSArray* ammoCoinPackArray;
@property (nonatomic, strong)NSArray* canvasList;
@property (nonatomic, strong)NSArray* packList;
@property (nonatomic, strong)NSArray* submissionList;

@property (nonatomic, strong)NSMutableArray* facebookSignUpArray;


@property (nonatomic, strong)UserInfo* userInfo;
@property (nonatomic, strong)UserInfo* signUpUserInfo;
@property (nonatomic, strong)BriefInfo* createBriefInfo;
@property (nonatomic, strong)ProfileInfo* userProfileInfo;
@property (nonatomic, strong)UserCreditInfo* userCreditInfoObj;

@property (nonatomic, assign)CGFloat oneAmmoCoinInAUD;
@property (nonatomic, assign)NSUInteger oneContentCost;
@property (nonatomic, assign)NSUInteger searchCount;

@property (nonatomic, assign)NSUInteger userCredits;

@property (nonatomic, assign)CGFloat locationVersionNr;

@property (nonatomic, assign)BOOL newCountryListInServer;

@property (nonatomic, assign)BOOL searchRegularUser;
@property (nonatomic, assign)BOOL isFaceBookSignUp;

@property (nonatomic, assign)EUserSearchType searchType;

@property (nonatomic, assign)BOOL createContentForSubmission;
@property (nonatomic,assign) BOOL isAlertShow;

@property (nonatomic, strong)BusinessOpenSubmissionInfo* createContentForSubmissionInfo;

@property (nonatomic,assign) BOOL messageNotification;
@property (nonatomic,assign) BOOL creditNotification;
@property (nonatomic,assign) BOOL submissionNotification;


#pragma mark -

- (NSDictionary*) getResponseFromData:(NSData*)data;
- (BOOL) checkResponseStatus:(NSDictionary*)dict;
- (NSString*) getImageStringFromImage:(UIImage*)image;

//- (void) sendRequestForCountryListWithCompletion:(DataManagerCompletionBlock)completion;
- (void) sendRequestForQuickInterestWithCompletion:(DataManagerCompletionBlock)completion;
//- (void) sendRequestForSecurityQuestionsWithCompletion:(DataManagerCompletionBlock)completion;
- (void) sendRequestForBusinessWithCompletion:(DataManagerCompletionBlock)completion;

- (void) sendRequestToGetUserInfoWithCompletion:(DataManagerCompletionBlock)completion;
- (void) sendRequestForLogin:(NSString*)username password:(NSString*)password withCompletion:(DataManagerCompletionBlock)completion;

- (void) sendRequestToAddLocation:(CLLocationCoordinate2D)coordinate withCompletion:(DataManagerCompletionBlock)completion;

- (void) sendRequestForSignUp:(UserInfo*)userInfo withCompletion:(SignUpCompletionBlock)signUpCompletion;
- (void) sendRequestForTermsAndConditionswithCompletion:(DataManagerCompletionBlock)completion;

//- (BOOL) checkCountryListExistAndParseCountryInfo;

- (void)  sendRequestToSaveBrief:(BriefInfo*)briefInfo;
- (void) sendRequestToSaveBrief:(BriefInfo*)briefInfo withCompletion:(DataManagerCompletionBlock)completion failure:(DataManagerFailureBlock)failureBlock;

- (void) sendRequestToAddCredit:(BriefInfo*)info recipt:(id)receipt receiptType:(EReciptType)receiptType withCompletion:(DataManagerCompletionBlock)completion failure:(DataManagerFailureBlock)failureBlock;

- (void) sendRequestToGetBriefForBuisness:(NSUInteger)businessId WithCompletion:(DataManagerCompletionBlock)completion failure:(DataManagerFailureBlock)failureBlock;
- (void) sendRequestToGetHomepageContentWithCompletion:(HomePageDataComplitionBlock)completion;

- (void) sendRequestToSubmitContent:(UIImage *)image caption:(NSString *)caption forBrief:(NSUInteger)briefId;

- (void) sendRequestToSubmitContent:(UIImage*)image caption:(NSString*)caption forBrief:(NSUInteger)briefId withCompletion:(DataManagerCompletionBlock)completion;

- (NSString*) getWIPDirecory;
- (NSString*) getPackDirectory;

- (NSString*) getBriefDirectory;

- (NSString*) getLogoDirectory;

- (void) sendRequestToGetBuisnessRulesWithCompletion:(DataManagerCompletionBlock)completion;
- (void) sendRequestToSearchText:(NSString*)searchText withCompletion:(DataManagerCompletionBlock)completion;

- (void) sendRequestToGetProfile:(EUserSearchType)userType withId:(NSUInteger)userId
				  withCompletion:(DataManagerCompletionBlock)completion;

- (void) sendRequestToGetbriefContent:(EBriefType)brieftype withId:(NSUInteger)briefID
					   withCompletion:(DataManagerCompletionBlock)completion;
- (void) sendRequestToUpdateBriefContent:(EBriefPostForType)briefPostType withId:(NSUInteger)contentID
						  withPaymentKey:(NSString*)paymentKey
						  withCompletion:(DataManagerCompletionBlock)completion;


- (void) sendRequestToSearchType:(ESearchType)searchType locationType:(NSString*)locationType withLocationId:(NSUInteger)locationId  withCategoryId:(NSUInteger)categoryId searchText:(NSString*)searchText withCompletion:(DataManagerCompletionBlock)completion;
- (void) sendRequestToGetuserCreditWithCompletion:(DataManagerCompletionBlock)completion;
- (void) sendRequestToGetuserMessageList:(ERequestMessage)requestMessage withCompletion:(DataManagerCompletionBlock)completion failure:(DataManagerFailureBlock)failureBlock;

- (void) sendRequestToRedeemCoin:(NSUInteger)coin cost:(CGFloat)cost forEmail:(NSString*)
email password:(NSString*)password withCompletion:(DataManagerCompletionBlock)completion;

- (void) sendRequestToSocialMediaSignUp:(EUserSocialMediaType)socialmediaType withUser:(UserInfo*)userInfo
						 withCompletion:(SignUpCompletionBlock)signUpCompletion;
- (void) sendRequestToSocialMediaLoginUser:(EUserSocialMediaType)socialmediaType withEmail:(NSString*)email
							withCompletion:(DataManagerCompletionBlock)completion;


//- (void) sendRequestToGetSuburbForPincode:(NSString*)pinCode country:(NSUInteger)countryId state:(NSUInteger)stateId withCompletion:(DataManagerCompletionBlock)completion;

- (void) sendRequestTosendPrivateMessageWithRequest:(NSURLRequest*)request andIsprogress:(BOOL) isProgress;
- (void) sendRequestToGetPrivateMessageForUser:(NSUInteger)userId withCompletion:(DataManagerCompletionBlock)completion;

- (void) sendRequestToGetAmmoCoinsPackWithCompletion:(DataManagerCompletionBlock)completion;

- (void) sendRequestToGetCanvasWithCompletion:(DataManagerCompletionBlock)completion;

- (void) sendRequestToReadMessage:(NSUInteger)messageID
				   withCompletion:(DataManagerCompletionBlock)completion
						  failure:(DataManagerFailureBlock)failureBlock;

- (void) sendRequestToGetPacksFromMarketplaceWithCompletion:(DataManagerCompletionBlock)completion;

- (PackInfo*) getPackForId:(NSUInteger)packId;

- (void) sendRequestToSaveSubmission:(SubmissionInfo*)info withCompletion:(DataManagerCompletionBlock)completion;
- (void) sendRequestToGetAllSubmissionWithCompletion:(DataManagerCompletionBlock)completion;

- (void) sendRequestToSearchUser:(EUserType)userType radius:(NSUInteger)radius categoryId:(NSArray*)categoryIds withCompletion:(DataManagerCompletionBlock)completion;

- (void) sendRequestValidateEmail:(NSString*)emailStr withCompletion:(DataManagerCompletionBlock)completion;
- (void) sendRequestValidatebusinessName:(NSString*)businessName andID:(NSUInteger)userID withCompletion:(DataManagerCompletionBlock)completion;
- (void) sendRequestToLoadLogoImageWithURL:(NSString*)logoURl;
@end

