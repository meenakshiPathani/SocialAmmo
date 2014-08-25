//
//  LayerInfo.m
//  SocialAmmo
//
//  Created by Meenakshi on 23/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "LayerInfo.h"

@implementation LayerInfo

- (id)initWithLayerIcon:(UIImage*)image
{
    self = [super init];
    if (self)
	{
		self.layerImage = image;
		self.showLayer = YES;
    }
    return self;
}

@end
