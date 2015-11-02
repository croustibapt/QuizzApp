//
//  DBHelper.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 14/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBHelper : NSObject {

@protected
    //SQLITE database
    sqlite3 * m_database;
}

@property (nonatomic, retain) NSString * databasePath;

- (id)initWithDatabasePath:(NSString *)databasePath;

- (Boolean)openDatabase;

- (void)closeDatabase;

- (NSString *)getStringWithStatement:(sqlite3_stmt *)statement andPosition:(int)position;

- (sqlite3_stmt *)executeSelect:(NSString *)request;

- (Boolean)executeRequest:(NSString *)request;

- (sqlite_int64)executeInsert:(NSString *)request;

@end
