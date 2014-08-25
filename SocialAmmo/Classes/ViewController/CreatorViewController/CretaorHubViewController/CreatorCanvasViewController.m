//
//  ContentCreatorEditPhotoViewController.m
//  Social Ammo
//
//  Created by Rupesh Kumar on 6/9/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


#import "ZipArchive.h"
#import "UIImage+Color.h"

#import "AppPrefData.h"

#import "ColorPickerView.h"
#import "LayerInfo.h"
#import "LayerView.h"
#import "LayerListViewController.h"
#import "SubmitContentViewController.h"
#import "WIPViewController.h"
#import "ImportImageViewController.h"
#import "CreatorCanvasViewController.h"
#import "SACEditToolView.h"
#import "AddCustomSubFolderView.h"
#import "CustomFolderInfo.h"
//#import "ImageBrandingViewController.h"
//#import "AddCaptionViewController.h"
#import "CustomImageView.h"


#define kSACEditScreenYShow (kIPhone5)? 298.0 : 240.0
#define KSACEeditScreenYHiden (kIPhone5)? 470.0: 382.0
#define kEditningYDiffrence 160.0

#define kLayerTag 2000
#define kReplaceAlertTag 7000
#define kMaxLayerCount 10

@interface CreatorCanvasViewController ()<SACEditToolViewDelegate,AddCustomSubFolderViewDelegate, LayerViewDelegate, ColorPickerDelegate, WIPViewControllerDelegate, LayerListViewDelegate>
{
	ImportImageViewController*	_importImageVC;
	WIPViewController*			_wipVC;
	LayerListViewController*	_layerListVC;
	
	NSMutableArray*		_layerList;
	
	LayerView*			_activeLayer;
	LayerView*			_importImagelayer;
	
	ColorPickerView*	_colorPicker;
	
	BOOL	_colorPickerVisible;
	
	NSUInteger _displayIndex;
}

@end

@implementation CreatorCanvasViewController

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
    
	//	[super addBackButtonWithOutTitle];
	
	_displayIndex = 0;
	self.title = @"Creator Canvas";
	
	_slider.transform=CGAffineTransformRotate(_slider.transform,270.0/180*M_PI);
	
	[self setupNavigationbarColors];
	
	[self addShadowToButton:_wipButton];
	[self addShadowToButton:_logoButton];
	[self addShadowToButton:_importButton];
	
	[self addShadowToLabel:_wipLabel];
	[self addShadowToLabel:_importlabel];
	
	[super addBackButton];
	[super addNextButton];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationEnteredForeground:)
												 name:UIApplicationWillEnterForegroundNotification
											   object:nil];
	
	
	[_imageEditingView bringSubviewToFront:_wipButton];
	[_imageEditingView bringSubviewToFront:_importButton];
	[_imageEditingView bringSubviewToFront:_wipLabel];
	[_imageEditingView bringSubviewToFront:_importlabel];
	
	[self createFolderArray];
	[self copyPlistToDocumnetDirectory];
	[self fetchInfoFromPackList];
	
	[self addSACEditView];
	[self setupFilterScrollViewAppearance];
	
	[self displayImportImageScreen:YES];
	
	_logoButton.hidden = (_gDataManager.createContentForSubmission) ? NO:YES;
	
	_creatorToolView.observer = self;
	
	_layerList		= [[NSMutableArray alloc] init];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self setupNavigationbarColors];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -- Back Button Action

//- (void) backButtonPressed:(UIButton*)sender
//{
//	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
//	[self.navigationController popViewControllerAnimated:YES];
//}

-(void) nextButtonAction:(UIButton*)sender
{
	if (_editngImageView.image == nil)
	{
		[UIUtils messageAlert:@"Please add images from camera roll, phone library or WIP." title:@"" delegate:nil];
	}
	else
	{
		[self showLayerList:NO];
		
		[self enableTheEditingTool:NO forLayer:nil];
		UIImage* image = [self getEditedImageFromView];
		[self displayEditorForImage:image];
	}
}

- (IBAction) wipButtonPressed:(id)sender
{
	if (_wipVC == nil)
		_wipVC = [[WIPViewController alloc] initWithNibName:kWIPViewNib bundle:nil];
	_wipVC.delegate = self;
	
	_wipVC.editedImage = [self getEditedImageFromView];
	[self.navigationController pushViewController:_wipVC animated:YES];
}

- (IBAction) importButtonPressed:(id)sender
{
	if (_editngImageView.image != nil)
	{
		[UIUtils messageAlert:@"Would you like to import another image as a layer? Cancel closes the box, yes adds it as a layer and no lets you add a new base." title:@""
					 delegate:self withCancelTitle:@"Cancel" otherButtonTitle:@"YES"
			otherButtonTitle1:@"NO" tag:kReplaceAlertTag];
	}
	else
	{
		[self displayImportImageScreen:YES];
	}
}

