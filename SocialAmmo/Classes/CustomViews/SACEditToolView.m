//
//  SACEditToolViewController.m
//  Social Ammo
//
//  Created by Rupesh Kumar on 6/9/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "SACEditToolView.h"
#import "SACToolView.h"
#import "CustomFolderInfo.h"

#define kGridStartX 10.0
#define kGridStartY 15.0
#define kColumnNumber 5
#define kHorgontalspace 0.0
#define kVerticalSpace 10.0
#define kSACToolTag 500

@interface SACEditToolView ()<SACToolViewDelegate>
{
	BOOL	_isWiggleStart;
}

@end

@implementation SACEditToolView

+ (id) createSACToolViews
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"SACEditToolView"
                                                      owner:self
                                                    options:nil];
    return [nibViews objectAtIndex:0];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
		//self.backgroundColor = GET_COLOR(60,160,180,1);
    }
    return self;
}

- (void) dealloc
{
	
}

#pragma  mark -- Button Action

- (IBAction) addToolBtnAction:(id)sender
{
	if (_isWiggleStart)
		[self stopWiggling];
	
	if ([self.delegate respondsToSelector:@selector(addSubFolder)])
		[self.delegate addSubFolder];
}

- (IBAction) undoBtnAction:(id)sender
{
	[UIUtils messageAlert:@"Work in progres" title:nil delegate:nil];
}

- (IBAction) layerBtnAction:(id)sender
{
	if (_isWiggleStart)
		[self stopWiggling];
	
	UIButton* button = (UIButton*)sender;
	button.selected = !button.selected;
	
	if ([self.delegate respondsToSelector:@selector(showLayerList:)])
		[self.delegate showLayerList:button.selected];
}

- (IBAction) deletBtnAction:(id)sender
{

}

- (IBAction) tapOnTopBtnAction:(id)sender
{
	if (_isWiggleStart)
		[self stopWiggling];
	
	if ([self.delegate respondsToSelector:@selector(handleTopBtnTap)])
		[self.delegate handleTopBtnTap];
}


#pragma mark -

// Set data for scroll view

- (void) setUpDataForView:(NSMutableArray*)folderList
{
	_layerBtn.enabled = NO;
	
	[self addShadowToButton:_colorlayerButton];
	[self addShadowToButton:_activelayerbtn];
	[self addShadowToButton:_eraserbutton];
	
	[[_scrollView subviews]  makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	_lists = [NSMutableArray arrayWithArray:folderList];
	
	NSArray* itemlist = [NSArray arrayWithArray:folderList];
	
	NSUInteger rows = (int) ceilf(itemlist.count/(float)kColumnNumber);
	CGPoint pt = CGPointMake(kGridStartX, kGridStartY);
	int itemIndex = 0;
	for (int j= 0; j < rows; ++j)
	{
		int height = 0;
		pt.x = kGridStartX;
		for (int i = 0;  i < kColumnNumber ; ++i)
		{
			if (itemIndex < itemlist.count)
			{
//				id folderInfo = [itemlist objectAtIndex:itemIndex];
				
					SACToolView* sacToolView = [SACToolView createSACToolViews];
					sacToolView.delgate = self;
					[_scrollView addSubview:sacToolView];
					[sacToolView setOrigin:pt];
					sacToolView.scrollParent = _scrollView;
					sacToolView.mainView = self;
					sacToolView.index = itemIndex;
				    sacToolView.tag = itemIndex +kSACToolTag;
					(_previousSelectedIndex == sacToolView.tag) ? [sacToolView showBorder:YES]:[sacToolView showBorder:NO];
					[sacToolView setScreenData:[itemlist objectAtIndex:itemIndex]];
					pt.x += sacToolView.frame.size.width +kHorgontalspace;
					height = sacToolView.frame.size.height + kHorgontalspace;
				
				// add long Press gesture
				
					UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
													  initWithTarget:self action:@selector(handleLongPress:)];
					lpgr.minimumPressDuration = .8; //seconds
					[sacToolView addGestureRecognizer:lpgr];

								
				itemIndex = itemIndex+1;
			}
		}
		pt.y += height;
	}
	
	_scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), pt.y+30);
	
	UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]
									initWithTarget:self action:@selector(handleTapGesture:)];
	[self addGestureRecognizer:tapGesture];

}

