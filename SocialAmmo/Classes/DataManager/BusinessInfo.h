//
//  BusinessInfo.h
//  Social Ammo
//
//  Created by Meenakshi on 03/02/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//


@interface BusinessInfo : NSObject

@property (nonatomic, assign)NSUInteger businessId;
@property (nonatomic, strong)NSString* businessName;
@property (nonatomic, strong)NSString* lowImageURL;
@property (nonatomic, strong)NSString* highImageURL;
@property (nonatomic, strong)NSString* iPhone5ImageURl;

- (id)initWithInfo:(NSDictionary*)dictionary;

@end
