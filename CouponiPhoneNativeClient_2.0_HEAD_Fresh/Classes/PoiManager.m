//
//  PoiManager.m
//  RivePoint
//
//  Created by Shahzad Mughal on 3/25/09.
//  Copyright 2009 kgflkfd. All rights reserved.
//

#import "PoiManager.h"
#import "DBManager.h"
#import "Poi.h"
#import "RivePointAppDelegate.h"

@implementation PoiManager

-(BOOL) save: (Poi*) poi{
	BOOL saved = NO ;
	DBManager *dbm = [[DBManager alloc]init];
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "insert into poi (poiId,poiSequenceNumber,poiCategoryId,name,phoneNumber,completeAddress,distance,couponCount,imageName,isSponsored,poiLogo,bigLogo,userPoints) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	sqlite3_stmt *compiledStatement;
	
	
	
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	else{
		
		sqlite3_bind_text(compiledStatement, 1, [poi.poiId UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 2, [poi.poiSequenceNumber UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 3, [poi.poiCategoryId UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 4, [poi.name UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 5, [poi.phoneNumber UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 6, [poi.completeAddress UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 7, [poi.distance UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 8, [poi.couponCount UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 9, [poi.imageName UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 10, [poi.isSponsored UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 11, [poi.imageBytes UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 13, [poi.userPoints UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(compiledStatement, 14, poi.reviewCount);
        sqlite3_bind_int(compiledStatement, 15, poi.feedbackCount);
		
//		if(poi.bigLogo){
//			
//			//UIImage  *uiImage  = [UIImage imageWithData:poi.bigLogo];
//			//NSData *data = UIImagePNGRepresentation(uiImage);
//			sqlite3_bind_blob(compiledStatement, 12, [poi.bigLogo bytes], [poi.bigLogo length], NULL);
//		}
//		else
//			sqlite3_bind_blob(compiledStatement, 12, nil, -1, NULL);
		
		int success = sqlite3_step(compiledStatement);
		if (success == SQLITE_ERROR) {
			NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
		} else {
			poi.pk = sqlite3_last_insert_rowid(database);
			NSLog(@"new record pk = %d" ,poi.pk);
			saved = YES;
		}
	}	
	
	sqlite3_finalize(compiledStatement);
	
	[dbm closeDatabase:database];
	[dbm release];
	
	
	return saved;
	
}

-(NSMutableArray*) findAll{
	DBManager *dbm = [[DBManager alloc]init];
	NSMutableArray *pois = [[NSMutableArray alloc]init];
	Poi *p = nil;
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "select * from poi";
	sqlite3_stmt *compiledStatement;
	
	
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read the data from the result row
			NSLog(@"Fetching columns") ;
			
			
			char *str =  nil;
			
			int pk = sqlite3_column_int(compiledStatement, 0);
			
			str = (char *)sqlite3_column_text(compiledStatement, 1);
			NSString *poiId = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 2);
			NSString *poiSequenceNumber = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 3);
			NSString *poiCategoryId = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 4);
			NSString *name = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 5);
			NSString *phoneNumber = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 6);
			NSString *completeAddress = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 7);
			NSString *distance = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 8);
			NSString *couponCount = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 9);
			NSString *imageName = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 10);
			NSString *isSponsored = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
					
			str = (char *)sqlite3_column_text(compiledStatement, 11);
			NSString *poiLogo = (str) ? [NSString stringWithUTF8String:str] : nil;
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 13);
			NSString *userPoints = (str) ? [NSString stringWithUTF8String:str] : nil;
			str = nil ;
            
            int _rCount = sqlite3_column_int(compiledStatement, 14);
            int _cCount = sqlite3_column_int(compiledStatement, 15);
			// Fill Setting object with the data from the database
			p = [[Poi alloc] init];
			
			NSLog(@"Filling Poi bean") ;
			p.pk = pk;
			p.poiId = poiId ;
			p.poiSequenceNumber = poiSequenceNumber;
			p.poiCategoryId = poiCategoryId;
			p.name = name;
			p.phoneNumber = phoneNumber;
			p.completeAddress = completeAddress;
			p.distance =distance;
			p.couponCount = couponCount;
			p.imageName = imageName;
			p.isSponsored = isSponsored ;
            p.userPoints = userPoints;
            p.reviewCount = _rCount;
            p.feedbackCount = _cCount;
		
			p.couponCount = [NSString stringWithFormat:@"%d", [self getCouponCount:[p.poiId intValue]]];
			if(poiLogo)
				p.imageBytes = poiLogo;
			/*if(bigLogoData)
				p.bigLogo = bigLogoData;*/
//			
//			 NSLog(@"pk = %d" ,p.pk);
//			 NSLog(@"poiId = %@" ,p.poiId);
//			 NSLog(@"poiSequenceNumber = %@" ,p.poiSequenceNumber);
//			 NSLog(@"poiCategoryId = %@" ,p.poiCategoryId);
//			 NSLog(@"name = %@" ,p.name);
//			 NSLog(@"phoneNumber = %@" ,p.phoneNumber);
//			 NSLog(@"completeAddress = %@" ,p.completeAddress);
//			 NSLog(@"distance = %@" ,p.distance);
//			 NSLog(@"couponCount = %@" ,p.couponCount);
//			 NSLog(@"imageName = %@" ,p.imageName);
//			 NSLog(@"isSponsored = %@" ,p.isSponsored);
//			 NSLog(@"logoImageBytes = %@" ,p.imageBytes);
//             NSLog(@"Review Count = %d" ,p.reviewCount);
//             NSLog(@"Cummulative Count = %d" ,p.feedbackCount);
			/*if(p.bigLogo)
				NSLog(@"bigLogoImageBytes = %d" ,[p.bigLogo length]);
			else
				NSLog(@"bigLogoImageBytes = nil");*/

			 
			[pois addObject:p];
			[p release];
		
		}
		
		sqlite3_finalize(compiledStatement);
	}
	else{
		NSLog(@"Some problem in compiling statement") ;
	}
	[dbm closeDatabase:database];
	[dbm release];
	
	return pois;
	
}

-(NSMutableArray*) findAllPois{
	DBManager *dbm = [[DBManager alloc]init];
	NSMutableArray *pois = [[NSMutableArray alloc]init];
	Poi *p = nil;
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "select p.*,count(c.couponId) from poi p inner join poi_coupon pc on  p.poiId = pc.poiId inner join coupon c on c.couponId=pc.couponId where pc.couponid = c.couponid and (c.earningPoints is null AND c.reqdPoints is null) group by p.poiId";
	sqlite3_stmt *compiledStatement;
	
	
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read the data from the result row
			NSLog(@"Fetching columns") ;
			
			
			char *str =  nil;
			
			int pk = sqlite3_column_int(compiledStatement, 0);
			
			str = (char *)sqlite3_column_text(compiledStatement, 1);
			NSString *poiId = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 2);
			NSString *poiSequenceNumber = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 3);
			NSString *poiCategoryId = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 4);
			NSString *name = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 5);
			NSString *phoneNumber = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 6);
			NSString *completeAddress = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 7);
			NSString *distance = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 8);
			NSString *couponCount = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 9);
			NSString *imageName = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 10);
			NSString *isSponsored = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
            
			str = (char *)sqlite3_column_text(compiledStatement, 11);
			NSString *poiLogo = (str) ? [NSString stringWithUTF8String:str] : nil;
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 13);
			NSString *userPoints = (str) ? [NSString stringWithUTF8String:str] : nil;
			str = nil ;
            
