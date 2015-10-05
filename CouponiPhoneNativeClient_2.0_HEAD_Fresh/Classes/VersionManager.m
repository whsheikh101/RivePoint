//
//  VersionManager.m
//  RivePoint
//
//  Created by Muhammad Hammad Ayaz on 6/10/10.
//  Copyright 2010 Netpace Systems Pvt Ltd. All rights reserved.
//

#import "VersionManager.h"
#import "DBManager.h"

@implementation VersionManager
-(BOOL)isTableExist{
	
	BOOL isExist = YES ;
	DBManager *dbm = [[DBManager alloc]init];
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "select * from version";
	sqlite3_stmt *compiledStatement;
	
	
	
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		isExist = NO;
	}
	
	
	sqlite3_finalize(compiledStatement);
	
	[dbm closeDatabase:database];
	[dbm release];
	
	return isExist;
}
-(NSString *) getVersion {
	
	DBManager *dbm = [[DBManager alloc]init];
	
	NSString *versionNo = nil;
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "select * from version";
	sqlite3_stmt *compiledStatement;
	
	
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read the data from the result row
			
			
			char *str =  nil;
			
			//int pk = sqlite3_column_int(compiledStatement, 0);
			
			str = (char *)sqlite3_column_text(compiledStatement, 0);
			versionNo = (str) ? [NSString stringWithUTF8String:str] : @"";
			str = nil ;
			
			break;
			
		}
		
		sqlite3_finalize(compiledStatement);
	}
	else{
		NSLog(@"Some problem in compiling statement") ;
	}
	[dbm closeDatabase:database];
	[dbm release];
	
	return versionNo;
}
-(BOOL) insert: (NSString*) version{
	BOOL saved = NO ;
	DBManager *dbm = [[DBManager alloc]init];
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "insert into version (versionNo) values (?)";
	sqlite3_stmt *compiledStatement;
	
	
	
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	else{
		
		sqlite3_bind_text(compiledStatement, 1, [version UTF8String], -1, SQLITE_TRANSIENT);
		
		int success = sqlite3_step(compiledStatement);
		if (success == SQLITE_ERROR) {
			NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
		} else {
			saved = YES;
		}
	}	
	
	sqlite3_finalize(compiledStatement);
	
	[dbm closeDatabase:database];
	[dbm release];
	
	
	return saved;
	
}
-(BOOL) update: (NSString*) version{
	BOOL updated = NO ;
	DBManager *dbm = [[DBManager alloc]init];
	sqlite3 *database = [dbm openDatabase];
	
	const char *sqlStatement = "update version set versionNo=?";
	sqlite3_stmt *compiledStatement;
	
	
	
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	else{
		
		sqlite3_bind_text(compiledStatement, 1, [version UTF8String], -1, SQLITE_TRANSIENT);		
		
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
@end
