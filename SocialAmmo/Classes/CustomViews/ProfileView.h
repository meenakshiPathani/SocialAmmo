//
//  ProfileView.h
//  Social Ammo
//
//  Created by Meenakshi on 18/02/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "AsyncImageView.h"

@protocol ProfileViewDelegate <NSObject>

- (void) showProfile;

@end

@interface ProfileView : UIView
{
	IBOutlet UIButton* _profileButton;
	IBOutlet AsyncImageView* _profileImageView;
}

@property(nonatomic, weak)id<ProfileViewDelegate> delegate;

-(IBAction) profileButtonPressed:(id)sender;

- (void) setProfileUrl:(NSString*)profileUrl;
- (void) setProfileBtnTitle:(NSString*)title;

@end
