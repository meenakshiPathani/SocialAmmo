//
//  BusinessBeaconpageView.m
//  SocialAmmo
//
//  Created by Rupesh Kumar on 7/30/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "BusinessBeaconpageView.h"
#import "ContentInfo.h"

@implementation BusinessBeaconpageView

- (id) initWithPageNumber:(NSUInteger)pageNumber
{
	self = [[[NSBundle mainBundle] loadNibNamed:@"BusinessBeaconpageView"
										  owner:self options:nil] objectAtIndex:0];
    if (self)
	{
		self.pageNumber = pageNumber;
		
		[_collectionView registerClass:[UICollectionViewCell class]
			forCellWithReuseIdentifier:@"CellIdentifier"];
		[_collectionView flashScrollIndicators];
    }
    return self;
}

- (void) cleanup
{
	_profileImageView.image = nil;
	_contentInfoList = nil;
	[_collectionView reloadData];
}

- (void) setDetails:(CreatorInfo*)obj
{
	[_collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
	_profileImageView.image = nil;
	_profileImageView.imageUrl = obj.profilePicUrl;
	[_profileImageView becomeActive];
	
	_nameLabel.text = obj.name;
	_locationRadiusLabel.text = [NSString stringWithFormat:@"%.2f km",obj.distance];
	_viewrCountLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)obj.viewersCount];
	
	_agelabel.text = [NSString stringWithFormat:@"Age %lu",(unsigned long)obj.age];;
//	_hideButton.hidden = NO;
	//_seenImageView.hidden = !obj.isSeen;
	
	_contentInfoList = [NSArray arrayWithArray:obj.contentList];
	
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView
	 numberOfItemsInSection:(NSInteger)section
{
    return _contentInfoList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier"
																		   forIndexPath:indexPath];
    AsyncImageView* imageView = [[AsyncImageView alloc] init];
	ContentInfo* infoOBj = [_contentInfoList objectAtIndex:indexPath.section];
	cell.backgroundView = imageView;
	imageView.imageUrl = infoOBj.thumbnailUrl;
    [imageView becomeActive];
	
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if(_contentInfoList.count > 3)
		if ([self.delgate respondsToSelector:@selector(disbaleOuterscroll)])
		[self.delgate disbaleOuterscroll];
}

#pragma mark --
#pragma  mark -- Button Action

- (IBAction) tapOnInviteButton:(id)sender
{
	if ([self.delgate respondsToSelector:@selector(handleInvitebuttonaction)])
		[self.delgate handleInvitebuttonaction];
}

- (IBAction) tapOnHideButton:(id)sender
{
	if ([self.delgate respondsToSelector:@selector(handleHideButtonAction)])
		[self.delgate handleHideButtonAction];
}

@end