- (IBAction) logoButtonPressed:(id)sender
{
	[self addLogoAction];
}

- (IBAction) colorButtonPressed:(UIButton*)sender
{
	[self showColorPicker];
}

- (IBAction) doneButtonPressed:(UIButton*)sender
{
	if (_colorPickerVisible)
		[self hideColorPicker];
	
	[_activeLayer disallowEditingInLayer];
	_activeLayer = nil;
}

- (IBAction) sliderValueChanged:(UISlider*)sender
{
	CGFloat value = sender.value;
	[_activeLayer updateLayerOpacity:value];
}


#pragma mark - Navigation

- (void) setupNavigationbarColors
{
	// Bar text color and background color
	
	self.navigationController.navigationBar.titleTextAttributes= @{UITextAttributeTextColor :
																	   kBlueColor};
	self.navigationController.navigationBar.barTintColor= kWhiteColor;
	self.navigationController.navigationBarHidden = NO;
	
}

- (void) applicationEnteredForeground:(NSNotification *)notification
{
	[self setupNavigationbarColors];
}

-(void) setupFilterScrollViewAppearance
{
    [_filterScrollView loadFiltersForImage:nil];
	_filterScrollView.observer = self;
	
	[_filterScrollView setScrollEnabled:YES];
	[_filterScrollView setShowsVerticalScrollIndicator:NO];
	_filterScrollView.showsHorizontalScrollIndicator = NO;
	
	[self.view bringSubviewToFront:_filterScrollView];
}

#pragma  mark -- SAC EDitool Delegate

- (void) handleTopBtnTap
{
	if (_colorPickerVisible)
		[self hideColorPicker];
	
	[self showHideTollViewAnimation];
}

- (void) addSubFolder
{
	[self addCustomFolderView];
}

- (void) deletCustomFolderInfo:(id)info atIndex:(NSInteger)index;
{
	if ([info isKindOfClass:[CustomFolderInfo class]])
	{
		CustomFolderInfo* folderInfo = (CustomFolderInfo*)info;
		[self deleteCustomFolderInfo:folderInfo];
		
		[_folderListArray removeObjectAtIndex:index];
		[_sacEditToolView setUpDataForView:_folderListArray];
	}
	else if ([info isKindOfClass:[PackInfo class]])
	{
		PackInfo* packInfo = (PackInfo*)info;
		[self sendRequestToDeletePack:packInfo atIndex:index];
	}
	
	if (index == _displayIndex)
	{
		_displayIndex = index -1;
		[self showTool];
	}
}

- (void) customFolderTapAtindex:(NSInteger)index
{
	_displayIndex = index;
	
	[self showTool];
}

- (void) showLayerList:(BOOL)show;
{
	if (_colorPickerVisible)
		[self hideColorPicker];
	
	if (show)
	{
		_layerListVC = [[LayerListViewController alloc] initWithNibName:kLayerListViewNib bundle:nil];
		_layerListVC.delegate = self;
		_layerListVC.layerList = _layerList;
		
		
		CGFloat y = CGRectGetMinY(_sacEditToolView.frame) - 44;
		_layerListVC.view.frame = CGRectMake(0, y, 180, 44);
		
		[self.view addSubview:_layerListVC.view];
	}
	else
	{
		[_layerListVC.view removeFromSuperview];
		_layerListVC = nil;
	}
}

- (void) handleActivateTap
{
	if (_activeLayer)
	{
		[self enableTheEditingTool:NO forLayer:_activeLayer];
		_activeLayer = nil;
	}
}

- (void) handleColorTap
{
	(_colorPickerVisible)?[self hideColorPicker]:[self showColorPicker];
}

- (void) handleErasebtnTap
{
	[UIUtils messageAlert:kWorkInProgress title:@"" delegate:@""];
}

#pragma mark-

- (void) showTool
{
	if (_displayIndex == 0)
		[self displayFilterToolView];
	else
		[self displayCreatorToolView:[_folderListArray objectAtIndex:_displayIndex]];
}

#pragma mark -- Subfolder delegate

- (void) saveSubFolder:(CustomFolderInfo*)folderInfo;
{
	folderInfo.canavsId = self.canvasInfo.canvasId;
	
	[_folderListArray addObject:folderInfo];
	[self saveCustomFolderInfoInPList:folderInfo];
	[_sacEditToolView setUpDataForView:_folderListArray];
}

