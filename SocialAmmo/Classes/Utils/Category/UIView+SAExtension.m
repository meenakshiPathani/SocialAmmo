//
//  UIView+SAExtension.m
//  Social Ammo
//
//  Created by Meenakshi on 04/02/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "UIView+SAExtension.h"

@implementation UIView (SAExtension)

- (UIResponder*)firstResponder
{
    UIResponder* result = [self isFirstResponder] ? self : nil;
    if (nil == result)
    {
        for (UIView *view in self.subviews)
        {
            result = [view firstResponder];
            if (nil != result)
            {
                break;
            }
        }
    }
    return result;
}

@end
