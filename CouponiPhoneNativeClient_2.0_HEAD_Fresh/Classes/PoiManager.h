//
//  PoiManager.h
//  RivePoint
//
//  Created by Shahzad Mughal on 3/25/09.
//  Copyright 2009 kgflkfd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Poi.h"

@interface PoiManager : NSObject {

}

-(Poi*) findByPoiId: (int) pid;
-(NSMutableArray*) findAll;
-(NSMutableArray*) findAllPois;
-(NSMutableArray *) findAllLoyaltyPoi;
-(BOOL) save: (Poi*) poi;
-(BOOL) update: (Poi*) poi;
-(BOOL) saveOrUpdate: (Poi*) poi;
-(BOOL) deletePoi: (Poi*)poi;
-(BOOL) deletePoiById: (int)pid;
-(int) getCouponCount: (int) poiId;
-(BOOL) deletePois;
@end
