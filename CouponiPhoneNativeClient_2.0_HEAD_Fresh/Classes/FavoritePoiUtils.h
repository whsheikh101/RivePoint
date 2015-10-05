//
//  FavoritePoiUtils.h
//  RivePoint
//
//  Created by Ahmer Mustafa on 9/27/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Poi.h"

@interface FavoritePoiUtils : NSObject
{
    
}

+(BOOL) addToUserFavPoi:(Poi *) poi;
+(NSMutableArray *) fetchAllUserFavPois;
+(Poi *) fetchPoiWithId:(int)poiId;
+(BOOL) deletePoiWithId:(int)poiId;
+(BOOL) isAlreadyExitPoiWithName:(NSString *)name;


@end
