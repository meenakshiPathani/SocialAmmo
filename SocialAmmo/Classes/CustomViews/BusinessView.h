//
//  BusinessView.h
//  SocialAmmo
//
//  Created by Meenakshi on 16/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

@protocol BusinessViewDelegate <NSObject>

- (void) beginEditing:(UITextView*)textView;
- (void) endEditing:(UITextView*)textView;
- (void) selectImageAction;

@end


@interface BusinessView : UIView
{
	IBOutlet UIImageView*	_businessNameImageView;
	IBOutlet UIImageView*	_businessDescriptionImageView;
	IBOutlet UIImageView*	_businessIconImageView;
	
	IBOutlet UITextView*	_nameTextView;
	IBOutlet UITextView*	_descriptionTextView;
	
	NSString* _businessName;
}
@property (nonatomic, weak)id <BusinessViewDelegate> delegate;
@property (nonatomic, retain)IBOutlet AsyncImageView* profileImageV;

- (void) displayBusinessInfo:(UserInfo*)info;
- (void) setBusinessImageViewWithImage:(UIImage*)image;
- (IBAction) selectImageBtnAction:(id)sender;

@end
