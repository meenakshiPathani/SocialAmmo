//
//  BusinessBeaconViewController.m
//  SocialAmmo
//
//  Created by Rupesh Kumar on 7/30/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "CreatorInfo.h"
#import "BusinessBeaconViewController.h"
#import "iCarousel.h"
#import "CaroselItemView.h"
#import "BusinessBeaconpageView.h"

@interface BusinessBeaconViewController ()<CaroselItemViewDelegate,BusinessBeaconpageViewDelegate>
{
	NSArray*	_submissionList;
	
	NSArray*	_creatorIdList;
	
	CreatorInfo*	_creatorInfo;
	
	SubmissionInfo*		_currentSubmisisonInfo;
}

@end

@implementation BusinessBeaconViewController

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
	
//	self.businessList = [NSArray arrayWithObjects:@"A",@"A",@"A",@"A",@"A",@"A", nil];
	
	_caroselFlowView.type = iCarouselTypeCoverFlow2;
	CGFloat height = (kIPhone5) ? 488 : 368;
	_outerScrollView.frame = CGRectMake(0, 20, 320, height);
	_outerScrollView.contentSize = CGSizeMake(320, 488);
	
	UISwipeGestureRecognizer* leftgesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(enableScroolView:)];
	leftgesture.direction = UISwipeGestureRecognizerDirectionLeft;
	leftgesture.cancelsTouchesInView = YES;
	
	UISwipeGestureRecognizer* rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(enableScroolView:)];
	rightGesture.direction = UISwipeGestureRecognizerDirectionRight;
	rightGesture.cancelsTouchesInView = YES;
	[_scrollView addGestureRecognizer:rightGesture];
	[_scrollView addGestureRecognizer:leftgesture];
	
//	[self initiateContentScrollView];
	
	_recycledPages = [[NSMutableSet alloc] init];
	_visiblePages = [[NSMutableSet alloc] init];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
		
	[self sendRequestToLoadBusinessBeaconData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    _caroselFlowView.delegate = nil;
    _caroselFlowView.dataSource = nil;
	
	_pageController = nil;
	_scrollView = nil;
	self.businessList = nil;	
	[super viewDidUnload];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _submissionList.count + 1;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
	CaroselItemView* itemView = (CaroselItemView*)view;
	
    if (!itemView)
    {
    	//load new item view instance from nib
        //control events are bound to view controller in nib file
        //note that it is only safe to use the reusingView if we return the same nib for each
        //item view, if different items have different contents, ignore the reusingView value
    	itemView = (CaroselItemView*)[CaroselItemView createCaroselItemView];
		itemView.delgate = self;
    }
	
	BOOL isLastIndex = (index == _submissionList.count) ? YES : NO;
	SubmissionInfo* info = (index == _submissionList.count)? nil : [_submissionList objectAtIndex:index];
	[itemView setScreenData:info lastIndex:isLastIndex];
	
    return itemView;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
	if (carousel.currentItemIndex < _submissionList.count)
	{
		_scrollView.hidden = NO;
		[self sendRequestToGetCreatorForSubmission:@""];
	}
	else
	{
		_scrollView.hidden = YES;
	}
}

#pragma  mark --
#pragma  mark -- CaroselItemviewDelegate

- (void) settingButtonTaped
{
	[UIUtils messageAlert:@"Work in Progress" title:@"" delegate:nil];
}

- (void) createNewTaped
{
	[UIUtils messageAlert:@"Work in Progress" title:@"" delegate:nil];
}


#pragma  mark -- paging

- (IBAction) changePage
{
	NSInteger currentPage = _pageController.currentPage+1;
	CGPoint offset = CGPointMake(currentPage *291, 0);
    [_scrollView setContentOffset:offset animated:YES];
    _pageControlBeingUsed = NO;
}

#pragma  mark -- Button Action

- (IBAction) tapOnArrowIcon:(id)sender
{
	NSInteger currentPage = _pageController.currentPage+1;
	if (currentPage >= _creatorIdList.count)
		return;
	
	CGPoint offset = CGPointMake(currentPage *291, 0);
    [_scrollView setContentOffset:offset animated:YES];
	_pageControlBeingUsed = NO;
	
	[self loadPages];
	
	NSString* creatorId = [_creatorIdList objectAtIndex:currentPage];
	
	if ([creatorId intValue] != _creatorInfo.creatorId)
	{
		[self sendRequestToGetCreatorForSubmission:creatorId];
	}
}


#pragma  mark --
#pragma mark Data set methods

- (NSString*) checkNil:(NSString*)string
{
    return (string == nil) ? @"" : string;
}

-(void) clearVisiblePageData
{
    for (UIView* view in _visiblePages)
    {
        [view removeFromSuperview];
    }
    [_visiblePages removeAllObjects];
    [_recycledPages removeAllObjects];
}