//            str = (char *)sqlite3_column_text(compiledStatement, 14);
//			couponCount = (str) ? [NSString stringWithUTF8String:str] : @"";
//			str = nil ;
            
            int _rCount = sqlite3_column_int(compiledStatement, 14);
            int _cCount = sqlite3_column_int(compiledStatement, 15);
            
			// Fill Setting object with the data from the database
			p = [[Poi alloc] init];
			
			NSLog(@"Filling Poi bean") ;
			p.pk = pk;
			p.poiId = poiId ;
			p.poiSequenceNumber = poiSequenceNumber;
			p.poiCategoryId = poiCategoryId;
			p.name = name;
			p.phoneNumber = phoneNumber;
			p.completeAddress = completeAddress;
			p.distance =distance;
			p.couponCount = couponCount;
			p.imageName = imageName;
			p.isSponsored = isSponsored ;
            p.userPoints = userPoints;
            p.reviewCount = _rCount;
            p.feedbackCount = _cCount;
            
			//p.couponCount = [NSString stringWithFormat:@"%d", [self getCouponCount:[p.poiId intValue]]];
			if(poiLogo)
				p.imageBytes = poiLogo;
			/*if(bigLogoData)
             p.bigLogo = bigLogoData;*/
			
//            NSLog(@"pk = %d" ,p.pk);
//            NSLog(@"poiId = %@" ,p.poiId);
//            NSLog(@"poiSequenceNumber = %@" ,p.poiSequenceNumber);
//            NSLog(@"poiCategoryId = %@" ,p.poiCategoryId);
//            NSLog(@"name = %@" ,p.name);
//            NSLog(@"phoneNumber = %@" ,p.phoneNumber);
//            NSLog(@"completeAddress = %@" ,p.completeAddress);
//            NSLog(@"distance = %@" ,p.distance);
//            NSLog(@"couponCount = %@" ,p.couponCount);
//            NSLog(@"imageName = %@" ,p.imageName);
//            NSLog(@"isSponsored = %@" ,p.isSponsored);
//            NSLog(@"logoImageBytes = %@" ,p.imageBytes);
//            NSLog(@"Review Count = %d" ,p.reviewCount);
//            NSLog(@"Cummulative Count = %d" ,p.feedbackCount);
			/*if(p.bigLogo)
             NSLog(@"bigLogoImageBytes = %d" ,[p.bigLogo length]);
             else
             NSLog(@"bigLogoImageBytes = nil");*/
            
            
			[pois addObject:p];
			[p release];
            
		}
		
		sqlite3_finalize(compiledStatement);
	}
	else{
		NSLog(@"Some problem in compiling statement") ;
	}
	[dbm closeDatabase:database];
	[dbm release];
	
	return pois;
	
}