- (void) addSACEditView
{
	_sacEditToolView = [SACEditToolView createSACToolViews];
	[_sacEditToolView setTitleForToolView:self.canvasInfo.canvasName];
	_sacEditToolView.delegate = self;
	CGRect rect = CGRectMake(0, KSACEeditScreenYHiden, 320, 280);
	_sacEditToolView.frame = rect;
	[_sacEditToolView setUpDataForView:_folderListArray];
	[self.view addSubview:_sacEditToolView];
	
	[_sacEditToolView selectToolWithPackId:self.selectedPackId];
}

#pragma mark-
#pragma mark- FilterToolView delegate

- (void) applyFilterImage:(UIImage*)image
{
	_editngImageView.image = image;
	
	//	[self updateImportLayerImage:image];
}

#pragma mark -- Private methods

- (UIImage*) getEditedImageFromView
{
	if (_editngImageView.image == nil)
		return nil;
	
	_importButton.hidden = YES;
	_wipButton.hidden = YES;
	_importlabel.hidden = YES;
	_logoButton.hidden = YES;
	_slider.hidden = YES;
	_wipLabel.hidden = YES;
	
	[_activeLayer disallowEditingInLayer];
	_activeLayer = nil;
	
    UIGraphicsBeginImageContextWithOptions( CGSizeMake( _imageEditingView.bounds.size.width,
													   _imageEditingView.
													   bounds.size.height )
										   ,_imageEditingView.opaque,[[UIScreen mainScreen] scale]);
    
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor blackColor].CGColor);
    CGRect r = _imageEditingView.frame;
    r.origin = CGPointZero;
    CGContextFillRect(UIGraphicsGetCurrentContext(), r);
    CGContextScaleCTM( UIGraphicsGetCurrentContext(), 1.0f, 1.0f );
    
    // Render the stage to the new context
    [_imageEditingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // Get an image from the context
    UIImage* viewImage = 0;
    viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Kill the render context
    UIGraphicsEndImageContext();
	
	_importButton.hidden = NO;
	_wipButton.hidden = NO;
	_logoButton.hidden = (!_gDataManager.createContentForSubmission) ?YES:NO;
	_wipLabel.hidden = NO;
	_importlabel.hidden = NO;
	
    return viewImage;
}

- (void) showAnimatedForView:(UIView*)animatedView
{
	animatedView.hidden = NO;
	
    animatedView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    animatedView.alpha = 0;
    [UIView beginAnimations:@"showAlert" context:nil];
    [UIView setAnimationDelegate:self];
    animatedView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    animatedView.alpha = 1.0;
    [UIView commitAnimations];
	[self.view bringSubviewToFront:animatedView];
}

- (void) hideAnimatedForView:(UIView*)animatedView
{
	animatedView.hidden = YES;
	
	[UIView beginAnimations:@"hideAlert" context:nil];
    [UIView setAnimationDelegate:self];
    animatedView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    animatedView.alpha = 0;
    [UIView commitAnimations];
	[self.view sendSubviewToBack:animatedView];
}

- (void) showHideTollViewAnimation
{
	CGRect rect = _sacEditToolView.frame;
	CGRect editingRect = _imageEditingView.frame;
	
	if (_isShowFull)
	{
		editingRect.origin.y = editingRect.origin.y + kEditningYDiffrence;
		rect.origin.y = KSACEeditScreenYHiden;
		_isShowFull = NO;
		
		
	}
	else
	{
		editingRect.origin.y = editingRect.origin.y - kEditningYDiffrence;
		rect.origin.y = kSACEditScreenYShow;
		_isShowFull = YES;
	}
	
	//	[UIView beginAnimations:@"animateTableView" context:nil];
	//	[UIView setAnimationDuration:0.4];
	
	_sacEditToolView.frame = rect;
	_imageEditingView.frame = editingRect;
	
	if(_layerListVC != nil)
	{
		CGRect rect = _layerListVC.view.frame;
		rect.origin.y = CGRectGetMinY(_sacEditToolView.frame) - CGRectGetHeight(rect);
		_layerListVC.view.frame = rect;
	}
	
	[_sacEditToolView showTopbtn:_isShowFull];
	
	//	[UIView commitAnimations];
}

- (void) addCustomFolderView
{
	AddCustomSubFolderView* addcustomFVC = [AddCustomSubFolderView createAddCustoMFolderView];
	addcustomFVC.delegate = self;
	[addcustomFVC showCustomFolderViewInView:self.view];
}

