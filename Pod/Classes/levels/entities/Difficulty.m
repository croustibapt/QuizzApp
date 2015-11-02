//
//  Difficulty.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 25/09/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "Difficulty.h"

@implementation Difficulty

- (id)initWithIdentifier:(int)aIdentifier andName:(NSString *)name andEnumValue:(int)enumValue andLanguage:(NSString *)language {
    self = [super init];
    if (self) {
        [self setIdentifier:aIdentifier];
        [self setName:name];
        [self setEnumValue:enumValue];
        [self setLanguage:language];
    }
    return self;
}

+ (Difficulty *)Difficulty {
    Difficulty * difficulty = [[Difficulty alloc] init];
    return difficulty;
}

+ (id)DifficultyWithIdentifier:(int)identifier andName:(NSString *)name andEnumValue:(int)enumValue andLanguage:(NSString *)language {
    Difficulty * difficulty = [[Difficulty alloc] initWithIdentifier:identifier andName:name andEnumValue:enumValue andLanguage:language];
    return difficulty;
}

@end
