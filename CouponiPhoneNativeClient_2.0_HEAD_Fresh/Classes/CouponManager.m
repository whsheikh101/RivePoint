//
//  CouponManager.m
//  RiveCouponnt
//
//  Created by Shahzad Mughal on 3/25/09.
//  Copyright 2009 kgflkfd. All rights reserved.
//

#import "CouponManager.h"
#import "DBManager.h"
#import "Coupon.h"
#import "PoiManager.h"
#import "Poi.h"
#import "RivePointAppDelegate.h"

@implementation CouponManager


-(BOOL) save: (Coupon*) cpn{
	BOOL saved = NO ;
	DBManager *dbm = [[DBManager alloc]init];
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "insert into coupon (couponId,title,subTitleLineOne,subTitleLineTwo,couponUniqueCode,validFrom,validTo,vendorLogoImageName,couponImageName,couponType,isRestrictedCoupon,perUserRedemption,userRedemptionCount,isAvailable,couponImagePreview,couponRating,earningPoints,reqdPoints) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	sqlite3_stmt *compiledStatement;
	
	
	
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	else{
		
		sqlite3_bind_text(compiledStatement, 1, [cpn.couponId UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 2, [cpn.title UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 3, [cpn.subTitleLineOne UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 4, [cpn.subTitleLineTwo UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 5, [cpn.couponUniqueCode UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 6, [cpn.validFrom UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 7, [cpn.validTo UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 8, [cpn.vendorLogoImageName UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 9, [cpn.couponImageName UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 10, [cpn.couponType UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 11, [cpn.isRestrictedCoupon UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 12, [cpn.perUserRedemption UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 13, [cpn.userRedemptionCount UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 14, [cpn.isAvailable UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(compiledStatement, 17, [cpn.earningPoints UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(compiledStatement, 18, [cpn.reqdPoints UTF8String], -1, SQLITE_TRANSIENT);
		if(cpn.couponImagePreview){
			sqlite3_bind_blob(compiledStatement, 15, [cpn.couponImagePreview bytes], [cpn.couponImagePreview length], NULL);
		}
		else
			sqlite3_bind_blob(compiledStatement, 15, nil, -1, NULL);
		
		sqlite3_bind_int(compiledStatement, 16, cpn.rating?[cpn.rating intValue]:0);
		
		int success = sqlite3_step(compiledStatement);
		if (success == SQLITE_ERROR) {
			NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
		} else {
			cpn.pk = sqlite3_last_insert_rowid(database);
			saved = YES;
		}
	}	
	
	if(saved){
		if(![self poiCouponExists:cpn]){
			[self savePoiCoupon:cpn];
		}
	}
	
	sqlite3_finalize(compiledStatement);
	
	[dbm closeDatabase:database];
	[dbm release];
	
	
	return saved;
	
}

-(NSMutableArray*) findAll{
	DBManager *dbm = [[DBManager alloc]init];
	NSMutableArray *cpns = [[NSMutableArray alloc]init];
	Coupon *c = nil;
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "select * from coupon";
	sqlite3_stmt *compiledStatement;
	
	
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read the data from the result row
			
			
			char *str =  nil;
			
			int pk = sqlite3_column_int(compiledStatement, 0);
			
			str = (char *)sqlite3_column_text(compiledStatement, 1);
			NSString *couponId = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 2);
			NSString *title = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 3);
			NSString *subTitleLineOne = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 4);
			NSString *subTitleLineTwo = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 5);
			NSString *couponUniqueCode = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 6);
			NSString *validFrom = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 7);
			NSString *validTo = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 8);
			NSString *vendorLogoImageName = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 9);
			NSString *couponImageName = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 10);
			NSString *couponType = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 11);
			NSString *isRestrictedCoupon = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 12);
			NSString *perUserRedemption = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 13);
			NSString *userRedemptionCount = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 14);
			NSString *isAvailable = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
            str = (char *)sqlite3_column_text(compiledStatement, 17);
			NSString *earningPoints = (str) ? [NSString stringWithUTF8String:str] :nil;
			str = nil ;
            
            str = (char *)sqlite3_column_text(compiledStatement, 18);
			NSString *reqdPoints = (str) ? [NSString stringWithUTF8String:str] : nil;
			str = nil ;
			
			
			// Fill Setting object with the data from the database
			c = [[Coupon alloc] init];
			
			c.pk = pk;
			c.couponId = couponId ;
			c.title = title;
			c.subTitleLineOne = subTitleLineOne;
			c.subTitleLineTwo = subTitleLineTwo;
			c.couponUniqueCode = couponUniqueCode;
			c.validFrom =validFrom;
			c.validTo = validTo;
			c.vendorLogoImageName = vendorLogoImageName;
			c.couponImageName = couponImageName ;
			c.couponType = couponType ;
			c.isRestrictedCoupon = isRestrictedCoupon ;
			c.perUserRedemption = perUserRedemption ;
			c.userRedemptionCount = userRedemptionCount ;
			c.isAvailable = isAvailable ;
            c.earningPoints = earningPoints;
            c.reqdPoints = reqdPoints;
			
//			NSLog(@"pk = %d" ,c.pk);
//			NSLog(@"couponId = %@" ,c.couponId);
//			NSLog(@"poiId = %@" ,c.poiId);
//			NSLog(@"title = %@" ,c.title);
//			NSLog(@"subTitleLineOne = %@" ,c.subTitleLineOne);
//			NSLog(@"subTitleLineTwo = %@" ,c.subTitleLineTwo);
//			NSLog(@"couponUniqueCode = %@" ,c.couponUniqueCode);
//			NSLog(@"validFrom = %@" ,c.validFrom);
//			NSLog(@"validTo = %@" ,c.validTo);
//			NSLog(@"vendorLogoImageName = %@" ,c.vendorLogoImageName);
//			NSLog(@"couponImageName = %@" ,c.couponImageName);
//			NSLog(@"couponType = %@" ,c.couponType);
//			NSLog(@"isRestrictedCoupon = %@" ,c.isRestrictedCoupon);
//			NSLog(@"perUserRedemption = %@" ,c.perUserRedemption);
//			NSLog(@"userRedemptionCount = %@" ,c.userRedemptionCount);
//			NSLog(@"isAvailable = %@" ,c.isAvailable);
			
			
			[cpns addObject:c];
			[c release];
			
		}
		
		sqlite3_finalize(compiledStatement);
	}
	else{
		NSLog(@"Some problem in compiling statement") ;
	}
	[dbm closeDatabase:database];
	[dbm release];
	
	return cpns;
	
}

-(BOOL) update: (Coupon*) cpn{
	BOOL updated = NO ;
	DBManager *dbm = [[DBManager alloc]init];
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "update coupon set title=?,subTitleLineOne=?,subTitleLineTwo=?,couponUniqueCode=?,validFrom=?,validTo=?,vendorLogoImageName=?,couponImageName=?,couponType=?,isRestrictedCoupon=?,perUserRedemption=?,userRedemptionCount=?,isAvailable=?,couponRating=?,earningPoints=?,reqdPoints=? where couponId=?";
	sqlite3_stmt *compiledStatement;
	
	
	
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	else{
		
		sqlite3_bind_text(compiledStatement, 1, [cpn.title UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 2, [cpn.subTitleLineOne UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 3, [cpn.subTitleLineTwo UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 4, [cpn.couponUniqueCode UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 5, [cpn.validFrom UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 6, [cpn.validTo UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 7, [cpn.vendorLogoImageName UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 8, [cpn.couponImageName UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 9, [cpn.couponType UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 10, [cpn.isRestrictedCoupon UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 11, [cpn.perUserRedemption UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 12, [cpn.userRedemptionCount UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 13, [cpn.isAvailable UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_int(compiledStatement, 14, [cpn.rating intValue]);
		sqlite3_bind_text(compiledStatement, 15, [cpn.earningPoints UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(compiledStatement, 16, [cpn.reqdPoints UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(compiledStatement, 17, [cpn.couponId UTF8String], -1, SQLITE_TRANSIENT);
		
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

-(Coupon*) findByCouponId: (int) cid{
	DBManager *dbm = [[DBManager alloc]init];
	Coupon *c = nil;
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "select * from coupon where couponId=?";
	sqlite3_stmt *compiledStatement;
	
	
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		sqlite3_bind_text(compiledStatement, 1, [[NSString stringWithFormat:@"%d",cid] UTF8String], -1, SQLITE_TRANSIENT);
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read the data from the result row
			
			char *str =  nil;
			
			int pk = sqlite3_column_int(compiledStatement, 0);
			
			str = (char *)sqlite3_column_text(compiledStatement, 1);
			NSString *couponId = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 2);
			NSString *title = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 3);
			NSString *subTitleLineOne = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 4);
			NSString *subTitleLineTwo = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 5);
			NSString *couponUniqueCode = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 6);
			NSString *validFrom = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 7);
			NSString *validTo = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 8);
			NSString *vendorLogoImageName = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 9);
			NSString *couponImageName = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 10);
			NSString *couponType = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 11);
			NSString *isRestrictedCoupon = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 12);
			NSString *perUserRedemption = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 13);
			NSString *userRedemptionCount = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 14);
			NSString *isAvailable = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
            str = (char *)sqlite3_column_text(compiledStatement, 17);
			NSString *earningPoints = (str) ? [NSString stringWithUTF8String:str] :nil;
			str = nil ;
            
            str = (char *)sqlite3_column_text(compiledStatement, 18);
			NSString *reqdPoints = (str) ? [NSString stringWithUTF8String:str] :nil;
			str = nil ;
			
			// Fill Setting object with the data from the database
			c = [[Coupon alloc] init];
			
			c.pk = pk;
			c.couponId = couponId ;
			c.title = title;
			c.subTitleLineOne = subTitleLineOne;
			c.subTitleLineTwo = subTitleLineTwo;
			c.couponUniqueCode = couponUniqueCode;
			c.validFrom =validFrom;
			c.validTo = validTo;
			c.vendorLogoImageName = vendorLogoImageName;
			c.couponImageName = couponImageName ;
			c.couponType = couponType ;
			c.isRestrictedCoupon = isRestrictedCoupon ;
			c.perUserRedemption = perUserRedemption ;
			c.userRedemptionCount = userRedemptionCount ;
			c.isAvailable = isAvailable ;
			c.earningPoints = earningPoints;
            c.reqdPoints = reqdPoints;
			
//			NSLog(@"pk = %d" ,c.pk);
//			NSLog(@"couponId = %@" ,c.couponId);
//			NSLog(@"poiId = %@" ,c.poiId);
//			NSLog(@"title = %@" ,c.title);
//			NSLog(@"subTitleLineOne = %@" ,c.subTitleLineOne);
//			NSLog(@"subTitleLineTwo = %@" ,c.subTitleLineTwo);
//			NSLog(@"couponUniqueCode = %@" ,c.couponUniqueCode);
//			NSLog(@"validFrom = %@" ,c.validFrom);
//			NSLog(@"validTo = %@" ,c.validTo);
//			NSLog(@"vendorLogoImageName = %@" ,c.vendorLogoImageName);
//			NSLog(@"couponImageName = %@" ,c.couponImageName);
//			NSLog(@"couponType = %@" ,c.couponType);
//			NSLog(@"isRestrictedCoupon = %@" ,c.isRestrictedCoupon);
//			NSLog(@"perUserRedemption = %@" ,c.perUserRedemption);
//			NSLog(@"userRedemptionCount = %@" ,c.userRedemptionCount);
//			NSLog(@"isAvailable = %@" ,c.isAvailable);
			
			
			
			break ;
			
		}
		
		sqlite3_finalize(compiledStatement);
	}
	else{
		NSLog(@"Some problem in compiling statement") ;
	}
	[dbm closeDatabase:database];
	[dbm release];
	
	return c;
	
	
}

-(NSMutableArray*) findByPoiId: (int) pid{
    //Todo : This method need to be removed after testing. Use Method findCouponsByPoiId in place of this
	DBManager *dbm = [[DBManager alloc]init];
	NSMutableArray *cpns = [[NSMutableArray alloc]init];
	Coupon *c = nil;
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "SELECT * FROM coupon Join poi_coupon on (coupon.couponId=poi_coupon.couponId) where poi_coupon.poiId=?";// and coupon.validTo >= ?";
	sqlite3_stmt *compiledStatement;
	
	
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		sqlite3_bind_text(compiledStatement, 1, [[NSString stringWithFormat:@"%d",pid] UTF8String], -1, SQLITE_TRANSIENT);
		//sqlite3_bind_double(compiledStatement, 2, validTo);
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read the data from the result row
			NSLog(@"Fetching columns") ;
			
			char *str =  nil;
			
			int pk = sqlite3_column_int(compiledStatement, 0);
			
			str = (char *)sqlite3_column_text(compiledStatement, 1);
			NSString *couponId = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 2);
			NSString *title = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 3);
			NSString *subTitleLineOne = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 4);
			NSString *subTitleLineTwo = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 5);
			NSString *couponUniqueCode = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 6);
			NSString *validFrom = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 7);
			NSString *validTo = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 8);
			NSString *vendorLogoImageName = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 9);
			NSString *couponImageName = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 10);
			NSString *couponType = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 11);
			NSString *isRestrictedCoupon = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 12);
			NSString *perUserRedemption = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 13);
			NSString *userRedemptionCount = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 14);
			NSString *isAvailable = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			NSData *data = [[[NSData alloc] initWithBytes:sqlite3_column_blob(compiledStatement, 15)
												  length:sqlite3_column_bytes(compiledStatement, 15)]autorelease];
			
			int couponRating = sqlite3_column_int(compiledStatement, 16);
            
            str = (char *)sqlite3_column_text(compiledStatement, 17);
			NSString *earningPoints = (str) ? [NSString stringWithUTF8String:str] : nil;
			str = nil ;
            
            str = (char *)sqlite3_column_text(compiledStatement, 18);
			NSString *reqdPoints = (str) ? [NSString stringWithUTF8String:str] : nil;
			str = nil ;
			
			// Fill Setting object with the data from the database
			c = [[Coupon alloc] init];
			NSLog(@"Filling settings bean") ;
			c.pk = pk;
			c.couponId = couponId ;
			c.title = title;
			c.subTitleLineOne = subTitleLineOne;
			c.subTitleLineTwo = subTitleLineTwo;
			c.couponUniqueCode = couponUniqueCode;
			c.validFrom =validFrom;
			c.validTo = validTo;
			c.vendorLogoImageName = vendorLogoImageName;
			c.couponImageName = couponImageName ;
			c.couponType = couponType ;
			c.isRestrictedCoupon = isRestrictedCoupon ;
			c.perUserRedemption = perUserRedemption ;
			c.userRedemptionCount = userRedemptionCount ;
			c.isAvailable = isAvailable ;
			if(data)
				c.couponImagePreview = data;
			
			c.rating = [NSString stringWithFormat:@"%d",couponRating];
			c.earningPoints = earningPoints;
            c.reqdPoints = reqdPoints;
            
