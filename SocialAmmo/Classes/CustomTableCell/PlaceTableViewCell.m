//
//  GooglePlaceTableViewCell.m
//  SocialAmmo
//
//  Created by Meenakshi on 04/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "PlaceTableViewCell.h"

@implementation PlaceTableViewCell

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

#pragma mark-

- (void) initiateCellWithPlaceInfo:(GooglePlaceInfo*)info
{
	_titleLabel.text = info.name;
	_detailLabel.text = (info.vicinity.length > 0) ? info.vicinity : info.formattedAddress;
//	_detailLabel.text = info.formattedAddress;
	
	_placeImageView.layer.borderColor = [UIColor blackColor].CGColor;
	_placeImageView.layer.borderWidth = 2.0;
	_placeImageView.layer.cornerRadius = 15.0;
	_placeImageView.clipsToBounds = YES;
	
	_placeImageView.image = nil;
	_placeImageView.imageUrl = info.icon;
	[_placeImageView becomeActive];
}

@end