- (void) setTitleForToolView:(NSString*)title
{
	_nameLabel.text = title;
}


- (void) updateLayerCount:(NSUInteger)count
{
	_countlabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)count];
}


- (void) showTopbtn:(BOOL)isShow
{
	_scrollView.hidden = !isShow;
	
//	_addBtn.hidden = !isShow;
//	_undoBtn.hidden = !isShow;
//	_layerBtn.hidden = !isShow;
	
	NSString* menuBackgroundImage = (isShow) ? @"menuexpanded.png" : @"menucondensed.png";
	_menuBackgroundView.image = [UIImage imageNamed:menuBackgroundImage];
	
//	UserInfo* userInfo = _gDataManager.userInfo;
//	_nameLabel.text = [NSString stringWithFormat:@"%@ %@",userInfo.firstname, userInfo.lastname];
}

- (void) showLayerToolButton:(BOOL)isShow withLogoEraser:(BOOL)isLogoLayer;
{
	_activelayerbtn.hidden = !isShow;
	_eraserbutton.hidden = (isShow && isLogoLayer)?NO:YES;
	_colorlayerButton.hidden = !isShow;
}

#pragma  mark -- SACTool delegate

- (void) tapOnButtonHandler:(SACToolView *)button
{
	if (_previousSelectedIndex >=kSACToolTag)
	{
		SACToolView* previusV = (SACToolView*)[_scrollView viewWithTag:_previousSelectedIndex];
		[previusV showBorder:NO];
	}
	
	if ([self.delegate respondsToSelector:@selector(customFolderTapAtindex:)])
		[self.delegate customFolderTapAtindex:button.index];
	
	_previousSelectedIndex = button.index+kSACToolTag;
	[button showBorder:YES];
}

- (void) touchDown
{
//	_scrollView.scrollEnabled = NO;
}

- (void) touchUp
{
//    _scrollView.scrollEnabled = YES;
}

- (BOOL) isTouchDeleteButton:(SACToolView *)button touching:(BOOL)finished;
{
    CGPoint newLoc = [self convertPoint:_deleetBtn.frame.origin toView:self];
    CGRect binFrame = _deleetBtn.frame;
    binFrame.origin = newLoc;
	
    if (CGRectIntersectsRect(binFrame, button.frame) == TRUE)
	{
		[_deleetBtn setImage:[UIImage imageNamed:@"ic_contentcreator_deletepack_del.png"] forState:UIControlStateNormal];
		
        if (finished)
            [self removeTheFolder:button];
		
			return YES;
    }
    else
	{
		[_deleetBtn setImage:[UIImage imageNamed:@"ic_contentcreator_deletepack.png"] forState:UIControlStateNormal];
		return NO;
	}
}

- (IBAction) tapOnActivebtnAction:(id)sender
{
	if([self.delegate respondsToSelector:@selector(handleActivateTap)])
		[self.delegate handleActivateTap];
}

- (IBAction) tapOnColorPickerAction:(id)sender
{
	if([self.delegate respondsToSelector:@selector(handleColorTap)])
		[self.delegate handleColorTap];
}

- (IBAction) eraserBtnAction:(id)sender
{
	if([self.delegate respondsToSelector:@selector(handleErasebtnTap)])
		[self.delegate handleErasebtnTap];
}


#pragma mark -- Private methods

- (void) removeTheFolder:(SACToolView *)button
{
	id info = [_lists objectAtIndex:button.index];
	
    // Move the other button to left
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_scrollView cache:YES];
	
    // Remove the object
	[_lists removeObjectAtIndex:button.index];
	
    // Remove the button
    [button removeFromSuperview];
	[_scrollView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];

    [UIView commitAnimations];
	
	_previousSelectedIndex = (_previousSelectedIndex == button.index+kSACToolTag) ?
											(button.index+kSACToolTag)-1 : _previousSelectedIndex;
	
