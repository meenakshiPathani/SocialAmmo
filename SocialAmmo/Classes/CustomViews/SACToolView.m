//
//  SACToolView.m
//  Social Ammo
//
//  Created by Rupesh Kumar on 6/9/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "SACToolView.h"


@implementation SACToolView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id) createSACToolViews
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"SACToolView"
                                                      owner:self
                                                    options:nil];
    return [nibViews objectAtIndex:0];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) dealloc
{
	
}

#pragma mark -

- (void) setOrigin:(CGPoint)point
{
    CGRect frame = self.frame;
    frame.origin = point;
    self.frame = frame;
}

- (void) setScreenData:(id)customFolder
{
	if ([customFolder isKindOfClass:[CustomFolderInfo class]])
	{
		_folderInfo = customFolder;
		_packName.text = _folderInfo.folderName;

		//Folder button config
		_folderbtn.layer.cornerRadius = 4.0;
		_folderbtn.backgroundColor = _folderInfo.folderColor;
		NSString* title = [NSString stringWithFormat:@"%lu", (unsigned long)_folderInfo.folderContents.count];
		[_folderbtn setTitle:title forState:UIControlStateNormal];
	}
	else if ([customFolder isKindOfClass:[PackInfo class]])
	{
		_packInfo = customFolder;
		_packName.text = _packInfo.packName;
		_brandName.attributedText = [self getBrandName:_packInfo.brandName];
				
		_btnImageView.image = nil;
		if (_packInfo.packIconUrl != nil)
		{
			_btnImageView.imageUrl = _packInfo.packIconUrl;
			[_btnImageView becomeActive];
		}
		else
		{
			_btnImageView.image = [UIImage imageNamed:@"iconblank.png"];
		}
	}
	
//	UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer
//										   alloc] initWithTarget:self
//											action:@selector(draggingGesture:)];
//    [self addGestureRecognizer:panGesture];
	
	/* download image for logo
	_btnImageView.image = nil;
	_btnImageView.imageUrl = @"";//item.imageURL;
	[_btnImageView becomeActive];
	 */
	
}

#pragma  mark -- Button Action

- (IBAction) tapBtnAction:(id)sender
{
	if ([self.delgate respondsToSelector:@selector(tapOnButtonHandler:)])
		[self.delgate tapOnButtonHandler:self];
}

#pragma mark - Gesture selector

- (void) draggingGesture: (id)sender
{
	if (self.index == 0)
		return;
	
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *) sender;
    switch (recognizer.state)
	{
        case UIGestureRecognizerStateBegan:
		{
			[self handleDragBegining];
        }
			break;

        case UIGestureRecognizerStateChanged:
		{
			[UIView beginAnimations:@"animatedS" context:nil];
			[UIView setAnimationDuration:.001];
			[UIView setAnimationBeginsFromCurrentState:YES];
			self.center = [recognizer locationInView: self.mainView];
			
			if ([self.delgate respondsToSelector:@selector(isTouchDeleteButton: touching:)])
				[self.delgate isTouchDeleteButton:self touching:NO];
				
			[UIView commitAnimations];
        }
			break;

        case UIGestureRecognizerStateEnded:
		{
            if ([self.delgate respondsToSelector:@selector(isTouchDeleteButton: touching:)])
			{
				BOOL isExist = [self.delgate isTouchDeleteButton:self touching:YES];
				
				if (!isExist)
					[self moveBackAnimation];
				
//				(isExist)?[self performDeleteAnimation]:[self moveBackAnimation];
			}
			
//			[self endOfDraging];
        }
			break;
			
		case UIGestureRecognizerStateCancelled:
		{
			NSLog(@"Canceld");
			
			[self endOfDraging];
		}
			break;

		case UIGestureRecognizerStateFailed:
		{
			NSLog(@"Failed");
			
			[self endOfDraging];
		}
			break;
			
		default:
			break;
    }
}

#pragma mark -- Private methods

- (void) handleDragBegining
{
	if ([self.delgate respondsToSelector:@selector(touchDown)])
		[self.delgate touchDown];
	
	_folderbtn.enabled = NO;
	
	self.originalPosition = self.center;
	self.scrollParent.scrollEnabled = NO;
	
	CGPoint newLoc = CGPointZero;
	newLoc = [[self superview] convertPoint:self.center toView:self.mainView];
	_originalOutsidePosition = newLoc;
	
	//[self.superview touchesCancelled:touches withEvent:event];
	//[self removeFromSuperview];
	
	self.center = newLoc;
	[self.mainView addSubview:self];
	[self.mainView bringSubviewToFront:self];
	self.isInScrollview = NO;
}

/* Stop the animation untill image not provided by client */

- (void) performDeleteAnimation
{
//	
//	 UIImageView * animation = [[UIImageView alloc] init];
//	 animation.frame = CGRectMake(self.center.x - 32, self.center.y - 32, 40, 40);
//	 
//	 animation.animationImages = [NSArray arrayWithObjects:
//	 [UIImage imageNamed: @"iconEliminateItem1.png"],
//	 [UIImage imageNamed: @"iconEliminateItem2.png"],
//	 [UIImage imageNamed: @"iconEliminateItem3.png"],
//	 [UIImage imageNamed: @"iconEliminateItem4.png"]
//	 ,nil];
//	 [animation setAnimationRepeatCount:1];
//	 [animation setAnimationDuration:0.35];
//	 [animation startAnimating];
//	 [self.mainView addSubview:animation];
//	 [animation bringSubviewToFront:self.mainView];
	 
}

- (void) moveBackAnimation
{
	[UIView beginAnimations:@"goback" context:nil];
	[UIView setAnimationDuration:0.4f];
	[UIView setAnimationBeginsFromCurrentState:YES];
	self.center = _originalOutsidePosition;
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
	[UIView commitAnimations];
}

// Animation stop selector
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"goback"] && finished)
	{
        [self removeFromSuperview];
        self.center = _originalPosition;
        [self.scrollParent addSubview:self];
        self.isInScrollview = YES;
    }
}

- (void) showBorder:(BOOL)isShow
{
	if (isShow)
	{
		_folderbtn.layer.borderWidth = 1.0;
		_folderbtn.layer.borderColor = [UIColor redColor].CGColor;
	}
	else
	{
		_folderbtn.layer.borderWidth = 1.0;
		_folderbtn.layer.borderColor = [UIColor clearColor].CGColor;
	}
}

//Enable the views after end of draging
- (void) endOfDraging
{
	if ([self.delgate respondsToSelector:@selector(touchUp)])
		[self.delgate touchUp];
	
	_folderbtn.enabled = YES;
}

- (NSAttributedString*) getBrandName:(NSString*)brandName
{
	NSMutableAttributedString*byStr  = [[NSMutableAttributedString alloc] initWithString:@"by "
																			  attributes:@{NSForegroundColorAttributeName: [UIColor
																															darkGrayColor],NSFontAttributeName:[UIFont fontWithName:
																																								kFontRalewayBold size:9.0f]}];
	
	NSAttributedString* brandNameStr = [[NSAttributedString alloc] initWithString:brandName
																	   attributes:@{NSForegroundColorAttributeName:
																						kBlueColor,NSFontAttributeName:
																						[UIFont fontWithName:kFontRalewayBold size:9.0f]}];
	
	[byStr appendAttributedString:brandNameStr];
	
	return  byStr;
}


@end
