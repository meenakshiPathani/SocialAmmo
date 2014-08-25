//
//  UIColor+HumanReadable.h
//  SocialAmmo
//
//  Created by Meenakshi on 20/06/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


@interface UIColor (HumanReadable)

+(NSString*) stringFromColor:(UIColor*)color;
+(UIColor*) colorFromString:(NSString*)string;

@end
