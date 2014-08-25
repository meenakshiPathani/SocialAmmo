//
//  MessageNotificationViewController.h
//  Social Ammo
//
//  Created by Rupesh Kumar on 4/28/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


@interface MessageNotificationViewController : UIViewController
{
	__weak IBOutlet UITableView* _listTableView;
			IBOutlet UIView* _headerView;
	
	UIRefreshControl*	_refreshControl;
	ERequestMessage _requestmessageType;
}
@property (nonatomic, assign)BOOL messageScreenVisible;

- (void) beginRefreshingTableView;

@end
