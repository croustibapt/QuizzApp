//
//  GameDBHelper.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 16/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "GameDBHelper.h"

#import "Media.h"
#import "LevelDBHelper.h"
#import "Constants.h"

@implementation PackMedia

@synthesize packId;
@synthesize mediaId;
@synthesize position;
@synthesize fExtra1;

- (id)initWithPackId:(int)aPackId andMediaId:(int)aMediaId andPosition:(int)aPosition andFExtra1:(float)aFExtra1 {
    self = [super init];
    if (self) {
        [self setPackId:aPackId];
        [self setMediaId:aMediaId];
        [self setPosition:aPosition];
        [self setFExtra1:aFExtra1];
    }
    return self;
}

+ (PackMedia *)packMediaWithPackId:(int)packId andMediaId:(int)mediaId andPosition:(int)position andFextra1:(float)aFExtra1 {
    PackMedia * packMedia = [[PackMedia alloc] initWithPackId:packId andMediaId:mediaId andPosition:position andFExtra1:aFExtra1];
    return packMedia;
}

@end

@implementation GameDBHelper

static GameDBHelper * s_gameDBHelperInstance;

+ (Boolean)copyDatabaseFrom:(NSString *)databasePath to:(NSString *)localGameDatabasePath {
    NSError * error = nil;
    NSFileManager * fm = [NSFileManager defaultManager];
    
    if (![fm fileExistsAtPath:localGameDatabasePath] && (databasePath != nil)) {
        [fm copyItemAtPath:databasePath toPath:localGameDatabasePath error:&error];
    }
    
    return (error == nil);
}

+ (GameDBHelper *)instance {
    if (s_gameDBHelperInstance == nil) {
        NSBundle * bundle = QUIZZ_APP_BUNDLE;
        
        NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString * localGameDatabasePath = [documentsDirectory stringByAppendingPathComponent:@"/Caches/game.sqlite"];

        NSString * gameDatabasePath = [bundle pathForResource:QUIZZ_APP_GAME_DATABASE_NAME ofType:@"sqlite"];
        if ([GameDBHelper copyDatabaseFrom:gameDatabasePath to:localGameDatabasePath]) {
            s_gameDBHelperInstance = [[GameDBHelper alloc] initWithDatabasePath:localGameDatabasePath];
        }
    }
    
    return s_gameDBHelperInstance;
}

#pragma mark - Difficulty

- (void)assignDifficultyValuesWithStatement:(sqlite3_stmt *)statement andDifficulty:(Difficulty *)difficulty {
    for (int i=0; i<sqlite3_column_count(statement); i++) {
        if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"id"]) {
            //Id
            [difficulty setIdentifier:sqlite3_column_int(statement, i)];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"name"]) {
            //Name
            [difficulty setName:[self getStringWithStatement:statement andPosition:i]];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"enume_value"]) {
            //Enum value
            [difficulty setEnumValue:sqlite3_column_int(statement, i)];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"language"]) {
            //Language
            [difficulty setLanguage:[self getStringWithStatement:statement andPosition:i]];
        }
    }
}

- (Difficulty *)getDifficulty:(int)difficultyId {
    GameDBHelper * dbHelper = [GameDBHelper instance];
    
    Difficulty * difficulty = nil;
    sqlite3_stmt * statement = [dbHelper executeSelect:[NSString stringWithFormat:@"SELECT * FROM difficulties WHERE id = %d;", difficultyId]];
    
    if (sqlite3_step(statement) == SQLITE_ROW) {
        if (difficulty == nil) {
            difficulty = [Difficulty Difficulty];
        }
        
        [dbHelper assignDifficultyValuesWithStatement:statement andDifficulty:difficulty];
    }
    
    sqlite3_finalize(statement);
    [dbHelper closeDatabase];
    
    return difficulty;
}

