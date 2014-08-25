//
//  BriefListViewController.m
//  Social Ammo
//
//  Created by Meenakshi on 04/02/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

//#import "SubmitCreditViewController.h"
//#import "SelectBriefLocationViewController.h"
#import "BusinessBriefTableCell.h"
#import "BriefListViewController.h"
#import "BriefListDetailViewController.h"
#import "AcceptDeclineListViewController.h"
#import "DeclineListViewController.h"

@interface BriefListViewController ()<BusinessBriefTableCellDelegate>
{
	NSArray*			_briefList;
}

@end

@implementation BriefListViewController

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
	
	UINib* nib = [UINib nibWithNibName:kBusinessBriefTableCellNib bundle:nil];
	[_tableView registerNib:nib forCellReuseIdentifier:@"BriefCell"];
	
	[_acessoryView setNextbuttonImage:@"btn_create.png"];
	_acessoryView.delegate = self;
	
	[self addRefreshControl];
	
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[_tableView setContentOffset:CGPointZero animated:NO];
	[self beginRefreshingTableView];
	
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(applicationEnteredForeground:)
//												 name:UIApplicationWillEnterForegroundNotification
//											   object:nil];
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
	_tableView.delegate = nil;
	_tableView = nil;
}

#pragma mark-

- (void) addRefreshControl
{
	_refreshControl = [[UIRefreshControl alloc] init];
	_refreshControl.tintColor = [UIColor whiteColor];
	
	[_refreshControl addTarget:self action:@selector(refreshBusinessList)
			  forControlEvents:UIControlEventValueChanged];
	
	[_tableView addSubview:_refreshControl];
}

#pragma mark-
#pragma SAInputAcessoryView dlegate methods-

- (void) acessoryButtonPressed
{
	[_refreshControl endRefreshing];
	[self dispalySelectBriefLocationScreen];
}

#pragma mark-
#pragma mark TableView delegate methods-

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [_briefList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	static NSString* cellIdentifier = @"BriefCell";
	
	BusinessBriefTableCell* cell = (BusinessBriefTableCell*) [tableView dequeueReusableCellWithIdentifier:
															  cellIdentifier];
	cell.delegate = self;
	cell.backgroundColor = [UIColor clearColor];
	BriefInfo* info = [_briefList objectAtIndex:indexPath.section];
	NSUInteger index = _briefList.count - indexPath.section;
	[cell setBriefInfoInCell:info index:index];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 140;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView* headerView = [[UIView alloc] initWithFrame:CGRectZero];
	headerView.backgroundColor = [UIColor clearColor];
	return headerView;
}

#pragma mark-

- (void) dispalySelectBriefLocationScreen
{
//	SelectBriefLocationViewController* viewCtrl = [[SelectBriefLocationViewController alloc] initWithNibName:kSelectBriefLocationViewNib bundle:nil];
//	[self.navigationController pushViewController:viewCtrl animated:NO];
}

#pragma mark-
#pragma mark RefreshBusiness methods

- (void) refreshBusinessList
{
	[_gDataManager sendRequestToGetBriefForBuisness:_gDataManager.userInfo.userId WithCompletion:^(BOOL status, NSString* errorMessage, ERequestType requestType){
		
		_gDataManager.userInfo.submissionNotify = NO;

		if (requestType == ERequestTypeGetBriefs)
		{
			if (status)
			{
				_briefList = _gDataManager.briefList;
				[_tableView reloadData];
			}
			else
			{
				if ([self.navigationController.topViewController isKindOfClass:[BriefListViewController class]] && (requestType == ERequestTypeGetBriefs))
					[UIUtils messageAlert:errorMessage title:nil delegate:nil];
			}
			[_refreshControl endRefreshing];
		}} failure:^(){
			[_refreshControl endRefreshing];
		}];
		
}

- (void) beginRefreshingTableView
{
    [_refreshControl beginRefreshing];
	
    if (_tableView.contentOffset.y == 0) {
		
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
			
            _tableView.contentOffset = CGPointMake(0, - _refreshControl.frame.size.height);
			
			[self refreshBusinessList];
			
        } completion:^(BOOL finished){
			
        }];
		
    }
}


#pragma mark--  Bussiness brief cell delegate

- (void) briefBtnActionWithType:(EBriefAction)briefactiontype forBrief:(BriefInfo*)breifInfo;
{
	if ([self.delegate respondsToSelector:@selector(briefActionWithType:forBrief:)])
		[self.delegate briefActionWithType:briefactiontype forBrief:breifInfo];
	
//	switch (briefactiontype)
//	{
//		case EBriefNewSubmission:
//			[self sendRequestToGetBreifContent:EBriefTypeNew andbriefID:breifInfo.briefId];
//			break;
//			
//		case EBriefCredit:
//			[self displayCreaditedBriefList:breifInfo];
//			break;
//			
//		case EBriefAccepted:
//			[self sendRequestToGetBreifContent:EBriefTypeAccepted andbriefID:breifInfo.briefId];
//			break;
//			
//		case EBriefDecliend:
//			[self sendRequestToGetBreifContent:EBriefTypeDeclined andbriefID:breifInfo.briefId];
//			break;
//			
//		default:
//			break;
//	}
	
}

#pragma  mark -- Services for brief Detail

- (void) sendRequestToGetBreifContent:(EBriefType)briefType andbriefID:(NSUInteger)breifID
{
	[_gDataManager sendRequestToGetbriefContent:briefType withId:breifID
								 withCompletion:^(BOOL status, NSString* message, ERequestType
												  requestType){
									 if (status)
										 [self displayBriefDetail:briefType];
									 else
										 [UIUtils messageAlert:message title:@"" delegate:nil];
								 }];
}

#pragma mark -- Screen navigation method

- (void) displayBriefDetail:(EBriefType)briefType
{
	switch (briefType)
	{
		case EBriefTypeNew:
			[self displayNewSubmissionDetailList];
			break;
			
		case EBriefTypeAccepted:
			[self displayAcceptedBriefList];
			break;
			
		case EBriefTypeDeclined:
			[self displayDeclinedBriefList];
			break;
		default:
			break;
	}
}

- (void) displayNewSubmissionDetailList
{
	BriefListDetailViewController* briefListVC = [[BriefListDetailViewController alloc] initWithNibName:																kBriefListDetailViewNib bundle:nil];
	[self.navigationController pushViewController:briefListVC animated:NO];
}

- (void) displayAcceptedBriefList
{
	AcceptDeclineListViewController* acceptedBLVC = [[AcceptDeclineListViewController alloc] initWithNibName:																kAcceptDeclineListViewNib bundle:nil];
	[self.navigationController pushViewController:acceptedBLVC animated:NO];
}

- (void) displayDeclinedBriefList
{
	DeclineListViewController* acceptedBLVC = [[DeclineListViewController alloc] initWithNibName:																kDeclineListViewNib bundle:nil];
	[self.navigationController pushViewController:acceptedBLVC animated:NO];
}

- (void) displayCreaditedBriefList:(BriefInfo*)info
{
//	SubmitCreditViewController* creditVC = [[SubmitCreditViewController alloc] initWithNibName:kSubmitCreditViewNib bundle:nil];
//	creditVC.briefInfo = info;
//	creditVC.heading = @"Top up brief";
//	creditVC.subHeading = @"Submit credit to the brief";
//	[self.navigationController pushViewController:creditVC animated:NO];

}


@end
