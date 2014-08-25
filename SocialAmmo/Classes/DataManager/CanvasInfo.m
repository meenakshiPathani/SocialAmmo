
//
//  CanvasInfo.m
//  Social Ammo
//
//  Created by Meenakshi on 11/06/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "CanvasInfo.h"

@implementation CanvasInfo

- (id)initWithInfo:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
	{
		self.canvasId = [[dictionary objectForKey:@"id"] integerValue];
		self.canvasName = [dictionary objectForKey:@"title"];
		
		self.canvasImageUrl = [dictionary objectForKey:@"image"];
		
		NSString* pack = [dictionary objectForKey:@"packs"];
		[self parsePacks:pack];
		
    }
    return self;
}

- (void) parsePacks:(NSString*)packs
{
	if ([packs isKindOfClass:[NSString class]])
	{
		packs = [packs stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if ([packs length] > 0)
			self.packArray = [packs componentsSeparatedByString:@","];
	}
}

@end
