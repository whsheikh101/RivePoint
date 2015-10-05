//
//  FavoritePoiUtils.m
//  RivePoint
//
//  Created by Ahmer Mustafa on 9/27/12.
//  Copyright (c) 2012 Netpace Systems. All rights reserved.
//

#import "FavoritePoiUtils.h"
#import "DBManager.h"
@implementation FavoritePoiUtils

+(BOOL) addToUserFavPoi:(Poi *) poi
{
    BOOL added = NO;
    
    DBManager *dbm = [[DBManager alloc]init];
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "insert into favPoi (poiId,poiSequenceNumber,poiCategoryId,name,phoneNumber,completeAddress,distance,couponCount,imageName,isSponsored,poiLogo,bigLogo,userPoints) values (?,?,?,?,?,?,?,?,?,?,?,?,?)";
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
//		
//		if(poi.bigLogo){
//			
//			//UIImage  *uiImage  = [UIImage imageWithData:poi.bigLogo];
//			//NSData *data = UIImagePNGRepresentation(uiImage);
//			sqlite3_bind_blob(compiledStatement, 12, [poi.bigLogo bytes], [poi.bigLogo length], NULL);
//		}
//		else
//			sqlite3_bind_blob(compiledStatement, 12, nil, -1, NULL);
//		
		int success = sqlite3_step(compiledStatement);
		if (success == SQLITE_ERROR) {
			NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
		} else {
			poi.pk = sqlite3_last_insert_rowid(database);
			NSLog(@"new record pk = %d" ,poi.pk);
			added = YES;
		}
	}	
	
	sqlite3_finalize(compiledStatement);
	
	[dbm closeDatabase:database];
	[dbm release];
    
    return added;
}

+(NSMutableArray *) fetchAllUserFavPois
{
    NSMutableArray * poiArray = [[NSMutableArray alloc]init];
    DBManager *dbm = [[DBManager alloc]init];
	Poi *p = nil;
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "select * from favPoi";
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
            
		//	p.couponCount = [NSString stringWithFormat:@"%d", [self getCouponCount:[p.poiId intValue]]];
			if(poiLogo)
				p.imageBytes = poiLogo;
			/*if(bigLogoData)
             p.bigLogo = bigLogoData;*/
			
            NSLog(@"pk = %d" ,p.pk);
            NSLog(@"poiId = %@" ,p.poiId);
            NSLog(@"poiSequenceNumber = %@" ,p.poiSequenceNumber);
            NSLog(@"poiCategoryId = %@" ,p.poiCategoryId);
            NSLog(@"name = %@" ,p.name);
            NSLog(@"phoneNumber = %@" ,p.phoneNumber);
            NSLog(@"completeAddress = %@" ,p.completeAddress);
            NSLog(@"distance = %@" ,p.distance);
            NSLog(@"couponCount = %@" ,p.couponCount);
            NSLog(@"imageName = %@" ,p.imageName);
            NSLog(@"isSponsored = %@" ,p.isSponsored);
            NSLog(@"logoImageBytes = %@" ,p.imageBytes);
			/*if(p.bigLogo)
             NSLog(@"bigLogoImageBytes = %d" ,[p.bigLogo length]);
             else
             NSLog(@"bigLogoImageBytes = nil");*/
            
            
			[poiArray addObject:p];
			[p release];
            
		}
		
		sqlite3_finalize(compiledStatement);
	}
	else{
		NSLog(@"Some problem in compiling statement") ;
	}
	[dbm closeDatabase:database];
	[dbm release];
    
    
    return poiArray;
}

+(Poi *) fetchPoiWithId:(int)poiId
{
    Poi * _poi = [[Poi alloc]init];
    DBManager *dbm = [[DBManager alloc]init];
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "select * from favPoi where poiId=?";
	sqlite3_stmt *compiledStatement;
	
	
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		sqlite3_bind_text(compiledStatement, 1, [[NSString stringWithFormat:@"%d", poiId] UTF8String], -1, SQLITE_TRANSIENT);
		
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
			
			NSData *bigLogoData = [[NSData alloc] initWithBytes:sqlite3_column_blob(compiledStatement, 12)
														 length:sqlite3_column_bytes(compiledStatement, 12)];
            
			
			
			// Fill Setting object with the data from the database
			NSLog(@"Filling Poi bean") ;
			_poi.pk = pk;
			_poi.poiId = poiId ;
			_poi.poiSequenceNumber = poiSequenceNumber;
			_poi.poiCategoryId = poiCategoryId;
			_poi.name = name;
			_poi.phoneNumber = phoneNumber;
			_poi.completeAddress = completeAddress;
			_poi.distance =distance;
			_poi.couponCount = couponCount;
			_poi.imageName = imageName;
			_poi.isSponsored = isSponsored ;
//			if(bigLogoData)
//				_poi.bigLogo = bigLogoData;
			[bigLogoData release];
			//p.couponCount = [NSString stringWithFormat:@"%d", [self getCouponCount:[_poi.poiId intValue]]];
            _poi.userPoints = userPoints;
            
			NSLog(@"pk = %d" ,_poi.pk);
			NSLog(@"poiId = %@" ,_poi.poiId);
			NSLog(@"poiSequenceNumber = %@" ,_poi.poiSequenceNumber);
			NSLog(@"poiCategoryId = %@" ,_poi.poiCategoryId);
			NSLog(@"name = %@" ,_poi.name);
			NSLog(@"phoneNumber = %@" ,_poi.phoneNumber);
			NSLog(@"completeAddress = %@" ,_poi.completeAddress);
			NSLog(@"distance = %@" ,_poi.distance);
			NSLog(@"couponCount = %@" ,_poi.couponCount);
			NSLog(@"imageName = %@" ,_poi.imageName);
			NSLog(@"isSponsored = %@" ,_poi.isSponsored);
//			if(_poi.bigLogo)
//				NSLog(@"bigLogoImageBytes = %d" ,[_poi.bigLogo length]);
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
    
    return _poi;
}

+(BOOL) deletePoiWithId:(int)poiId
{
    BOOL isDeleted = NO;
    DBManager *dbm = [[DBManager alloc]init];
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "delete from favPoi where poiId=?";
	sqlite3_stmt *compiledStatement;
	
	
	
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	else{
		
		sqlite3_bind_text(compiledStatement, 1, [[NSString stringWithFormat:@"%d",poiId] UTF8String], -1, SQLITE_TRANSIENT);
		
		int success = sqlite3_step(compiledStatement);
		if (success == SQLITE_ERROR) {
			NSAssert1(0, @"Error: failed to delete poi with message '%s'.", sqlite3_errmsg(database));
		} else {
			isDeleted = YES;
		}
		
	}
	
	sqlite3_finalize(compiledStatement);
	
	[dbm closeDatabase:database];
	[dbm release];
    return isDeleted;
}

+(BOOL) isAlreadyExitPoiWithName:(NSString *)name
{
    BOOL isExist = NO;
    DBManager *dbm = [[DBManager alloc]init];
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "select * from favPoi where name=?";
	sqlite3_stmt *compiledStatement;
	
	
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		sqlite3_bind_text(compiledStatement, 1, [[NSString stringWithFormat:@"%@", name] UTF8String], -1, SQLITE_TRANSIENT);
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
			isExist = YES;
			break;
		}
		
		sqlite3_finalize(compiledStatement);
	}
	else{
		NSLog(@"Some problem in compiling statement") ;
	}
	[dbm closeDatabase:database];
	[dbm release];

    return isExist;
}

@end
