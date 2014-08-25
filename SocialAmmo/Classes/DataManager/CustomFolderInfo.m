//
//  CustomFolderInfo.m
//  Social Ammo
//
//  Created by Rupesh Kumar on 6/11/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "UIColor+HumanReadable.h"
#import "CustomFolderInfo.h"

@implementation CustomFolderInfo

- (id)initWithInfo:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
	{
		self.folderName = [dictionary objectForKey:@"Name"];
		self.folderContents = [dictionary objectForKey:@"Contents"];
		self.humanReadableColor = [dictionary objectForKey:@"Color"];
		self.folderColor = [UIColor colorFromString:self.humanReadableColor];
		self.purchase = [[dictionary objectForKey:@"Purchase"] boolValue];
		
		self.canavsId = [[dictionary objectForKey:@"CanvasId"] integerValue];
    }
    return self;
}


@end
