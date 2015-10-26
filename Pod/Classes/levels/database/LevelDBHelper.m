//
//  LevelDBHelper.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 16/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "LevelDBHelper.h"

#import "Pack.h"
#import "Media.h"

@implementation LevelDBHelper

#pragma mark - Level

- (void)assignMediaValuesWithStatement:(sqlite3_stmt *)statement andMedia:(Media *)media {
    for (int i=0; i<sqlite3_column_count(statement); i++) {
        if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"id"]) {
            //Id
            [media setIdentifier:sqlite3_column_int(statement, i)];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"title"]) {
            //Title
            [media setTitle:[self getStringWithStatement:statement andPosition:i]];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"rects"]) {
            //Blur rect
            NSString * blurRectString = [self getStringWithStatement:statement andPosition:i];
            [media setRects:blurRectString];
            
            NSArray * rectValues = [blurRectString componentsSeparatedByString:@";"];
            
            if (([rectValues count] % 4) == 0) {
                NSMutableArray * topLeftBlurRects = [NSMutableArray array];
                NSMutableArray * bottomRightBlurRects = [NSMutableArray array];
                
                for (int i=0; i<[rectValues count]; i+=4) {
                    CGPoint topLeft = CGPointMake([[rectValues objectAtIndex:i+0] floatValue], [[rectValues objectAtIndex:i+1] floatValue]);
                    CGPoint bottomRight = CGPointMake([[rectValues objectAtIndex:i+2] floatValue], [[rectValues objectAtIndex:i+3] floatValue]);
                    
                    [topLeftBlurRects addObject:[NSValue valueWithCGPoint:topLeft]];
                    [bottomRightBlurRects addObject:[NSValue valueWithCGPoint:bottomRight]];
                }
                
                [media setTopLeftBlurRects:topLeftBlurRects];
                [media setBottomRightBlurRects:bottomRightBlurRects];
            }
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"difficulty"]) {
            //Difficulty
            [media setDifficulty:sqlite3_column_int(statement, i)];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"language"]) {
            //Language
            [media setLanguage:[self getStringWithStatement:statement andPosition:i]];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"variants"]) {
            //Variants
            NSString * strVariants = [self getStringWithStatement:statement andPosition:i];
            [media setStrVariants:strVariants];
            
            if (![strVariants isEqualToString:@""]) {
                NSArray * variants = [strVariants componentsSeparatedByString:@";"];
                [media setVariants:variants];
            }
        }
    }
}

- (NSArray *)getMedias:(Pack *)pack {
    NSMutableArray * medias = nil;
    
    float sumDifficulty = 0;
    float nbMedias = 0;
    
    NSString * request = [NSString stringWithFormat:@"SELECT * FROM medias m, packs_medias pm WHERE pm.pack_id = %d AND m.id = pm.media_id ORDER BY pm.position ASC;", pack.identifier];
    sqlite3_stmt * sqlStatement = [self executeSelect:request];
    
    while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
        if (medias == nil) {
            medias = [[NSMutableArray alloc] init];
        }
        
        Media * currentMedia = [Media Media];
        [self assignMediaValuesWithStatement:sqlStatement andMedia:currentMedia];
        sumDifficulty += currentMedia.difficulty;
        
        [medias addObject:currentMedia];
        
        nbMedias++;
    }
    
    sqlite3_finalize(sqlStatement);
    [self closeDatabase];
    
    [pack setDifficulty:(sumDifficulty/nbMedias)];
    
    return medias;
}

