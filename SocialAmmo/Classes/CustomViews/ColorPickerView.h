//
//  ColorPickerView.h
//  SocialAmmo
//
//  Created by Meenakshi on 24/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


@protocol ColorPickerDelegate <NSObject>

- (void) pickColor:(UIColor*)color;
- (void) colorPickerDoneButtonPressed:(UIColor*)color;

@end

@interface ColorPickerView : UIView
{
	IBOutlet UIImageView*	_colorImageView;
	IBOutlet UIImageView*	_colorSelector;
	
	IBOutlet UIView*	_colorBackgroundView;
	
	UIColor*	_color;
}
@property(nonatomic, weak)id<ColorPickerDelegate> delegate;

+ (id) createColorPickerView;

- (IBAction) doneButtonPressed:(UIButton*)sender;

@end
