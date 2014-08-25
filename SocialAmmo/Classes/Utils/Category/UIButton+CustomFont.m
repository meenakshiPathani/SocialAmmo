//
//  UIButton+CustomFont.m
//  Social Ammo
//
//  Created by Meenakshi on 27/01/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "UIButton+CustomFont.h"

@implementation UIButton (CustomFont)

- (NSString *)fontName
{
    return self.titleLabel.font.fontName;
}

- (void)setFontName:(NSString *)fontName
{
    self.titleLabel.font = [UIFont fontWithName:fontName size:self.titleLabel.font.pointSize];
}

@end
