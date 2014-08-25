//
//  UITextField+CustomFont.m
//  Social Ammo
//
//  Created by Meenakshi on 27/01/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "UITextField+CustomFont.h"

@implementation UITextField (CustomFont)

- (NSString *)fontName {
    return self.font.fontName;
}

- (void)setFontName:(NSString *)fontName {
    self.font = [UIFont fontWithName:fontName size:self.font.pointSize];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
