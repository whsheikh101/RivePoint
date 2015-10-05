//
//  DBManager.m
//  RivePoint
//
//  Created by Shahzad Mughal on 2/18/09.
//  Copyright 2009 Rivepoint. All rights reserved.
//

#import "DBManager.h"


@implementation DBManager

-(NSString*) getDatabaseName{
	if(databaseName==nil){
		databaseName = [[NSString alloc] initWithString:@"rivepoint-coupon.sql"];
	}
	return databaseName;
}

-(NSString*) getDeviceDbPath {
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	deviceDbPath = [documentsDir stringByAppendingPathComponent:[self getDatabaseName]];
	return deviceDbPath;
}

-(NSString*) getDatabasePath {
	//Get the path to the database in the application package
	databasePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[self getDatabaseName]];
	return databasePath;
}

-(void) checkAndCreateDatabase{
	
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	
//	NSString *dbName = [self getDatabaseName];
	NSString *masterDb = [self getDatabasePath];
	NSString *deviceDb= [self getDeviceDbPath] ;
	NSError *errorStr;	
//	NSLog(@"databaseName=%@" , dbName);
//	NSLog(@"masterDB=%@" , masterDb);
//	NSLog(@"deviceDB=%@" , deviceDb);
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];

	// Check if the database has already been created in the users filesystem i.e. device
	success = [fileManager fileExistsAtPath:deviceDb];
	
	// If the database already exists then return without doing anything
	if(success){ 
		return;
	}
	
//	NSLog(@"Creating DB");
	
	// If not then proceed to copy the database from the application to the users filesystem
	// Copy the database from the package to the users filesystem
	success = [fileManager copyItemAtPath:masterDb toPath:deviceDb error:&errorStr];
	
	if(!success){
		NSLog(@"failed to create db error = %@" , errorStr);
	}
	else{
		NSLog(@"db created successfully") ;
	}
	
	[fileManager release];

}
-(BOOL) replaceDatabase{
	
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	
	NSString *dbName = [self getDatabaseName];
	NSString *masterDb = [self getDatabasePath];
	NSString *deviceDb= [self getDeviceDbPath] ;
	NSError *errorStr;	
	NSLog(@"databaseName=%@" , dbName);
	NSLog(@"masterDB=%@" , masterDb);
	NSLog(@"deviceDB=%@" , deviceDb);
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem i.e. device
	success = [fileManager fileExistsAtPath:deviceDb];
/*	
	// If the database already exists then return without doing anything
	if(success){ 
		NSLog(@"Db already exists");
		return;
	}
*/	
	
	// If not then proceed to copy the database from the application to the users filesystem
	// Copy the database from the package to the users filesystem
	[fileManager removeItemAtPath:deviceDb error:nil];
	
	
	success = [fileManager copyItemAtPath:masterDb toPath:deviceDb error:&errorStr];
	
	if(!success){
		NSLog(@"failed to create db error = %@" , errorStr);
	}
	else{
		NSLog(@"db created successfully") ;
	}
	
	[fileManager release];
	return success;
}
-(sqlite3*) openDatabase{
	sqlite3 *database;
	NSString *dbPath = [self getDeviceDbPath];
	
	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		NSLog(@"Database esuccessfully opened") ;
	}
	else{
		NSLog(@"Failed to open database.");
	}
	return database ;
}

-(void) closeDatabase: (sqlite3*) database {
	sqlite3_close(database);
}

-(void)dealloc {
	[databaseName release];
	[super dealloc];
}
@end
