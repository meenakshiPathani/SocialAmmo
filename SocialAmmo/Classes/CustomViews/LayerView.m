//
//  LayerView.m
//  SocialAmmo
//
//  Created by Meenakshi on 23/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "UIImage+Color.h"
#import "LayerView.h"

#define kLogoLayerSize 102
#define kLayerImageSize 82

@interface LayerView ()
{
}

@end

@implementation LayerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id) createLayerView
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:kLayerViewNib
                                                      owner:self
                                                    options:nil];
    return [nibViews objectAtIndex:0];
}

- (void) initiateWithLayerInfo:(LayerInfo*)info
{
	self.layerInfo = info;
	
	self.frame = (info.layerType == ELayerTypeLogo)?CGRectMake(self.superview.center.x, self.superview.center.y, 150, 150):CGRectMake(self.superview.center.x, self.superview.center.y, 250, 250);
	
	if (info.layerType == ELayerTypeLogo)
	{
		CGRect zoomRect = _zoomableView.frame;
		zoomRect.size = CGSizeMake(kLogoLayerSize, kLogoLayerSize);
		_zoomableView.frame = zoomRect;
		
		CGRect layerImageBRect = _layerImageBackground.frame;
		layerImageBRect.size = CGSizeMake(kLogoLayerSize, kLogoLayerSize);
		_layerImageBackground.frame = layerImageBRect;
		
		CGRect layerImageRect = self.layerImageView.frame;
		layerImageRect.size = CGSizeMake(kLayerImageSize, kLayerImageSize);
		self.layerImageView.frame = layerImageRect;
	}
	
	_zoomableView.center = self.center;
	
	_layerImageBackground.image = [UIImage imageNamed:@"transformsquare.png"];
	
	_circleView = [[CLCircleView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
	_circleView.center = CGPointMake(self.frame.size.width - 25,self.frame.size.height - 25);
	_circleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
	_circleView.radius = 0.7;
	_circleView.color = [UIColor whiteColor];
	_circleView.borderColor = [UIColor blackColor];
	_circleView.borderWidth = 5;
	[self addSubview:_circleView];
	
	_scale = 1;
	_arg = 0;
	
	[self initGestures];
	[self setEditingEbabled:YES];
	
	self.layerImageView.image = info.layerImage;
}

- (void)initGestures
{
	_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
	_panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)];
    [_circleView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewDidPan:)]];
	
	[_zoomableView addGestureRecognizer:_panGesture];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* view= [super hitTest:point withEvent:event];
    if(view==self){
        return nil;
    }
    return view;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    self.transform = CGAffineTransformIdentity;
    
    _zoomableView.transform = CGAffineTransformMakeScale(_scale, _scale);
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (_zoomableView.frame.size.width + 32)) / 2;
    rct.origin.y += (rct.size.height - (_zoomableView.frame.size.height + 32)) / 2;
    rct.size.width  = _zoomableView.frame.size.width + 32;
    rct.size.height = _zoomableView.frame.size.height + 32;
    self.frame = rct;
    
    _zoomableView.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    
    self.transform = CGAffineTransformMakeRotation(_arg);
}

- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint p = [sender translationInView:self.superview];
    
    if(sender.state == UIGestureRecognizerStateBegan)
	{
        _initialPoint = self.center;
    }
    self.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
}

- (void)circleViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint p = [sender translationInView:self.superview];
    
    static CGFloat tmpR = 1;
    static CGFloat tmpA = 0;
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = [self.superview convertPoint:_circleView.center fromView:_circleView.superview];
        
        CGPoint p = CGPointMake(_initialPoint.x - self.center.x, _initialPoint.y - self.center.y);
        tmpR = sqrt(p.x*p.x + p.y*p.y);
        tmpA = atan2(p.y, p.x);
        
        _initialArg = _arg;
        _initialScale = _scale;
    }
    
    p = CGPointMake(_initialPoint.x + p.x - self.center.x, _initialPoint.y + p.y - self.center.y);
    CGFloat R = sqrt(p.x*p.x + p.y*p.y);
    CGFloat arg = atan2(p.y, p.x);
    
    _arg   = _initialArg + arg - tmpA;
    [self setScale:MAX(_initialScale * R / tmpR, 0.2)];
}

#pragma mark-

- (void) handleTapGesture:(UITapGestureRecognizer*)gesture
{
	[self setEditingEbabled:YES];
	self.allowEditing = YES;
	
	[self removeGestureRecognizer:_tapGesture];
	if ([self.delegate respondsToSelector:@selector(handleTapEventForLayer:)])
		[self.delegate handleTapEventForLayer:self];
}

- (void) disallowEditingInLayer
{
	[self allowEditingInLayer:NO];
	
	[self addGestureRecognizer:_tapGesture];
}

- (void) allowEditingInLayer:(BOOL)editing
{
	[self setEditingEbabled:editing];
	
	if([self.delegate respondsToSelector:@selector(allowEditingInLayer:)])
		[self.delegate allowEditingInLayer:self];
}

- (IBAction) tapONCancelBtnAction:(id)sender
{
	if([self.delegate respondsToSelector:@selector(handleCancelTapInLayer:)])
		[self.delegate handleCancelTapInLayer:self];
}

- (IBAction) tapOnActivebtnAction:(id)sender
{
	self.allowEditing = NO;
	
	[self disallowEditingInLayer];
}

#pragma mark-

- (void) updateLayerOpacity:(CGFloat)alpha;
{
	self.layerImageView.alpha = alpha;
}

- (void) updateLayerImage:(UIImage*)image
{
	self.layerImageView.image = image;
}

- (void) setEditingEbabled:(BOOL)isEditable
{
	isEditable?[self removeGestureRecognizer:_tapGesture]:[self addGestureRecognizer:_tapGesture];
	
	(isEditable)?[_zoomableView addGestureRecognizer:_panGesture]:[_zoomableView removeGestureRecognizer:_panGesture];
	
	_cancelbutton.hidden = !isEditable;
	_layerImageBackground.hidden = !isEditable;
	_circleView.hidden = !isEditable;
}

@end