- (BusinessBeaconpageView*) dequeueRecycledPage
{
    BusinessBeaconpageView* page = [_recycledPages anyObject];
	if (page)
	{
        [_recycledPages removeObject:page];
		[page cleanup];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
	for (BusinessBeaconpageView* page in _visiblePages)
	{
        if (page.pageNumber == index)
		{
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (void) configurePage:(BusinessBeaconpageView*)page forIndex:(NSUInteger)index
{
    if (index > _creatorIdList.count)
        return;
    page.pageNumber = index;
	
	CGRect frame = _scrollView.bounds;
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	if (screenRect.size.height > 480)
	{
		// this is an iPhone 5+
		frame.size.height = 312;
	}
	
	frame.origin.x = (index * frame.size.width);
    page.frame = frame;
  	
	if (_creatorIdList.count > index)
	{
//		Services* obj = [self.businessList objectAtIndex:index];
		[page setDetails:_creatorInfo];
	}
}

- (void) loadPages
{
    CGRect visibleBounds = _scrollView.bounds;
	
    NSUInteger firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    NSUInteger lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
	
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, self.businessList.count - 1);
	
	_pageController.currentPage = firstNeededPageIndex;
	
	for (BusinessBeaconpageView* page in _visiblePages)
	{
        if (page.pageNumber < firstNeededPageIndex || page.pageNumber > lastNeededPageIndex)
		{
            [_recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
	
    [_visiblePages minusSet:_recycledPages];
    
	for (NSUInteger displayIndex = firstNeededPageIndex; displayIndex <= lastNeededPageIndex; displayIndex++)
	{
//        if (![self isDisplayingPageForIndex:displayIndex])
		{
            BusinessBeaconpageView* page = [self dequeueRecycledPage];
            if (page == nil)
			{
                page = [[BusinessBeaconpageView alloc] initWithPageNumber:displayIndex];
				page.delgate = self;
            }
            [self configurePage:page forIndex:displayIndex];
            [_scrollView addSubview:page];
            [_visiblePages addObject:page];
        }
    }
}


- (void) enableScroolView:(UISwipeGestureRecognizer*)gesture
{
	[_scrollView setScrollEnabled:YES];
}

#pragma mark -
#pragma mark ScrollView delegate

- (void) scrollViewDidScroll:(UIScrollView*) sender
{
	if (!_pageControlBeingUsed)
	{
		[self loadPages];
		
		CGFloat pageWidth = _scrollView.frame.size.width;
		int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		_pageController.currentPage = page;
	}
}

- (void) scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
	_pageControlBeingUsed = NO;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
	_pageControlBeingUsed = NO;
	
	CGFloat pageWidth = _scrollView.frame.size.width;
	int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	_pageController.currentPage = page;
	
	NSString* creatorId = [_creatorIdList objectAtIndex:page];
	
	if ([creatorId intValue] != _creatorInfo.creatorId)
	{
		[self sendRequestToGetCreatorForSubmission:creatorId];
	}
}

#pragma mark -
#pragma mark BusinessBeaconpage delegate

- (void) handleInvitebuttonaction
{
	NSUInteger index = _caroselFlowView.currentItemIndex;
	SubmissionInfo* info = [_submissionList objectAtIndex:index];

	[self sendRequestToPostInvitation:_creatorInfo.creatorId forSubmission:info.submisionId];
	
}

- (void) disbaleOuterscroll
{
	_scrollView.scrollEnabled = NO;
}

- (void) handleHideButtonAction
{
	NSUInteger index = _caroselFlowView.currentItemIndex;
	SubmissionInfo* info = [_submissionList objectAtIndex:index];
	
	[self sendRequestToHideCraetor:_creatorInfo.creatorId forSubmission:info.submisionId];
}

#pragma mark-

- (void) sendRequestToLoadBusinessBeaconData
{
	[_gDataManager sendRequestToGetAllSubmissionWithCompletion:^(BOOL status, NSString* message, ERequestType requestType){
		if (status)
		{
			_submissionList = _gDataManager.submissionList;
			[_caroselFlowView reloadData];
			
			if (_submissionList.count > 0)
			{
				_currentSubmisisonInfo = [_submissionList objectAtIndex:0];
				[self sendRequestToGetCreatorForSubmission:@""];
			}
		}
		else
		{
			[UIUtils messageAlert:message title:nil delegate:nil];
		}
	}];
}

#pragma mark- Service request

- (void) sendRequestToGetCreatorForSubmission:(NSString*)creatorId
{
	NSUInteger index = _caroselFlowView.currentItemIndex;
	if (index >= _submissionList.count)
		return;

	SubmissionInfo* info = [_submissionList objectAtIndex:index];

	[_gAppDelegate showLoadingView:YES];
	
	NSString* postString = [NSString stringWithFormat:@"token=%@&submission_id=%lu&creator_id=%@", _gAppPrefData.sessionToken, (unsigned long)info.submisionId, creatorId];
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kGetCreatorForSubmission
														   postString:postString];
	[WebServiceManager sendRequest:request
						completion:^ (NSData* responseData, NSError* error)
	 {
		 [_gAppDelegate showLoadingView:NO];
		 
		 if (error)
		 {
			 if (![error.domain caseInsensitiveCompare:@"NSPOSIXErrorDomain"]==NSOrderedSame)
				 [UIUtils messageAlert:kNetworkErrorMessage title:kNetworkError delegate:nil];
		 }
		 else
		 {
			 _Assert(responseData);
			 
			 DataManager* dataManager = _gDataManager;
			 NSDictionary* response = [dataManager getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [dataManager checkResponseStatus:response];
			 
			 if (status)
			 {
				 _creatorIdList = [response objectForKey:@"creators"];
				 _arrowBtn.hidden = (_creatorIdList.count > 0)?NO:YES;
				 _scrollView.hidden = (_creatorIdList.count > 0)?NO:YES;
				 _creatorInfo = [[CreatorInfo alloc] initWithInfo:[response objectForKey:@"user_data"]];
				 
				 [self initiateContentScrollView];
			 }
			 else
			 {
			 	 NSString* message = [response objectForKey:@"err_message"];
			 	 [UIUtils messageAlert:message title:nil delegate:nil];
			 }
		 }
	 }];
}

- (void) sendRequestToPostInvitation:(NSUInteger)creatorId forSubmission:(NSUInteger)submissionId
{
	[_gAppDelegate showLoadingView:YES];
	
	NSString* postString = [NSString stringWithFormat:@"token=%@&submission_id=%lu&creator_id=%lu", _gAppPrefData.sessionToken, (unsigned long)submissionId, (unsigned long)creatorId];
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kSendSubmissionInvitation
														   postString:postString];
	[WebServiceManager sendRequest:request
						completion:^ (NSData* responseData, NSError* error)
	 {
		 [_gAppDelegate showLoadingView:NO];
		 
		 if (error)
		 {
			 if (![error.domain caseInsensitiveCompare:@"NSPOSIXErrorDomain"]==NSOrderedSame)
				 [UIUtils messageAlert:kNetworkErrorMessage title:kNetworkError delegate:nil];
		 }
		 else
		 {
			_Assert(responseData);
			 
			DataManager* dataManager = _gDataManager;
			NSDictionary* response = [dataManager getResponseFromData:responseData];
			_Assert(response);
			 
			BOOL status = [dataManager checkResponseStatus:response];
			 
			NSString* message = (status) ?  [response objectForKey:@"message"] : [response objectForKey:@"err_message"];
			[UIUtils messageAlert:message title:nil delegate:nil];
		 }
	 }];
}

- (void) sendRequestToHideCraetor:(NSUInteger)creatorId forSubmission:(NSUInteger)submissionId
{
	[_gAppDelegate showLoadingView:YES];
	
	NSString* postString = [NSString stringWithFormat:@"token=%@&submission_id=%lu&creator_id=%lu", _gAppPrefData.sessionToken, (unsigned long)submissionId, (unsigned long)creatorId];
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kHideCreatorForSubmission
														   postString:postString];
	[WebServiceManager sendRequest:request
						completion:^ (NSData* responseData, NSError* error)
	 {
		 [_gAppDelegate showLoadingView:NO];
		 
		 if (error)
		 {
			 if (![error.domain caseInsensitiveCompare:@"NSPOSIXErrorDomain"]==NSOrderedSame)
				 [UIUtils messageAlert:kNetworkErrorMessage title:kNetworkError delegate:nil];
		 }
		 else
		 {
			 _Assert(responseData);
			 
			 DataManager* dataManager = _gDataManager;
			 NSDictionary* response = [dataManager getResponseFromData:responseData];
			 _Assert(response);
			 
			 BOOL status = [dataManager checkResponseStatus:response];
			 
			 if (status)
			 {
				 [self sendRequestToGetCreatorForSubmission:@""];
			 }
			 else
			 {
				 NSString* message = [response objectForKey:@"err_message"];
				 [UIUtils messageAlert:message title:nil delegate:nil];
			 }
		 }
	 }];
}


#pragma mark-

- (void) getNextCreator
{
	NSUInteger nextIndex = 0;
	NSString* currentCreatorId = [NSString stringWithFormat:@"%lu",(unsigned long)_creatorInfo.creatorId];
	
	for (NSString* creatorId in _creatorIdList)
	{
		if ([creatorId intValue] == [currentCreatorId intValue])
		{
			nextIndex = [_creatorIdList indexOfObject:creatorId] +1;
		}
	}
	
	NSString* nextCreatorId = @"";
	if (nextIndex < _creatorIdList.count)
		nextCreatorId =[_creatorIdList objectAtIndex:nextIndex];
	[self sendRequestToGetCreatorForSubmission:nextCreatorId];
}

- (void) initiateContentScrollView
{
	_scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width
										 * _creatorIdList.count, 0);
	_pageController.numberOfPages = _creatorIdList.count;
    
	NSUInteger index = 0;
	NSString* currentCreatorId = [NSString stringWithFormat:@"%lu",(unsigned long)_creatorInfo.creatorId];
	
	for (NSString* creatorId in _creatorIdList)
	{
		if ([creatorId intValue] == [currentCreatorId intValue])
		{
			index = [_creatorIdList indexOfObject:creatorId];
		}
	}

	_scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width* index  , _scrollView.contentOffset.y);
	
	[self loadPages];

}

@end
