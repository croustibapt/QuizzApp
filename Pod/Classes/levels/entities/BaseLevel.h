//
//  BaseLevel.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 14/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseLevel : NSObject

@property (nonatomic, readwrite) int identifier;

@property (nonatomic, readwrite) int value;

@property (nonatomic, readwrite) int difficultyId;

@property (nonatomic, retain) NSDate * releaseDate;

@property (nonatomic, retain) NSString * language;

@property (nonatomic, retain) NSString * md5;

@property (nonatomic, readwrite) int zipSize;

@property (nonatomic, retain) NSString * extra1;

@property (nonatomic, retain) NSString * extra2;

@property (nonatomic, retain) NSString * extra3;

@property (nonatomic, readwrite) double fExtra1;

@property (nonatomic, readwrite) double fExtra2;

@property (nonatomic, readwrite) double fExtra3;

@property (nonatomic, retain) NSDictionary * basePacks;

@property (nonatomic, readwrite) Boolean isCompleted;

@property (nonatomic, readwrite) float progression;

@property (nonatomic, readonly) NSNumber * key;

- (id)initWithIdentifier:(int)identifier andValue:(int)value andDifficultyId:(int)difficultyId andReleaseDate:(NSDate *)releaseDate andLanguage:(NSString *)language andMd5:(NSString *)md5 andZipSize:(int)zipSize andExtra1:(NSString *)aExtra1 andExtra2:(NSString *)aExtra2 andExtra3:(NSString *)aExtra3 andFExtra1:(double)aFExtra1 andFExtra2:(double)aFExtra2 andFExtra3:(double)aFExtra3 andBasePacks:(NSDictionary *)basePacks;

+ (BaseLevel *)BaseLevelWithIdentifier:(int)identifier andValue:(int)value andDifficultyId:(int)difficultyId andReleaseDate:(NSDate *)releaseDate andLanguage:(NSString *)language andMd5:(NSString *)md5 andZipSize:(int)zipSize andExtra1:(NSString *)aExtra1 andExtra2:(NSString *)aExtra2 andExtra3:(NSString *)aExtra3 andFExtra1:(double)aFExtra1 andFExtra2:(double)aFExtra2 andFExtra3:(double)aFExtra3 andBasePacks:(NSDictionary *)basePacks;

- (void)refreshCompleted;

@end
