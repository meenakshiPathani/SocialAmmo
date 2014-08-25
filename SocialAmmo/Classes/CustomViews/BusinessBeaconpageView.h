//
//  BusinessBeaconpageView.h
//  SocialAmmo
//
//  Created by Rupesh Kumar on 7/30/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "CreatorInfo.h"

@class  ContentInfo;

@protocol BusinessBeaconpageViewDelegate <NSObject>

- (void) handleInvitebuttonaction;
//- (void) handleLocationButtonAction;
- (void) handleHideButtonAction;
- (void) disbaleOuterscroll;
@end


@interface BusinessBeaconpageView : UIView
{
	IBOutlet AsyncImageView* _profileImageView;
	
	IBOutlet UILabel* _nameLabel;
	IBOutlet UILabel* _agelabel;
	IBOutlet UILabel* _viewrCountLabel;
	IBOutlet UILabel* _locationRadiusLabel;
	
	IBOutlet UIButton* _hideButton;
	IBOutlet UICollectionView* _collectionView;
	IBOutlet UIImageView* _seenImageView;
}

@property (nonatomic, assign) NSUInteger pageNumber;
@property (nonatomic, assign) id<BusinessBeaconpageViewDelegate> delgate;
@property (nonatomic, retain) NSArray* contentInfoList;

- (id) initWithPageNumber:(NSUInteger)pageNumber;
- (void) setDetails:(CreatorInfo*)obj;

- (void) cleanup;

- (IBAction) tapOnInviteButton:(id)sender;
- (IBAction) tapOnHideButton:(id)sender;

@end