//
//  SettingsManager.h
//  RivePoint
//
//  Created by Shahzad Mughal on 2/18/09.
//  Copyright 2009 Rivepoint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h> //import sqlite3 database
#import "Setting.h" 


@interface SettingManager : NSObject {

}
 
-(Setting*) find;
-(BOOL) save: (Setting*) setting;
-(BOOL) update: (Setting*) setting;
-(BOOL) updateSubsId: (Setting*) setting;

@end
