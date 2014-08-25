//
//  PackInfo.h
//  SocialAmmo
//
//  Created by Meenakshi on 23/06/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


@interface PackInfo : NSObject

{
	
}
@property (nonatomic, assign) NSUInteger		packId;
@property (nonatomic, assign) NSUInteger		coin;
@property (nonatomic, assign) NSUInteger		cost;

@property (nonatomic, assign) EPackType		packType;

@property (nonatomic, strong) NSString*		brandName;
@property (nonatomic, strong) NSString*		packName;
@property (nonatomic, strong) NSString*		packContentUrl;
@property (nonatomic, strong) NSString*		packIconUrl;

@property (nonatomic, assign) BOOL			purchase;
@property (nonatomic, assign) BOOL			free;

- (id)initWithInfo:(NSDictionary*)dictionary;
@end
