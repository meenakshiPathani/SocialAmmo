//
//  MessageNotificationViewController.m
//  Social Ammo
//
//  Created by Rupesh Kumar on 4/28/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

//#import "MessageViewController.h"
#import "MessageNotificationViewController.h"
#import "MessageNotificationTableCell.h"
#import "MessageInfo.h"

#define kLowerMessageLimit 19

@interface MessageNotificationViewController ()

@end

@implementation MessageNotificationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	UINib* nib = [UINib nibWithNibName:kMessageNotifiCellNib bundle:nil];
	[_listTableView registerNib:nib forCellReuseIdentifier:@"MessageNotificationCellID"];
	
	if ([_listTableView respondsToSelector:@selector(setSeparatorInset:)])
        [_listTableView setSeparatorInset:UIEdgeInsetsMake(0, 30, 0,30)];
	
	_requestmessageType = ERequestTopTwentyMessage;
	
	[self addRefreshControl];

	[self addHeaderView];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
		
	[_listTableView reloadData];
	
	[_listTableView setContentOffset:CGPointZero animated:NO];
	[self beginRefreshingTableView];
}

- (void) viewWillDisappear:(BOOL)animated
{
	[_refreshControl endRefreshing];
	
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
	_refreshControl = nil;
	_listTableView.delegate = nil;
	_listTableView = nil;
}


#pragma mark-

- (void) addRefreshControl
{
	_refreshControl = [[UIRefreshControl alloc] init];
	_refreshControl.tintColor = [UIColor lightGrayColor];
	
	[_refreshControl addTarget:self action:@selector(refreshMessageList)
			  forControlEvents:UIControlEventValueChanged];
	
	[_listTableView addSubview:_refreshControl];
}

#pragma mark --
#pragma mark -- TableView Data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return _gDataManager.messageinfoList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	static NSString* cellIdentifier = @"MessageNotificationCellID";
	
	MessageNotificationTableCell* cell = (MessageNotificationTableCell*) [tableView
											dequeueReusableCellWithIdentifier:cellIdentifier];
	cell.backgroundColor = [UIColor clearColor];
	
	MessageInfo* obj = [_gDataManager.messageinfoList objectAtIndex:indexPath.section];
	if (obj)
		[cell setUpInitial:obj];
	
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ((_gDataManager.messageinfoList.count == section+1) && (section >= kLowerMessageLimit))?50:0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	UIView* footerView  = [[UIView alloc] init];
	
	if ((_gDataManager.messageinfoList.count == section+1) && (section >= kLowerMessageLimit))
	{
		//create the button
		UIButton* btn = [self creatReadLessMoreButton];
		[footerView addSubview:btn];
	}
	
	return  footerView;
}

#pragma mark --
#pragma mark -- TableView Delegate method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//	MessageInfo* info = [_gDataManager.messageinfoList objectAtIndex:indexPath.section];
//	if ([info.messageRead boolValue] == NO)
//	{
//		[self sendRequestToReadmessage:info];
//		return;
//	}
//
//	[self openMessage:info];
}

#pragma  mark --

- (void) addHeaderView
{
	_listTableView.tableHeaderView = _headerView;
}

#pragma mark-
#pragma mark RefreshMessage methods

- (void) refreshMessageList
{
	[_gDataManager sendRequestToGetuserMessageList:_requestmessageType
									withCompletion:^(BOOL status, NSString* errorMessage,
													 ERequestType requestType)
	{
		[_listTableView reloadData];
		_gDataManager.userInfo.messageNotify = NO;

//		if (status)
//			[_listTableView reloadData];
		if(!status)
		{
			
//			AppDelegate* appdelegate = _gAppDelegate;
//			UINavigationController* navVC = (UINavigationController*)appdelegate.window.rootViewController;
//			if ([ navVC.topViewController isKindOfClass: [MessageNotificationViewController class]] && (requestType == ERequestTypeGetMessageList))
			
			if (self.messageScreenVisible)
				[UIUtils messageAlert:errorMessage title:nil delegate:nil];
		}
		
		[_refreshControl endRefreshing];
	}failure:^(){
		[_refreshControl endRefreshing];
	}];
}

- (void) beginRefreshingTableView
{
    [_refreshControl beginRefreshing];
	
    if (_listTableView.contentOffset.y == 0) {
		
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
						 animations:^(void){
			
            _listTableView.contentOffset = CGPointMake(0, - _refreshControl.frame.size.height);
			
			[self refreshMessageList];
			
        } completion:^(BOOL finished){
			
        }];
    }
}

#pragma mark-

- (void) sendRequestToReadmessage:(MessageInfo*)messageInfo
{
	[_gDataManager sendRequestToReadMessage:messageInfo.messageID
									withCompletion:^(BOOL status, NSString* errorMessage,
													 ERequestType requestType)
	 {
		 if (status)
		 {
			 [self openMessage:messageInfo];
		 }
		 else
		 {
			 [UIUtils messageAlert:errorMessage title:@"" delegate:nil];
		 }
		 
		 [_refreshControl endRefreshing];
	 }failure:^(){
		 [_refreshControl endRefreshing];
	 }];
}

- (void) displayPrivateMessageScreen:(MessageInfo*)info
{
//	MessageViewController* viewCtrl = [[MessageViewController alloc] initWithNibName:kMessageViewNib
//																			  bundle:nil];
//		viewCtrl.userId = info.userID;
//	viewCtrl.userName = info.userName;
//	viewCtrl.unlockMessageThread = YES;
//	[self.navigationController pushViewController:viewCtrl animated:YES];
}

- (UIButton*) creatReadLessMoreButton
{
	NSString* titleStr  = (_gDataManager.messageinfoList.count >
						   kLowerMessageLimit+1)? @"Read Less":@"Read More";
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	[button setTitle:titleStr forState:UIControlStateNormal];
	
	//the button should be as big as a table view cell
	[button setFrame:CGRectMake(100, 3, 120, 44)];
	
	//set title, font size and font color
	[button.titleLabel setFont:[UIFont fontWithName:kFontRalewayBold size:16]];
	[button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	
	//set action of the button
	[button addTarget:self action:@selector(readMoreButtonAction:) forControlEvents:
	 UIControlEventTouchUpInside];

	return button;
}

- (void) readMoreButtonAction:(UIButton*)button
{
	_requestmessageType = ([button.titleLabel.text
							isEqualToString:@"Read More"])?ERequestAllMessage:ERequestTopTwentyMessage;
	
	[self refreshMessageList];
}

- (void) openMessage:(MessageInfo*) messageInfo
{
	if ([messageInfo.messageType caseInsensitiveCompare:@"private message"] == NSOrderedSame)
	{
		[self displayPrivateMessageScreen:messageInfo];
	}
	else if ([messageInfo.messageType caseInsensitiveCompare:@"Message thread deleted."] ==
			 NSOrderedSame)
	{
		[UIUtils messageAlert:@"Work in progress" title:nil delegate:nil];
	}
	else	
	{
		[UIUtils messageAlert:@"Work in progress" title:nil delegate:nil];
	}
}
@end
