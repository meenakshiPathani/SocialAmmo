//
//  NewSubmissionTableCell.m
//  Social Ammo
//
//  Created by Meenakshi on 18/02/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "NewSubmissionTableCell.h"

#define kAcceptAlerttag 100
#define kDeclineAlertTag  101

@implementation NewSubmissionTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) setUpInitial:(BriefContentInfo*)briefContentInfo
{
	self.briefContentInfoObj = briefContentInfo;
	
	_userProfileView.delegate = self;
	_userProfileView.layer.cornerRadius = 16;
	
	[_userProfileView setProfileUrl:briefContentInfo.profilePicUrl];

	_userPostImageview.image = nil;
	_userPostImageview.imageUrl = briefContentInfo.fullImageUrl;
	[_userPostImageview becomeActive];
	
	_locationLabel.text = briefContentInfo.countryName;
	_viewerLabel.text = @"0";
	_usernameLabel.text = briefContentInfo.userName;
}


#pragma mark -- Button action

- (IBAction) acceptButtonAction:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(handleAcceptAction:)])
		[self.delegate handleAcceptAction:self.briefContentInfoObj];
	
//	[UIUtils messageAlert:@"Accept for 20 Ammo coins?" title:@"" delegate:self withCancelTitle:@"Cancel"
//										otherButtonTitle :@"Ok" tag:kAcceptAlerttag];
}

- (IBAction) declineButtonAction:(id)sender
{
	[UIUtils messageAlert:@"You want to decline?" title:@"" delegate:self withCancelTitle:@"Cancel"
										otherButtonTitle :@"Ok" tag:kDeclineAlertTag];
}

- (IBAction) zoomBtnAction:(UIButton*)sender
{
	if ([self.delegate respondsToSelector:@selector(handleZoomIngwithImage: withSender:)])
		[self.delegate handleZoomIngwithImage:self.briefContentInfoObj.fullImageUrl withSender:sender];
}


#pragma mark -- profile view Dlegate

- (void) showProfile
{
	if ([self.delegate respondsToSelector:@selector(showProfileForId:)])
		[self.delegate showProfileForId:self.briefContentInfoObj.userId];
}

#pragma mark --
#pragma mark -- Alertview index

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (alertView.tag)
	{
		case kAcceptAlerttag:
		{
			if (buttonIndex == 1)
			{
				if ([self.delegate respondsToSelector:@selector(handleAcceptAction:)])
					[self.delegate handleAcceptAction:self.briefContentInfoObj];
			}
		}
			break;
			
		case kDeclineAlertTag:
		{
			if (buttonIndex == 1)
			{
				if ([self.delegate respondsToSelector:@selector(handleDeclineAction:)])
					[self.delegate handleDeclineAction:self.briefContentInfoObj];
			}
		}
			break;
			
		default:
			break;
	}
}

@end