+ (void)addDifficulty:(Difficulty *)difficulty {
    GameDBHelper * dbHelper = [GameDBHelper instance];

    //Check if not exists
    if ([dbHelper getDifficulty:difficulty.identifier] == nil) {
        NSString * request = [NSString stringWithFormat:@"INSERT INTO difficulties (id, name, enum_value, language) VALUES (%d, '%@', %d, '%@');", difficulty.identifier, difficulty.name, difficulty.enumValue, difficulty.language];
        [dbHelper executeInsert:request];
    }
}

+ (NSMutableDictionary *)getDifficulties:(NSString *)language {
    GameDBHelper * dbHelper = [GameDBHelper instance];
    NSMutableDictionary * difficulties = nil;
    
    NSString * request = [NSString stringWithFormat:@"SELECT * FROM difficulties WHERE language = '%@';", language];
    sqlite3_stmt * sqlStatement = [dbHelper executeSelect:request];
    
    while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
        if (difficulties == nil) {
            difficulties = [[NSMutableDictionary alloc] init];
        }
        
        Difficulty * currentDifficulty = [Difficulty Difficulty];
        [dbHelper assignDifficultyValuesWithStatement:sqlStatement andDifficulty:currentDifficulty];
        
        [difficulties setObject:currentDifficulty forKey:[NSNumber numberWithInt:currentDifficulty.identifier]];
    }
    
    sqlite3_finalize(sqlStatement);
    [dbHelper closeDatabase];
    
    return difficulties;
}

#pragma mark - Level

- (void)packsMediasTransaction:(NSArray *)packsMedias {
    //SQL query
    const char * query = "INSERT INTO packs_medias (pack_id, media_id, position, completed) VALUES (?, ?, ?, ?);";
    sqlite3_stmt * packsMediasStatement = nil;
    
    if (sqlite3_prepare(m_database, query, -1, &packsMediasStatement, NULL) == SQLITE_OK) {
        for (PackMedia * packMedia in packsMedias) {
            //Migration
            Boolean isMediaCompleted = [GameDBHelper isPackFinishedInMovieQuizz1:(int)round(packMedia.fExtra1)];
            
            sqlite3_bind_int(packsMediasStatement, 1, packMedia.packId);
            sqlite3_bind_int(packsMediasStatement, 2, packMedia.mediaId);
            sqlite3_bind_int(packsMediasStatement, 3, packMedia.position);
            sqlite3_bind_int(packsMediasStatement, 4, isMediaCompleted);
            
            if (sqlite3_step(packsMediasStatement) != SQLITE_DONE) {
                NSLog(@"SQL Error: %s", sqlite3_errmsg(m_database));
            }
            
            sqlite3_reset(packsMediasStatement);
        }
        
        if (sqlite3_finalize(packsMediasStatement) != SQLITE_OK) {
            NSLog(@"SQL Error: %s", sqlite3_errmsg(m_database));
        }
    } else {
        NSLog(@"SQL Error: %s", sqlite3_errmsg(m_database));
    }
}

- (void)mediasTransaction:(NSArray *)medias {
    //SQL query
    const char * query = "INSERT INTO medias (id, title, rects, difficulty, language, variants) VALUES (?, ?, ?, ?, ?, ?);";
    sqlite3_stmt * mediasStatement = nil;
    
    if (sqlite3_prepare(m_database, query, -1, &mediasStatement, NULL) == SQLITE_OK) {
        for (Media * media in medias) {
            sqlite3_bind_int(mediasStatement, 1, media.identifier);
            sqlite3_bind_text(mediasStatement, 2, [media.title UTF8String], -1, NULL);
            sqlite3_bind_text(mediasStatement, 3, [media.rects UTF8String], -1, NULL);
            sqlite3_bind_int(mediasStatement, 4, media.difficulty);
            sqlite3_bind_text(mediasStatement, 5, [media.language UTF8String], -1, NULL);
            sqlite3_bind_text(mediasStatement, 6, [media.strVariants UTF8String], -1, NULL);
            
            if (sqlite3_step(mediasStatement) != SQLITE_DONE) {
                NSLog(@"SQL Error: %s", sqlite3_errmsg(m_database));
            }
            
            sqlite3_reset(mediasStatement);
        }
        
        if (sqlite3_finalize(mediasStatement) != SQLITE_OK) {
            NSLog(@"SQL Error: %s", sqlite3_errmsg(m_database));
        }
    } else {
        NSLog(@"SQL Error: %s", sqlite3_errmsg(m_database));
    }
}

