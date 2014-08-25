//
//  DeclineTableCell.m
//  Social Ammo
//
//  Created by Rupesh Kumar on 3/25/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "DeclineTableCell.h"

@implementation DeclineTableCell

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

- (IBAction) reapproveButtonAction:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(handleReApproveAction:)])
		[self.delegate handleReApproveAction:self.briefContentInfoObj];
}

- (IBAction) removeButtonAction:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(handleRemoveAction:)])
		[self.delegate handleRemoveAction:self.briefContentInfoObj];
}

- (IBAction) zoomBtnAction:(id)sender
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

@end