-(NSMutableArray*) findAllLoyaltyPoi{
	DBManager *dbm = [[DBManager alloc]init];
	NSMutableArray *pois = [[NSMutableArray alloc]init];
	Poi *p = nil;
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "select p.*,count(c.couponId) from poi p inner join poi_coupon pc on  p.poiId = pc.poiId inner join coupon c on c.couponId=pc.couponId where pc.couponid = c.couponid and (c.earningPoints not null OR c.reqdPoints not null) group by p.poiId";
	sqlite3_stmt *compiledStatement;
	
	
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read the data from the result row
			NSLog(@"Fetching columns") ;
			
			
			char *str =  nil;
			
			int pk = sqlite3_column_int(compiledStatement, 0);
			
			str = (char *)sqlite3_column_text(compiledStatement, 1);
			NSString *poiId = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 2);
			NSString *poiSequenceNumber = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 3);
			NSString *poiCategoryId = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 4);
			NSString *name = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 5);
			NSString *phoneNumber = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 6);
			NSString *completeAddress = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 7);
			NSString *distance = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 8);
			NSString *couponCount = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 9);
			NSString *imageName = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 10);
			NSString *isSponsored = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
            
			str = (char *)sqlite3_column_text(compiledStatement, 11);
			NSString *poiLogo = (str) ? [NSString stringWithUTF8String:str] : nil;
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 13);
			NSString *userPoints = (str) ? [NSString stringWithUTF8String:str] : nil;
			str = nil ;
            
//            str = (char *)sqlite3_column_text(compiledStatement, 14);
//			couponCount = (str) ? [NSString stringWithUTF8String:str] : @"";
//			str = nil ;
            
            int _rCount = sqlite3_column_int(compiledStatement, 14);
            int _cCount = sqlite3_column_int(compiledStatement, 15);
            
			// Fill Setting object with the data from the database
			p = [[Poi alloc] init];
			
			NSLog(@"Filling Poi bean") ;
			p.pk = pk;
			p.poiId = poiId ;
			p.poiSequenceNumber = poiSequenceNumber;
			p.poiCategoryId = poiCategoryId;
			p.name = name;
			p.phoneNumber = phoneNumber;
			p.completeAddress = completeAddress;
			p.distance =distance;
			p.couponCount = couponCount;
			p.imageName = imageName;
			p.isSponsored = isSponsored ;
            p.userPoints = userPoints;
            p.reviewCount = _rCount;
            p.feedbackCount = _cCount;
            
			//p.couponCount = [NSString stringWithFormat:@"%d", [self getCouponCount:[p.poiId intValue]]];
			if(poiLogo)
				p.imageBytes = poiLogo;
			/*if(bigLogoData)
             p.bigLogo = bigLogoData;*/
//			
//            NSLog(@"pk = %d" ,p.pk);
//            NSLog(@"poiId = %@" ,p.poiId);
//            NSLog(@"poiSequenceNumber = %@" ,p.poiSequenceNumber);
//            NSLog(@"poiCategoryId = %@" ,p.poiCategoryId);
//            NSLog(@"name = %@" ,p.name);
//            NSLog(@"phoneNumber = %@" ,p.phoneNumber);
//            NSLog(@"completeAddress = %@" ,p.completeAddress);
//            NSLog(@"distance = %@" ,p.distance);
//            NSLog(@"couponCount = %@" ,p.couponCount);
//            NSLog(@"imageName = %@" ,p.imageName);
//            NSLog(@"isSponsored = %@" ,p.isSponsored);
//            NSLog(@"logoImageBytes = %@" ,p.imageBytes);
			/*if(p.bigLogo)
             NSLog(@"bigLogoImageBytes = %d" ,[p.bigLogo length]);
             else
             NSLog(@"bigLogoImageBytes = nil");*/
            
            
			[pois addObject:p];
			[p release];
            
		}
		
		sqlite3_finalize(compiledStatement);
	}
	else{
		NSLog(@"Some problem in compiling statement") ;
	}
	[dbm closeDatabase:database];
	[dbm release];
	
	return pois;
	
}