- (void)packsTransactionsWithPacks:(NSArray *)packs andLevelId:(int)levelId {
    //SQL query
    const char * query = "INSERT INTO packs (id, level_id, title, author, language, extra1, extra2, extra3, fextra1, fextra2, fextra3) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
    sqlite3_stmt * packsStatement = nil;
    
    if (sqlite3_prepare(m_database, query, -1, &packsStatement, NULL) == SQLITE_OK) {
        for (Pack * pack in packs) {
            sqlite3_bind_int(packsStatement, 1, pack.identifier);
            sqlite3_bind_int(packsStatement, 2, levelId);
            sqlite3_bind_text(packsStatement, 3, [pack.title UTF8String], -1, NULL);
            sqlite3_bind_text(packsStatement, 4, [pack.author UTF8String], -1, NULL);
            sqlite3_bind_text(packsStatement, 5, [pack.language UTF8String], -1, NULL);
            
            sqlite3_bind_text(packsStatement, 6, [pack.extra1 UTF8String], -1, NULL);
            sqlite3_bind_text(packsStatement, 7, [pack.extra2 UTF8String], -1, NULL);
            sqlite3_bind_text(packsStatement, 8, [pack.extra3 UTF8String], -1, NULL);

            sqlite3_bind_double(packsStatement, 9, pack.fExtra1);
            sqlite3_bind_double(packsStatement, 10, pack.fExtra2);
            sqlite3_bind_double(packsStatement, 11, pack.fExtra3);
            
            if (sqlite3_step(packsStatement) != SQLITE_DONE) {
                NSLog(@"SQL Error: %s", sqlite3_errmsg(m_database));
            }
            
            sqlite3_reset(packsStatement);
        }
        
        if (sqlite3_finalize(packsStatement) != SQLITE_OK) {
            NSLog(@"SQL Error: %s", sqlite3_errmsg(m_database));
        }
    } else {
        NSLog(@"SQL Error: %s", sqlite3_errmsg(m_database));
    }
}

- (void)levelsTransaction:(NSArray *)levels {
    //SQL query
    const char * query = "INSERT INTO levels (id, value, difficulty_id, release_date, language) VALUES (?, ?, ?, ?, ?);";
    sqlite3_stmt * levelsStatement = nil;
    
    if (sqlite3_prepare(m_database, query, -1, &levelsStatement, NULL) == SQLITE_OK) {
        for (Level * level in levels) {
            sqlite3_bind_int(levelsStatement, 1, level.identifier);
            sqlite3_bind_int(levelsStatement, 2, level.value);
            sqlite3_bind_int(levelsStatement, 3, level.difficultyId);
            sqlite3_bind_int(levelsStatement, 4, (int)[level.releaseDate timeIntervalSince1970]);
            sqlite3_bind_text(levelsStatement, 5, [level.language UTF8String], -1, NULL);
            
            if (sqlite3_step(levelsStatement) != SQLITE_DONE) {
                NSLog(@"SQL Error: %s", sqlite3_errmsg(m_database));
            }
            
            sqlite3_reset(levelsStatement);
        }
        
        if (sqlite3_finalize(levelsStatement) != SQLITE_OK) {
            NSLog(@"SQL Error: %s", sqlite3_errmsg(m_database));
        }
    } else {
        NSLog(@"SQL Error: %s", sqlite3_errmsg(m_database));
    }
}

