//
//  UIColor+HumanReadable.m
//  SocialAmmo
//
//  Created by Meenakshi on 20/06/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "UIColor+HumanReadable.h"

@implementation UIColor (HumanReadable)

+(NSString*) stringFromColor:(UIColor*)color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    return [NSString stringWithFormat:@"[%f, %f, %f, %f]",
            components[0],
            components[1],
            components[2],
            components[3]];
}

+(UIColor*) colorFromString:(NSString*)string
{
	if ([string length] == 0)
		return [UIColor clearColor];
		
    NSString *componentsString = [[string stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
    NSArray *components = [componentsString componentsSeparatedByString:@", "];
    return [UIColor colorWithRed:[(NSString*)components[0] floatValue]
                           green:[(NSString*)components[1] floatValue]
                            blue:[(NSString*)components[2] floatValue]
                           alpha:[(NSString*)components[3] floatValue]];
}

@end
