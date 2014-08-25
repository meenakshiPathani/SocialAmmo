//
//  DeclineTableCell.h
//  Social Ammo
//
//  Created by Rupesh Kumar on 3/25/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


#import "ProfileView.h"
#import "MessageInfo.h"

@protocol MessageNotificationTableCellDelegate <NSObject>

- (void) showProfileForId:(NSUInteger)userId;

@end

@interface MessageNotificationTableCell : UITableViewCell <ProfileViewDelegate>
{
	IBOutlet UILabel*		_notifiDescrLbl;
	IBOutlet UILabel*		_timelabel;
	IBOutlet UILabel*		_usernameLabel;
	IBOutlet UIImageView*		_notifiIconView;

	IBOutlet AsyncImageView*	_userPostImageview;
	IBOutlet ProfileView*		_userProfileView;
}

@property(nonatomic, weak)id <MessageNotificationTableCellDelegate> delegate;
@property (nonatomic, retain) MessageInfo* messgaeInfoObj;

- (void) setUpInitial:(MessageInfo*)messageInfo;


@end
