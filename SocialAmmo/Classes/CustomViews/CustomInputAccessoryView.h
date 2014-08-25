//
//  CustomInputAccessoryView.h
//  PicLab
//
//  Created by Rupesh Kumar on 2/17/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

// Delegate to handle action.
@protocol CustomInputAccessoryViewDelegate<NSObject>
@optional
- (void) handleColorPickerBtnAction;
- (void) handleAlignmentAction:(NSTextAlignment)alignmentValue;
- (void) handleDoneBtnAction;
- (void) handleHideBtnAction;

@end

@interface CustomInputAccessoryView : UIView
{
    IBOutlet UIButton* _donebutton;
    IBOutlet UIButton* _hidePickerButton;
}

@property (nonatomic, assign) id<CustomInputAccessoryViewDelegate> accessoryViewDelegate;

+ (id) createInputAccesryView;

- (IBAction) leftAlignmentAction:(id)sender;
- (IBAction) centerAlignmentaction:(id)sender;
- (IBAction) rightAlignmentaction:(id)sender;
- (IBAction) colorPickerAction:(id)sender;
- (IBAction) doneButtonaction:(id)sender;
- (IBAction) hidePickerBtnAction:(id)sender;

@end
