//
//  GameProvider.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 12/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "GameProvider.h"

#import "Level.h"
#import "GameDBHelper.h"
#import "Constants.h"
#import "QuizzApp.h"

GameProvider * s_gameProviderInstance;

@implementation GameProvider

@synthesize levelRecentDate = m_levelRecentDate;
@synthesize difficulties = m_difficulties;
@synthesize baseLevels = m_baseLevels;

+ (GameProvider *)instance {
    if (s_gameProviderInstance == nil) {
        s_gameProviderInstance = [[GameProvider alloc] init];
    }
    
    return s_gameProviderInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        m_difficulties = [[NSMutableDictionary alloc] init];
        m_baseLevels = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSData *)requestDataWithUrl:(NSString *)url andError:(NSError **)error {
    NSData * data = nil;
    
    NSURL * dataURL = [NSURL URLWithString:url];
    NSMutableURLRequest * dataRequest = [[NSMutableURLRequest alloc] initWithURL:dataURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:QUIZZ_APP_INIT_REQUEST_TIMEOUT];
    
    NSURLResponse * response = nil;
    data = [NSURLConnection sendSynchronousRequest:dataRequest returningResponse:&response error:error];
    
    if (data == nil) {
        *error = [NSError errorWithDomain:NSLocalizedStringFromTableInBundle(@"STR_NO_CONNECTIVITY_ERROR", nil, QUIZZ_APP_STRING_BUNDLE, nil) code:-1 userInfo:nil];
    }
    
    return data;
}

- (Boolean)requestInfo {
    NSError * error = nil;
    
    QuizzApp * quizzApp = [QuizzApp instance];
    
    NSData * data = [self requestDataWithUrl:[NSString stringWithFormat:@"%@%@/%@", QUIZZ_APP_SERVICE_PATH, QUIZZ_APP_SERVICE_INFO, quizzApp.gameServiceName] andError:&error];
    
    NSString * language = [Utils currentLanguage];
    
    if (error == nil) {
        NSDictionary * jsonContent = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        //Recent date
        int timeStamp = [[jsonContent objectForKey:@"level_recent_date"] intValue];
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
        
        [s_gameProviderInstance setLevelRecentDate:date];
        
        //Difficulties
        NSArray * difficulties = [jsonContent objectForKey:@"difficulties"];
        
        for (NSDictionary * jsonValue in difficulties) {
            NSDictionary * jsonDifficulty = [jsonValue objectForKey:@"Difficulty"];
            
            int difficultyId = [[jsonDifficulty objectForKey:@"id"] intValue];
            NSString * name = [jsonDifficulty objectForKey:@"name"];
            int enumValue = [[jsonDifficulty objectForKey:@"enum_value"] intValue];
            
            NSDictionary * jsonLanguage = [jsonValue objectForKey:@"Language"];
            NSString * lang = [jsonLanguage objectForKey:@"value"];
            
            if ([language isEqualToString:lang]) {
                Difficulty * difficulty = [Difficulty DifficultyWithIdentifier:difficultyId andName:name andEnumValue:enumValue andLanguage:lang];
                [m_difficulties setObject:difficulty forKey:[NSNumber numberWithInt:difficultyId]];
            
                [GameDBHelper addDifficulty:difficulty];
            }
        }
    } else {
        [self setDifficulties:[GameDBHelper getDifficulties:language]];
    }
    
    return (error == nil);
}

- (float)fExtraValue:(id)object {
    if (object == [NSNull null]) {
        return -1.0;
    } else {
        return [object floatValue];
    }
}

