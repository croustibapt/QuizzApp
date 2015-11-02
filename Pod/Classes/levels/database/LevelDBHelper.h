//
//  LevelDBHelper.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 16/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "DBHelper.h"
#import "Level.h"

@interface LevelDBHelper : DBHelper

#pragma mark - Level

+ (Level *)getLevel:(NSString *)databasePath;

@end
