//
//  LayerTableViewCell.m
//  SocialAmmo
//
//  Created by Meenakshi on 23/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "LayerTableViewCell.h"

@implementation LayerTableViewCell

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

-(void) initaiteLayerCell:(LayerInfo*)info withTag:(NSUInteger)tag
{
	_nameLabel.text = [NSString stringWithFormat:@"Layer %d",(int)(tag +1)];
	
	self.deleteLayerButton.tag = tag;
	self.showLayerButton.tag = tag;
	self.hidenEyeButton.tag = tag;
	
	self.hidenEyeButton.hidden = info.showLayer;
	self.showLayerButton.hidden = !info.showLayer;
	
	_layerIconImageView.image = info.layerImage;
}

- (IBAction) showButtonPressed:(UIButton*)sender
{
	if([self.delegate respondsToSelector:@selector(handleShowButtonTap:)])
		[self.delegate handleShowButtonTap:sender];
	
	self.hidenEyeButton.hidden = NO;
	self.showLayerButton.hidden = YES;
}

- (IBAction) hidebuttonpresed:(UIButton*)sender
{
	if([self.delegate respondsToSelector:@selector(handleHideButtonTap:)])
		[self.delegate handleHideButtonTap:sender];
	
	self.hidenEyeButton.hidden = YES;
	self.showLayerButton.hidden = NO;

}


@end
