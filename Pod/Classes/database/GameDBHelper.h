//
//  GameDBHelper.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 16/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "DBHelper.h"

#import "Level.h"
#import "Pack.h"
#import "Difficulty.h"

@interface PackMedia : NSObject {
    
}

@property (nonatomic, readwrite) int packId;

@property (nonatomic, readwrite) int mediaId;

@property (nonatomic, readwrite) int position;

@property (nonatomic, readwrite) float fExtra1;

+ (PackMedia *)packMediaWithPackId:(int)packId andMediaId:(int)mediaId andPosition:(int)position andFextra1:(float)fExtra1;

@end

@interface GameDBHelper : DBHelper

#pragma mark - Difficulty

+ (void)addDifficulty:(Difficulty *)difficulty;

+ (NSMutableDictionary *)getDifficulties:(NSString *)language;

#pragma mark - Level

+ (Boolean)addLevel:(Level *)level;

+ (NSDictionary *)getLevels:(NSString *)language andMinId:(int)minId andMaxId:(int)maxId;

+ (NSDictionary *)getLevels:(NSString *)language;

+ (Level *)getLevel:(int)levelId;

+ (Boolean)isLevelImported:(int)levelId;

+ (Boolean)hasLevelsWithMaxId:(int)maxId;

#pragma mark - Pack

+ (Boolean)isPackCompleted:(int)packId;

+ (NSDictionary *)getPacksForLevel:(int)levelId;

+ (Pack *)getPack:(int)packId;

+ (void)restartPack:(int)packId;

+ (NSDictionary *)getAllPacks;

#pragma mark - Media

+ (Boolean)isPackFinishedInMovieQuizz1:(int)packId;

+ (NSArray *)getMediasForPack:(Pack *)pack;

+ (void)completeMedia:(int)mediaId inPack:(int)packId;

+ (void)updateRemoteIds:(NSArray *)remoteIds;

#pragma mark - Score

+ (NSDictionary *)getLocalProgression;

@end