- (Boolean)addLevel:(Level *)level {
    if (level == nil) {
        return NO;
    }
    
    Boolean returnValue = YES;
    
    NSMutableArray * packs = [NSMutableArray array];
    NSMutableArray * medias = [NSMutableArray array];
    NSMutableArray * packsMedias = [NSMutableArray array];
    
    //Loop on packs
    for (NSNumber * packId in level.packs) {
        Pack * pack = [level.packs objectForKey:packId];
        [packs addObject:pack];
        
        int position = 0;
        for (Media * media in pack.medias) {
            //Media
            [medias addObject:media];

            //PackMedia
            [packsMedias addObject:[PackMedia packMediaWithPackId:pack.identifier andMediaId:media.identifier andPosition:position andFextra1:pack.fExtra1]];
            
            position++;
        }
    }
    
    if ([self openDatabase]) {
        if (sqlite3_exec(m_database, "BEGIN EXCLUSIVE TRANSACTION", 0, 0, 0) == SQLITE_OK) {
            [self levelsTransaction:[NSArray arrayWithObject:level]];
            [self packsTransactionsWithPacks:packs andLevelId:level.identifier];
            [self mediasTransaction:medias];
            [self packsMediasTransaction:packsMedias];
            
            if (sqlite3_exec(m_database, "COMMIT TRANSACTION", 0, 0, 0) != SQLITE_OK) {
                NSLog(@"SQL Error: %s",sqlite3_errmsg(m_database));
            }
        }
        
        [self closeDatabase];
    }
    
    return returnValue;
}

+ (Boolean)addLevel:(Level *)level {
    GameDBHelper * dbHelper = [GameDBHelper instance];
    return [dbHelper addLevel:level];
}

+ (void)checkLevels {
    NSFileManager * fm = [NSFileManager defaultManager];
    
    NSArray * dirContent = [fm contentsOfDirectoryAtPath:[Level levelsPath] error:nil];
    NSString * comparator = [NSString stringWithFormat:@"self BEGINSWITH '%@'", QUIZZ_APP_LEVEL_DIRECTORY_PREFIX];
    
    NSPredicate * fltr = [NSPredicate predicateWithFormat:comparator];
    NSArray * levelsDirectories = [dirContent filteredArrayUsingPredicate:fltr];
    
    for (NSString * levelDirName in levelsDirectories) {
        int levelId = [[levelDirName stringByReplacingOccurrencesOfString:QUIZZ_APP_LEVEL_DIRECTORY_PREFIX withString:@""] intValue];
//        NSLog(@"%d", levelId);
        
        if (![GameDBHelper isLevelImported:levelId]) {
            NSString * databasePath = [NSString stringWithFormat:@"%@/level_%d/level_%d.sqlite", [Level levelsPath], levelId, levelId];
            
            Level * level = [LevelDBHelper getLevel:databasePath];
            [self addLevel:level];
        }
    }
}

- (NSDictionary *)getBasePacks:(int)levelId {
    NSMutableDictionary * basePacks = nil;
    
    sqlite3_stmt * sqlStatement = [self executeSelect:[NSString stringWithFormat:@"SELECT p.* FROM packs p, levels l WHERE l.id = %d AND p.level_id = l.id;", levelId]];
    
    while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
        if (basePacks == nil) {
            basePacks = [NSMutableDictionary dictionary];
        }
        
        BasePack * currentBasePack = [BasePack BasePack];
        [self assignBasePackValuesWithStatement:sqlStatement andBasePack:currentBasePack];
        
        [basePacks setObject:currentBasePack forKey:[NSNumber numberWithInt:currentBasePack.identifier]];
    }
    
    sqlite3_finalize(sqlStatement);
    [self closeDatabase];
    
    //Loop on packs to get its difficulty
    for (NSNumber * packId in basePacks) {
        //Difficulty
        BasePack * basePack = [basePacks objectForKey:packId];
        [basePack setDifficulty:[GameDBHelper getPackDifficulty:basePack.identifier]];
        
        //Completed
//        Boolean isCompleted = [GameDBHelper isPackCompleted:[packId intValue]];
        [basePack refreshCompleted];
    }
    
    return basePacks;
}

