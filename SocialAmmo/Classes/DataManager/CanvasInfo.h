//
//  CanvasInfo.h
//  Social Ammo
//
//  Created by Meenakshi on 11/06/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


@interface CanvasInfo : NSObject
{
	
}
@property (nonatomic, assign) NSUInteger canvasId;
@property (nonatomic, strong) NSString*	canvasName;
@property (nonatomic, strong) NSString*	canvasImageUrl;
@property (nonatomic, strong) NSArray*	packArray;

- (id)initWithInfo:(NSDictionary*)dictionary;
- (void) parsePacks:(NSString*)packs;

@end
