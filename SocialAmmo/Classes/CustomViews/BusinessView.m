//
//  BusinessView.m
//  SocialAmmo
//
//  Created by Meenakshi on 16/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "BusinessView.h"

@implementation BusinessView


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
		
		[self prepareLayoutOfView];
    }
    return self;
}

#pragma mark-

- (void)baseInit
{
	NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"BuisnessView" owner:self options:nil];
	if (array.count > 0)
		[self addSubview:[array objectAtIndex:0]];
}

- (void) prepareLayoutOfView
{
	_businessNameImageView.layer.cornerRadius = CGRectGetWidth(_businessNameImageView.frame)/2;
	_businessDescriptionImageView.layer.cornerRadius = 56;
	
	self.profileImageV.image = nil;
	self.profileImageV.imageUrl = _gDataManager.userInfo.profilePicURL;
	[self.profileImageV becomeActive];
	self.profileImageV.layer.cornerRadius = CGRectGetWidth(self.profileImageV.frame)/2;;
	self.profileImageV.clipsToBounds = YES;
	
//	_nameTextView.layer.cornerRadius = CGRectGetWidth(_nameTextView.frame)/2;
//	_descriptionTextView.layer.cornerRadius = CGRectGetWidth(_descriptionTextView.frame)/2;
}

#pragma mark-

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	if ([self.delegate respondsToSelector:@selector(beginEditing:)])
		[self.delegate beginEditing:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	NSUInteger oldLength = [textView.text length];
	NSUInteger replacementLength = [text length];
	NSUInteger rangeLength = range.length;
	
	NSUInteger newLength = oldLength - rangeLength + replacementLength;
	
	NSUInteger maxLength = (textView.tag == 1) ? kBuisnessNameMaxLength : kBuisnessDescriptionMaxLength;

	BOOL returnKey = [text rangeOfString: @"\n"].location != NSNotFound;
	
	return newLength <= maxLength || returnKey;
	
	//	NSString* textString = textView.text;
//    textString = [textString stringByReplacingCharactersInRange:range withString:text];
//    CGSize textSize = [textString sizeWithAttributes:@{NSFontAttributeName:textView.font}];
//	
//    return (textSize.width < textView.bounds.size.width) ? YES : NO;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	DLog(@"%@", textView.text);
	
	if ([self.delegate respondsToSelector:@selector(endEditing:)])
		[self.delegate endEditing:textView];

	return YES;
}

#pragma mark-

- (void) displayBusinessInfo:(UserInfo*)info
{	
	_nameTextView.text = info.businessName;
}

- (void) setBusinessImageViewWithImage:(UIImage*)image
{
	_businessIconImageView.hidden = YES;
	self.profileImageV.image = image;
}

- (IBAction) selectImageBtnAction:(id)sender
{
	[self endEditing:YES];
	
	if ([self.delegate respondsToSelector:@selector(selectImageAction)])
		[self.delegate selectImageAction];
}

@end