- (void) displayEditorForImage:(UIImage *)imageToEdit
{
	//	if (_gDataManager.createContentForSubmission)
	//	{
	////		ImageBrandingViewController* viewCtrl = [[ImageBrandingViewController alloc] initWithNibName:
	////												 kImageBrandingViewNib bundle:nil];
	////		viewCtrl.editableImage = imageToEdit;
	////		[self.navigationController pushViewController:viewCtrl animated:YES];
	//	}
	//	else
	{
		SubmitContentViewController* viewCtrl = [[SubmitContentViewController alloc] initWithNibName:
												 kSubmitContentViewNib bundle:nil];
		viewCtrl.editedImage = imageToEdit;
		[self.navigationController pushViewController:viewCtrl animated:YES];
	}
}

#pragma mark- PList action

- (void) saveCustomFolderInfoInPList:(CustomFolderInfo*)info
{
	NSString* pListPath = [self getPackPlistPath];
	NSMutableArray* packList = [[NSMutableArray alloc] initWithContentsOfFile:pListPath];
	NSNumber* canvasId = [NSNumber numberWithInteger:info.canavsId];
	
	NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:info.folderName,@"Name", info.humanReadableColor, @"Color", canvasId, @"CanvasId", info.folderContents, @"Contents", nil];
	[packList addObject:dict];
	
	BOOL sucess = [packList writeToFile:pListPath atomically:NO];
	
	if (!sucess)
		DLog(@"writeToFile failed with error");
}

- (void) fetchInfoFromPackList
{
	NSString* pListPath = [self getPackPlistPath];

	NSArray* packList = [[NSArray alloc] initWithContentsOfFile:pListPath];
	
	for (int i = 0; i < packList.count; ++i)
	{
		NSDictionary* dict = [packList objectAtIndex:i];
		CustomFolderInfo* info = [[CustomFolderInfo alloc] initWithInfo:dict];
		if (info.canavsId == self.canvasInfo.canvasId)
			[_folderListArray addObject:info];
	}
}

- (void) deleteCustomFolderInfo:(CustomFolderInfo*)info
{
//	NSString* filepath = [NSString stringWithFormat:@"%d/PackList.plist", _gDataManager.userInfo.userId];
//	NSString* pListPath = [UIUtils documentDirectoryWithSubpath:filepath];
	
	NSString* pListPath = [self getPackPlistPath];
	NSMutableArray* packList = [[NSMutableArray alloc] initWithContentsOfFile:pListPath];
	
	for (NSDictionary* dict in packList)
	{
		NSUInteger canvasId = [[dict objectForKey:@"CanvasId"] integerValue];
		if (info.canavsId == canvasId)
		{
			[packList removeObject:dict];
			break;
		}
	}
	
	BOOL sucess = [packList writeToFile:pListPath atomically:NO];
	
	if (!sucess)
		DLog(@"writeToFile failed with error");
}

- (void) copyPlistToDocumnetDirectory
{
	NSFileManager *fileManger=[NSFileManager defaultManager];
	NSError *error;
//	NSArray *pathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	
//	NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
//	doumentDirectoryPath = [doumentDirectoryPath stringByAppendingString:[NSString stringWithFormat:
//										@"%d/",_gDataManager.userInfo.userId]];

	NSString *destinationPath= [self getPackPlistPath];
	
	if ([fileManger fileExistsAtPath:destinationPath])
		return;
	
	NSString *sourcePath=[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"PackList.plist"];
	
	[fileManger copyItemAtPath:sourcePath toPath:destinationPath error:&error];
}

- (NSString*) getPackPlistPath
{
	NSString* filepath = [NSString stringWithFormat:@"%lu/PackList.plist", (unsigned long)_gDataManager.userInfo.userId];
	NSString* pListPath = [UIUtils documentDirectoryWithSubpath:filepath];
	return pListPath;
}

#pragma mark-

- (void) displayFilterToolView
{
	_filterScrollView.hidden = NO;
	_creatorToolView.hidden = YES;
	
	[self.view bringSubviewToFront:_filterScrollView];
}

- (void) displayCreatorToolView:(id)info
{
	_creatorToolView.hidden = NO;
	_filterScrollView.hidden = YES;
	NSArray* toolArray = nil;
	EPackType packType;
	if ([info isKindOfClass:[CustomFolderInfo class]])
	{
		CustomFolderInfo* folderInfo = (CustomFolderInfo*) info;
		toolArray = folderInfo.folderContents;
		
		packType = EPackTypeImage;
	}
	else if ([info isKindOfClass:[PackInfo class]])
	{
		PackInfo* packInfo = (PackInfo*) info;
		packType = packInfo.packType;
		
		NSString* filePath = [_gDataManager getPackDirectory];
		NSString* name = [packInfo.packContentUrl lastPathComponent];
		NSString* sourcePath = [filePath stringByAppendingString:name];
		
		if (![UIUtils isFileExistAtPath:sourcePath])
		{
			[self sendRequestToDownloadPack:packInfo];
			return;
		}
		else
		{
			toolArray = [self getToolArrayForPack:packInfo];
		}
	}
	
	[_creatorToolView initalizeToolView:toolArray withImage:_editngImageView.image withType:packType];
	
	[self.view bringSubviewToFront:_creatorToolView];
}