- (void)assignPackValuesWithStatement:(sqlite3_stmt *)statement andPack:(Pack *)pack {
    for (int i=0; i<sqlite3_column_count(statement); i++) {
        if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"id"]) {
            //Id
            [pack setIdentifier:sqlite3_column_int(statement, i)];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"title"]) {
            //Title
            [pack setTitle:[self getStringWithStatement:statement andPosition:i]];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"language"]) {
            //Language
            [pack setLanguage:[self getStringWithStatement:statement andPosition:i]];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"level_id"]) {
            //Level id
            [pack setLevelId:sqlite3_column_int(statement, i)];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"extra1"]) {
            //Extra1
            [pack setExtra1:[self getStringWithStatement:statement andPosition:i]];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"extra2"]) {
            //Extra2
            [pack setExtra2:[self getStringWithStatement:statement andPosition:i]];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"extra3"]) {
            //Extra3
            [pack setExtra3:[self getStringWithStatement:statement andPosition:i]];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"fextra1"]) {
            //FExtra1
            [pack setFExtra1:sqlite3_column_double(statement, i)];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"fextra2"]) {
            //FExtra2
            [pack setFExtra2:sqlite3_column_double(statement, i)];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"fextra3"]) {
            //FExtra3
            [pack setFExtra3:sqlite3_column_double(statement, i)];
        }
    }
}

- (NSDictionary *)getPacks {
    NSMutableDictionary * packs = nil;
    
    NSString * request = @"SELECT * FROM packs;";
    sqlite3_stmt * sqlStatement = [self executeSelect:request];
    
    while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
        if (packs == nil) {
            packs = [NSMutableDictionary dictionary];
        }
        
        Pack * currentPack = [Pack Pack];
        [self assignPackValuesWithStatement:sqlStatement andPack:currentPack];
        
        [packs setObject:currentPack forKey:[NSNumber numberWithInt:currentPack.identifier]];
    }
    
    sqlite3_finalize(sqlStatement);
    [self closeDatabase];
    
    //Medias
    for (NSNumber * packId in packs) {
        Pack * pack = [packs objectForKey:packId];
        
        NSArray * medias = [self getMedias:pack];
        [pack setMedias:medias];
    }
    
    return packs;
}

- (void)assignLevelValuesWithStatement:(sqlite3_stmt *)statement andLevel:(Level *)level {
    for (int i=0; i<sqlite3_column_count(statement); i++) {
        if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"id"]) {
            //Id
            [level setIdentifier:sqlite3_column_int(statement, i)];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"value"]) {
            //Value
            [level setValue:sqlite3_column_int(statement, i)];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"difficulty_id"]) {
            //Difficulty
            [level setDifficultyId:sqlite3_column_int(statement, i)];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"release_date"]) {
            //Release date
            int timeStamp = sqlite3_column_int(statement, i);
            NSDate * releaseDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
            
            [level setReleaseDate:releaseDate];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"language"]) {
            //Language
            [level setLanguage:[self getStringWithStatement:statement andPosition:i]];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"extra1"]) {
            //Extra1
            [level setExtra1:[self getStringWithStatement:statement andPosition:i]];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"extra2"]) {
            //Extra2
            [level setExtra2:[self getStringWithStatement:statement andPosition:i]];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"extra3"]) {
            //Extra3
            [level setExtra3:[self getStringWithStatement:statement andPosition:i]];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"fextra1"]) {
            //FExtra1
            [level setFExtra1:sqlite3_column_double(statement, i)];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"fextra2"]) {
            //FExtra2
            [level setFExtra2:sqlite3_column_double(statement, i)];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"fextra3"]) {
            //FExtra3
            [level setFExtra3:sqlite3_column_double(statement, i)];
        }
    }
}

- (Level *)getLevel {
    Level * level = nil;
    
    sqlite3_stmt * statement = [self executeSelect:@"SELECT * FROM levels;"];
    
    if (sqlite3_step(statement) == SQLITE_ROW) {
        if (level == nil) {
            level = [Level Level];
        }
        
        [self assignLevelValuesWithStatement:statement andLevel:level];
        [level setPacks:[self getPacks]];
    }
    
    sqlite3_finalize(statement);
    [self closeDatabase];
    
    return level;
}

+ (Level *)getLevel:(NSString *)databasePath {
    LevelDBHelper * dbHelper = [[LevelDBHelper alloc] initWithDatabasePath:databasePath];
    Level * level = [dbHelper getLevel];
            
    return level;
}

@end