+ (NSDictionary *)getLevels:(NSString *)language andMinId:(int)minId andMaxId:(int)maxId {
    [self checkLevels];
    
    GameDBHelper * dbHelper = [GameDBHelper instance];
    NSMutableDictionary * levels = nil;
    
    NSString * request = [NSString stringWithFormat:@"SELECT * FROM levels WHERE language = '%@' AND id > %d AND id < %d;", language, minId, maxId];
    
    sqlite3_stmt * sqlStatement = [dbHelper executeSelect:request];
    
    while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
        if (levels == nil) {
            levels = [NSMutableDictionary dictionary];
        }
        
        Level * currentLevel = [Level Level];
        [dbHelper assignLevelValuesWithStatement:sqlStatement andLevel:currentLevel];

        [levels setObject:currentLevel forKey:[NSNumber numberWithInt:currentLevel.identifier]];
    }
    
    sqlite3_finalize(sqlStatement);
    [dbHelper closeDatabase];
    
    //Packs ids
    for (NSNumber * levelId in levels) {
        Level * level = [levels objectForKey:levelId];
        
        NSDictionary * basePacks = [dbHelper getBasePacks:level.identifier];
        [level setBasePacks:basePacks];
    }
    
    return levels;
}

+ (NSDictionary *)getLevels:(NSString *)language {
    return [GameDBHelper getLevels:language andMinId:0 andMaxId:INT16_MAX];
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

+ (Level *)getLevel:(int)levelId {
    GameDBHelper * dbHelper = [GameDBHelper instance];
    
    Level * level = nil;
    sqlite3_stmt * statement = [dbHelper executeSelect:[NSString stringWithFormat:@"SELECT * FROM levels WHERE id = %d;", levelId]];
    
    if (sqlite3_step(statement) == SQLITE_ROW) {
        if (level == nil) {
            level = [Level Level];
        }
        
        [dbHelper assignLevelValuesWithStatement:statement andLevel:level];
        
        NSDictionary * basePacks = [dbHelper getBasePacks:level.identifier];
        [level setBasePacks:basePacks];
    }
    
    sqlite3_finalize(statement);
    [dbHelper closeDatabase];
    
    return level;
}

+ (Boolean)isLevelImported:(int)levelId {
    GameDBHelper * dbHelper = [GameDBHelper instance];
    
    Boolean levelImported = NO;
    sqlite3_stmt * statement = [dbHelper executeSelect:[NSString stringWithFormat:@"SELECT * FROM levels WHERE id = %d;", levelId]];
    
    if (sqlite3_step(statement) == SQLITE_ROW) {
        levelImported = YES;
    }
    
    sqlite3_finalize(statement);
    [dbHelper closeDatabase];
    
    return levelImported;
}

+ (Boolean)hasLevelsWithMaxId:(int)maxId {
    GameDBHelper * dbHelper = [GameDBHelper instance];
    
    Boolean hasLevels = NO;
    sqlite3_stmt * statement = [dbHelper executeSelect:[NSString stringWithFormat:@"SELECT count(id) FROM levels WHERE id < %d;", maxId]];
    
    if (sqlite3_step(statement) == SQLITE_ROW) {
        hasLevels = sqlite3_column_int(statement, 0);
    }
    
    sqlite3_finalize(statement);
    [dbHelper closeDatabase];
    
    return hasLevels;
}

#pragma mark - Pack

+ (float)getPackDifficulty:(int)packId {
    GameDBHelper * dbHelper = [GameDBHelper instance];
    
    float difficulty = -1.0;
    sqlite3_stmt * statement = [dbHelper executeSelect:[NSString stringWithFormat:@"SELECT AVG(m.difficulty) FROM medias m, packs_medias pm WHERE pm.pack_id = %d AND pm.media_id = m.id;", packId]];
    
    if (sqlite3_step(statement) == SQLITE_ROW) {
        difficulty = sqlite3_column_double(statement, 0);
    }
    
    sqlite3_finalize(statement);
    [dbHelper closeDatabase];
    
    return difficulty;
}

- (void)assignBasePackValuesWithStatement:(sqlite3_stmt *)statement andBasePack:(BasePack *)basePack {
    for (int i=0; i<sqlite3_column_count(statement); i++) {
        if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"id"]) {
            //Id
            [basePack setIdentifier:sqlite3_column_int(statement, i)];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"title"]) {
            //Title
            [basePack setTitle:[self getStringWithStatement:statement andPosition:i]];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"level_id"]) {
            //Level id
            [basePack setLevelId:sqlite3_column_int(statement, i)];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"extra1"]) {
            //Extra1
            [basePack setExtra1:[self getStringWithStatement:statement andPosition:i]];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"extra2"]) {
            //Extra2
            [basePack setExtra2:[self getStringWithStatement:statement andPosition:i]];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"extra3"]) {
            //Extra3
            [basePack setExtra3:[self getStringWithStatement:statement andPosition:i]];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"fextra1"]) {
            //FExtra1
            [basePack setFExtra1:sqlite3_column_double(statement, i)];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"fextra2"]) {
            //FExtra2
            [basePack setFExtra2:sqlite3_column_double(statement, i)];
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"fextra3"]) {
            //FExtra3
            [basePack setFExtra3:sqlite3_column_double(statement, i)];
        }
    }
}