- (Boolean)requestLevels {
    [m_baseLevels removeAllObjects];
    
    QuizzApp * quizzApp = [QuizzApp instance];
    
    NSError * error = nil;
    NSString * requestUrl = [NSString stringWithFormat:@"%@%@/%@", QUIZZ_APP_SERVICE_PATH, QUIZZ_APP_SERVICE_LEVELS_LIST, quizzApp.gameServiceName];
    NSData * data = [self requestDataWithUrl:requestUrl andError:&error];
    
    if (error == nil) {
        NSArray * jsonContent = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString * language = [Utils currentLanguage];

        for (NSDictionary * jsonLevel in jsonContent) {
            NSString * lang = [jsonLevel objectForKey:@"language"];

            if ([language isEqualToString:lang]) {
                int levelId = [[jsonLevel objectForKey:@"id"] intValue];
                int value = [[jsonLevel objectForKey:@"value"] intValue];
                int difficultyId = [[jsonLevel objectForKey:@"difficulty_id"] intValue];
                
                int timeStamp = [[jsonLevel objectForKey:@"release_date"] intValue];
                NSDate * releaseDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
                
                
                NSString * md5 = [jsonLevel objectForKey:@"md5"];
                int zipSize = [[jsonLevel objectForKey:@"zip_size"] intValue];
                
                NSString * levelExtra1 = [jsonLevel objectForKey:@"extra1"];
                NSString * levelExtra2 = [jsonLevel objectForKey:@"extra2"];
                NSString * levelExtra3 = [jsonLevel objectForKey:@"extra3"];
                
                float levelFExtra1 = [self fExtraValue:[jsonLevel objectForKey:@"fextra1"]];
                float levelFExtra2 = [self fExtraValue:[jsonLevel objectForKey:@"fextra2"]];
                float levelFExtra3 = [self fExtraValue:[jsonLevel objectForKey:@"fextra3"]];
                
                NSMutableDictionary * basePacks = [[NSMutableDictionary alloc] init];
                NSArray * jsonPacks = [jsonLevel objectForKey:@"packs"];
                
                for (NSDictionary * jsonPack in jsonPacks) {
                    int packId = [[jsonPack objectForKey:@"id"] intValue];
                    
                    NSString * title = [jsonPack objectForKey:@"title"];

                    NSString * extra1 = [jsonPack objectForKey:@"extra1"];
                    NSString * extra2 = [jsonPack objectForKey:@"extra2"];
                    NSString * extra3 = [jsonPack objectForKey:@"extra3"];
                    
                    float fExtra1 = [self fExtraValue:[jsonPack objectForKey:@"fextra1"]];
                    float fExtra2 = [self fExtraValue:[jsonPack objectForKey:@"fextra2"]];
                    float fExtra3 = [self fExtraValue:[jsonPack objectForKey:@"fextra3"]];
                    
                    float difficulty = [self fExtraValue:[jsonPack objectForKey:@"difficulty"]];
                    
                    BasePack * basePack = [BasePack BasePackWithIdentifier:packId andTitle:title andLevelId:levelId andExtra1:extra1 andExtra2:extra2 andExtra3:extra3 andFExtra1:fExtra1 andFExtra2:fExtra2 andFExtra3:fExtra3 andDifficulty:difficulty];
                    [basePacks setObject:basePack forKey:[NSNumber numberWithInt:packId]];
                }
            
                BaseLevel * baseLevel = [BaseLevel BaseLevelWithIdentifier:levelId andValue:value andDifficultyId:difficultyId andReleaseDate:releaseDate andLanguage:lang andMd5:md5 andZipSize:zipSize andExtra1:levelExtra1 andExtra2:levelExtra2 andExtra3:levelExtra3 andFExtra1:levelFExtra1 andFExtra2:levelFExtra2 andFExtra3:levelFExtra3 andBasePacks:basePacks];
                [m_baseLevels setObject:baseLevel forKey:[NSNumber numberWithInt:levelId]];
            }
        }
    }
    
    return (error == nil);
}

+ (Boolean)requestLevels {
    return [[GameProvider instance] requestLevels];
}

+ (Boolean)start {
    GameProvider * gameProvider = [GameProvider instance];
    Boolean ok = [gameProvider requestInfo];
    ok = ok && [gameProvider requestLevels];
    
    return ok;
}

+ (Difficulty *)getDifficulty:(int)difficultyId {
    GameProvider * gameProvider = [GameProvider instance];

    NSNumber * key = [NSNumber numberWithInt:difficultyId];
    return [gameProvider.difficulties objectForKey:key];
}

+ (NSDictionary *)getBaseLevelWithMinId:(int)minId andMaxId:(int)maxId {
    NSMutableDictionary * allBaseLevels = [NSMutableDictionary dictionary];
    GameProvider * gameProvider = [GameProvider instance];
    
    for (NSNumber * baseLevelId in gameProvider.baseLevels) {
        int levelId = [baseLevelId intValue];
        
        if ((levelId >= minId) && (levelId <= maxId)) {
            BaseLevel * baseLevel = [gameProvider.baseLevels objectForKey:baseLevelId];
            [allBaseLevels setObject:baseLevel forKey:baseLevelId];
        }
    }
    
    return allBaseLevels;
}

+ (NSArray *)getAllLevels:(NSString *)language andMinId:(int)minId andMaxId:(int)maxId {
    NSMutableDictionary * allDictLevels = [NSMutableDictionary dictionaryWithDictionary:[GameProvider getBaseLevelWithMinId:minId andMaxId:maxId]];
    
    //Loop on local levels to replace downloaded ones
    NSDictionary * localLevels = [GameDBHelper getLevels:language andMinId:minId andMaxId:maxId];
    for (NSNumber * levelId in localLevels) {
        Level * level = [localLevels objectForKey:levelId];
        [allDictLevels setObject:level forKey:[NSNumber numberWithInt:level.identifier]];
    }
    
    NSMutableArray * allLevels = [NSMutableArray arrayWithArray:[allDictLevels allValues]];
    NSSortDescriptor * sorter = [NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES];
    NSArray * sortDescriptors = [NSArray arrayWithObject:sorter];
    
    [allLevels sortUsingDescriptors:sortDescriptors];
    
    return allLevels;
}

+ (NSArray *)getAllLevels:(NSString *)language {
    return [GameProvider getAllLevels:language andMinId:0 andMaxId:INT16_MAX];
}

@end
