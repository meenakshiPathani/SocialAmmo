//
//  WIPViewController.m
//  SocialAmmo
//
//  Created by Meenakshi on 22/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "WIPCollectionCell.h"
#import "WIPViewController.h"

#define kSaveWIPAlert 100
#define kOpenWIPAlert 200

@interface WIPViewController ()
{
	NSMutableArray*	_workInProgressList;
	
	BOOL _isWiggleStart;
	NSIndexPath* _selectedIndexpath;
	
	UITapGestureRecognizer* _tapGesture;
}

@end

@implementation WIPViewController

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
	
	self.title = @"Works in Progress";
	[super addBackButton];
	
	UINib* nib = [UINib nibWithNibName:kWIPCollectionCellNib bundle:[NSBundle mainBundle]];
	[_collectionView registerNib:nib forCellWithReuseIdentifier:@"WIPCollectionCell"];
	
	UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
										  initWithTarget:self action:@selector(handleLongPress:)];
	lpgr.minimumPressDuration = .8; //seconds
	[_collectionView addGestureRecognizer:lpgr];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationEnteredForeground:)
												 name:UIApplicationWillEnterForegroundNotification
											   object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	_selectedIndexpath = nil;
	
//	_saveCurrentCanvasButton.enabled = (self.editedImage == nil) ? NO : YES;
	
//	NSString* directory = [_gDataManager getWIPDirecory];
//	_workInProgressList = (NSMutableArray*)[[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil];
	
	_workInProgressList = [[NSMutableArray alloc] initWithArray:[self getSortedArray]];
	[_collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark-

- (void) applicationEnteredForeground:(NSNotification *)notification
{
	[_collectionView reloadData];
}

#pragma mark- Button action

- (IBAction) saveCurrentCanvas:(id)sender
{
	if (self.editedImage == nil)
	{
		[UIUtils messageAlert:@"There is no image to save." title:nil delegate:nil];
		return;
	}
	
	NSString* message = @"Do you want to save this content in WIP?";
	[UIUtils messageAlertWithOkCancel:message title:nil delegate:self tag:kSaveWIPAlert];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
	NSUInteger collectionViewCount = 4;
	NSUInteger lastSection = (int) ceilf(_workInProgressList.count/4.0);
	if (section == lastSection-1)
	{
		collectionViewCount = _workInProgressList.count - section*4;
	}
	
	return collectionViewCount;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	NSUInteger section = (int) ceilf(_workInProgressList.count/4.0);
    return section;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	WIPCollectionCell *cell = (WIPCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"WIPCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
	
	NSUInteger index = (indexPath.section*4) + indexPath.row;
	UIImage* imagedForCell = [self getImageForIndexpath:indexPath];
	
	cell.cellImageView.image = imagedForCell;
	cell.tag = index;
	
	if (_isWiggleStart)
		[cell startWigglingForCell:self action:@selector(closeBtn:)];
	else
		[cell stopWigglingForCell];
	
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isWiggleStart) return NO;
    else return YES;
}

-(BOOL) collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
//	return NO;
    return !_isWiggleStart;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	_selectedIndexpath  = indexPath;
	
	NSString* message = @"Do you want to open this Work in Progress with canvas? This will replace your current canvas.";
	[UIUtils messageAlert:message title:nil delegate:self withCancelTitle:@"Cancel" otherButtonTitle:@"Open" tag:kOpenWIPAlert];
}

#pragma mark-

- (UIImage*) getImageForIndexpath:(NSIndexPath*)indexPath
{
	NSString* directory = [_gDataManager getWIPDirecory];
	NSUInteger index = (indexPath.section*4) + indexPath.row;
	NSString* fileName = [[_workInProgressList objectAtIndex:index] lastPathComponent];
	NSString* filepath = [directory stringByAppendingString:fileName];
	
	UIImage* imagedForCell = [UIImage imageWithContentsOfFile:filepath];
	return imagedForCell;
}

