//
//  LocationUtil.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 6/14/10.
//  Copyright 2010 Netpace Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationUpdater.h"

@class CLLocation;
@class CLLocationManager;
@interface LocationUtil : NSObject {

}
+(void) handleLocationErrors:(NSObject *) refDelegate error:(NSError *)error locationManager:(CLLocationManager *)locationManager;
+(void) gpsOn:(CLLocationManager *)locationManager refDelegate:(LocationUpdater *) refDelegate;
+(void) gpsOff:(CLLocationManager *)locationManager;
+(void) updateGpsAccuracy:(CLLocationManager *)locationManager;
+(void) updateLocation:(CLLocation *)newLocation locationManager:(CLLocationManager *)locationManager;
@end