//			NSLog(@"pk = %d" ,c.pk);
//			NSLog(@"couponId = %@" ,c.couponId);
//			NSLog(@"poiId = %@" ,c.poiId);
//			NSLog(@"title = %@" ,c.title);
//			NSLog(@"subTitleLineOne = %@" ,c.subTitleLineOne);
//			NSLog(@"subTitleLineTwo = %@" ,c.subTitleLineTwo);
//			NSLog(@"couponUniqueCode = %@" ,c.couponUniqueCode);
//			NSLog(@"validFrom = %@" ,c.validFrom);
//			NSLog(@"validTo = %@" ,c.validTo);
//			NSLog(@"vendorLogoImageName = %@" ,c.vendorLogoImageName);
//			NSLog(@"couponImageName = %@" ,c.couponImageName);
//			NSLog(@"couponType = %@" ,c.couponType);
//			NSLog(@"isRestrictedCoupon = %@" ,c.isRestrictedCoupon);
//			NSLog(@"perUserRedemption = %@" ,c.perUserRedemption);
//			NSLog(@"userRedemptionCount = %@" ,c.userRedemptionCount);
//			NSLog(@"isAvailable = %@" ,c.isAvailable);
//			NSLog(@"rating = %@" ,c.rating);
			
			[cpns addObject:c];
			[c release];
			
		}
		
		sqlite3_finalize(compiledStatement);
	}
	else{
		NSLog(@"Some problem in compiling statement") ;
	}
	[dbm closeDatabase:database];
	[dbm release];
	
	return cpns;
	
	
}

