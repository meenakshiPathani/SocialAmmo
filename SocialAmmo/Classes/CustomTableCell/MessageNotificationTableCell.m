//
//  DeclineTableCell.m
//  Social Ammo
//
//  Created by Rupesh Kumar on 3/25/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "NSDate+DateConversions.h"

#import "MessageNotificationTableCell.h"

@implementation MessageNotificationTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setUpInitial:(MessageInfo*)messageInfo
{
	self.messgaeInfoObj = messageInfo;
		
	// set profile picture
	_userProfileView.delegate = self;
	_userProfileView.layer.cornerRadius = 16;
	[_userProfileView setProfileUrl:messageInfo.profilePicURl];

	// Set user post image
	_userPostImageview.image = nil;
	_userPostImageview.imageUrl = messageInfo.contentUrl;
	[_userPostImageview becomeActive];
	
	_notifiIconView.hidden = [messageInfo.messageRead boolValue];
	
	_usernameLabel.text = messageInfo.userName;
	_notifiDescrLbl.text = messageInfo.messageStr;
	_notifiDescrLbl.numberOfLines = 2;

	_notifiDescrLbl.minimumScaleFactor = 8.0;
	_notifiDescrLbl.adjustsFontSizeToFitWidth = YES;
	
	// add time lable according to message
	CGRect rect = _timelabel.frame;
	rect.origin.y = _notifiDescrLbl.frame.origin.y+_notifiDescrLbl.frame.size.height;
	_timelabel.frame = rect;
	
	_timelabel.text = [NSDate getDateString:messageInfo.dateAndTime forTimeInterval:messageInfo.timeInterval];
}

#pragma mark -- profile view Dlegate

- (void) showProfile
{
	
}

@end
