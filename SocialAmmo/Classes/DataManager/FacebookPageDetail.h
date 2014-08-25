//
//  FacebookPageDetail.h
//  Social Ammo
//
//  Created by Rupesh Kumar on 5/21/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookPageDetail : NSObject
{
	
}

@property (nonatomic, strong) NSString*		pageAccesToken;
@property (nonatomic, strong) NSString*		category;
@property (nonatomic, strong) NSString*		pageID;
@property (nonatomic, strong) NSString*		pageName;

- (id)initWithInfo:(NSDictionary*)dictionary;

@end
