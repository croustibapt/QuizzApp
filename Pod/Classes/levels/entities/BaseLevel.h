//
//  BaseLevel.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 14/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseLevel : NSObject

@property (nonatomic) int identifier;

@property (nonatomic) int value;

@property (nonatomic) int difficultyId;

@property (nonatomic, strong) NSDate * releaseDate;

@property (nonatomic, strong) NSString * language;

@property (nonatomic, strong) NSString * md5;

@property (nonatomic) int zipSize;

@property (nonatomic, strong) NSString * extra1;

@property (nonatomic, strong) NSString * extra2;

@property (nonatomic, strong) NSString * extra3;

@property (nonatomic) double fExtra1;

@property (nonatomic) double fExtra2;

@property (nonatomic) double fExtra3;

@property (nonatomic, strong) NSDictionary * basePacks;

@property (nonatomic) Boolean isCompleted;

@property (nonatomic) float progression;

@property (nonatomic, readonly) NSNumber * key;

- (id)initWithIdentifier:(int)identifier andValue:(int)value andDifficultyId:(int)difficultyId andReleaseDate:(NSDate *)releaseDate andLanguage:(NSString *)language andMd5:(NSString *)md5 andZipSize:(int)zipSize andExtra1:(NSString *)aExtra1 andExtra2:(NSString *)aExtra2 andExtra3:(NSString *)aExtra3 andFExtra1:(double)aFExtra1 andFExtra2:(double)aFExtra2 andFExtra3:(double)aFExtra3 andBasePacks:(NSDictionary *)basePacks;

+ (BaseLevel *)BaseLevelWithIdentifier:(int)identifier andValue:(int)value andDifficultyId:(int)difficultyId andReleaseDate:(NSDate *)releaseDate andLanguage:(NSString *)language andMd5:(NSString *)md5 andZipSize:(int)zipSize andExtra1:(NSString *)aExtra1 andExtra2:(NSString *)aExtra2 andExtra3:(NSString *)aExtra3 andFExtra1:(double)aFExtra1 andFExtra2:(double)aFExtra2 andFExtra3:(double)aFExtra3 andBasePacks:(NSDictionary *)basePacks;

- (void)refreshCompleted;

@end
