//
//  WIPViewController.h
//  SocialAmmo
//
//  Created by Meenakshi on 22/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

@protocol WIPViewControllerDelegate <NSObject>

- (void) selectedWipImageForEditing:(UIImage*)image;

@end


@interface WIPViewController : BaseViewController
{
	IBOutlet UICollectionView*	_collectionView;
	
	IBOutlet UIButton*	_saveCurrentCanvasButton;
}
@property(nonatomic, weak)id<WIPViewControllerDelegate> delegate;
@property(nonatomic, strong)UIImage* editedImage;

- (IBAction) saveCurrentCanvas:(id)sender;

@end
