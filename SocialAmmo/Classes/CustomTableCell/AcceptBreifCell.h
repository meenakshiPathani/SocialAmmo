//
//  AcceptBreifCell.h
//  Social Ammo
//
//  Created by Rupesh Kumar on 3/21/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileView.h"
#import "BriefContentInfo.h"

@protocol AcceptBreifCellDelegate <NSObject>

- (void) handleBufferAction;
- (void) handleShareAction:(NSInteger)tagValue withBriefContentInfo:(BriefContentInfo*)briefContentInfo
				  andImage:(UIImage*)sharedImage;
- (void) showProfileForId:(NSUInteger)userId;
- (void) handleZoomIngwithImage:(NSString*)imageUrl withSender:(UIButton*)sender;
- (void) showMessageforUserWithContentInfo:(BriefContentInfo*)contentInfo;


@end

@interface AcceptBreifCell : UITableViewCell<ProfileViewDelegate>
{
	IBOutlet UILabel*		_locationLabel;
	IBOutlet UILabel*		_viewerLabel;
	IBOutlet UILabel*		_usernameLabel;
	
	IBOutlet AsyncImageView*	_userPostImageview;
	IBOutlet ProfileView*	_userProfileView;
}

@property(nonatomic, weak)id <AcceptBreifCellDelegate> delegate;
@property(strong, nonatomic) BriefContentInfo* briefContentInfoObj;

- (void) setUpInitial:(BriefContentInfo*)briefContentInfo;

- (IBAction) saveToPhoneBtnAction:(id)sender;
- (IBAction) bufferBtnAction:(id)sender;
- (IBAction) zoomBtnAction:(id)sender;
- (IBAction) commentBtnAction:(id)sender;
- (IBAction) shareButtonAction:(UIButton*)sender;

@end