- (void)assignPackValuesWithStatement:(sqlite3_stmt *)statement andPack:(Pack *)pack {
    [self assignBasePackValuesWithStatement:statement andBasePack:pack];
    
    for (int i=0; i<sqlite3_column_count(statement); i++) {
        if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"language"]) {
            //Language
            [pack setLanguage:[self getStringWithStatement:statement andPosition:i]];
        }
    }
}

+ (NSDictionary *)getPacksForLevel:(int)levelId {
    GameDBHelper * dbHelper = [GameDBHelper instance];
    NSMutableDictionary * packs = nil;
    
    NSString * request = [NSString stringWithFormat:@"SELECT * FROM packs WHERE level_id = %d;", levelId];
    sqlite3_stmt * sqlStatement = [dbHelper executeSelect:request];
    
    while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
        if (packs == nil) {
            packs = [NSMutableDictionary dictionary];
        }
        
        Pack * currentPack = [Pack Pack];
        [dbHelper assignPackValuesWithStatement:sqlStatement andPack:currentPack];
        
        [packs setObject:currentPack forKey:[NSNumber numberWithInt:currentPack.identifier]];
    }
    
    sqlite3_finalize(sqlStatement);
    [dbHelper closeDatabase];
    
    //Medias
    for (NSNumber * packId in packs) {
        Pack * pack = [packs objectForKey:packId];
        
        //Medias
        NSArray * medias = [GameDBHelper getMediasForPack:pack];
        [pack setMedias:medias];
        
        //Difficulty
        float packDifficulty = [GameDBHelper getPackDifficulty:pack.identifier];
        [pack setDifficulty:packDifficulty];
        
        //Completed
//        Boolean isCompleted = [GameDBHelper isPackCompleted:pack.identifier];
        [pack refreshCompleted];
    }
    
    return packs;
}

+ (Pack *)getPack:(int)packId {
    GameDBHelper * dbHelper = [GameDBHelper instance];
    Pack * pack = nil;
    
    sqlite3_stmt * statement = [dbHelper executeSelect:[NSString stringWithFormat:@"SELECT * FROM packs WHERE id = %d;", packId]];
    
    if (sqlite3_step(statement) == SQLITE_ROW) {
        pack = [Pack Pack];
        [dbHelper assignPackValuesWithStatement:statement andPack:pack];
    }
    
    sqlite3_finalize(statement);
    [dbHelper closeDatabase];
    
    //Difficulty
    float packDifficulty = [GameDBHelper getPackDifficulty:pack.identifier];
    [pack setDifficulty:packDifficulty];
    
    //Is completed?
//    [pack setIsCompleted:[GameDBHelper isPackCompleted:packId]];
    [pack refreshCompleted];
    
    return pack;
}

