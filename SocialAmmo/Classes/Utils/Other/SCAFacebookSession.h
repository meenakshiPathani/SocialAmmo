//
//  SCAFacebookSession.h
//  Social Ammo
//
//  Created by Rupesh on 13/05/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

NSString* const kAppLocaleErrorDomain;

typedef void (^SCAFacebookSessionPostCompletion) (id result, NSError* error);

@interface SCAFacebookSession : NSObject

+ (void)closeSession;
+ (void)openSessionWithPermissions:(NSArray *)permissions block:(SCAFacebookSessionPostCompletion)block;
+ (BOOL)activeSessionIsOpenWithPermissions:(NSArray *)permissions;

+ (void)postImage:(UIImage *)image completion:(SCAFacebookSessionPostCompletion)completion;
+ (void)postText:(NSString *)text completion:(SCAFacebookSessionPostCompletion)completion;

@end
