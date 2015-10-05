//
//  VersionManager.h
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 6/10/10.
//  Copyright 2010 Netpace Systems Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VersionManager : NSObject {
	
}
-(BOOL)isTableExist;
-(NSString *) getVersion;
-(BOOL) insert: (NSString*) version;
-(BOOL) update: (NSString*) version;
@end
