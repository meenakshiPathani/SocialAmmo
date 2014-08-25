//
//  WIPCollectionCell.h
//  SocialAmmo
//
//  Created by Meenakshi on 23/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


@interface WIPCollectionCell : UICollectionViewCell
{
	BOOL _isWiggling;
}

@property(nonatomic, strong)IBOutlet UIImageView* cellImageView;

- (void) startWigglingForCell:(id)target action:(SEL)selector;
- (void) stopWigglingForCell;

@end
