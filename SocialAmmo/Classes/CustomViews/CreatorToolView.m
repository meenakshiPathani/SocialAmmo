//
//  CreatorToolView.m
//  SocialAmmo
//
//  Created by Meenakshi on 17/06/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "CreatorToolView.h"

#define kBaseImageTag 3000

@implementation CreatorToolView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self baseInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self baseInit];
	}
	return self;
}

#pragma mark-

- (void)baseInit
{
	self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"FilterColor_back.png"]];
}

- (void) initalizeToolView:(NSArray*)tools withImage:(UIImage*)image withType:(EPackType)type
{
	[self clearToolView];
	
	_toolArray = tools;
	
	int offsetX = 10;
	
    for(int index = 0; index < [tools count]; ++index)
    {
        UIView* toolView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, 10, 40, 40)];
		toolView.backgroundColor = [UIColor blackColor];
        
        toolView.tag = index;
        
		NSString* filepath = [tools objectAtIndex:index];
		
        // create filter preview image views
		if (type == EPackTypeImage)
		{
			UIImageView* previewImageView = [self createPreviewImageView:filepath];
			[toolView addSubview:previewImageView];
			[self applyGesturesToFilterPreviewImageView:previewImageView];
		}
		else if (type == EPackTypeText)
		{
			UILabel* previewLabel = [self createPreviewLabel:filepath];
			[toolView addSubview:previewLabel];
		}

        toolView.tag = index;
		
        [self addSubview:toolView];
        
        offsetX += toolView.bounds.size.width + 10;
    }
    
	[self setContentSize:CGSizeMake(offsetX, CGRectGetHeight(self.frame))];
}

- (UIImageView*) createPreviewImageView:(NSString*)imageFilepath
{
	UIImage *smallImage =  [UIImage imageWithContentsOfFile:imageFilepath];
	
	// create filter preview image views
	UIImageView* previewImageView = [[UIImageView alloc] initWithImage:smallImage];
	[previewImageView setUserInteractionEnabled:YES];
	
	previewImageView.opaque = NO;
	previewImageView.backgroundColor = [UIColor clearColor];
	previewImageView.layer.masksToBounds = YES;
	previewImageView.frame = CGRectMake(0, 0, 40, 40);
	
	return previewImageView;
}

- (UILabel*) createPreviewLabel:(NSString*)fontPath
{
	// create filter preview label
	UILabel* previewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
	previewLabel.text = @"Abc";
	previewLabel.textColor = [UIColor whiteColor];
	previewLabel.textAlignment = NSTextAlignmentCenter;
	NSURL* url = [NSURL fileURLWithPath:fontPath];
	previewLabel.font = [UIUtils cutomFont:url];
	[previewLabel setUserInteractionEnabled:YES];
	
	previewLabel.opaque = NO;
	previewLabel.backgroundColor = [UIColor clearColor];
	previewLabel.layer.masksToBounds = YES;
	
	return previewLabel;
}

- (void) clearToolView
{
	NSArray* subviewArray = self.subviews;
	
	for (UIView* view in subviewArray)
	{
		[view removeFromSuperview];
	}
}

- (void) applyGesturesToFilterPreviewImageView:(UIView *) view
{
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(applyTool:)];
	
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
	
    [view addGestureRecognizer:singleTapGestureRecognizer];
}

- (void)applyTool:(UITapGestureRecognizer*)sender
{
	UIView* previusV = [self viewWithTag:_previousSelectedIndex];
	previusV.layer.borderWidth = 1.0;
	previusV.layer.borderColor = [UIColor clearColor].CGColor;
	
	sender.view.superview.layer.borderWidth = 1.0;
	sender.view.superview.layer.borderColor = [UIColor redColor].CGColor;
	
	NSInteger tooltag = sender.view.superview.tag;
	if ([self.observer respondsToSelector:@selector(applyToolImageAtIndex:)])
		[self.observer applyToolImageAtIndex:tooltag];
	
	_previousSelectedIndex = tooltag;
}

- (void) updateBaseImage:(UIImage*)image
{
	for (UIView* view in self.subviews)
	{
		UIImageView* baseImageView = (UIImageView*)[view viewWithTag:kBaseImageTag];
		baseImageView.image = image;
	}
}



@end