-(NSMutableArray*) findCouponsByPoiId: (int) pid{
    
	DBManager *dbm = [[DBManager alloc]init];
	NSMutableArray *cpns = [[NSMutableArray alloc]init];
	Coupon *c = nil;
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "SELECT * FROM coupon Join poi_coupon on (coupon.couponId=poi_coupon.couponId) where poi_coupon.poiId=? AND (coupon.earningPoints IS NULL AND coupon.reqdPoints IS NULL)";// and coupon.validTo >= ?";
	sqlite3_stmt *compiledStatement;
	
	
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		sqlite3_bind_text(compiledStatement, 1, [[NSString stringWithFormat:@"%d",pid] UTF8String], -1, SQLITE_TRANSIENT);
		//sqlite3_bind_double(compiledStatement, 2, validTo);
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read the data from the result row
			
			char *str =  nil;
			
			int pk = sqlite3_column_int(compiledStatement, 0);
			
			str = (char *)sqlite3_column_text(compiledStatement, 1);
			NSString *couponId = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 2);
			NSString *title = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 3);
			NSString *subTitleLineOne = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 4);
			NSString *subTitleLineTwo = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 5);
			NSString *couponUniqueCode = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 6);
			NSString *validFrom = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 7);
			NSString *validTo = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 8);
			NSString *vendorLogoImageName = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 9);
			NSString *couponImageName = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 10);
			NSString *couponType = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 11);
			NSString *isRestrictedCoupon = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 12);
			NSString *perUserRedemption = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 13);
			NSString *userRedemptionCount = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 14);
			NSString *isAvailable = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			NSData *data = [[[NSData alloc] initWithBytes:sqlite3_column_blob(compiledStatement, 15)
                                                   length:sqlite3_column_bytes(compiledStatement, 15)]autorelease];
			
			int couponRating = sqlite3_column_int(compiledStatement, 16);
            
            str = (char *)sqlite3_column_text(compiledStatement, 17);
			NSString *earningPoints = (str) ? [NSString stringWithUTF8String:str] : nil;
			str = nil ;
            
            str = (char *)sqlite3_column_text(compiledStatement, 18);
			NSString *reqdPoints = (str) ? [NSString stringWithUTF8String:str] : nil;
			str = nil ;
			
			// Fill Setting object with the data from the database
			c = [[Coupon alloc] init];
			c.pk = pk;
			c.couponId = couponId ;
			c.title = title;
			c.subTitleLineOne = subTitleLineOne;
			c.subTitleLineTwo = subTitleLineTwo;
			c.couponUniqueCode = couponUniqueCode;
			c.validFrom =validFrom;
			c.validTo = validTo;
			c.vendorLogoImageName = vendorLogoImageName;
			c.couponImageName = couponImageName ;
			c.couponType = couponType ;
			c.isRestrictedCoupon = isRestrictedCoupon ;
			c.perUserRedemption = perUserRedemption ;
			c.userRedemptionCount = userRedemptionCount ;
			c.isAvailable = isAvailable ;
			if(data)
				c.couponImagePreview = data;
			
			c.rating = [NSString stringWithFormat:@"%d",couponRating];
			c.earningPoints = earningPoints;
            c.reqdPoints = reqdPoints;
            