//	[_deleetBtn setImage:[UIImage imageNamed:@"ic_contentcreator_deletepack.png"]
//				forState:UIControlStateNormal];
	
	if ([self.delegate respondsToSelector:@selector(deletCustomFolderInfo:atIndex:)])
		[self.delegate deletCustomFolderInfo:info atIndex:button.index];
}

#pragma mark-

- (void) enableLayerButton:(BOOL)enable withCount:(NSUInteger)count
{
	_layerBtn.enabled = enable;
}

#pragma mark-

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
	[self startWiggling];
}

- (void) startWiggling
{
    _isWiggleStart = YES;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationEnteredForeground:)
												 name:UIApplicationWillEnterForegroundNotification
											   object:nil];
	
    int closeBtnTag = 1;
    for (UIView* view in [_scrollView subviews])
    {
		 if ([view isKindOfClass:[SACToolView class]])
        {
            
			SACToolView* toolview = (SACToolView*)view;
			
			if (toolview.index )
			
            toolview.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-5));
            
            [UIView animateWithDuration:0.25
                                  delay:0.0
                                options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse)
                             animations:^ {
                                 toolview.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(5));
                             }
                             completion:NULL
             ];
            
			if (toolview.index != 0)
			{
				UIImage* closeBtnImg = [UIImage imageNamed:@"close_delete.png"];
				UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
				closeBtn.frame = CGRectMake(0, 0, 60, 70);
				closeBtn.layer.cornerRadius = 10;
				closeBtn.tag = closeBtnTag;
				CGFloat spacing = 40;
				closeBtn.imageEdgeInsets = UIEdgeInsetsMake(-10, spacing, spacing, -10);
				//closeBtn.backgroundColor = [UIColor whiteColor];
				[closeBtn setImage:closeBtnImg forState:UIControlStateNormal];
				[closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
				[toolview addSubview:closeBtn];
				
				closeBtnTag++;
			}
        }
    }
}

- (void) stopWiggling
{
    _isWiggleStart = NO;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
	for (UIView* view in [_scrollView subviews])
    {
		if ([view isKindOfClass:[SACToolView class]])
        {
			SACToolView* toolview = (SACToolView*)view;

            [UIView animateWithDuration:0.25
                                  delay:0.0
                                options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear)
                             animations:^ {
                                 toolview.transform = CGAffineTransformIdentity;
                             }
                             completion:NULL
             ];
        }
    }
    
	for (UIView* view in [_scrollView subviews])		// removeCloseButtonFromWiggleIcon
    {
		if ([view isKindOfClass:[SACToolView class]])
        {
			SACToolView* toolview = (SACToolView*)view;

            for (UIButton* deleteBtn in toolview.subviews)
            {
                if ([deleteBtn isKindOfClass:[UIButton class]])
                {
                    if (deleteBtn.tag > 0)
                        [deleteBtn removeFromSuperview];
                }
            }
        }
    }
}

- (IBAction) closeBtn:(UIButton*)sender
{
	SACToolView* toolView = (SACToolView*) sender.superview;
	[self stopWiggling];

	[self removeTheFolder:toolView];
}

- (void) handleTapGesture:(UITapGestureRecognizer*)gesture
{
	[self stopWiggling];
}

#pragma mark-

- (void) applicationEnteredForeground:(NSNotification *)notification
{
	// restart wiggling
	[self stopWiggling];
	
	[self startWiggling];
}

- (void) addShadowToButton:(UIButton*)button
{
	button.layer.shadowColor = [UIColor blackColor].CGColor;
	button.layer.shadowOpacity = 0.5;
	button.layer.shadowRadius = 2;
	button.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
}

- (void) selectToolWithPackId:(NSUInteger)packId
{
	int itemIndex = 0;

	for (id info in _lists)
	{
		if ([info isKindOfClass:[PackInfo class]])
		{
			PackInfo* packInfo = (PackInfo*)info;
			if (packInfo.packId == packId)
			{
				NSUInteger tag = itemIndex + kSACToolTag;
				SACToolView* toolView = [_scrollView viewWithTag:tag];
				[toolView tapBtnAction:nil];
				return;
			}
		}
		
		itemIndex = itemIndex +1;
	}
}


@end
