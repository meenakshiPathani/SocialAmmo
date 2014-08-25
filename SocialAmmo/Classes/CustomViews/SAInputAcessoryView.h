//
//  SAInputAcessoryView.h
//  Social Ammo
//
//  Created by Meenakshi on 16/01/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "SAButton.h"

@protocol SAInputAcessoryViewDelegate <NSObject>

- (void) acessoryButtonPressed;

@end

@interface SAInputAcessoryView : UIView
{
	
}
@property(nonatomic, weak)id <SAInputAcessoryViewDelegate> delegate;

@property(nonatomic, strong) SAButton* nextButton;

- (void) setNextButtonTitle:(NSString*)title;
- (void) setButtonEnableDisable:(BOOL) isEnabled;
- (void) setNextbuttonImage:(NSString*)imageName;

@end