- (void) createFolderArray
{
	_folderListArray = [[NSMutableArray alloc] init];
	
	PackInfo* pack = [[PackInfo alloc] init];
	pack.packName = @"Filter";
	pack.brandName = @"Stocks";
	[_folderListArray addObject:pack];
	
	for (NSString* packId in _gDataManager.userInfo.packIdArray)
	{
		PackInfo* info = [_gDataManager getPackForId:[packId integerValue]];
		if (info != nil)
			[_folderListArray addObject:info];
	}
}

#pragma mark- pack method

- (NSArray*) getIconImageArrayforPack:(PackInfo*)pack
{
	NSArray* imageNameArray = nil;
	NSString* sourcePath = [self getFilePathForPack:pack];
	sourcePath = [sourcePath stringByAppendingString:@"/IconImage/"];
	
	if ([UIUtils isFileExistAtPath:sourcePath])
	{
		imageNameArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sourcePath error:nil];
		imageNameArray = [self getImageArray:imageNameArray withFilepath:sourcePath];
		
		//		NSURL* selectedFolderURL = [NSURL fileURLWithPath:sourcePath];
		//		imageNameArray = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:selectedFolderURL
		//					 includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey]
		//										options:NSDirectoryEnumerationSkipsHiddenFiles
		//										  error:nil];
	}
	
	return imageNameArray;
}

- (NSArray*) getBigImageArrayforPack:(PackInfo*)pack
{
	NSArray* imageNameArray = nil;
	NSString* sourcePath = [self getFilePathForPack:pack];
	sourcePath = [sourcePath stringByAppendingString:@"/BigImage/"];
	
	if ([UIUtils isFileExistAtPath:sourcePath])
	{
		imageNameArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sourcePath error:nil];
		imageNameArray = [self getImageArray:imageNameArray withFilepath:sourcePath];
	}
	
	return imageNameArray;
}

- (NSString*) getFilePathForPack:(PackInfo*)pack
{
	NSString* filePath = [_gDataManager getPackDirectory];
	//	NSString* name = [pack.packContentUrl lastPathComponent];
	//	name = [name stringByReplacingOccurrencesOfString:@".zip" withString:@""];
	
	NSString* sourcePath = [filePath stringByAppendingString:[NSString stringWithFormat:@"%@",pack.packName]];
	return sourcePath;
}

- (NSArray*) getImageArray:(NSArray*)array withFilepath:(NSString*)filepath
{
	NSMutableArray* filePathArray = [[NSMutableArray alloc] initWithCapacity:array.count];
	
	for (NSString* imageName in array)
	{
		NSString* newFilepath= [filepath stringByAppendingString:imageName];
		[filePathArray addObject:newFilepath];
	}
	
	return filePathArray;
}

#pragma mark-

- (void) sendRequestToDeletePack:(PackInfo*)pack atIndex:(NSUInteger)index
{
	[_gAppDelegate showLoadingView:YES];
	
	NSString* postString = [NSString stringWithFormat:@"token=%@&package_id=%lu", _gAppPrefData.sessionToken, (unsigned long)pack.packId];
	
	NSURLRequest* request = [WebServiceManager postRequestWithService:kDeletePackFromCanvasService
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
				 [self.canvasInfo parsePacks:[response objectForKey:@"packs"]];
				 [_gDataManager.userInfo parsePacks:response];
				 
				 [_folderListArray removeObjectAtIndex:index];
				 [_sacEditToolView setUpDataForView:_folderListArray];
			 }
			 else
			 {
				 NSString* message = [response objectForKey:@"err_message"];
				 [UIUtils messageAlert:message title:nil delegate:nil];
			 }
		 }
	 }];
}

#pragma mark -- CreatorToll view

- (void) applyToolImageAtIndex:(NSInteger)imageIndex
{
	NSString* imageFilepath = [self.selctedPackImageArray objectAtIndex:imageIndex];
	UIImage* image = [UIImage imageWithContentsOfFile:imageFilepath];
	
	[self createLayerWithImage:image withLayerType:ELayerTypePackImage];
}

