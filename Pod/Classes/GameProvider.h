//
//  GameProvider.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 12/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Difficulty.h"

@interface GameProvider : NSObject

@property (nonatomic, retain) NSDate * levelRecentDate;

@property (nonatomic, retain) NSMutableDictionary * difficulties;

@property (nonatomic, retain) NSMutableDictionary * baseLevels;

+ (Boolean)start;

+ (Difficulty *)getDifficulty:(int)difficultyId;

+ (NSArray *)getAllLevels:(NSString *)language andMinId:(int)minId andMaxId:(int)maxId;

+ (NSArray *)getAllLevels:(NSString *)language;

+ (Boolean)requestLevels;

@end
