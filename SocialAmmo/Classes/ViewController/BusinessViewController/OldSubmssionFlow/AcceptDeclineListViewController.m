//
//  AcceptDeclineListViewController.m
//  Social Ammo
//
//  Created by Rupesh Kumar on 3/21/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "AcceptDeclineListViewController.h"
#import "AcceptBreifCell.h"
#import "ImageZoomViewController.h"
#import "SocialSharing.h"
#import "ZoomView.h"
#import <Social/Social.h>
#import <Pinterest/Pinterest.h>

#define  kCellHeight 270.0

@interface AcceptDeclineListViewController ()<AcceptBreifCellDelegate>

@end

@implementation AcceptDeclineListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCompletionBlock:(AcceptDeclineListCompletionBlock)block
{
    self = [super initWithNibName:kAcceptDeclineListViewNib bundle:nil];
    if (self) {
        // Custom initialization
		self.completion = block;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[super addBackButton];
	
	self.title = @"Accepted";

	
	UINib* nib = [UINib nibWithNibName:kAcceptBreifCellNib bundle:nil];
	[_listTableView registerNib:nib forCellReuseIdentifier:@"AcceptBriefCellID"];
	
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
	static NSString* cellIdentifier = @"AcceptBriefCellID";
	
	AcceptBreifCell* cell = (AcceptBreifCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
	UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, (section == 0)?20:5)];
	headerView.backgroundColor = [UIColor clearColor];
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	// To provide gap between top and other section
    return (section == 0)?20:5;
}

#pragma mark -- AcceptBreifCell delegate

- (void) handleBufferAction
{
	[UIUtils messageAlert:kWorkInProgress title:@"" delegate:nil];
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


- (void) handleShareAction:(NSInteger)tagValue withBriefContentInfo:(BriefContentInfo*)briefContentInfo
				  andImage:(UIImage*)sharedImage
{
	if ([UIUtils isConnectedToNetwork] == NO)
	{
		[UIUtils messageAlert:kNetworkErrorMessage title:kNetworkError delegate:nil];
		return;
	}
	
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:briefContentInfo.
						  thumbnilUrl,@"ThumbImageURl",briefContentInfo.fullImageUrl,@"FullImageURL"
						  ,briefContentInfo.userName,@"UserName",sharedImage,@"SharedImage",nil];
	
	SocialSharing* socialSharing = [[SocialSharing alloc] initWithInfo:dict andController:self];
	switch (tagValue)
	{
		case EFaceBookShare:
			[socialSharing shareOnFacebook];
			break;
			
		case ETwitterShare:
			[socialSharing shareOnTwitter];
			break;
			
		case ELinkdInShare:
			[socialSharing shareOnLinkdIn];
			break;
			
		case EInstagramShare:
			[self shareOnInstagram:briefContentInfo];
			break;
			
		case EPinInterestShare:
			[socialSharing shareOnPinInterest];
			break;
			
		default:
			break;
	}
}

- (void) showProfileForId:(NSUInteger)userId
{
//	[super sendRequestToGetProfileInfo:userId userType:ESearchTypeUser];
}

- (void) showMessageforUserWithContentInfo:(BriefContentInfo*)contentInfo;
{
//	MessageViewController* viewCtrl = [[MessageViewController alloc] initWithNibName:kMessageViewNib bundle:nil];
//	viewCtrl.userId = contentInfo.userId;
//	viewCtrl.userName = contentInfo.userName;
//	viewCtrl.unlockMessageThread = contentInfo.messageThreadUnlock;
//	[self.navigationController pushViewController:viewCtrl animated:YES];
}

#pragma mark -- Private methods

- (void) shareOnInstagram:(BriefContentInfo*)briefContentInfo
{
	NSURL *instagramURL = [NSURL URLWithString:@"instagram://"];
	
	if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
	{
		NSURL* url = [NSURL URLWithString:briefContentInfo.fullImageUrl];
		UIImage* sharedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
		if (sharedImage)
		{
			[self openDocIntractWithImage:sharedImage andInfo:briefContentInfo];
		}
		else
			[UIUtils messageAlert:kWaitSaveMessage title:@"" delegate:nil];
	}
	else
		[UIUtils messageAlert:kInstagramErrormessage title:@"" delegate:nil];
}


- (void) openDocIntractWithImage:(UIImage*)sharedImage andInfo:(BriefContentInfo*)briefContentInfo
{
	NSData* imageData = UIImagePNGRepresentation(sharedImage);
	NSString* imagePath = [UIUtils documentDirectoryWithSubpath:@"image.igo"];
	[imageData writeToFile:imagePath atomically:NO];
	NSURL* fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"file://%@",
											 imagePath]];

	NSString* captionStr = [NSString stringWithFormat:kCaptionMessage,
							[UIUtils checknilAndWhiteSpaceinString:briefContentInfo.userName]];
	
	self.documentController = [self setupControllerWithURL:
							   fileURL usingDelegate:self];
	self.documentController.annotation = [NSDictionary dictionaryWithObject:captionStr
																	 forKey:@"InstagramCaption"];
	self.documentController.UTI = @"com.instagram.photo";
	[self.documentController presentOpenInMenuFromRect:self.view.frame inView:self.view
											  animated:YES];
}

#pragma mark-
#pragma mark UIDocumentInteractionController delegate


- (UIDocumentInteractionController *) setupControllerWithURL:(NSURL*)fileURL                                               usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate
{
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}

@end
