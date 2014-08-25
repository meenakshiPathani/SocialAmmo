//
//  LayerInfo.h
//  SocialAmmo
//
//  Created by Meenakshi on 23/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


@interface LayerInfo : NSObject
{
	
}
@property (nonatomic, strong)NSString* name;
@property (nonatomic, strong)UIImage* layerImage;
@property (nonatomic, assign) NSInteger layerTag;


@property (nonatomic, assign)BOOL showLayer;
@property (nonatomic, assign)ELayerType layerType;

- (id)initWithLayerIcon:(UIImage*)image;

@end
