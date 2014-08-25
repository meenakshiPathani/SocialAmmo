//
//  NewLogInViewController.h
//  SocialAmmo
//
//  Created by Rupesh Kumar on 7/1/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	ENewLoginFieldUsername = 10,
	ENewLoginFieldPassword,
} ENewLoginFieldType;

@interface NewLogInViewController : UIViewController
{
	IBOutlet UITextField* _usernameTextField;
	IBOutlet UITextField* _passwordTextField;
	
	IBOutlet UIScrollView* _scrollView;
}

- (IBAction) loginWithFacebookBtnAction:(id)sender;
- (IBAction) logInWithLinkdInButtonAction:(id)sender;
- (IBAction) backButtonAction:(id)sender;
- (IBAction) goBttnAction:(id)sender;


@end
