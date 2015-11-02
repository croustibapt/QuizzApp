//
//  Difficulty.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 25/09/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Difficulty : NSObject

@property (nonatomic, readwrite) int identifier;

@property (nonatomic, retain) NSString * name;

@property (nonatomic, readwrite) int enumValue;

@property (nonatomic, retain) NSString * language;

- (id)initWithIdentifier:(int)identifier andName:(NSString *)name andEnumValue:(int)enumValue andLanguage:(NSString *)language;

+ (Difficulty *)Difficulty;

+ (id)DifficultyWithIdentifier:(int)identifier andName:(NSString *)name andEnumValue:(int)enumValue andLanguage:(NSString *)language;

@end
