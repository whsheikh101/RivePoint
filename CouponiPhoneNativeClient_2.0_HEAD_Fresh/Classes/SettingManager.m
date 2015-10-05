//
//  SettingsManager.m
//  RivePoint
//
//  Created by Shahzad Mughal on 2/18/09.
//  Copyright 2009 Rivepoint. All rights reserved.
//

#import "SettingManager.h"
#import "Setting.h"
#import "DBManager.h"


@implementation SettingManager

-(BOOL) save: (Setting*) setting{
	BOOL saved = NO ;
	DBManager *dbm = [[DBManager alloc]init];
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "insert into settings (deviceId,email,zip,longitude,latitude,city,county,state,country,enableGPS,gpsAccuracy) values (?,?,?,?,?,?,?,?,?,?,?)";
	sqlite3_stmt *compiledStatement;
	


    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	else{
		
		sqlite3_bind_text(compiledStatement, 1, [setting.deviceId UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 2, [setting.email UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 3, [setting.zip UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 4, [setting.longitute UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 5, [setting.latitude UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 6, [setting.city UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 7, [setting.county UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 8, [setting.state UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 9, [setting.country UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 10, [setting.enableGPS UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 11, [setting.gpsAccuracy UTF8String], -1, SQLITE_TRANSIENT);
		
		int success = sqlite3_step(compiledStatement);
		if (success == SQLITE_ERROR) {
			NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
		} else {
			setting.pk = sqlite3_last_insert_rowid(database);
			saved = YES;
		}
	}
	
	sqlite3_finalize(compiledStatement);
	
	[dbm closeDatabase:database];
	[dbm release];

	
	return saved;
}

-(BOOL) updateSubsId: (Setting*) setting{
	BOOL updated = NO ;
	DBManager *dbm = [[DBManager alloc]init];
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "update settings set subsId=? where deviceId=?";
	sqlite3_stmt *compiledStatement;
	
	
	
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	else{
		
		sqlite3_bind_text(compiledStatement, 1, [setting.subsId UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 2, [setting.deviceId UTF8String], -1, SQLITE_TRANSIENT);
		
		int success = sqlite3_step(compiledStatement);
		if (success == SQLITE_ERROR) {
			NSAssert1(0, @"Error: failed to update setting's email in database with message '%s'.", sqlite3_errmsg(database));
		} else {
			updated = YES;
		}
		
	}
	
	sqlite3_finalize(compiledStatement);
	
	[dbm closeDatabase:database];
	[dbm release];
	
	
	return updated;
}

-(BOOL) update: (Setting*) setting{
	BOOL updated = NO ;
	DBManager *dbm = [[DBManager alloc]init];
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "update settings set email=?,zip=?,longitude=?,latitude=?,city=?,county=?,state=?,country=?,enableGPS=?,gpsAccuracy=? where deviceId=?";
	sqlite3_stmt *compiledStatement;
	
	
	
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	else{
		
		sqlite3_bind_text(compiledStatement, 1, [setting.email UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 2, [setting.zip UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 3, [setting.longitute UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 4, [setting.latitude UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 5, [setting.city UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 6, [setting.county UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 7, [setting.state UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 8, [setting.country UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 9, [setting.enableGPS UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 10, [setting.gpsAccuracy UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(compiledStatement, 11, [setting.deviceId UTF8String], -1, SQLITE_TRANSIENT);
		
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

-(Setting*) find {

	DBManager *dbm = [[DBManager alloc]init];
//	Setting * s = [[Setting alloc] init];
	Setting *s = nil;
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "select * from settings";
	sqlite3_stmt *compiledStatement;

	
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read the data from the result row
			
			
			char *str =  nil;
			
			int pk = sqlite3_column_int(compiledStatement, 0);
			
			str = (char *)sqlite3_column_text(compiledStatement, 1);
			NSString *deviceId = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 2);
			NSString *email = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;

			str = (char *)sqlite3_column_text(compiledStatement, 3);
			NSString *zip = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 4);
			NSString *longitute = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 5);
			NSString *latitude = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 6);
			NSString *city = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 7);
			NSString *county = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 8);
			NSString *state = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 9);
			NSString *country = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 10);
			NSString *enableGPS = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 11);
			NSString *gpsAccuracy = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			str = (char *)sqlite3_column_text(compiledStatement, 12);
			NSString *subsId = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			// Fill Setting object with the data from the database
			
            s = [[Setting alloc] init];
			s.pk = pk;
			s.deviceId = deviceId ;
			s.email = email;
			s.zip = zip;
			s.longitute = longitute;
			s.latitude = latitude;
			s.city = city;
			s.county =county;
			s.country = country;
			s.state = state;
			s.enableGPS = enableGPS ;
			s.gpsAccuracy = gpsAccuracy;
			s.subsId=subsId;
			
			/*
			NSLog(@"pk = %d" ,s.pk);
			NSLog(@"deviceId = %@" ,s.deviceId);
			NSLog(@"email = %@" ,s.email);
			NSLog(@"zip = %@" ,s.zip);
			NSLog(@"longitude = %@" ,s.longitute);
			NSLog(@"latitude = %@" ,s.latitude);
			NSLog(@"city = %@" ,s.city);
			NSLog(@"county = %@" ,s.county);
			NSLog(@"ountry = %@" ,s.country);
			NSLog(@"state = %@" ,s.state);
			NSLog(@"enableGPS = %@" ,s.enableGPS);
			NSLog(@"gpsAccuracy = %@" ,s.gpsAccuracy);
			*/
			break;

		}
		
		sqlite3_finalize(compiledStatement);
	}
	else{
		NSLog(@"Some problem in compiling statement") ;
	}
	[dbm closeDatabase:database];
	[dbm release];
	
	return s;
}

@end
