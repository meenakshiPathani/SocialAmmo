//
//  BriefListViewController.h
//  Social Ammo
//
//  Created by Meenakshi on 04/02/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "SAInputAcessoryView.h"

@protocol BriefListDelegate <NSObject>

-(void) briefActionWithType:(EBriefAction)briefactiontype forBrief:(BriefInfo*)breifInfo;

@end

@interface BriefListViewController : UIViewController <SAInputAcessoryViewDelegate>
{
	IBOutlet SAInputAcessoryView*	_acessoryView;
	
	UIRefreshControl*	_refreshControl;
	IBOutlet UITableView*	_tableView;
}
@property(nonatomic, weak)id<BriefListDelegate> delegate;

- (void) beginRefreshingTableView;

@end