-(int) getCouponCount: (int) poiId {
	DBManager *dbm = [[DBManager alloc]init];
	int couponCount = -1;
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "SELECT count(*) FROM coupon Join poi_coupon on (coupon.couponId=poi_coupon.couponId) where poi_coupon.poiId=?";// and coupon.validTo >= ?";
	sqlite3_stmt *compiledStatement;
	
	
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		sqlite3_bind_text(compiledStatement, 1,[ [NSString stringWithFormat:@"%d",poiId] UTF8String], -1, SQLITE_TRANSIENT);
		//sqlite3_bind_double(compiledStatement, 2, validTo);
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read the data from the result row
			NSLog(@"Fetching poi coupons count") ;
			
			couponCount = sqlite3_column_int(compiledStatement, 0);
			
			NSLog(@"coupons in this poi %d" , couponCount);
		}
		
		sqlite3_finalize(compiledStatement);
	}
	else{
		NSLog(@"Some problem in compiling statement") ;
	}
	[dbm closeDatabase:database];
	[dbm release];
	
	return couponCount;
	
}


-(BOOL) update: (Poi*) poi{
	BOOL updated = NO ;
	DBManager *dbm = [[DBManager alloc]init];
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "update poi set poiSequenceNumber=?,poiCategoryId=?,name=?,phoneNumber=?,completeAddress=?,distance=?,couponCount=?,imageName=?,isSponsored=?,userPoints=?,reviewCount=?,cumCount=? where poiId=?";
	sqlite3_stmt *compiledStatement;
	
	
	
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));

	}
	else{
		
		sqlite3_bind_text(compiledStatement, 1, [poi.poiSequenceNumber UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 2, [poi.poiCategoryId UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 3, [poi.name UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 4, [poi.phoneNumber UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 5, [poi.completeAddress UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 6, [poi.distance UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 7, [poi.couponCount UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 8, [poi.imageName UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 9, [poi.isSponsored UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(compiledStatement, 10, [poi.userPoints UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(compiledStatement, 11, poi.reviewCount);
        sqlite3_bind_int(compiledStatement, 12, poi.feedbackCount);
		sqlite3_bind_text(compiledStatement, 13, [poi.poiId UTF8String], -1, SQLITE_TRANSIENT);
        		
		int success = sqlite3_step(compiledStatement);
		if (success == SQLITE_ERROR) {
			NSAssert1(0, @"Error: failed to update into the database with message '%s'.", sqlite3_errmsg(database));
		} else {
			updated = YES;
		}
	}
	
	sqlite3_finalize(compiledStatement);
	
	[dbm closeDatabase:database];
	[dbm release];
	
	
	return updated;
	
}

-(Poi*) findByPoiId: (int) pid{
	DBManager *dbm = [[DBManager alloc]init];
	Poi *p = nil;
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "select * from poi where poiId=?";
	sqlite3_stmt *compiledStatement;
	
	
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		sqlite3_bind_text(compiledStatement, 1, [[NSString stringWithFormat:@"%d", pid] UTF8String], -1, SQLITE_TRANSIENT);
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read the data from the result row
			NSLog(@"Fetching columns") ;
			
			char *str =  nil;
			
			int pk = sqlite3_column_int(compiledStatement, 0);
			
			str = (char *)sqlite3_column_text(compiledStatement, 1);
			NSString *poiId = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 2);
			NSString *poiSequenceNumber = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 3);
			NSString *poiCategoryId = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 4);
			NSString *name = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 5);
			NSString *phoneNumber = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 6);
			NSString *completeAddress = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 7);
			NSString *distance = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 8);
			NSString *couponCount = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 9);
			NSString *imageName = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 10);
			NSString *isSponsored = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
            
            str = (char *)sqlite3_column_text(compiledStatement, 13);
			NSString *userPoints = (str) ? [NSString stringWithUTF8String:str] : nil;
			str = nil ;
			
            int _rCount = sqlite3_column_int(compiledStatement, 14);
            int _cCount = sqlite3_column_int(compiledStatement, 15);
            
			NSData *bigLogoData = [[NSData alloc] initWithBytes:sqlite3_column_blob(compiledStatement, 12)
														 length:sqlite3_column_bytes(compiledStatement, 12)];

			
			
			// Fill Setting object with the data from the database
			p = [[Poi alloc] init];
			
			NSLog(@"Filling Poi bean") ;
			p.pk = pk;
			p.poiId = poiId ;
			p.poiSequenceNumber = poiSequenceNumber;
			p.poiCategoryId = poiCategoryId;
			p.name = name;
			p.phoneNumber = phoneNumber;
			p.completeAddress = completeAddress;
			p.distance =distance;
			p.couponCount = couponCount;
			p.imageName = imageName;
			p.isSponsored = isSponsored ;
//			if(bigLogoData)
//				p.bigLogo = bigLogoData;
			[bigLogoData release];
			p.couponCount = [NSString stringWithFormat:@"%d", [self getCouponCount:[p.poiId intValue]]];
            p.userPoints = userPoints;
            p.reviewCount = _rCount;
            p.feedbackCount = _cCount;

//			NSLog(@"pk = %d" ,p.pk);
//			NSLog(@"poiId = %@" ,p.poiId);
//			NSLog(@"poiSequenceNumber = %@" ,p.poiSequenceNumber);
//			NSLog(@"poiCategoryId = %@" ,p.poiCategoryId);
//			NSLog(@"name = %@" ,p.name);
//			NSLog(@"phoneNumber = %@" ,p.phoneNumber);
//			NSLog(@"completeAddress = %@" ,p.completeAddress);
//			NSLog(@"distance = %@" ,p.distance);
//			NSLog(@"couponCount = %@" ,p.couponCount);
//			NSLog(@"imageName = %@" ,p.imageName);
//			NSLog(@"isSponsored = %@" ,p.isSponsored);
//			if(p.bigLogo)
//				NSLog(@"bigLogoImageBytes = %d" ,[p.bigLogo length]);
//			else
//				NSLog(@"bigLogoImageBytes = nil");
			
			
			break ;
			
		}
		
		sqlite3_finalize(compiledStatement);
	}
	else{
		NSLog(@"Some problem in compiling statement") ;
	}
	[dbm closeDatabase:database];
	[dbm release];
	
	return p;
	
	
}

