//
//  AppPrefData.h
//
//  

@interface AppPrefData : NSObject 
{
}

@property (nonatomic, retain) NSString* emailId;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* deviceToken;
@property (nonatomic, retain) NSString* sessionToken;
@property (nonatomic, retain) NSString* fbToken;
@property (nonatomic, retain) NSString* linkedInToken;
@property (nonatomic, assign) BOOL islocationEnabled;


@property (nonatomic) BOOL isLogin;
@property (nonatomic) BOOL isRememberMe;
@property (nonatomic) BOOL isFreshLogin;

+ (AppPrefData*) sharedObject;

- (void) loadAllData;
- (void) saveAllData;

@end

#define _gAppPrefData [AppPrefData sharedObject]
