//
//  Level.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 25/09/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "Level.h"

#import "Pack.h"
#import "GameDBHelper.h"
#import "Utils.h"

@implementation Level

//@synthesize isCompleted = m_isCompleted;
//@synthesize progression = m_progression;
@synthesize packs = m_packs;

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithIdentifier:(int)aIdentifier andPacks:(NSDictionary *)aPacks {
    self = [super init];
    if (self) {
        [self setIdentifier:aIdentifier];
        [self setPacks:aPacks];
    }
    return self;
}

//- (float)progression {
//    float superProgression = [super progression];
//    return MAX(superProgression, m_progression);
//}

//- (Boolean)isCompleted {
//    Boolean superIsCompleted = [super isCompleted];
//    return (m_isCompleted || superIsCompleted);
//}

//- (void)refreshCompleted {
//    float progress = 0.0;
//    Boolean completed = ([self.basePacks count] > 0);
//    
//    for (NSNumber * packId in self.basePacks) {
//        Boolean isPackCompleted = [GameDBHelper isPackCompleted:[packId intValue]];
//        
//        if (isPackCompleted) {
//            progress += 1.0;
//        } else {
//            completed = NO;
//        }
//    }
//    
//    [self setIsCompleted:completed];
//    [self setProgression:(progress / [self.basePacks count])];
//}

+ (Level *)Level {
    Level * level = [[Level alloc] init];
    return level;
}

+ (Level *)LevelWithIdentifier:(int)aIdentifier andPacks:(NSDictionary *)packs {
    Level * level = [[Level alloc] initWithIdentifier:aIdentifier andPacks:packs];
    return level;
}

+ (NSString *)levelsPath {
    NSString * language = [Utils currentLanguage];
    NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * packsPath = [NSString stringWithFormat:@"%@/Caches/levels/%@", documentsDirectory, language];
    
    return packsPath;
}

@end
