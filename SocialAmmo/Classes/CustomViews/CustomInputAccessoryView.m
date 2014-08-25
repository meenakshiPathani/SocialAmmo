//
//  CustomInputAccessoryView.m
//  PicLab
//
//  Created by Rupesh Kumar on 2/17/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "CustomInputAccessoryView.h"

@implementation CustomInputAccessoryView

- (void) dealloc
{
    _donebutton = nil;
    _hidePickerButton = nil;
    self.accessoryViewDelegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id) createInputAccesryView
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"CustomInputAccessoryView"
                                                      owner:self
                                                    options:nil];
    return [nibViews objectAtIndex:0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark --  
#pragma mark --  InputAccessoryview Action

- (IBAction) colorPickerAction:(id)sender
{
    _donebutton.hidden = !_donebutton.hidden;
    _hidePickerButton.hidden = !_hidePickerButton.hidden;
    
    if (_donebutton.hidden)
    {
        if (self.accessoryViewDelegate && [self.accessoryViewDelegate respondsToSelector:
										   @selector(handleColorPickerBtnAction)])
            [self.accessoryViewDelegate handleColorPickerBtnAction];
    }
    else if (_hidePickerButton.hidden)
    {
        if (self.accessoryViewDelegate && [self.accessoryViewDelegate respondsToSelector:
										   @selector(handleHideBtnAction)])
            [self.accessoryViewDelegate handleHideBtnAction];
    }
}

- (IBAction) leftAlignmentAction:(id)sender
{
   	if (self.accessoryViewDelegate && [self.accessoryViewDelegate respondsToSelector:
									   @selector(handleAlignmentAction:)])
		[self.accessoryViewDelegate handleAlignmentAction:NSTextAlignmentLeft];
}

- (IBAction) centerAlignmentaction:(id)sender
{
   	if (self.accessoryViewDelegate && [self.accessoryViewDelegate respondsToSelector:
									   @selector(handleAlignmentAction:)])
		[self.accessoryViewDelegate handleAlignmentAction:NSTextAlignmentCenter];
}

- (IBAction) rightAlignmentaction:(id)sender
{
   	if (self.accessoryViewDelegate && [self.accessoryViewDelegate respondsToSelector:
									   @selector(handleAlignmentAction:)])
		[self.accessoryViewDelegate handleAlignmentAction:NSTextAlignmentRight];
}

- (IBAction) doneButtonaction:(id)sender
{
   	if (self.accessoryViewDelegate && [self.accessoryViewDelegate respondsToSelector:
									   @selector(handleDoneBtnAction)])
		[self.accessoryViewDelegate handleDoneBtnAction];
}

- (IBAction)hidePickerBtnAction:(id)sender
{
    _donebutton.hidden = NO;
    _hidePickerButton.hidden = YES;
    
   	if (self.accessoryViewDelegate && [self.accessoryViewDelegate respondsToSelector:
									   @selector(handleHideBtnAction)])
		[self.accessoryViewDelegate handleHideBtnAction];
}

@end