-(BOOL) saveOrUpdate: (Poi*) poi{
	BOOL inserted = NO ;
	
	Poi *p = [self findByPoiId:[poi.poiId intValue]];
	if(p){
		NSLog(@"save or update: updating");
		inserted = [self update:poi];
		[p release];
	}
	else{
		NSLog(@"save or update: saving");
		inserted = [self save:poi];
	}
	
	return inserted;
}


-(BOOL) deletePoi: (Poi*)poi{
	return [self deletePoiById:[poi.poiId intValue]];
}

-(BOOL) deletePoiById: (int)pid{
	BOOL deleted = NO ;
	
	DBManager *dbm = [[DBManager alloc]init];
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "delete from poi where poiId=?";
	sqlite3_stmt *compiledStatement;
	
	
	
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	else{
		
		sqlite3_bind_text(compiledStatement, 1, [[NSString stringWithFormat:@"%d",pid] UTF8String], -1, SQLITE_TRANSIENT);
		
		int success = sqlite3_step(compiledStatement);
		if (success == SQLITE_ERROR) {
			NSAssert1(0, @"Error: failed to delete poi with message '%s'.", sqlite3_errmsg(database));
		} else {
			deleted = YES;
		}
		
	}
	
	sqlite3_finalize(compiledStatement);
	
	[dbm closeDatabase:database];
	[dbm release];
	
	return deleted;
	
}
-(BOOL) deletePois{
	BOOL deleted = NO ;
	
	DBManager *dbm = [[DBManager alloc]init];
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "delete from poi";
	sqlite3_stmt *compiledStatement;
	
	
	
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	else{
		
		//sqlite3_bind_text(compiledStatement, 1, [[NSString stringWithFormat:@"%d",pid] UTF8String], -1, SQLITE_TRANSIENT);
		
		int success = sqlite3_step(compiledStatement);
		if (success == SQLITE_ERROR) {
			NSAssert1(0, @"Error: failed to delete poi with message '%s'.", sqlite3_errmsg(database));
		} else {
			deleted = YES;
		}
		
	}
	
	sqlite3_finalize(compiledStatement);
	
	[dbm closeDatabase:database];
	[dbm release];
	
	return deleted;
	
}

@end