//			NSLog(@"pk = %d" ,c.pk);
//			NSLog(@"couponId = %@" ,c.couponId);
//			NSLog(@"poiId = %@" ,c.poiId);
//			NSLog(@"title = %@" ,c.title);
//			NSLog(@"subTitleLineOne = %@" ,c.subTitleLineOne);
//			NSLog(@"subTitleLineTwo = %@" ,c.subTitleLineTwo);
//			NSLog(@"couponUniqueCode = %@" ,c.couponUniqueCode);
//			NSLog(@"validFrom = %@" ,c.validFrom);
//			NSLog(@"validTo = %@" ,c.validTo);
//			NSLog(@"vendorLogoImageName = %@" ,c.vendorLogoImageName);
//			NSLog(@"couponImageName = %@" ,c.couponImageName);
//			NSLog(@"couponType = %@" ,c.couponType);
//			NSLog(@"isRestrictedCoupon = %@" ,c.isRestrictedCoupon);
//			NSLog(@"perUserRedemption = %@" ,c.perUserRedemption);
//			NSLog(@"userRedemptionCount = %@" ,c.userRedemptionCount);
//			NSLog(@"isAvailable = %@" ,c.isAvailable);
//			NSLog(@"rating = %@" ,c.rating);
			
			[cpns addObject:c];
			[c release];
			
		}
		
		sqlite3_finalize(compiledStatement);
	}
	else{
		NSLog(@"Some problem in compiling statement") ;
	}
	[dbm closeDatabase:database];
	[dbm release];
	
	return cpns;
	
	
}

