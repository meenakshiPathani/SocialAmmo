//
//  DPFacebookSession.m
//  DuelPics
//
//  Created by Meenakshi on 21/04/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "SCAFacebookSession.h"
#import "AppPrefData.h"

NSString* const kAppLocaleErrorDomain = @"com. The Social Ammo.DuelPics.ErrorDomain";

@interface SCAFacebookSession ()

@end

@implementation SCAFacebookSession

+ (void)closeSession
{
	[FBSession.activeSession closeAndClearTokenInformation];
}

+ (BOOL)activeSessionIsOpenWithPermissions:(NSArray *)permissions
{
	FBAccessTokenData* tokenData = [[FBSessionTokenCachingStrategy defaultInstance]
									fetchFBAccessTokenData];
	FBSession* session = [[FBSession alloc] initWithPermissions:permissions];
	BOOL isOpen = [session openFromAccessTokenData:tokenData completionHandler:nil];
	if (isOpen)
	{
		[FBSession setActiveSession:session];
	}
	return isOpen;
}

+ (void)openSessionWithPermissions:(NSArray *)permissions block:(SCAFacebookSessionPostCompletion)block
{
	if ([[FBSession activeSession] isOpen])
	{
		[self getInfoForSelfWithBlock:block];
	}
	else
	{
		FBSession* session = [[FBSession alloc] initWithPermissions:permissions];
		[FBSession setActiveSession:session];
		[session openWithBehavior:FBSessionLoginBehaviorForcingWebView
				completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
			[self sessionStateChanged:session state:status error:error block:block];
		}];
	}
}

+ (void)postImage:(UIImage *)image completion:(SCAFacebookSessionPostCompletion)completion
{
	if ([FBSession.activeSession.permissions indexOfObject:@"user_photos"] == NSNotFound)
    {
        [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"user_photos"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
												if (!error)
												{
                                                    // re-call assuming we now have the permission
                                                    [SCAFacebookSession postImage:image
																	   completion:completion];
                                                }
                                            }];
    }
    else
	{
		if (image && [image isMemberOfClass:[UIImage class]])
		{
			[FBRequestConnection startForUploadPhoto:image
								   completionHandler:^(FBRequestConnection *connection, id result,
													   NSError *error) {
									   completion(result, error);
			}];
		}
		else
		{
			NSString* desc = image ? @"Not an UIImage Object" : @"Object must be not nil";
			completion(nil,[SCAFacebookSession errorLocalWithDescription:desc]);
		}
	}
}

+ (void)postText:(NSString *)text completion:(SCAFacebookSessionPostCompletion)completion
{
	if (text && text.length > 0)
	{
		[FBRequestConnection startForPostStatusUpdate:text
									completionHandler:^(FBRequestConnection *connection, id result,
														NSError *error) {
										completion(result, error);
		}];
	}
	else
	{
		NSString* desc = text ? @"Text must be non empty" : @"Object must be not nil";
		completion(nil,[SCAFacebookSession errorLocalWithDescription:desc]);
	}
}

#pragma mark - Private Method

+ (SCAFacebookSession *)dPFacebookSessionInstance
{
	static SCAFacebookSession* sDPFacebookSession;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sDPFacebookSession = [[SCAFacebookSession alloc] init];
	});

	return sDPFacebookSession;
}

+ (NSError *)errorLocalWithDescription:(NSString *)description
{
	NSDictionary* userInfo = @{NSLocalizedDescriptionKey : description};
	NSError* error = [NSError errorWithDomain:kAppLocaleErrorDomain
										 code:2
									 userInfo:userInfo];
	
	return error;
}

+ (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
					  block:(SCAFacebookSessionPostCompletion)block
{
	if (error)
	{		// error code means user clicked on cancel
//		if (error.code == 2)
//		{
//			block(nil,error);
//		}
//		else
//		{
			block(nil,error);
//		}
	}
	else
	{
		switch (state)
		{
			case FBSessionStateOpen:
			{
				_gAppPrefData.fbToken = session.accessTokenData.accessToken;
				[_gAppPrefData saveAllData];
				
				[self getInfoForSelfWithBlock:block];
			}
				break;

			case FBSessionStateClosed:
			case FBSessionStateClosedLoginFailed:
				[FBSession.activeSession closeAndClearTokenInformation];
				break;

			default:
				break;
		}
	}
}

+ (void)getInfoForSelfWithBlock:(SCAFacebookSessionPostCompletion)block
{
	[_gAppDelegate showLoadingView:YES];

	[FBRequestConnection
	 startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
		 [_gAppDelegate showLoadingView:NO];

		 block(result,error);
	 }];
}

@end
