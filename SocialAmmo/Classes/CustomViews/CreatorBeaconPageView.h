//
//  CreatorBeaconView.h
//  SocialAmmo
//
//  Created by Rupesh Kumar on 8/20/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreatorBeaconPageViewDelegate <NSObject>

- (void) handlehideAction:(NSUInteger)businessID;
- (void) handleCreateAction:(BusinessOpenSubmissionInfo*)businessSubmisionInfo;
- (void) hadelSpecificbtnAction;

@end

@interface CreatorBeaconPageView : UIView
{
	IBOutlet UILabel*  _creaternameLbl;
	IBOutlet UILabel* _createrContentLbl;
	IBOutlet UIImageView* _seenImageView;
	IBOutlet UIImageView* _logoSpaceImageView;
	
	IBOutlet AsyncImageView* _profileImageView;
	
	IBOutlet UIButton* _specificBtn;
	IBOutlet UIButton* _hideButton;
	
	IBOutlet UILabel* _indicaterlabel;
	IBOutlet UILabel* _locationlabel;
	IBOutlet UILabel* _specificUnseenLabel;
}

@property (nonatomic, assign) NSUInteger pageNumber;
@property (nonatomic, assign) id <CreatorBeaconPageViewDelegate> delgate;
@property (nonatomic, retain) NSArray* businessInfoList;
@property (nonatomic, retain) BusinessOpenSubmissionInfo* businessSubInfo;

- (id) initWithPageNumber:(NSUInteger)pageNumber;
- (void) setOpenSubmissionDetails:(BusinessOpenSubmissionInfo*)obj;
- (void) cleanUp;

- (IBAction) hideBtnAction:(id)sender;
- (IBAction) createBtnAction:(id)sender;
- (IBAction) specificBtnAction:(id)sender;

@end