+ (Boolean)isPackCompleted:(int)packId {
    GameDBHelper * dbHelper = [GameDBHelper instance];
    
    NSMutableArray * ids = nil;
    int sumCompleted = 0;
    
    sqlite3_stmt * statement = [dbHelper executeSelect:[NSString stringWithFormat:@"SELECT pm.media_id, pm.completed as sumCompleted FROM packs_medias pm WHERE pm.pack_id = %d;", packId]];
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        if (ids == nil) {
            ids = [NSMutableArray array];
        }
        
        [ids addObject:[NSNumber numberWithInt:sqlite3_column_int(statement, 0)]];
        sumCompleted += sqlite3_column_int(statement, 1);
    }
    
    sqlite3_finalize(statement);
    [dbHelper closeDatabase];
    
    //Database
    Boolean isDatabaseFinished = (sumCompleted == QUIZZ_APP_NB_MEDIAS_IN_PACK);
    return isDatabaseFinished;
}

+ (void)restartPack:(int)packId {
    GameDBHelper * dbHelper = [GameDBHelper instance];
    
    NSString * request = [NSString stringWithFormat:@"UPDATE packs_medias SET completed = 0 WHERE pack_id = %d;", packId];
    
    [dbHelper executeRequest:request];
}

+ (NSDictionary *)getAllPacks {
    GameDBHelper * dbHelper = [GameDBHelper instance];
    NSMutableDictionary * packs = nil;
    
    NSString * request = [NSString stringWithFormat:@"SELECT * FROM packs;"];
    sqlite3_stmt * sqlStatement = [dbHelper executeSelect:request];
    
    while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
        if (packs == nil) {
            packs = [NSMutableDictionary dictionary];
        }
        
        Pack * currentPack = [Pack Pack];
        [dbHelper assignPackValuesWithStatement:sqlStatement andPack:currentPack];
        
        [packs setObject:currentPack forKey:[NSNumber numberWithInt:currentPack.identifier]];
    }
    
    sqlite3_finalize(sqlStatement);
    [dbHelper closeDatabase];
    
    //Medias
    for (NSNumber * packId in packs) {
        Pack * pack = [packs objectForKey:packId];
        
        //Medias
        NSArray * medias = [GameDBHelper getMediasForPack:pack];
        [pack setMedias:medias];
        
        //Difficulty
        float packDifficulty = [GameDBHelper getPackDifficulty:pack.identifier];
        [pack setDifficulty:packDifficulty];
        
        //Completed
        //        Boolean isCompleted = [GameDBHelper isPackCompleted:pack.identifier];
        [pack refreshCompleted];
    }
    
    return packs;
}

#pragma mark - Media

- (void)assignMediaValuesWithStatement:(sqlite3_stmt *)statement andMedia:(Media *)media {
    Boolean isDatabaseCompleted = NO;
    
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
            NSInteger leftValuesCount = [rectValues count];
            
            NSMutableArray * topLeftBlurRects = [NSMutableArray array];
            NSMutableArray * bottomRightBlurRects = [NSMutableArray array];
            
            for (int i = 0; (i < [rectValues count]) && (leftValuesCount >= 4); i+=4) {
                CGPoint topLeft = CGPointMake([[rectValues objectAtIndex:i+0] floatValue], [[rectValues objectAtIndex:i+1] floatValue]);
                CGPoint bottomRight = CGPointMake([[rectValues objectAtIndex:i+2] floatValue], [[rectValues objectAtIndex:i+3] floatValue]);
                
                [topLeftBlurRects addObject:[NSValue valueWithCGPoint:topLeft]];
                [bottomRightBlurRects addObject:[NSValue valueWithCGPoint:bottomRight]];
                
                leftValuesCount -= 4;
            }
            
            [media setTopLeftBlurRects:topLeftBlurRects];
            [media setBottomRightBlurRects:bottomRightBlurRects];
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
        } else if ([[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] isEqualToString:@"completed"]) {
            //Completed
            isDatabaseCompleted = sqlite3_column_int(statement, i);
        }
    }
    
    [media setIsCompleted:isDatabaseCompleted];
}

+ (Boolean)isPackFinishedInMovieQuizz1:(int)packId {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    NSArray * packsIds = (NSArray *)[prefs objectForKey:MOVIE_QUIZZ_MIGRATION_1_PACK_IDS_KEY];
    return [packsIds containsObject:[NSNumber numberWithInt:packId]];
}

