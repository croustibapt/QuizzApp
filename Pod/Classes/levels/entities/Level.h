//
//  Level.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 25/09/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseLevel.h"

@interface Level : BaseLevel {
    float progression;
}

@property (nonatomic, retain) NSDictionary * packs;

- (id)initWithIdentifier:(int)identifier andPacks:(NSDictionary *)packs;

+ (Level *)Level;

+ (Level *)LevelWithIdentifier:(int)identifier andPacks:(NSDictionary *)packs;

+ (NSString *)levelsPath;

@end
