//
//  BaseLevel.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 14/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "BaseLevel.h"

#import "GameDBHelper.h"

@interface BaseLevel() {
    NSDictionary * m_basePacks;
}

@end

@implementation BaseLevel

@synthesize basePacks = m_basePacks;

- (id)initWithIdentifier:(int)aIdentifier andValue:(int)aValue andDifficultyId:(int)aDifficultyId andReleaseDate:(NSDate *)aReleaseDate andLanguage:(NSString *)aLanguage  andMd5:(NSString *)aMd5 andZipSize:(int)aZipSize andExtra1:(NSString *)aExtra1 andExtra2:(NSString *)aExtra2 andExtra3:(NSString *)aExtra3 andFExtra1:(double)aFExtra1 andFExtra2:(double)aFExtra2 andFExtra3:(double)aFExtra3 andBasePacks:(NSDictionary *)aBasePacks {
    self = [super init];
    if (self) {
        [self setIdentifier:aIdentifier];
        [self setValue:aValue];
        [self setDifficultyId:aDifficultyId];
        [self setReleaseDate:aReleaseDate];
        [self setLanguage:aLanguage];
        [self setMd5:aMd5];
        [self setZipSize:aZipSize];
        [self setBasePacks:aBasePacks];
    }
    return self;
}

+ (BaseLevel *)BaseLevelWithIdentifier:(int)aIdentifier andValue:(int)aValue andDifficultyId:(int)aDifficultyId andReleaseDate:(NSDate *)aReleaseDate andLanguage:(NSString *)aLanguage  andMd5:(NSString *)aMd5 andZipSize:(int)aZipSize andExtra1:(NSString *)aExtra1 andExtra2:(NSString *)aExtra2 andExtra3:(NSString *)aExtra3 andFExtra1:(double)aFExtra1 andFExtra2:(double)aFExtra2 andFExtra3:(double)aFExtra3 andBasePacks:(NSDictionary *)aBasePacks {
    BaseLevel * baseLevel = [[BaseLevel alloc] initWithIdentifier:aIdentifier andValue:aValue andDifficultyId:aDifficultyId andReleaseDate:aReleaseDate andLanguage:aLanguage andMd5:aMd5 andZipSize:aZipSize andExtra1:aExtra1 andExtra2:aExtra2 andExtra3:aExtra3 andFExtra1:aFExtra1 andFExtra2:aFExtra2 andFExtra3:aFExtra3 andBasePacks:aBasePacks];
    return baseLevel;
}

- (Boolean)isCompleted {
    Boolean completed = YES;
    
    for (NSNumber * packId in self.basePacks) {
        BasePack * basePack = [self.basePacks objectForKey:packId];
        
        if (!basePack.isCompleted) {
            completed = NO;
            break;
        }
    }
    
    return completed;
}

- (float)progression {
    float progress = 0.0;
    
    for (NSNumber * packId in self.basePacks) {
        BasePack * basePack = [self.basePacks objectForKey:packId];
        
        if (basePack.isCompleted) {
            progress += 1.0;
        }
    }
    
    return (progress / [self.basePacks count]);
}

- (void)refreshCompleted {
    //Loop on packs
    for (NSNumber * packId in self.basePacks) {
        BasePack * basePack = [self.basePacks objectForKey:packId];
        [basePack refreshCompleted];
    }
}

- (void)setBasePacks:(NSDictionary *)aBasePacks {
    m_basePacks = aBasePacks;
    
    [self refreshCompleted];
}

- (NSNumber *)key {
    return [NSNumber numberWithInt:self.value];
}

@end
