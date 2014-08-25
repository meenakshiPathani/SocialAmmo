//
//  CustomFolderInfo.h
//  Social Ammo
//
//  Created by Rupesh Kumar on 6/11/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


@interface CustomFolderInfo : NSObject
{
	
}

@property (nonatomic, strong) NSString*		folderName;
@property (nonatomic, strong) UIColor*		folderColor;
@property (nonatomic, assign) NSString*		humanReadableColor;
@property (nonatomic, strong) NSArray*		folderContents;
@property (nonatomic, assign) BOOL			purchase;
@property (nonatomic, assign) NSUInteger	canavsId;

- (id)initWithInfo:(NSDictionary*)dictionary;

@end