-(NSMutableArray*) findLoyaltyCouponsByPoiId: (int) pid{
    
	DBManager *dbm = [[DBManager alloc]init];
	NSMutableArray *cpns = [[NSMutableArray alloc]init];
	Coupon *c = nil;
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "SELECT * FROM coupon Join poi_coupon on (coupon.couponId=poi_coupon.couponId) where poi_coupon.poiId=? AND (coupon.earningPoints NOT NULL OR coupon.reqdPoints NOT NULL)";// and coupon.validTo >= ?";
	sqlite3_stmt *compiledStatement;
	
	
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		sqlite3_bind_text(compiledStatement, 1, [[NSString stringWithFormat:@"%d",pid] UTF8String], -1, SQLITE_TRANSIENT);
		//sqlite3_bind_double(compiledStatement, 2, validTo);
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read the data from the result row
			
			char *str =  nil;
			
			int pk = sqlite3_column_int(compiledStatement, 0);
			
			str = (char *)sqlite3_column_text(compiledStatement, 1);
			NSString *couponId = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 2);
			NSString *title = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 3);
			NSString *subTitleLineOne = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 4);
			NSString *subTitleLineTwo = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 5);
			NSString *couponUniqueCode = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 6);
			NSString *validFrom = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 7);
			NSString *validTo = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 8);
			NSString *vendorLogoImageName = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 9);
			NSString *couponImageName = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 10);
			NSString *couponType = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 11);
			NSString *isRestrictedCoupon = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 12);
			NSString *perUserRedemption = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 13);
			NSString *userRedemptionCount = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 14);
			NSString *isAvailable = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			NSData *data = [[[NSData alloc] initWithBytes:sqlite3_column_blob(compiledStatement, 15)
                                                   length:sqlite3_column_bytes(compiledStatement, 15)]autorelease];
			
			int couponRating = sqlite3_column_int(compiledStatement, 16);
            
            str = (char *)sqlite3_column_text(compiledStatement, 17);
			NSString *earningPoints = (str) ? [NSString stringWithUTF8String:str] : nil;
			str = nil ;
            
            str = (char *)sqlite3_column_text(compiledStatement, 18);
			NSString *reqdPoints = (str) ? [NSString stringWithUTF8String:str] : nil;
			str = nil ;
			
			// Fill Setting object with the data from the database
			c = [[Coupon alloc] init];
			c.pk = pk;
			c.couponId = couponId ;
			c.title = title;
			c.subTitleLineOne = subTitleLineOne;
			c.subTitleLineTwo = subTitleLineTwo;
			c.couponUniqueCode = couponUniqueCode;
			c.validFrom =validFrom;
			c.validTo = validTo;
			c.vendorLogoImageName = vendorLogoImageName;
			c.couponImageName = couponImageName ;
			c.couponType = couponType ;
			c.isRestrictedCoupon = isRestrictedCoupon ;
			c.perUserRedemption = perUserRedemption ;
			c.userRedemptionCount = userRedemptionCount ;
			c.isAvailable = isAvailable ;
			if(data)
				c.couponImagePreview = data;
			
			c.rating = [NSString stringWithFormat:@"%d",couponRating];
			c.earningPoints = earningPoints;
            c.reqdPoints = reqdPoints;
            
