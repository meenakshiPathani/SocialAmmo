//
//  CreatorBeaconViewController.m
//  SocialAmmo
//
//  Created by Rupesh Kumar on 7/29/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "CreatorHubViewController.h"
#import "BusinessOpenSubmissionInfo.h"
#import "CreatorBeaconPageView.h"

#import "CreatorBeaconViewController.h"

#define kArrowHeight (kIPhone5)?66.0:56.0
#define kArrwoY 	(kIPhone5)?418.0:343.0
#define kScrollHeight (kIPhone5)?385:290

@interface CreatorBeaconViewController () <CreatorBeaconPageViewDelegate>
{
	NSArray*			_businessIdList;
	BusinessOpenSubmissionInfo*		_openSubmisisonInfo;
	CGRect _leftInitialFrame;
	CGRect _rightIntialFrame;
	
	CAGradientLayer* _maskLayer;
}

@end

@implementation CreatorBeaconViewController

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
	
	_visiblePages = [[NSMutableSet alloc] init];
	_recycledPages = [[NSMutableSet alloc] init];
	
	_leftInitialFrame = _leftArraowBtn.frame;
	_rightIntialFrame = _rightArraowBtn.frame;
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self addGradientLayer];
	[self sendRequestToGetBeaconBusiness:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark -- Button action

- (IBAction) rightarraowBtnAction:(id)sender
{
//	[self getNextOpenSubmission];
}

- (IBAction) leftarraowBtnAction:(id)sender
{
//	[self getNextOpenSubmission];
}

- (IBAction) locationSearchAction:(id)sender
{
	
}

- (IBAction) normalSearchAction:(id)sender
{
	
}

#pragma  mark -- paging

- (IBAction) changePage
{
	NSInteger currentPage = _pageController.currentPage+1;
	CGPoint offset = CGPointMake(currentPage *(kScrollHeight), 0);
    [_scrollView setContentOffset:offset animated:YES];
    _pageControlBeingUsed = NO;
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

- (CreatorBeaconPageView*) dequeueRecycledPage
{
    CreatorBeaconPageView* page = [_recycledPages anyObject];
	if (page)
	{
        [_recycledPages removeObject:page];
		[page cleanUp];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
	for (CreatorBeaconPageView* page in _visiblePages)
	{
        if (page.pageNumber == index)
		{
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (void) configurePage:(CreatorBeaconPageView*)page forIndex:(NSUInteger)index
{
    if (index > _businessIdList.count)
        return;
    page.pageNumber = index;
	
	CGRect frame = _scrollView.bounds;
	
	frame.origin.y = (index * frame.size.height);
    page.frame = frame;
  	
	if (_businessIdList.count > index)
	{
		[page setOpenSubmissionDetails:_openSubmisisonInfo];
	}
}

- (void) loadPages
{
    CGRect visibleBounds = _scrollView.bounds;
	
    NSUInteger firstNeededPageIndex = floorf(CGRectGetMinY(visibleBounds) / CGRectGetHeight(visibleBounds));
    NSUInteger lastNeededPageIndex  = floorf((CGRectGetMaxY(visibleBounds)-1) / CGRectGetHeight(visibleBounds));
	
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, _businessIdList.count - 1);
	
	_pageController.currentPage = firstNeededPageIndex;
	
	for (CreatorBeaconPageView* page in _visiblePages)
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
            CreatorBeaconPageView* page = [self dequeueRecycledPage];
            if (page == nil)
			{
                page = [[CreatorBeaconPageView alloc] initWithPageNumber:displayIndex];
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

		CGFloat pageheight = _scrollView.frame.size.height;
		int page = floor((_scrollView.contentOffset.y - pageheight / 2) / pageheight) + 1;
		_pageController.currentPage = page;
		if (page>=1)
		{
			CGFloat diffrencPara = (kScrollHeight)/(kArrowHeight);
			NSInteger ofset = sender.contentOffset.y -(page*(kScrollHeight));
			CGFloat height  = _rightIntialFrame.size.height -  (ofset/diffrencPara);
			if (height > 10 && height < (kArrowHeight-1))
			{
				CGFloat updateY = (kArrwoY) + (kArrowHeight) - height;
				_rightIntialFrame.size.height = height;
				_leftInitialFrame.size.height = height;
				_rightIntialFrame.origin.y = updateY;
				_leftInitialFrame.origin.y = updateY;
				_leftArraowBtn.frame = _leftInitialFrame;
				_rightArraowBtn.frame = _rightIntialFrame;
				
				NSLog(@"rupesh %f  %f ", height, _scrollView.contentOffset.y );

			}
		}
		[CATransaction begin];
		[CATransaction setDisableActions:YES];
		_maskLayer.position = CGPointMake(0, _scrollView.contentOffset.y);
		[CATransaction commit];
	}
}

- (void) scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
	_pageControlBeingUsed = NO;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
	_pageControlBeingUsed = NO;
	
	CGFloat pageheight = _scrollView.frame.size.height;
	int page = floor((_scrollView.contentOffset.y - pageheight / 2) / pageheight) + 1;
	_pageController.currentPage = page;
	
	NSString* buisnessId = [_businessIdList objectAtIndex:page];
	
	if ([buisnessId intValue] != _openSubmisisonInfo.businessId)
	{
		[self sendRequestToGetBeaconBusiness:buisnessId];
	}
	_leftInitialFrame.size.height = kArrowHeight;
	_rightIntialFrame.size.height = kArrowHeight;
	_leftInitialFrame.origin.y = kArrwoY;
	_rightIntialFrame.origin.y = kArrwoY;
	
	_leftArraowBtn.frame =_leftInitialFrame;
	_rightArraowBtn.frame = _rightIntialFrame;
	NSLog(@"rupeshewewewewew %f dfdf %f", _leftInitialFrame.origin.y, _leftInitialFrame.size.height);

}

#pragma  mark-- CreatorBeacon Delegate

- (void) handlehideAction:(NSUInteger)businessID
{
	[self sendRequestToHideBusiness:businessID];
}

- (void) handleCreateAction:(BusinessOpenSubmissionInfo*)businessSubmisionInfo
{
	if ([self.delegate respondsToSelector:@selector(displayCreatorHubForSubmssion:)])
		[self.delegate displayCreatorHubForSubmssion:businessSubmisionInfo];
}

- (void) hadelSpecificbtnAction
{
	
}

#pragma mark- Service request

- (void) sendRequestToGetBeaconBusiness:(NSString*)businessId
{
	[_gAppDelegate showLoadingView:YES];
	
	UserInfo* info = _gDataManager.userInfo;
	
	NSString* radius = @"";
	NSString* postString = [NSString stringWithFormat:@"token=%@&latitude=%f&longitude=%f&radius=%@&business_id=%@", _gAppPrefData.sessionToken, info.userLocation.latitude, info.userLocation.longitude, radius, businessId];
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kGetBeaconBusiness
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
				 _businessIdList = [response objectForKey:@"businesses"];
				 _openSubmisisonInfo = [[BusinessOpenSubmissionInfo alloc] initWithInfo:[response objectForKey:@"user_data"]];
				 
				 [self initiateContentScrollView];

//				 [self setUpScreenDataWithInfo];
			 }
			 else
			 {
			 	 NSString* message = [response objectForKey:@"err_message"];
			 	 [UIUtils messageAlert:message title:nil delegate:nil];
			 }
		 }
	 }];
}