- (void) displayImportImageScreen:(BOOL)isReplaced
{
	if (_importImageVC == nil)
		_importImageVC = [[ImportImageViewController alloc] initWithCompletionBlock:^(UIImage* image){
			
			[_importImageVC.view removeFromSuperview];
			_importImageVC = nil;
			
			if (image != nil)
			{
				if (isReplaced)
				{
					_editngImageView.image = image;
					[self showHideTollViewAnimation];
					[_filterScrollView loadFiltersForImage:image];
				}
				else
				{
					[self createLayerWithImage:image withLayerType:ELayerTypePackImage];
				}

			}
		}];
	_importImageVC.navigationController = self.navigationController;
	
	_importImageVC.view.frame = self.view.frame;
	[self.view addSubview:_importImageVC.view];
	[self.view bringSubviewToFront:_importImageVC.view];
}

#pragma mark-

- (void) createLayerWithImage:(UIImage*)image withLayerType:(ELayerType)type
{
	if (_editngImageView.image == nil)
	{
		[UIUtils messageAlert:@"Please import image to edit in canvas." title:@"" delegate:nil];
		return;
	}
	else if(_layerList.count >= 10)
	{
		[UIUtils messageAlert:@"You can add at max 10 layers." title:@"" delegate:nil];
		return;
	}
	
	if (type == ELayerTypeLogo)
		_logoButton.enabled = NO;
	
	if((_activeLayer != nil) && (_activeLayer.layerInfo.showLayer))
	{
		if (type == ELayerTypeLogo)
			_activeLayer.layerInfo.layerType = type;
		else if (!_logoButton.enabled)
			_logoButton.enabled = YES;
		
		[self updateActiveLayerImage:image];
		[self enableTheEditingTool:YES forLayer:nil];
		
		return;
	}
	
	LayerInfo* info = [[LayerInfo alloc] initWithLayerIcon:image];
	info.layerType = type;
	
	LayerView* layer = [LayerView createLayerView];
	if (_layerList.count > 0)
	{
	
		LayerInfo* layerInfotemp = (LayerInfo*)[_layerList lastObject];
		layer.tag = (layerInfotemp.layerTag) + 1;
	}
	else
	{
		layer.tag = kLayerTag;
	}
	
	info.layerTag = layer.tag;
	[_layerList addObject:info];
	
	[layer initiateWithLayerInfo:info];
	
	_activeLayer = layer;
	_activeLayer.delegate = self;
	
	[_imageEditingView addSubview:layer];
	layer.center = _editngImageView.center;
	
	if (_layerList.count > 0)
		[_sacEditToolView enableLayerButton:YES withCount:_layerList.count];
	
	[self enableTheEditingTool:YES forLayer:nil];
	
	if (_layerListVC != nil)
		[_layerListVC updateLayerList:_layerList];
	
	[_sacEditToolView updateLayerCount:_layerList.count];
}

- (void) showColorPicker
{
	[self showLayerList:NO];
	
	if (_colorPickerVisible)
		return;
	
	if (_colorPicker == nil)
		_colorPicker = [ColorPickerView createColorPickerView];
	CGFloat y = CGRectGetMinY(_sacEditToolView.frame) - 185;
	_colorPicker.frame = CGRectMake(0, y, 320, 185);
	_colorPicker.delegate = self;
	
	[self.view addSubview:_colorPicker];
	
	_colorPickerVisible = YES;
}

#pragma mark- LayerView Delegate

-(void) handleTapEventForLayer:(LayerView*)layer
{
	if(_activeLayer != nil)
		[_activeLayer disallowEditingInLayer];
	
	_activeLayer = layer;
	
	[self showLayerList:NO];
	
	[_imageEditingView bringSubviewToFront:_activeLayer];
	[self enableTheEditingTool:layer.allowEditing forLayer:nil];
}

- (void) allowEditingInLayer:(LayerView*)layer
{
//	if (!layer.allowEditing)
//		_activeLayer = nil;
//	
//	[self enableTheEditingTool:layer.allowEditing forLayer:layer];
}

- (void) handleCancelTapInLayer:(LayerView*)layer
{
	[_layerList removeObject:layer.layerInfo];
	[layer removeFromSuperview];
	
	if(_activeLayer.layerInfo.layerTag == layer.layerInfo.layerTag)
	{
		_activeLayer = nil;
		_logoButton.enabled = YES;
	}
	
	[self enableTheEditingTool:NO forLayer:nil];
	[_layerListVC updateLayerList:_layerList];
	[_sacEditToolView updateLayerCount:_layerList.count];
}

#pragma mark- ColorPickerView Delegate

- (void) pickColor:(UIColor*)color
{
	UIImage* image = _activeLayer.layerImageView.image;
	UIImage* coloredImage = [image imageWithColor:color];
	
	if (coloredImage != nil)
		[self updateActiveLayerImage:coloredImage];
}

