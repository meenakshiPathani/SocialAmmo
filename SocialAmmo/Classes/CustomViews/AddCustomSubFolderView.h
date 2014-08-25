//
//  AddCustomSubFolderView.h
//  Social Ammo
//
//  Created by Rupesh Kumar on 6/11/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomFolderInfo.h"
#import "CustomInputView.h"

@protocol AddCustomSubFolderViewDelegate <NSObject>

- (void) saveSubFolder:(CustomFolderInfo*)folderInfo;

@end

@interface AddCustomSubFolderView : UIView <CustomInputViewDelegate>
{
	IBOutlet UITextField* _nameTextField;
	IBOutlet UIButton* _colorBtn;
	IBOutlet UIButton* _saveBtn;
	IBOutlet UIButton* _cancelBtn;
	
	IBOutlet UIView* _colorPickerView;
}

@property (nonatomic,assign) IBOutlet id<AddCustomSubFolderViewDelegate> delegate;

+ (id) createAddCustoMFolderView;

- (void) baseInit;
- (void) showCustomFolderViewInView:(UIView*)currentView;
- (void) hideCustomFolderView;

- (IBAction) savebtnAction:(id)sender;
- (IBAction) cancelbtnAction:(id)sender;
- (IBAction) colorBtnAction:(id)sender;
- (IBAction) donebtnAction:(id)sender;

@end
