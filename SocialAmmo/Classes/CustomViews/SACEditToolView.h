//
//  SACEditToolViewController.h
//  Social Ammo
//
//  Created by Rupesh Kumar on 6/9/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "CustomFolderInfo.h"

@protocol SACEditToolViewDelegate <NSObject>

- (void) handleTopBtnTap;
- (void) addSubFolder;
- (void) deletCustomFolderInfo:(id)info atIndex:(NSInteger)index;

- (void) customFolderTapAtindex:(NSInteger)index;
- (void) showLayerList:(BOOL)show;

- (void) handleActivateTap;
- (void) handleColorTap;
- (void) handleErasebtnTap;

@end

@interface SACEditToolView : UIView
{
	IBOutlet UIImageView* _menuBackgroundView;

	IBOutlet UIScrollView* _scrollView;
	IBOutlet UILabel* _nameLabel;
	IBOutlet UILabel* _countlabel;
	
	IBOutlet UIButton* _addBtn;
	IBOutlet UIButton* _undoBtn;
	IBOutlet UIButton* _layerBtn;
	
	IBOutlet UIButton* _deleetBtn;
	IBOutlet UIButton* _showMenuButton;
	
	IBOutlet UIButton* _colorlayerButton;
	IBOutlet UIButton* _activelayerbtn;
	IBOutlet UIButton* _eraserbutton;
	
	NSUInteger _previousSelectedIndex;

	NSMutableArray* _lists;
}

@property (nonatomic,assign) BOOL isFullShow;
@property (nonatomic,assign) id<SACEditToolViewDelegate> delegate;
@property (nonatomic) CGPoint orignalPoint;

+ (id) createSACToolViews;

- (void) setUpDataForView:(NSMutableArray*)folderList;
- (void) setTitleForToolView:(NSString*)title;
- (void) updateLayerCount:(NSUInteger)count;

- (void) showTopbtn:(BOOL)isShow;
- (void) showLayerToolButton:(BOOL)isShow withLogoEraser:(BOOL)isLogoLayer;

- (IBAction) addToolBtnAction:(id)sender;
- (IBAction) undoBtnAction:(id)sender;
- (IBAction) layerBtnAction:(id)sender;

- (IBAction) tapOnColorPickerAction:(id)sender;
- (IBAction) tapOnActivebtnAction:(id)sender;
- (IBAction) eraserBtnAction:(id)sender;

- (IBAction) deletBtnAction:(id)sender;
- (IBAction) tapOnTopBtnAction:(id)sender;

- (void) enableLayerButton:(BOOL)enable withCount:(NSUInteger)count;

- (void) selectToolWithPackId:(NSUInteger)packId;

@end