#pragma  mark --

- (void) sendRequestToHideBusiness:(NSUInteger)businessId
{
	[_gAppDelegate showLoadingView:YES];
	
	NSString* postString = [NSString stringWithFormat:@"token=%@&business_id=%lu", _gAppPrefData.sessionToken, (unsigned long)businessId];
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kHideBusiness
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
				 [self sendRequestToGetBeaconBusiness:@""];
			 }
			 else
			 {
			 	 NSString* message = [response objectForKey:@"err_message"];
			 	 [UIUtils messageAlert:message title:nil delegate:nil];
			 }
		 }
	 }];
}

- (void) getNextOpenSubmission
{
	NSUInteger nextIndex = 0;
	NSString* currentbusinessId = [NSString stringWithFormat:@"%lu",(unsigned long)_openSubmisisonInfo.businessId];
	
	for (NSString* businessId in _businessIdList)
	{
		if ([businessId intValue] == [currentbusinessId intValue])
		{
			nextIndex = [_businessIdList indexOfObject:businessId] +1;
		}
	}
	
	NSString* nextBusinessId = @"";
	if (nextIndex < _businessIdList.count)
		nextBusinessId =[_businessIdList objectAtIndex:nextIndex];
	[self sendRequestToGetBeaconBusiness:nextBusinessId];
}

- (void) initiateContentScrollView
{
	_scrollView.contentSize = CGSizeMake( _scrollView.frame.size.width, _scrollView.frame.size.height
										 * _businessIdList.count);
	_pageController.numberOfPages = _businessIdList.count;
    
	NSUInteger index = 0;
	NSString* currentBusinessId = [NSString stringWithFormat:@"%lu",(unsigned long)_openSubmisisonInfo.businessId];
	
	for (NSString* businessId in _businessIdList)
	{
		if ([businessId intValue] == [currentBusinessId intValue])
		{
			index = [_businessIdList indexOfObject:businessId];
		}
	}
	
	_scrollView.contentOffset = CGPointMake( _scrollView.contentOffset.x, _scrollView.frame.size.height* index);

	[self loadPages];
}

- (void) addGradientLayer
{
	if (_maskLayer)
		return;
	
	_maskLayer = [CAGradientLayer layer];
	
	CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
	CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
	
	_maskLayer.colors = [NSArray arrayWithObjects:(__bridge id)outerColor,
						 (__bridge id)innerColor, (__bridge id)innerColor,
						 (__bridge id)outerColor, nil];
	_maskLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
							[NSNumber numberWithFloat:0.1],
							[NSNumber numberWithFloat:0.9],
							[NSNumber numberWithFloat:1.0], nil];
	
	_maskLayer.bounds = _scrollView.frame;
	_maskLayer.anchorPoint = CGPointZero;
	
	_scrollView.layer.mask = _maskLayer;
}

@end
