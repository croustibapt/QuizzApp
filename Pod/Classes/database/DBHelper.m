//
//  DBHelper.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 14/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "DBHelper.h"

@implementation DBHelper

- (id)initWithDatabasePath:(NSString *)databasePath {
    self = [super init];
    if (self) {
        //Get the path to the documents directory and append the databaseName
        self.databasePath = databasePath;
        
        if (![self checkDatabase]) {
            NSLog(@"Database not found : %@", databasePath);
        }
    }
    return self;
}

- (Boolean)checkDatabase {
    Boolean success;
	NSFileManager * fileManager = [NSFileManager defaultManager];
	success = [fileManager fileExistsAtPath:self.databasePath];
    return success;
}

- (Boolean)openDatabase {
    Boolean returnValue = NO;
    
    returnValue = (sqlite3_open([self.databasePath UTF8String], &m_database) == SQLITE_OK);
    
    return returnValue;
}

- (void)closeDatabase {
    sqlite3_close(m_database);
}

- (NSString *)getStringWithStatement:(sqlite3_stmt *)statement andPosition:(int)position {
    NSString * returnString = @"";
    char * string = (char *)sqlite3_column_text(statement, position);
    
    if (string != nil) {
        returnString = [NSString stringWithUTF8String:string];
    }
    
    return returnString;
}

- (sqlite3_stmt *)executeSelect:(NSString *)request {
    [self openDatabase];
    
    //NSLog(@"%@", request);
    sqlite3_stmt * compiledStatement;
    
    if (sqlite3_prepare_v2(m_database, [request cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStatement, NULL) == SQLITE_OK) {
        return compiledStatement;
    } else {
        NSLog(@"%@", [NSString stringWithUTF8String:(char *)sqlite3_errmsg(m_database)]);
//        NSLog(@"Select error");
        return nil;
    }
}

- (Boolean)executeRequest:(NSString *)request {
    [self openDatabase];
    Boolean returnValue = YES;
    
    request = [request stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    NSLog(@"%@", request);
    
    int result = sqlite3_exec(m_database, [request cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL);
    
    if (result != SQLITE_OK) {
        //an error occured
        NSLog(@"%@", [NSString stringWithUTF8String:(char *)sqlite3_errmsg(m_database)]);
        returnValue = NO;
    }
    
    [self closeDatabase];
    
    return returnValue;
}

- (sqlite_int64)executeInsert:(NSString *)request {
    [self openDatabase];
    sqlite_int64 returnValue = -1;
    
    request = [request stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    NSLog(@"%@", request);
    
    int result = sqlite3_exec(m_database, [request cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL);
    
    if (result == SQLITE_OK) {
        returnValue = sqlite3_last_insert_rowid(m_database);
    } else {
        //An error occured
        NSLog(@"%@", [NSString stringWithUTF8String:(char *)sqlite3_errmsg(m_database)]);
    }
    
    [self closeDatabase];
    
    return returnValue;
}

@end
