//
//  SAInputAcessoryView.m
//  Social Ammo
//
//  Created by Meenakshi on 16/01/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "SAButton.h"
#import "SAInputAcessoryView.h"

#define kButtonWidth 100
#define kButtonHeight 40


@implementation SAInputAcessoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self initiateInputView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
		[self initiateInputView];
    }
	
    return self;
}


- (void) initiateInputView
{
	self.backgroundColor = kWhiteColor;
	
	// Initialization code
	CGFloat x = (CGRectGetWidth(self.frame)- kButtonWidth)/2;
	CGFloat y = (CGRectGetHeight(self.frame)- kButtonHeight)/2;
	CGRect rect = CGRectMake(x, y, kButtonWidth, kButtonHeight);
	self.nextButton = [self createButton:rect title:@"Next >" tag:ENextButton];
	
	[self addSubview:self.nextButton];
	
	self.nextButton.exclusiveTouch = YES;
}

-(SAButton*) createButton:(CGRect)rect title:(NSString*)title tag:(NSUInteger)tag
{
	SAButton* button = [SAButton buttonWithType:UIButtonTypeCustom];
	button.exclusiveTouch = YES;
	button.frame = rect;
	[button setTitle:title forState:UIControlStateNormal];
	button.tag = tag;
	button.titleLabel.font = [UIFont fontWithName:kFontRalewayBold size:16.0];
	[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[button setColor:kBlueColor];
	
	return button;
}

- (IBAction) buttonPressed:(UIButton*)sender
{
	switch (sender.tag)
	{
		case ENextButton:
		{
			if ([self.delegate respondsToSelector:@selector(acessoryButtonPressed)])
				[self.delegate acessoryButtonPressed];
			break;
		}
		default:
			break;
	}
}


- (void) setNextButtonTitle:(NSString*)title
{
	UIFont* font = self.nextButton.titleLabel.font;
	CGSize size = [title sizeWithFont:font];
	
	size.width += 50;
	if (size.width > 100)
	{
		CGFloat x = (CGRectGetWidth(self.frame)- size.width)/2;
		CGFloat y = (CGRectGetHeight(self.frame)- kButtonHeight)/2;
		self.nextButton.frame = CGRectMake(x, y, size.width, kButtonHeight);
	}
	
	[self.nextButton setTitle:title forState:UIControlStateNormal];
}

- (void) setNextbuttonImage:(NSString *)imageName
{
	[self setNextButtonTitle:nil];
	[self.nextButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
	self.nextButton.layer.borderColor = [UIColor clearColor].CGColor;
}

- (void) setButtonEnableDisable:(BOOL) isEnabled
{
	self.nextButton.enabled = isEnabled;
	UIColor* customColor = (isEnabled)?kBlueColor:[kBlueColor colorWithAlphaComponent:.4];
	self.nextButton.layer.borderColor = customColor.CGColor;
	[self.nextButton setTitleColor:customColor forState:UIControlStateNormal];
}

@end
