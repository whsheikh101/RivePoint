//
//  MapPoint.m
//  mapKitViewController
//
//  Created by Danish Ghauri on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapPoint.h"

@implementation MapPoint

@synthesize coordinate,title,subtitle;

-(id) initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString *) t subtitle:(NSString *) st with:(int)poid{
 
    if (self==[super init]) {
        coordinate=c;
        self.title=t;
        self.subtitle=st;
        self.poiIndex = poid;
    }
    return self;

}
@end
