//
//  BasePack.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 14/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BasePack : NSObject

@property (nonatomic) int identifier;

@property (nonatomic, strong) NSString * title;

@property (nonatomic) int levelId;

@property (nonatomic, strong) NSString * extra1;

@property (nonatomic, strong) NSString * extra2;

@property (nonatomic, strong) NSString * extra3;

@property (nonatomic) float fExtra1;

@property (nonatomic) float fExtra2;

@property (nonatomic) float fExtra3;

@property (nonatomic) float difficulty;

@property (nonatomic) Boolean isCompleted;

@property (nonatomic) Boolean isRemoteCompleted;

- (id)initWithIdentifier:(int)identifier andTitle:(NSString *)title andLevelId:(int)levelId andExtra1:(NSString *)extra1 andExtra2:(NSString *)extra2 andExtra3:(NSString *)extra3 andFExtra1:(float)fExtra1 andFExtra2:(float)fExtra2 andFExtra3:(float)fExtra3 andDifficulty:(float)difficulty;

+ (BasePack *)BasePack;

+ (BasePack *)BasePackWithIdentifier:(int)identifier andTitle:(NSString *)title andLevelId:(int)levelId andExtra1:(NSString *)extra1 andExtra2:(NSString *)extra2 andExtra3:(NSString *)extra3 andFExtra1:(float)fExtra1 andFExtra2:(float)fExtra2 andFExtra3:(float)fExtra3 andDifficulty:(float)difficulty;

+ (UIColor *)getColorWithDifficulty:(int)difficulty;

+ (UIColor *)getDarkColorWithDifficulty:(int)difficulty;

- (void)refreshCompleted;

@end
