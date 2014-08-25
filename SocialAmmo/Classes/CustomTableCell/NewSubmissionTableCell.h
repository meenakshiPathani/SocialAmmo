//
//  NewSubmissionTableCell.h
//  Social Ammo
//
//  Created by Meenakshi on 18/02/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


#import "ProfileView.h"
#import "BriefContentInfo.h"

@protocol NewSubmissionTableCellDelegate <NSObject>

- (void) handleAcceptAction:(BriefContentInfo*)obj;
- (void) handleDeclineAction:(BriefContentInfo*)obj;
- (void) showProfileForId:(NSUInteger)userId;
- (void) handleZoomIngwithImage:(NSString*)imageUrl withSender:(UIButton*)sender;

@end

@interface NewSubmissionTableCell : UITableViewCell <ProfileViewDelegate>
{
	IBOutlet UILabel*		_locationLabel;
	IBOutlet UILabel*		_viewerLabel;
	IBOutlet UILabel*		_usernameLabel;
	IBOutlet AsyncImageView*	_userPostImageview;
	IBOutlet ProfileView*		_userProfileView;
}

@property(nonatomic, weak)id <NewSubmissionTableCellDelegate> delegate;
@property(strong, nonatomic) BriefContentInfo* briefContentInfoObj;

- (void) setUpInitial:(BriefContentInfo*)briefContentInfo;

- (IBAction) acceptButtonAction:(id)sender;
- (IBAction) declineButtonAction:(id)sender;
- (IBAction) zoomBtnAction:(UIButton*)sender;

@end