//			NSLog(@"pk = %d" ,c.pk);
//			NSLog(@"couponId = %@" ,c.couponId);
//			NSLog(@"poiId = %@" ,c.poiId);
//			NSLog(@"title = %@" ,c.title);
//			NSLog(@"subTitleLineOne = %@" ,c.subTitleLineOne);
//			NSLog(@"subTitleLineTwo = %@" ,c.subTitleLineTwo);
//			NSLog(@"couponUniqueCode = %@" ,c.couponUniqueCode);
//			NSLog(@"validFrom = %@" ,c.validFrom);
//			NSLog(@"validTo = %@" ,c.validTo);
//			NSLog(@"vendorLogoImageName = %@" ,c.vendorLogoImageName);
//			NSLog(@"couponImageName = %@" ,c.couponImageName);
//			NSLog(@"couponType = %@" ,c.couponType);
//			NSLog(@"isRestrictedCoupon = %@" ,c.isRestrictedCoupon);
//			NSLog(@"perUserRedemption = %@" ,c.perUserRedemption);
//			NSLog(@"userRedemptionCount = %@" ,c.userRedemptionCount);
//			NSLog(@"isAvailable = %@" ,c.isAvailable);
//			NSLog(@"rating = %@" ,c.rating);
			
			[cpns addObject:c];
			[c release];
			
		}
		
		sqlite3_finalize(compiledStatement);
	}
	else{
		NSLog(@"Some problem in compiling statement") ;
	}
	[dbm closeDatabase:database];
	[dbm release];
	
	return cpns;
	
	
}

-(BOOL) saveOrUpdate: (Coupon*) cpn{
	BOOL inserted = YES ;
	
	Coupon *p = [self findByCouponId:[cpn.couponId intValue]];
	[p autorelease];
	if(p){
		NSLog(@"save or update: updating");
		inserted = [self update:cpn];
		if(inserted){
			if(![self poiCouponExists:cpn]){
				NSLog(@"Maping poi coupon");
				[self savePoiCoupon:cpn];
			}
		}
	}
	else{
		NSLog(@"save or update: saving");
		inserted = [self save:cpn];
	}
	
	return inserted;
}


