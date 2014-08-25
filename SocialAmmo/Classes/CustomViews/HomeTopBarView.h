//
//  UserTopBarView.h
//  Social Ammo
//
//  Created by Meenakshi on 27/01/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

@protocol HomeTopBarViewDelegate <NSObject>

- (void) topBarButtonSelected:(UIButton*)sender;

@end

@interface HomeTopBarView : UIView
{
	IBOutlet UIButton*	_homeButton;
	IBOutlet UIButton*	_beaconButton;
	IBOutlet UIButton*	_messageButton;
	IBOutlet UIImageView* _selectedBeaconbar;
	IBOutlet UIImageView* _selectedSubmisionBar;
	IBOutlet UIImageView* _selctedMessageBar;
	
	IBOutlet UIImageView* _submissionNotifyImageView;

}

@property (nonatomic, assign)id<HomeTopBarViewDelegate> delegate;

+ (HomeTopBarView*) topBarView;
- (void) prepareTopBarLayoutForUserType:(EUserType)userType andController:(UIViewController*)viewController;

- (void) showMessageNotifyIcon:(BOOL)show;
- (void) showSubmissionNotifyIcon:(BOOL)show;

- (void) showBeaconbarSelcted;
- (void) showSubmissionSeleccted;
- (void) showSelectedMessageBar;

@end
