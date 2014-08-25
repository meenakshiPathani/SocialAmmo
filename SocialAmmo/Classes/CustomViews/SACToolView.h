//
//  SACToolView.h
//  Social Ammo
//
//  Created by Rupesh Kumar on 6/9/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "PackInfo.h"
#import "CustomFolderInfo.h"

@protocol SACToolViewDelegate;

@interface SACToolView : UIView
{
	IBOutlet AsyncImageView* _btnImageView;
	IBOutlet UILabel* _brandName;
	IBOutlet UILabel* _packName;

	IBOutlet UIButton* _folderbtn;
	IBOutlet UIButton* _deletebtn;

	CGPoint _originalOutsidePosition;
	
	CustomFolderInfo*	_folderInfo;
	PackInfo*		_packInfo;
}

@property (nonatomic, assign) id<SACToolViewDelegate> delgate;
@property (nonatomic) CGPoint originalPosition;
@property (nonatomic,assign) BOOL isInScrollview;
@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, retain) UIScrollView *scrollParent;
@property (nonatomic) NSInteger index;

+ (id) createSACToolViews;

- (void) setOrigin:(CGPoint)point;
- (void) setScreenData:(CustomFolderInfo*)item;
- (void) showBorder:(BOOL)isShow;

- (IBAction) tapBtnAction:(id)sender;

@end

@protocol SACToolViewDelegate <NSObject>

- (void) tapOnButtonHandler:(SACToolView *)button;
- (void) touchDown;
- (void) touchUp;
- (BOOL) isTouchDeleteButton:(SACToolView*)button touching:(BOOL)finished;


@end