- (void) colorPickerDoneButtonPressed:(UIColor*)color
{
	[self hideColorPicker];
}

#pragma mark-

- (void) updateActiveLayerImage:(UIImage*)image
{
	_activeLayer.layerImageView.image = image;
	_activeLayer.layerInfo.layerImage = image;
	
	if (_layerListVC != nil)
		[_layerListVC.tableview reloadData];
}

- (void) updateImportLayerImage:(UIImage*)image
{
	_activeLayer = _importImagelayer;
	_importImagelayer.layerImageView.image = image;
	
	LayerInfo* info = _importImagelayer.layerInfo;
	info.layerImage = image;
	
	if (_layerListVC != nil)
		[_layerListVC.tableview reloadData];
}

#pragma mark-

- (void) hideColorPicker
{
	_colorPickerVisible = NO;
	
	[_colorPicker removeFromSuperview];
	_colorPicker = nil;
}

#pragma mark-

- (void) bringAllButtonToFront
{
	[_imageEditingView bringSubviewToFront:_importButton];
	[_imageEditingView bringSubviewToFront:_wipButton];
	[_imageEditingView bringSubviewToFront:_logoButton];
	[_imageEditingView bringSubviewToFront:_importlabel];
	[_imageEditingView bringSubviewToFront:_wipLabel];
	[_imageEditingView bringSubviewToFront:_slider];
}

#pragma mark- WIPDelegate

- (void) selectedWipImageForEditing:(UIImage*)image
{
	if (image != nil)
	{
		_editngImageView.image = image;
		
		//		[self createLayerWithImage:image withLayerType:ELayerTypeImportImage];
		
		[self showHideTollViewAnimation];
		[_filterScrollView loadFiltersForImage:image];
		//		[_creatorToolView updateBaseImage:image];
	}
	
	_wipVC = nil;
}

#pragma mark- LayerList delegate

- (void) removeLayer:(NSUInteger)layerIndex
{
	LayerView* layer = (LayerView*)[_imageEditingView viewWithTag:layerIndex];
	
	if(_activeLayer.layerInfo.layerTag == layer.layerInfo.layerTag)
	{
		_activeLayer = nil;
		[self enableTheEditingTool:NO forLayer:nil];
	}
	
	if (layer.layerInfo.layerType == ELayerTypeLogo)
		_logoButton.enabled = YES;
	
	[layer removeFromSuperview];
	
	if (_layerList.count == 0)
	{
		[_sacEditToolView enableLayerButton:NO withCount:_layerList.count];
		_activeLayer= nil;
		[self enableTheEditingTool:NO forLayer:nil];
		[self showLayerList:NO];
	}
	[_sacEditToolView updateLayerCount:_layerList.count];
}

- (void) showLayer:(BOOL)show atIndex:(NSUInteger)layerIndex
{
	LayerView* layer = (LayerView*)[_imageEditingView viewWithTag:layerIndex];
	layer.hidden = (show) ? NO : YES;
	layer.layerInfo.showLayer = (show) ? YES : NO;


	if(_activeLayer.layerInfo.layerTag == layer.layerInfo.layerTag)
		[self enableTheEditingTool:show forLayer:layer];
}

- (void) activateTheLayerAtIndex:(NSUInteger)index
{
	LayerView* layer = (LayerView*)[_imageEditingView viewWithTag:index];
	layer.hidden = NO;
	layer.layerInfo.showLayer = YES;
	
	if(_activeLayer)
		[_activeLayer disallowEditingInLayer];
	
	_activeLayer = layer;
	[_imageEditingView bringSubviewToFront:_activeLayer];
	
	[self enableTheEditingTool:YES forLayer:layer];
}

- (void) enableTheEditingTool:(BOOL)isEditable forLayer:(LayerView*)layerView
{
	if (isEditable)
		[self bringAllButtonToFront];
	
	if (layerView)
		[layerView setEditingEbabled:isEditable];
	
	if (_colorPickerVisible)
		isEditable? NSLog(@"Visible"):[self hideColorPicker];
	
	_slider.hidden = !isEditable;
	
	BOOL isLogoEnabled = _logoButton.enabled;
	[_sacEditToolView  showLayerToolButton:isEditable withLogoEraser:!isLogoEnabled];
}

#pragma mark-

- (BOOL) checkLayerVisible
{
	for (LayerInfo* info in _layerList)
	{
		if (info.showLayer)
			return YES;
	}
	return NO;
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
			 
			 //
			 NSArray* toolArray = [self getToolArrayForPack:info];
			 
			 [_creatorToolView initalizeToolView:toolArray withImage:_editngImageView.image withType:info.packType];
			 
			 [self.view bringSubviewToFront:_creatorToolView];
			 
		 }
	 }];
}

