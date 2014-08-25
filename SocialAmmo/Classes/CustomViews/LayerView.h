//
//  LayerView.h
//  SocialAmmo
//
//  Created by Meenakshi on 23/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

//#import "CustomImageView.h"

#import "LayerInfo.h"
#import "CLCircleView.h"

@class LayerView;

@protocol LayerViewDelegate <NSObject>

- (void) handleTapEventForLayer:(LayerView*)layer;
- (void) allowEditingInLayer:(LayerView*)layer;
- (void) handleCancelTapInLayer:(LayerView*)layer;

@end

@interface LayerView : UIView
{
	IBOutlet UIImageView*	_layerImageBackground;
	IBOutlet UIView*	_zoomableView;
	
	IBOutlet UIButton* _cancelbutton;	
	
	UITapGestureRecognizer* _tapGesture;
	UIPanGestureRecognizer* _panGesture;
	
	CLCircleView* _circleView;
	
	CGFloat _scale;
    CGFloat _arg;
    
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
}

@property (nonatomic, retain) IBOutlet UIImageView* layerImageView;
@property (nonatomic, assign)BOOL allowEditing;
@property (nonatomic, strong)LayerInfo*	layerInfo;

@property (nonatomic, weak)id<LayerViewDelegate> delegate;

+ (id) createLayerView;

- (void) initiateWithLayerInfo:(LayerInfo*)info;
- (void) disallowEditingInLayer;
- (void) setEditingEbabled:(BOOL)isEditable;
- (void) updateLayerOpacity:(CGFloat)alpha;
- (void) updateLayerImage:(UIImage*)image;

- (IBAction) tapONCancelBtnAction:(id)sender;

@end
