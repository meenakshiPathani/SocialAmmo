//
//  AppDelegate.h
//  Social Ammo
//
//  Created by Meenakshi on 06/01/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "UILoadingView.h"
#import "SAMenuViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
	UILoadingView*	_loadingView;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SAMenuViewController* viewController;
@property (assign, nonatomic) BOOL appInBackgroundState;

- (void) showAccountScreen;

- (void) showLoadingView:(BOOL)show;
- (void) showProgressView:(BOOL)show;
- (void) setLoadingViewTitle:(NSString*)title;
- (void) setProgressData:(float)dataValue;

- (void) registerKeyboardNotifications:(id)observer;
- (void) unregisterKeyboardNotifications:(id)observer;

- (void) initializeApplication:(UIViewController*)initialViewController;

- (void) initializeLocationManager;
- (void) updateLocation;

- (void) saveImageInApplicationDirectory:(UIImage*)image withCaption:(NSString*)caption;
- (BOOL) checkWIPImageExistwithTitle:(NSString*)title;

@end