-(BOOL) savePoiCoupon: (Coupon*) cpn{
	BOOL saved = NO ;
	DBManager *dbm = [[DBManager alloc]init];
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "insert into poi_coupon (poiId,couponId) values (?,?)";
	sqlite3_stmt *compiledStatement;
	
	
	
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	else{
		
		sqlite3_bind_text(compiledStatement, 1, [cpn.poiId UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 2, [cpn.couponId UTF8String], -1, SQLITE_TRANSIENT);
		
		
		int success = sqlite3_step(compiledStatement);
		if (success == SQLITE_ERROR) {
			NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
		} else {
			int pk = sqlite3_last_insert_rowid(database);
			NSLog(@"new poi_coupon record pk = %d" ,pk);
			saved = YES;
		}
	}
	
	sqlite3_finalize(compiledStatement);
	
	[dbm closeDatabase:database];
	[dbm release];
	
	
	return saved;
	
}


-(BOOL) poiCouponExists: (Coupon*) cpn{
	DBManager *dbm = [[DBManager alloc]init];
	BOOL exists = NO;
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "select * from poi_coupon where couponId=? and poiId=?";
	sqlite3_stmt *compiledStatement;
	
	
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		sqlite3_bind_text(compiledStatement, 1, [cpn.couponId UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 2, [cpn.poiId UTF8String], -1, SQLITE_TRANSIENT);
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read the data from the result row
			NSLog(@"Poi coupon exists") ;
			
			exists = YES;
			break ;
			
		}
		
		sqlite3_finalize(compiledStatement);
	}
	else{
		NSLog(@"Some problem in compiling statement") ;
	}
	[dbm closeDatabase:database];
	[dbm release];
	
	return exists;
	
	
}

-(int) getCouponsCount{
	DBManager *dbm = [[DBManager alloc]init];
	int totalCount = 0;
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "select count(*) from coupon"; //where coupon.validTo >= ?";
	sqlite3_stmt *compiledStatement;
	
	
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		//sqlite3_bind_double(compiledStatement, 1, validTo);
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read the data from the result row
			NSLog(@"Getting total coupons count") ;

			totalCount = sqlite3_column_int(compiledStatement, 0);
			
			break;			
		}
		
		sqlite3_finalize(compiledStatement);
	}
	else{
		NSLog(@"Some problem in compiling statement") ;
	}
	[dbm closeDatabase:database];
	[dbm release];
	
	return totalCount;
	
}

-(BOOL) deleteByCouponId: (int)cid{
	BOOL deleted = NO ;
	
	DBManager *dbm = [[DBManager alloc]init];
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "delete from coupon where couponId=?";
	sqlite3_stmt *compiledStatement;
	
	
	
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	else{
		
		sqlite3_bind_text(compiledStatement, 1, [[NSString stringWithFormat:@"%d",cid] UTF8String], -1, SQLITE_TRANSIENT);
		
		int success = sqlite3_step(compiledStatement);
		if (success == SQLITE_ERROR) {
			NSAssert1(0, @"Error: failed to delete coupon with message '%s'.", sqlite3_errmsg(database));
		} else {
			deleted = YES;
		}
		
	}
	
	sqlite3_finalize(compiledStatement);
	
	[dbm closeDatabase:database];
	[dbm release];

	return deleted;
}
-(BOOL) deleteCoupons{
	BOOL deleted = NO ;
	
	DBManager *dbm = [[DBManager alloc]init];
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "delete from coupon";
	sqlite3_stmt *compiledStatement;
	
	
	
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	else{
		
		//sqlite3_bind_text(compiledStatement, 1, [[NSString stringWithFormat:@"%d",cid] UTF8String], -1, SQLITE_TRANSIENT);
		
		int success = sqlite3_step(compiledStatement);
		if (success == SQLITE_ERROR) {
			NSAssert1(0, @"Error: failed to delete coupon with message '%s'.", sqlite3_errmsg(database));
		} else {
			deleted = YES;
		}
		
	}
	
	sqlite3_finalize(compiledStatement);
	
	[dbm closeDatabase:database];
	[dbm release];
	
	return deleted;
}

