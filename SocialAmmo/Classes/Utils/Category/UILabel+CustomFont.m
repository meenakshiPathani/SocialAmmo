//
//  UILabel+CustomFont.m
//  Social Ammo
//
//  Created by Meenakshi on 24/01/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "UILabel+CustomFont.h"

@implementation UILabel (CustomFont)

- (NSString *)fontName {
    return self.font.fontName;
}

- (void)setFontName:(NSString *)fontName {
    self.font = [UIFont fontWithName:fontName size:self.font.pointSize];
}

@end
