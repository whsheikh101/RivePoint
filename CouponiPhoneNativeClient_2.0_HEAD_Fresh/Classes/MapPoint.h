//
//  MapPoint.h
//  mapKitViewController
//
//  Created by Danish Ghauri on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface MapPoint : NSObject<MKAnnotation> {

    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D coordinate;
    	     
}
	 
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property int poiIndex;
	 
-(id) initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString *) t subtitle:(NSString *) st with:(int)poid;

@end
