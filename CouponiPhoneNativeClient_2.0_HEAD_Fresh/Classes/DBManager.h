//
//  DBManager.h
//  RivePoint
//
//  Created by Shahzad Mughal on 2/18/09.
//  Copyright 2009 Rivepoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h> //import sqlite3 database

@interface DBManager : NSObject {

	
	NSString *databaseName;//this holds the db file name
	NSString *databasePath;//the master db file path that bundles with application
	NSString *deviceDbPath;//db path with respect to device
	
}
-(NSString*) getDatabaseName;
-(NSString*) getDatabasePath;
-(NSString*) getDeviceDbPath;
-(void) checkAndCreateDatabase;
-(BOOL) replaceDatabase;
-(sqlite3*) openDatabase;
-(void) closeDatabase: (sqlite3*) database ;

@end
