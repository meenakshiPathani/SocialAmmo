//
//  DeclineListViewController.m
//  Social Ammo
//
//  Created by Rupesh Kumar on 3/25/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "DeclineListViewController.h"
#import "DeclineTableCell.h"
#import "BriefContentInfo.h"
#import "ImageZoomViewController.h"
#import "ZoomView.h"

#define  kCellHeight		240.0
#define  kServicealerttag	800.0

@interface DeclineListViewController ()<DeclineTableCellDelegate>

@end

@implementation DeclineListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCompletionBlock:(DeclineListCompletionBlock)block
{
    self = [super initWithNibName:kDeclineListViewNib bundle:nil];
    if (self) {
        // Custom initialization
		self.completion = block;
    }
    return self;
}


- (void) viewDidLoad
{
	[super viewDidLoad];
	
	[super addBackButton];

	self.title = @"Declined";

	UINib* nib = [UINib nibWithNibName:kDeclineTableCellNib bundle:nil];
	[_listTableView registerNib:nib forCellReuseIdentifier:@"DeclineTableCellID"];
	
	if ([_listTableView respondsToSelector:@selector(setSeparatorInset:)])
        [_listTableView setSeparatorInset:UIEdgeInsetsZero];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
	
}

#pragma mark-back button action

-(void) backButtonAction:(UIButton*)sender
{
	self.completion();
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --
#pragma mark -- TableView Data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return _gDataManager.briefContentInfoList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	static NSString* cellIdentifier = @"DeclineTableCellID";
	
	DeclineTableCell* cell = (DeclineTableCell*) [tableView dequeueReusableCellWithIdentifier:
															  cellIdentifier];
	cell.delegate = self;
	cell.backgroundColor = [UIColor clearColor];
	cell.layer.cornerRadius = 10.0;
	
	BriefContentInfo* obj = [_gDataManager.briefContentInfoList objectAtIndex:indexPath.section];
	if (obj)
		[cell setUpInitial:obj];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, (section== 0) ? 20: 5)];
	headerView.backgroundColor = [UIColor clearColor];
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	// To provide gap between top and other section
    return (section == 0)?20:5;
}

#pragma mark -- Decline cell delegate

- (void) handleReApproveAction:(BriefContentInfo*)obj
{
	
	[_gDataManager sendRequestToUpdateBriefContent:EBriefPostForReApprove withId:obj.contentID withPaymentKey:@"" 								withCompletion:^(BOOL status, NSString* message, ERequestType
													 requestType){
										if (status)
											[UIUtils messageAlert:message title:@"" delegate:self
															  tag:kServicealerttag];
										else
											[UIUtils messageAlert:message title:nil delegate:nil];
									}];
}

- (void) handleRemoveAction:(BriefContentInfo*)obj
{
	[_gDataManager sendRequestToUpdateBriefContent:EBriefPostForDeleted withId:obj.contentID withPaymentKey:@"" 								withCompletion:^(BOOL status, NSString* message, ERequestType requestType){
		if (status)
			[UIUtils messageAlert:message title:@"" delegate:self
							  tag:kServicealerttag];
		else
			[UIUtils messageAlert:message title:nil delegate:nil];
	}];

}

- (void) showProfileForId:(NSUInteger)userId
{
//	[super sendRequestToGetProfileInfo:userId userType:ESearchTypeUser];
}

- (void) handleZoomIngwithImage:(NSString*)imageUrl withSender:(UIButton*)sender
{
	if (imageUrl.length > 0)
	{
		ImageZoomViewController* zoomVC = [[ImageZoomViewController alloc] initWithNibName:
										   kImageZoomViewNib bundle :nil];
		UINavigationController* navC = [[UINavigationController alloc] initWithRootViewController:
										zoomVC];
		zoomVC.fullImageURL = imageUrl;
		
		// Button center animation
		navC.navigationBar.hidden = YES;
		CGPoint pt = [sender center];
		CGRect frame = [sender convertRect:sender.frame toView:self.view];
		pt.y += frame.origin.y;
		zoomVC.closeCenter = pt;
		
		[super popUpView:navC.view fromPoint:pt];
		[self addChildViewController:navC];
        
		/* Zoom by zoom view
		 AppDelegate* appDelagte = _gAppDelegate;
		 ZoomView* zoomview = [ZoomView zoomView];
		 [zoomview showViewWithURL:imageUrl onView:appDelagte.window];
		 */
		
		/* Flip animation code
		 zoomVC.fullImageURL = imageUrl;
		 UINavigationController *navigationController = [[UINavigationController alloc]
		 initWithRootViewController:zoomVC];
		 navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
		 navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
		 [self presentViewController:navigationController animated:YES completion:nil];
		 [self.navigationController pushViewController:zoomVC animated:YES];
		 */
	}
	else
		[UIUtils messageAlert:@"Image not available." title:@"" delegate:nil];
}

#pragma mark --
#pragma mark -- Alertview Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		self.completion();
		[self.navigationController popViewControllerAnimated:YES];
	}
}

@end
