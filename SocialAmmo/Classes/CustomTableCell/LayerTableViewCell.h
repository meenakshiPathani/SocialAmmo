//
//  LayerTableViewCell.h
//  SocialAmmo
//
//  Created by Meenakshi on 23/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "LayerInfo.h"

@protocol LayerTableViewCellDelegate <NSObject>

- (void) handleShowButtonTap:(UIButton*)sender;
- (void) handleHideButtonTap:(UIButton*)sender;

@end

@interface LayerTableViewCell : UITableViewCell
{
	IBOutlet UILabel*		_nameLabel;
	IBOutlet UIImageView*	_layerIconImageView;
}

@property (nonatomic, weak)id<LayerTableViewCellDelegate> delegate;

@property(nonatomic, strong)IBOutlet UIButton* deleteLayerButton;
@property(nonatomic, strong)IBOutlet UIButton* showLayerButton;
@property(nonatomic, strong)IBOutlet UIButton* hidenEyeButton;


-(void) initaiteLayerCell:(LayerInfo*)info withTag:(NSUInteger)tag;


- (IBAction) showButtonPressed:(UIButton*)sender;
- (IBAction) hidebuttonpresed:(UIButton*)sender;

@end
