//
//  GooglePlaceTableViewCell.h
//  SocialAmmo
//
//  Created by Meenakshi on 04/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "GooglePlaceInfo.h"
#import "AsyncImageView.h"

@interface PlaceTableViewCell : UITableViewCell
{
	IBOutlet UILabel*	_titleLabel;
	IBOutlet UILabel*	_detailLabel;
	
	IBOutlet AsyncImageView*		_placeImageView;
}
- (void) initiateCellWithPlaceInfo:(GooglePlaceInfo*)info;

@end
