//
//  LocationManager.h
//  SocialAmmo
//
//  Created by Meenakshi on 04/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@class LocationManager;

@protocol LocationManagerDelegate <NSObject>

- (void) locationManger:(LocationManager*)manager didupdateNewLoaction:(CLLocation *)location;
- (void) locationManger:(LocationManager*)manager didFailToUpdateWithError:(NSError *)error;


@end


@interface LocationManager : NSObject <CLLocationManagerDelegate>
{
	CLLocationManager*			_locationManager;
	CLLocation*					_lastAccuratePosition;
	
}

@property (nonatomic, weak) id<LocationManagerDelegate> delegate;

- (void) startUpdatingLocation;
- (void) startUpdatingHeading;
- (void) stopUpdatingLocation;
- (void) stopUpdatingHeading;


@end
