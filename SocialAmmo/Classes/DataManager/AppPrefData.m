//
//  AppPrefData.m
//
//

#import "AppPrefData.h"

static AppPrefData*	sAppPrefData = nil;

@implementation AppPrefData

@synthesize emailId, password, isLogin,isRememberMe,deviceToken,sessionToken;

+ (AppPrefData*) sharedObject
{
	if (sAppPrefData == nil)
	{
		sAppPrefData = [[AppPrefData alloc] init];
	}
	return sAppPrefData;
}

- (id) init
{
	if (self = [super init])
	{
		[self loadAllData];
	}
	return self;
}

- (void) loadAppPrefData
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary* dictionary = [defaults objectForKey:@"keyPreferenceData"];
	if (dictionary == nil)
	{
		self.emailId =  @"";
		self.password = @"";
		self.deviceToken = @"";
		self.isLogin = NO;
        self.isRememberMe = NO;
		self.sessionToken = @"";
		self.fbToken = @"";
		self.linkedInToken = @"";
		self.islocationEnabled = NO;
		self.isFreshLogin = NO;
	}
	else
	{
		self.emailId = [dictionary objectForKey:@"keyEmailId"];
		self.password = [dictionary objectForKey:@"keyPassword"];
        self.deviceToken = [dictionary objectForKey:@"keyDeviceToken"];
        self.sessionToken = [dictionary objectForKey:@"keySessionToken"];
		self.isLogin = [[dictionary objectForKey:@"keyIsLogin"] boolValue];
        self.isRememberMe = [[dictionary objectForKey:@"keyisRememberMe"] boolValue];
		self.fbToken = [dictionary objectForKey:@"keyFacebookToken"];
		self.linkedInToken = [dictionary objectForKey:@"keyLinkedInToken"];
		self.islocationEnabled = [[dictionary objectForKey:@"keyLocation"] boolValue];
		self.isFreshLogin = [[dictionary objectForKey:@"KeyFreshLogin"] boolValue];


	}
}

- (NSDictionary*) dataAsDictionary
{
	NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
	[dictionary setObject:self.emailId forKey:@"keyEmailId"];
	[dictionary setObject:self.password forKey:@"keyPassword"];
    [dictionary setObject:self.deviceToken forKey:@"keyDeviceToken"];
	[dictionary setObject:self.sessionToken forKey:@"keySessionToken"];
	[dictionary setObject:[NSNumber numberWithBool:self.isLogin] forKey:@"keyIsLogin"];
    [dictionary setObject:[NSNumber numberWithBool:self.isRememberMe] forKey:@"keyisRememberMe"];
	[dictionary setObject:self.fbToken forKey:@"keyFacebookToken"];
	[dictionary setObject:self.linkedInToken forKey:@"keyLinkedInToken"];
	[dictionary setObject:[ NSNumber numberWithBool:self.islocationEnabled] forKey:@"keyLocation"];
	[dictionary setObject:[ NSNumber numberWithBool:self.isFreshLogin] forKey:@"KeyFreshLogin"];

	return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void) saveAppPrefData
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[self dataAsDictionary] forKey: @"keyPreferenceData"];
	[defaults synchronize];
}

#pragma mark -

- (void) loadAllData
{
	[self loadAppPrefData];
}

- (void) saveAllData
{
	[self saveAppPrefData];
}

@end
