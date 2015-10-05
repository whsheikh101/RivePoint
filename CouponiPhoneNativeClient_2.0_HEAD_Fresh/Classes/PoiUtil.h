//
//  PoiUtil.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 7/2/10.
//  Copyright 2010 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Poi.h"
@class PoiFinderNew;

@interface PoiUtil : NSObject {

}
+(UITableViewCell *) getAppropriateCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
							  poiFinder:(PoiFinderNew *)poiFinder poiArray:(NSArray*)poiArray 
								command:(NSString *)command	actualPOISInList:(int)actualPOISInList;

+(void)dialPhoneNumber:(Poi *)poi;



@end
