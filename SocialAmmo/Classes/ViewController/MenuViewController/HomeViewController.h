//
//  HomeViewController.h
//  SocialAmmo
//
//  Created by Rupesh Kumar on 7/10/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "HomeTopBarView.h"

#import "BriefListViewController.h"
#import "MessageNotificationViewController.h"
#import "CreatorBeaconViewController.h"
#import "BusinessBeaconViewController.h"

@interface HomeViewController : UIViewController
{
	HomeTopBarView* _homeTopbar;
	CreatorBeaconViewController* _creatorbeaconVC;
	BusinessBeaconViewController* _businessBeaconVC;
	
	MessageNotificationViewController*	_messageNotifVC;
	BriefListViewController*			_briefListVC;
}

@end