#pragma mark-
#pragma mark UIAlertView delegate methods-

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (alertView.tag)
	{
		case kSaveWIPAlert:
			if (buttonIndex == 1)
			{
				[_gAppDelegate saveImageInApplicationDirectory:self.editedImage withCaption:nil];
				[self.navigationController popViewControllerAnimated:YES];
			}
			break;
		case kOpenWIPAlert:
		{
			if (buttonIndex == 1)
			{
				UIImage* imagedForCell = [self getImageForIndexpath:_selectedIndexpath];
				[self.navigationController popViewControllerAnimated:YES];
				
				if([self.delegate respondsToSelector:@selector(selectedWipImageForEditing:)])
					[self.delegate selectedWipImageForEditing:imagedForCell];
			}
		}
		default:
			break;
	}
}

#pragma mark-

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
	_isWiggleStart = YES;
	[_collectionView reloadData];
	
	[self addTapGesture];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
	if(_isWiggleStart == NO)
		return;
	
	[_collectionView reloadData];
	
	_isWiggleStart = NO;
	[self removeTapGesture];
}

- (IBAction) closeBtn:(UIButton*)sender
{
	if (_workInProgressList.count > sender.tag)
	{
		[self removeImageAtIndex:sender.tag];
//	
		[_workInProgressList removeObjectAtIndex:sender.tag];
//		WIPCollectionCell* cell = (WIPCollectionCell*)[sender superview];
//		NSIndexPath* indexpath = [_collectionView indexPathForCell:cell];
//		
//		[_collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexpath]];

		[_collectionView reloadData];
//
		_isWiggleStart = NO;
		[self removeTapGesture];

//		[_collectionView performBatchUpdates:^{
//			
//			[self removeImageAtIndex:sender.tag];
//			
////			// Create the new array to delete object to resolve the issue “Collection was mutated while being enumerated"
////			NSMutableArray* array = [[NSMutableArray alloc] initWithArray:_workInProgressList];
////			[array removeObjectAtIndex:sender.tag];
////			_workInProgressList = array;
//			
////			[_workInProgressList removeObjectAtIndex:sender.tag];
//
//			WIPCollectionCell* cell = (WIPCollectionCell*)[sender superview];
//			NSIndexPath* indexpath = [_collectionView indexPathForCell:cell];
//						
//			[_collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexpath]];
//			
//		} completion:^(BOOL finished) {
//			
//			_isWiggleStart = NO;
//			[self removeTapGesture];
//		}];
	}
	
	
}

#pragma mark- RemoveImage from WIP directory

- (void) removeImageAtIndex:(NSUInteger)index
{
	NSString* directory = [_gDataManager getWIPDirecory];
	NSString* fileName = [[_workInProgressList objectAtIndex:index] lastPathComponent];
	NSString* filepath = [directory stringByAppendingString:fileName];
	
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSError* error = nil;
	if ([UIUtils isFileExistAtPath:filepath])
		[fileManager removeItemAtPath:filepath error:&error];
	
	if (error)
		DLog(@"%@",error.description);
}

- (NSArray*) getSortedArray
{
	NSString* directory = [_gDataManager getWIPDirecory];
	NSURL *documentsURL = [[NSURL alloc] initFileURLWithPath:directory];
	
//	NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
	
	NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:documentsURL
															  includingPropertiesForKeys:@[NSURLContentModificationDateKey]
																				 options:NSDirectoryEnumerationSkipsHiddenFiles
																				   error:nil];
	
	NSArray *sortedContent = [directoryContent sortedArrayUsingComparator:
							  ^(NSURL *file1, NSURL *file2)
							  {
								  // compare
								  NSDate *file1Date;
								  [file1 getResourceValue:&file1Date forKey:NSURLContentModificationDateKey error:nil];
								  
								  NSDate *file2Date;
								  [file2 getResourceValue:&file2Date forKey:NSURLContentModificationDateKey error:nil];
								  
								  // Ascending:
//								  return [file1Date compare: file2Date];
								  // Descending:
								  return [file2Date compare: file1Date];
							  }];
	return sortedContent;
}

#pragma mark-

- (void) addTapGesture
{
	if (_tapGesture == nil)
		_tapGesture = [[UITapGestureRecognizer alloc]
				   initWithTarget:self action:@selector(handleTapGesture:)];
	[_collectionView addGestureRecognizer:_tapGesture];

}

- (void) removeTapGesture
{
	[_collectionView removeGestureRecognizer:_tapGesture];
	_tapGesture = nil;
}

@end
