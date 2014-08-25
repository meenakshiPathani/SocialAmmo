//
//  AcceptBreifCell.m
//  Social Ammo
//
//  Created by Rupesh Kumar on 3/21/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "AcceptBreifCell.h"
#import <Social/Social.h>

@implementation AcceptBreifCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
	{
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

#pragma mark -- Private Methods

- (BOOL) checkImageExistwithTitle:(NSString*)title
{
	NSString* directory = [_gDataManager getBriefDirectory];
	NSArray* fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil];
	for (NSString* fileName in fileList)
	{
		if ([title compare:fileName] == NSOrderedSame)
			return YES;
	}
	return NO;
}

- (void) saveImageInApplicationDirectory:(NSString*)prefix
{
	NSString* directory = [_gDataManager getBriefDirectory];
	
	NSString* filepath = [NSString stringWithFormat:@"%@%@",directory,prefix];
	DLog(@"%@", filepath);
	UIImage* image  = _userPostImageview.image;
	
	if (image != nil)
	{
		NSData* imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
		[UIUtils saveImageWithData:imageData forFilePath:filepath];
	}
	else
		[UIUtils messageAlert:kWaitSaveMessage title:@"" delegate:nil];
}

#pragma mark -- Button action

- (IBAction) saveToPhoneBtnAction:(id)sender
{
	UIImageWriteToSavedPhotosAlbum(_userPostImageview.image, nil, nil, nil);
	[UIUtils messageAlert:@"Image saved to camera roll." title:nil delegate:nil];
}

- (IBAction) bufferBtnAction:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(handleBufferAction)])
		[self.delegate handleBufferAction];
}

- (IBAction) zoomBtnAction:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(handleZoomIngwithImage: withSender:)])
		[self.delegate handleZoomIngwithImage:self.briefContentInfoObj.fullImageUrl withSender:sender];
}

- (IBAction) commentBtnAction:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(showMessageforUserWithContentInfo:)])
		[self.delegate showMessageforUserWithContentInfo:self.briefContentInfoObj];
}

- (IBAction) shareButtonAction:(UIButton*)sender
{
	if ([self.delegate respondsToSelector:@selector(handleShareAction: withBriefContentInfo:
													andImage:)])
		[self.delegate handleShareAction:sender.tag withBriefContentInfo:self.briefContentInfoObj
								andImage:_userPostImageview.image];
}

#pragma mark -- profile view Delegate

- (void) showProfile
{
	if ([self.delegate respondsToSelector:@selector(showProfileForId:)])
		[self.delegate showProfileForId:self.briefContentInfoObj.userId];
}


@end