-(BOOL) findInPoiCouponByCouponId: (int) cid{
	DBManager *dbm = [[DBManager alloc]init];
	BOOL exists = NO;
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "select * from poi_coupon where couponId=?";
	sqlite3_stmt *compiledStatement;
	
	
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		sqlite3_bind_text(compiledStatement, 1, [[NSString stringWithFormat:@"%d",cid] UTF8String], -1, SQLITE_TRANSIENT);
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read the data from the result row
			NSLog(@"Coupon find in poi_coupon by couponId") ;
			
			exists = YES;
			break ;
			
		}
		
		sqlite3_finalize(compiledStatement);
	}
	else{
		NSLog(@"Some problem in compiling statement") ;
	}
	[dbm closeDatabase:database];
	[dbm release];
	
	return exists;
	
	
}
-(BOOL) deleteAll{
	BOOL deleted = NO ;
	
	DBManager *dbm = [[DBManager alloc]init];
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "delete from poi_coupon";
	sqlite3_stmt *compiledStatement;
	
	
	
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	else{
		
		//sqlite3_bind_text(compiledStatement, 1, [cpn.couponId UTF8String], -1, SQLITE_TRANSIENT);
		//sqlite3_bind_text(compiledStatement, 2, [cpn.poiId UTF8String], -1, SQLITE_TRANSIENT);
		
		int success = sqlite3_step(compiledStatement);
		if (success == SQLITE_ERROR) {
			NSAssert1(0, @"Error: failed to delete coupon with message '%s'.", sqlite3_errmsg(database));
		} else {
			deleted = YES;
		}
		
	}
	
	sqlite3_finalize(compiledStatement);
	
	[dbm closeDatabase:database];
	[dbm release];
	
	if(deleted){
		{
			/*BOOL exists = [self findInPoiCouponByCouponId:[cpn.couponId intValue]];	
			if(!exists){
				[self deleteByCouponId:[cpn.couponId intValue]];
			}*/
			[self deleteCoupons];
			
			/*NSMutableArray *cpns = [self findByPoiId:[cpn.poiId intValue]];
			if([cpns count]==0){
				NSLog(@"No more coupons for this Poi, deleting poi");
				PoiManager *pm = [[PoiManager alloc]init];
				[pm deletePoiById:[cpn.poiId intValue]];
				[pm release];
				[cpns release];
			}
			else{
				NSLog(@"More coupons exists for this poi");
				[cpns release];
			}*/
			PoiManager *pm = [[PoiManager alloc]init];
			[pm deletePois];
			[pm release];
			
		}
	}
	
	return deleted;
	
}


-(BOOL) deleteCoupon: (Coupon*)cpn{
	BOOL deleted = NO ;
	
	DBManager *dbm = [[DBManager alloc]init];
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "delete from poi_coupon where couponId=? and poiId=?";
	sqlite3_stmt *compiledStatement;
	
	
	
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	else{
		
		sqlite3_bind_text(compiledStatement, 1, [cpn.couponId UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 2, [cpn.poiId UTF8String], -1, SQLITE_TRANSIENT);
    
		int success = sqlite3_step(compiledStatement);
		if (success == SQLITE_ERROR) {
			NSAssert1(0, @"Error: failed to delete coupon with message '%s'.", sqlite3_errmsg(database));
		} else {
			deleted = YES;
		}

	}
	
	sqlite3_finalize(compiledStatement);
	
	[dbm closeDatabase:database];
	[dbm release];
	
	if(deleted){
		{
			BOOL exists = [self findInPoiCouponByCouponId:[cpn.couponId intValue]];	
			if(!exists){
				[self deleteByCouponId:[cpn.couponId intValue]];
			}
			
			NSMutableArray *cpns = [self findByPoiId:[cpn.poiId intValue]];
			if([cpns count]==0){
				NSLog(@"No more coupons for this Poi, deleting poi");
				PoiManager *pm = [[PoiManager alloc]init];
				[pm deletePoiById:[cpn.poiId intValue]];
				[pm release];
				[cpns release];
			}
			else{
				NSLog(@"More coupons exists for this poi");
				[cpns release];
			}
			
		}
	}
	
	return deleted;
	
}

-(int) getExpiredCouponsCount{
	DBManager *dbm = [[DBManager alloc]init];
	int totalCount = -1;
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "select count(*) from coupon where coupon.validTo <= ?";
	sqlite3_stmt *compiledStatement;
	
	double validTo = [RivePointAppDelegate getCurrentDate];
	
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		sqlite3_bind_double(compiledStatement, 1, validTo);
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read the data from the result row
			NSLog(@"Getting total coupons count") ;
			
			totalCount = sqlite3_column_int(compiledStatement, 0);
			
			break;			
		}
		
		sqlite3_finalize(compiledStatement);
	}
	else{
		NSLog(@"Some problem in compiling statement") ;
	}
	[dbm closeDatabase:database];
	[dbm release];
	
	return totalCount;
	
}


@end
