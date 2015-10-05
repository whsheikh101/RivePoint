//
//  CustomAnotation.h
//  RivePoint
//
//  Created by Ahmer Mustafa on 10/25/10.
//  Copyright 2010 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate; 
	NSString *title;
	NSString *subtitle;
	int poiIndex;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property int poiIndex;

- (id) initWithCoordiantes:(float)latitude longitude:(float)longitude 
					 title:(NSString *)pTitle subtitle:(NSString *)pSubtitle;

@end
