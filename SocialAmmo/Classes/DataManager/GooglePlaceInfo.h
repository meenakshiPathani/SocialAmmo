//
//  GooglePlaceInfo.h
//  SocialAmmo
//
//  Created by Meenakshi on 04/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GooglePlaceInfo : NSObject
{
	
}
@property (nonatomic, retain) NSString    *placesId;
@property (nonatomic, retain) NSString    *reference;
@property (nonatomic, retain) NSString    *name;
@property (nonatomic, retain) NSString    *icon;
@property (nonatomic, retain) NSString    *rating;
@property (nonatomic, retain) NSString    *vicinity;
@property (nonatomic, retain) NSArray     *type; //array
@property (nonatomic, retain) NSString    *url;
@property (nonatomic, retain) NSArray     *addressComponents; //array
@property (nonatomic, retain) NSString    *formattedAddress;
@property (nonatomic, retain) NSString    *formattedPhoneNumber;
@property (nonatomic, retain) NSString    *website;
@property (nonatomic, retain) NSString    *internationalPhoneNumber;
@property (nonatomic, retain) NSString      *searchTerms;
@property (nonatomic, assign) CLLocationCoordinate2D    coordinate;
//NEW
@property (nonatomic, retain) NSString    *distanceInFeetString;
@property (nonatomic, retain) NSString    *distanceInMilesString;

- (id)initWithJsonResultDict:(NSDictionary *)jsonResultDict andUserCoordinates:(CLLocationCoordinate2D)userCoords;
- (id)initWithJsonResultDict:(NSDictionary *)jsonResultDict searchTerms:(NSString *)terms andUserCoordinates:(CLLocationCoordinate2D)userCoords;

- (id)initWithName:(NSString *)name
          latitude:(double)lt
         longitude:(double)lg
         placeIcon:(NSString *)icn
            rating:(NSString *)rate
          vicinity:(NSString *)vic
              type:(NSString *)typ
         reference:(NSString *)ref
               url:(NSString *)www
 addressComponents:(NSString *)addComp
  formattedAddress:(NSArray *)fAddrss
formattedPhoneNumber:(NSString *)fPhone
           website:(NSString *)web
internationalPhone:(NSString *)intPhone
       searchTerms:(NSString *)search
    distanceInFeet:(NSString *)distanceFeet
   distanceInMiles:(NSString *)distanceMiles;

@end
