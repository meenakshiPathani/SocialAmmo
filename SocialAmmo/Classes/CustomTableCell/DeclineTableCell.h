//
//  DeclineTableCell.h
//  Social Ammo
//
//  Created by Rupesh Kumar on 3/25/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "ProfileView.h"
#import "BriefContentInfo.h"

@protocol DeclineTableCellDelegate <NSObject>

- (void) handleReApproveAction:(BriefContentInfo*)obj;
- (void) handleRemoveAction:(BriefContentInfo*)obj;
- (void) showProfileForId:(NSUInteger)userId;
- (void) handleZoomIngwithImage:(NSString*)imageUrl withSender:(UIButton*)sender;
@end

@interface DeclineTableCell : UITableViewCell <ProfileViewDelegate>
{
	IBOutlet UILabel*		_locationLabel;
	IBOutlet UILabel*		_viewerLabel;
	IBOutlet UILabel*		_usernameLabel;
	
	IBOutlet AsyncImageView*	_userPostImageview;
	IBOutlet ProfileView*	_userProfileView;
}

@property(nonatomic, weak)id <DeclineTableCellDelegate> delegate;
@property(strong, nonatomic) BriefContentInfo* briefContentInfoObj;

- (void) setUpInitial:(BriefContentInfo*)briefContentInfo;

- (IBAction) reapproveButtonAction:(id)sender;
- (IBAction) removeButtonAction:(id)sender;
- (IBAction) zoomBtnAction:(id)sender;

@end
