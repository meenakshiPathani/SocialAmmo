//
//  ContentCreatorEditPhotoViewController.h
//  Social Ammo
//
//  Created by Rupesh Kumar on 6/9/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "CanvasInfo.h"
#import "CreatorToolView.h"
#import "FilterToolView.h"

@class SACEditToolView;
@class AddCustomSubFolderView;
@class CustomImageView;

@interface CreatorCanvasViewController : BaseViewController <FilterToolDelegate, CreatorToolDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
	IBOutlet UIImageView* _editngImageView;
	IBOutlet FilterToolView* _filterScrollView;
	IBOutlet CreatorToolView* _creatorToolView;
	
	SACEditToolView* _sacEditToolView;
	CustomImageView* _packImageView;
	
	IBOutlet UIView* _imageEditingView;
	IBOutlet UIView* _workingView;
	
	IBOutlet UIButton*		_wipButton;
	IBOutlet UIButton*	_importButton;
	IBOutlet UIButton*		_logoButton;
	IBOutlet UILabel*		_wipLabel;
	IBOutlet UILabel*		_importlabel;
	
	NSMutableArray* _folderListArray;
	
	BOOL _isShowFull;
	BOOL isLogoAvailable;
	BOOL _isReplaceImage;
	
	IBOutlet UIButton*	_activeButton;
	IBOutlet UIButton*	_colorButton;
	
	IBOutlet UISlider*	_slider;
	
}
@property(nonatomic, assign) NSUInteger selectedPackId;

@property(nonatomic, strong) CanvasInfo* canvasInfo;
@property (nonatomic,retain) NSString* logoURL;
@property(nonatomic,retain) NSMutableArray* selctedPackImageArray;

- (IBAction) wipButtonPressed:(id)sender;
- (IBAction) importButtonPressed:(id)sender;
- (IBAction) logoButtonPressed:(id)sender;

- (IBAction) colorButtonPressed:(UIButton*)sender;
- (IBAction) doneButtonPressed:(UIButton*)sender;

- (IBAction) sliderValueChanged:(UISlider*)sender;


@end