+ (NSArray *)getMediasForPack:(Pack *)pack {
    GameDBHelper * dbHelper = [GameDBHelper instance];
    NSMutableArray * medias = nil;
    
    NSString * request = [NSString stringWithFormat:@"SELECT * FROM medias m, packs_medias pm WHERE pm.pack_id = %d AND m.id = pm.media_id ORDER BY pm.position ASC;", pack.identifier];
    sqlite3_stmt * sqlStatement = [dbHelper executeSelect:request];
    
    while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
        if (medias == nil) {
            medias = [NSMutableArray array];
        }
        
        Media * currentMedia = [Media Media];
        [dbHelper assignMediaValuesWithStatement:sqlStatement andMedia:currentMedia];
        
        [medias addObject:currentMedia];
    }
    
    sqlite3_finalize(sqlStatement);
    [dbHelper closeDatabase];
    
    return medias;
}

+ (void)completeMedia:(int)mediaId inPack:(int)packId {
    GameDBHelper * dbHelper = [GameDBHelper instance];
    
    NSString * request = [NSString stringWithFormat:@"UPDATE packs_medias SET completed = 1 WHERE media_id = %d AND pack_id = %d;", mediaId, packId];
    
    [dbHelper executeRequest:request];
}

+ (void)updateRemoteIds:(NSArray *)remoteIds {
    if ([remoteIds count] > 0) {
        NSString * strIds = @"";
        
        int i = 0;
        for (NSNumber * mediaId in remoteIds) {
            if (i > 0) {
                strIds = [strIds stringByAppendingString:@", "];
            }
                
            strIds = [strIds stringByAppendingFormat:@"%d", [mediaId intValue]];
            i++;
        }
        
        GameDBHelper * dbHelper = [GameDBHelper instance];
        
        NSString * request = [NSString stringWithFormat:@"UPDATE packs_medias SET completed = 1 WHERE media_id IN (%@);", strIds];
        
        [dbHelper executeRequest:request];
    }
}

#pragma mark - Score

//+ (NSSet *)getLocalCompletedMedias {
//    GameDBHelper * dbHelper = [GameDBHelper instance];
//    NSMutableSet * mediaIds = nil;
//    
//    NSString * request = @"SELECT m.id FROM medias m, packs_medias pm WHERE pm.completed = 1 AND m.id = pm.media_id;";
//    sqlite3_stmt * sqlStatement = [dbHelper executeSelect:request];
//    
//    while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
//        if (mediaIds == nil) {
//            mediaIds = [NSMutableSet set];
//        }
//        
//        int mediaId = sqlite3_column_int(sqlStatement, 0);
//        [mediaIds addObject:[NSNumber numberWithInt:mediaId]];
//    }
//    
//    sqlite3_finalize(sqlStatement);
//    [dbHelper closeDatabase];
//    
//    return mediaIds;
//}

+ (NSDictionary *)getLocalProgression {
    GameDBHelper * dbHelper = [GameDBHelper instance];
    NSMutableDictionary * packs = nil;
    
    NSString * request = @"SELECT pm.pack_id, pm.media_id FROM packs_medias pm WHERE pm.completed = 1;";
    sqlite3_stmt * sqlStatement = [dbHelper executeSelect:request];
    
    while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
        if (packs == nil) {
            packs = [NSMutableDictionary dictionary];
        }
        
        int packId = sqlite3_column_int(sqlStatement, 0);
        int mediaId = sqlite3_column_int(sqlStatement, 1);

        NSString * packKey = [NSString stringWithFormat:@"%d", packId];
        NSMutableArray * pack = [packs objectForKey:packKey];
        if (pack == nil) {
            pack = [NSMutableArray array];
            [packs setObject:pack forKey:packKey];
        }
        
        [pack addObject:[NSNumber numberWithInt:mediaId]];
    }
    
    sqlite3_finalize(sqlStatement);
    [dbHelper closeDatabase];
    
    return packs;
}

@end
