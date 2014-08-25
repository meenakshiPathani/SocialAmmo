//
//  AddCustomSubFolderView.m
//  Social Ammo
//
//  Created by Rupesh Kumar on 6/11/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "UIColor+HumanReadable.h"
#import "AddCustomSubFolderView.h"
#import "CustomInputView.h"

#define kSACEditScreenYShow (kIPhone5)?365.0:277.0
#define KSACEeditScreenYHiden (kIPhone5)?568.0:480.0

@implementation UITextField (Custom)

//- (CGRect)textRectForBounds:(CGRect)bounds
//{
//	return CGRectMake(bounds.origin.x + 10, bounds.origin.y,
//					  bounds.size.width - 20, bounds.size.height);
//}
//
//- (CGRect)editingRectForBounds:(CGRect)bounds
//{
//	return [self textRectForBounds:bounds];
//}

@end

@implementation AddCustomSubFolderView

+ (id) createAddCustoMFolderView
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"AddCustomSubFolderView"
                                                      owner:self
                                                    options:nil];
    return [nibViews objectAtIndex:0];
}

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

#pragma mark -

- (void) baseInit
{
	UIGestureRecognizer* touchRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:touchRecognizer];
	
	_nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Title" attributes:@{NSForegroundColorAttributeName: GET_COLOR(9, 204, 231, 1.0),NSFontAttributeName:[UIFont fontWithName:kFontRalewayRegular size:16.0F]}];
	_nameTextField.font = [UIFont fontWithName:kFontRalewayRegular size:16.0F];
	
	_colorBtn.layer.cornerRadius = 16.0;
	
	// Set title color for diffrent diffrent state

	UIColor* highLightedColor = [kWhiteColor colorWithAlphaComponent:.30];
	[_colorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_colorBtn setTitleColor:highLightedColor forState:UIControlStateHighlighted];
	[_colorBtn setTitleColor:highLightedColor forState:UIControlStateSelected];
	
	_saveBtn.layer.borderWidth = .50;
	_cancelBtn.layer.borderWidth = .50;
	_saveBtn.layer.borderColor = [kBlueColor colorWithAlphaComponent:.2].CGColor;
	_cancelBtn.layer.borderColor = [kBlueColor colorWithAlphaComponent:.2].CGColor;
	
	[_colorBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 200.0, 0, 0)];
}

- (void) showCustomFolderViewInView:(UIView*)currentView
{
	[self baseInit];
	
	[currentView.window addSubview:self];
	
	self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.alpha = 0;
    [UIView beginAnimations:@"showAlert" context:nil];
    [UIView setAnimationDelegate:self];
    self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    self.alpha = 1.0;
    [UIView commitAnimations];
}

- (void) hideCustomFolderView
{
	[UIView beginAnimations:@"hideAlert" context:nil];
    [UIView setAnimationDelegate:self];
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.alpha = 0;
    [UIView commitAnimations];
	[self removeFromSuperview];
}

- (void) showColorPicker:(BOOL)isShow
{
	CGRect rect = _colorPickerView.frame;
	rect.origin.y = (isShow)?kSACEditScreenYShow:KSACEeditScreenYHiden;
	
	[UIView beginAnimations:@"animateTableView" context:nil];
	[UIView setAnimationDuration:0.4];
	
	_colorPickerView.frame = rect;
	[UIView commitAnimations];
}

#pragma  mark -- GestureHanlder method

- (void) handleTapGesture:(id)sender
{
	if ([_nameTextField isFirstResponder])
		[_nameTextField resignFirstResponder];
	
	[self showColorPicker:NO];
}


#pragma  mark -- Button Action

- (IBAction) savebtnAction:(id)sender
{
	NSString* foldername = [UIUtils checknilAndWhiteSpaceinString:_nameTextField.text];
	
	if (foldername.length < 1)
	{
		[UIUtils messageAlert:@"Please enter the title" title:@"" delegate:nil];
		return;
	}
		
	CustomFolderInfo* folderInfo = [[CustomFolderInfo alloc] init];
	folderInfo.folderName = foldername;
//	folderInfo.folderContentNumbers = @"0";
	folderInfo.folderColor = [_colorBtn backgroundColor];
	folderInfo.humanReadableColor = [UIColor stringFromColor:_colorBtn.backgroundColor];
	folderInfo.folderContents = [[NSArray alloc] init];
	folderInfo.purchase = NO;
	
	if ([self.delegate respondsToSelector:@selector(saveSubFolder:)])
		[self.delegate saveSubFolder:folderInfo];
	
	[self hideCustomFolderView];
}

- (IBAction) cancelbtnAction:(id)sender
{
	[self hideCustomFolderView];
}

- (IBAction) colorBtnAction:(id)sender
{
	if([_nameTextField isFirstResponder])
	   [_nameTextField resignFirstResponder];
	
	[self showColorPicker:YES];
}

- (IBAction) donebtnAction:(id)sender
{
	[self showColorPicker:NO];
}

#pragma  mark -- CustomInputViewDelegate color picker

- (void) fillTextWithColor:(UIColor*)textColor
{
	_colorBtn.backgroundColor = textColor;
}

#pragma  mark -- TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	[self showColorPicker:NO];
	return  YES;
}

@end
