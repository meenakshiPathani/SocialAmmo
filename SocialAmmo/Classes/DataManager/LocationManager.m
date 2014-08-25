//
//  LocationManager.m
//  SocialAmmo
//
//  Created by Meenakshi on 04/07/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.
//

#import "LocationManager.h"


@implementation LocationManager

@synthesize delegate = _delegate;

#pragma mark -
#pragma mark ObjectLifeCycleMethod

- (id) init
{
	self = [super init];
	
	if(self != nil)
	{
		_locationManager = [[CLLocationManager alloc] init];
		
		_locationManager.delegate = self;
		_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		
		[_locationManager startUpdatingLocation];
	}
	
	return self;
}

- (void) startUpdatingLocation
{
	[_locationManager startUpdatingLocation];
}

- (void) startUpdatingHeading
{
	[_locationManager startUpdatingHeading];
}

- (void) stopUpdatingLocation
{
	[_locationManager stopUpdatingLocation];
}

- (void) stopUpdatingHeading
{
	[_locationManager stopUpdatingHeading];
}

- (void) dealloc
{
	
}

#pragma mark -
#pragma mark LocationManagerDelegateMethod

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	[_locationManager stopUpdatingLocation];
	
	if([self.delegate respondsToSelector:@selector(locationManger:didupdateNewLoaction:)])
		[self.delegate locationManger:self didupdateNewLoaction:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	if([self.delegate respondsToSelector:@selector(locationManger:didFailToUpdateWithError:)])
		[self.delegate locationManger:self didFailToUpdateWithError:error];
}

@end