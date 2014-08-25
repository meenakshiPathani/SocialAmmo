//
//  UITextView+CustomFont.m
//  Social Ammo
//
//  Created by Meenakshi on 31/01/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "UITextView+CustomFont.h"

@implementation UITextView (CustomFont)

- (NSString *)fontName
{
    return self.font.fontName;
}

- (void)setFontName:(NSString *)fontName
{
    self.font = [UIFont fontWithName:fontName size:self.font.pointSize];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

- (BOOL)canBecomeFirstResponder
{
    return self.editable;
}

@end
