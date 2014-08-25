//
//  CreatorToolViewController.m
//  Social Ammo
//
//  Created by Rupesh Kumar on 6/4/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "ZipArchive.h"
#import "WebServiceManager.h"
#import "CreatorToolViewController.h"
#import "CreatorToolSubView.h"

#define kGridStartX 10.0
#define kGridStartY 0.0

#define kBuyPackAlertTag 100

@interface CreatorToolViewController ()<CreatorToolSubViewDelegate>

@end

@implementation CreatorToolViewController

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
	
	[self setUpDataForView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-

- (void) setUpDataForView
{
	[_herebtn addTarget:self action:@selector(hereBtnTouchDownAction) forControlEvents:UIControlEventTouchDown];
	
	NSArray* itemList = _gDataManager.packList;
	
	int column = 3;
	NSUInteger rows = (int) ceilf(itemList.count/(float)column);
	CGPoint pt = CGPointMake(kGridStartX, kGridStartY);
	int itemIndex = 0;
	for (int j= 0; j < rows; ++j)
	{
		int height = 0;
		pt.x = kGridStartX;
		for (int i = 0;  i < column ; ++i)
		{
			if (itemIndex < itemList.count)
			{
				CreatorToolSubView* creatorToolV = [CreatorToolSubView createCreatorToolSuBView];
				creatorToolV.delgate = self;
				[_scrollView addSubview:creatorToolV];
				[creatorToolV setOrigin:pt];
				[creatorToolV setScreenData:[itemList objectAtIndex:itemIndex]];
				pt.x += creatorToolV.frame.size.width + 5.0;
				height = creatorToolV.frame.size.height + 4.0;
				
				++itemIndex;
			}
		}
		pt.y += height;
	}
	
	CGRect rect = _bottomView.frame;
	rect.origin.y = pt.y+20;
	_bottomView.frame = rect;
	
	[_scrollView addSubview:_bottomView];
	_scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), pt.y+50);
}

#pragma  mark -- Creator Tool delegate

- (void) openPack:(PackInfo*)info
{
//	NSString* filePath = [_gDataManager getPackDirectory];
//	NSString* name = [info.packContentUrl lastPathComponent];
//	NSString* sourcePath = [filePath stringByAppendingString:name];
//	
//	if (![UIUtils isFileExistAtPath:sourcePath])
//	{
//		[self sendRequestToDownloadPack:info];
//	}
//	else
	{
		if ([self.observer respondsToSelector:@selector(displayCanvasForPack:)])
			[self.observer displayCanvasForPack:info];
	}
}

- (void) buyPack:(PackInfo*)info
{
	_packInfo = info;
	
	if (_packInfo.free)
	{
		if ([self.observer respondsToSelector:@selector(installFreePack:)])
			[self.observer installFreePack:_packInfo];
		return;
	}
	
	NSString* message = [NSString stringWithFormat:@"Do you want to buy the %@ pack. Its cost is %lu or $%lu.", info.packName, (unsigned long)info.coin, (unsigned long)info.cost];
	[UIUtils messageAlert:message title:nil delegate:self withCancelTitle:@"No" otherButtonTitle:@"Yes" tag:kBuyPackAlertTag];
}

- (IBAction)hereButtonaction:(id)sender
{
	_underlineview.backgroundColor = GET_COLOR(68, 231, 231, 1.0);
	[UIUtils messageAlert:kWorkInProgress title:@"" delegate:nil];
}

- (void) hereBtnTouchDownAction
{
	_underlineview.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.10];
}

#pragma mark-

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag == kBuyPackAlertTag)
	{
		if (buttonIndex == 1)
		{
			if ([self.observer respondsToSelector:@selector(displayPurchaseSheetForPack:)])
				[self.observer displayPurchaseSheetForPack:_packInfo];
		}
	}
}

#pragma mark-

- (void) sendRequestToDownloadPack:(PackInfo*)info
{
	[_gAppDelegate showLoadingView:YES];
	
	NSString* postString = @"";
	
	NSURLRequest* request = [WebServiceManager postRequestWithUrlString:info.packContentUrl
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
			 
			 // save & unzip the packs in document directory
			 
			 NSString* filePath = [_gDataManager getPackDirectory];
			 NSString* name = [info.packContentUrl lastPathComponent];
			 
			 NSString* sourcePath = [filePath stringByAppendingString:name];
			 
			 [UIUtils saveFileWithData:responseData withFilePath:sourcePath];
			 
			 filePath = [filePath stringByAppendingString:[NSString stringWithFormat:@"%@",info.packName]];
			 [ZipArchive unzipFileAtPath:sourcePath toDestination:filePath];
			 
			 if ([self.observer respondsToSelector:@selector(displayCanvasForPack:)])
				 [self.observer displayCanvasForPack:info];
		 }
	 }];
}

#pragma mark-

- (void) updateToolWithPackInfo:(PackInfo*)pack
{
	CreatorToolSubView* toolView = (CreatorToolSubView*)[self.view viewWithTag:pack.packId];
	[toolView displayOpenBtn];
}

@end