- (NSArray*) getToolArrayForPack:(PackInfo*)info
{
	NSArray* toolArray = nil;
	
	if (info.packType == EPackTypeImage)
	{
		toolArray = [self getIconImageArrayforPack:info];
		self.selctedPackImageArray = [NSMutableArray arrayWithArray:[self getBigImageArrayforPack:info]];
	}
	else if (info.packType == EPackTypeText)
	{
		toolArray = [self getFontArrayforPack:info];
	}
	
	return toolArray;
}

- (void) addLogoAction
{
	NSString* title = [self.logoURL lastPathComponent];
	if ([self checkLogoImageExistwithTitle:title])
	{
		NSString* directory = [_gDataManager getLogoDirectory];
		NSString* fileName = [self.logoURL lastPathComponent];
		NSString* filepath = [directory stringByAppendingString:fileName];
		UIImage* logoImage = [UIImage imageWithContentsOfFile:filepath];
		[self createLayerWithImage:logoImage withLayerType:ELayerTypeLogo];
	}
	else
	{
		[self sendRequestToDownloadLogo:self.logoURL];
	}
}

- (void) sendRequestToDownloadLogo:(NSString*)logoURl
{
	[_gAppDelegate showLoadingView:YES];
	
	NSString* postString = @"";
	
	NSURLRequest* request = [WebServiceManager postRequestWithUrlString:logoURl
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
			 
			 NSString* directory = [_gDataManager getLogoDirectory];
			 
			 NSString* fileName = [logoURl lastPathComponent];
			 NSString* filepath = [directory stringByAppendingString:fileName];
			 UIImage * imagee = [UIImage imageWithData:responseData];
			 [UIUtils saveImageWithData:responseData forFilePath:filepath];
			 
			 [self createLayerWithImage:imagee withLayerType:ELayerTypeLogo];
		 }
	 }];
}

#pragma  mark -- AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == kReplaceAlertTag)
	{
		switch (buttonIndex)
		{
			case 0:
				[alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
				break;
				
			case 1:
				[self displayImportImageScreen:NO];
				break;
				
			case 2:
				[self displayImportImageScreen:YES];
				break;
				
			default:
				break;
		}
		
	}
}

#pragma mark-

- (void) addShadowToButton:(UIButton*)button
{
	button.layer.shadowColor = [UIColor blackColor].CGColor;
	button.layer.shadowOpacity = 0.5;
	button.layer.shadowRadius = 2;
	button.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
}

- (void) addShadowToLabel:(UILabel*)label
{
	label.layer.shadowColor = [UIColor blackColor].CGColor;
	label.layer.shadowOpacity = 0.5;
	label.layer.shadowRadius = 2;
	label.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
}

- (void) saveLogoImageInApplicationDirectory:(UIImage*)image withCaption:(NSString*)caption
{
	NSString* directory = [_gDataManager getLogoDirectory];
	
	NSString* fileName = [caption lastPathComponent];
	NSString* filepath = [directory stringByAppendingString:fileName];
	NSData* imageData = [NSData dataWithData:UIImageJPEGRepresentation(image, 0.5)];
	[UIUtils saveImageWithData:imageData forFilePath:filepath];
}

- (BOOL) checkLogoImageExistwithTitle:(NSString*)title
{
	NSString* directory = [_gDataManager getLogoDirectory];
	NSArray* fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil];
	for (NSString* fileName in fileList)
	{
		if ([title compare:fileName] == NSOrderedSame)
			return YES;
	}
	return NO;
}

#pragma mark-

- (NSArray*) getFontArrayforPack:(PackInfo*)pack
{
	NSString* sourcePath = [self getFilePathForPack:pack];
	sourcePath = [sourcePath stringByAppendingString:@"/DafontTextPack/"];
	
	if ([UIUtils isFileExistAtPath:sourcePath])
	{
		NSArray* files =  [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:sourcePath]
										includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey]
														   options:NSDirectoryEnumerationSkipsHiddenFiles
															 error:nil];
		
		NSMutableArray* customFontArray = [[NSMutableArray alloc] initWithCapacity:files.count];
		
		for (NSString* path in files)
		{
			NSString* fontName = [path lastPathComponent];
			NSString* fontPath = [sourcePath stringByAppendingString:fontName];
			[customFontArray addObject:fontPath];
		}
		
		NSArray* fontArray = [[NSArray alloc] initWithArray:customFontArray];
		
		return fontArray;
//		fontArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sourcePath error:nil];
	}
	
	return nil;
}

@end
