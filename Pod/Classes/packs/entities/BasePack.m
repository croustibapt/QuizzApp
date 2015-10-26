//
//  BasePack.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 14/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "BasePack.h"

#import "GameDBHelper.h"
#import "ProgressManager.h"

@implementation BasePack

@synthesize identifier;
@synthesize title = m_title;
@synthesize levelId;
@synthesize extra1 = m_extra1;
@synthesize extra2 = m_extra2;
@synthesize extra3 = m_extra3;
@synthesize fExtra1;
@synthesize fExtra2;
@synthesize fExtra3;
@synthesize difficulty;
@synthesize isCompleted = m_isCompleted;
@synthesize isRemoteCompleted = m_isRemoteCompleted;

- (id)initWithIdentifier:(int)aIdentifier andTitle:(NSString *)aTitle andLevelId:(int)aLevelId andExtra1:(NSString *)aExtra1 andExtra2:(NSString *)aExtra2 andExtra3:(NSString *)aExtra3 andFExtra1:(float)aFExtra1 andFExtra2:(float)aFExtra2 andFExtra3:(float)aFExtra3 andDifficulty:(float)aDifficulty {
    self = [super init];
    if (self) {
        [self setIdentifier:aIdentifier];
        [self setTitle:aTitle];
        [self setLevelId:aLevelId];
        [self setExtra1:aExtra1];
        [self setExtra2:aExtra2];
        [self setExtra3:aExtra3];
        [self setFExtra1:aFExtra1];
        [self setFExtra2:aFExtra2];
        [self setFExtra3:aFExtra3];
        [self setDifficulty:aDifficulty];
    }
    return self;
}

+ (BasePack *)BasePack {
    BasePack * basePack = [[BasePack alloc] init];
    return basePack;
}

+ (BasePack *)BasePackWithIdentifier:(int)aIdentifier andTitle:(NSString *)aTitle andLevelId:(int)aLevelId andExtra1:(NSString *)aExtra1 andExtra2:(NSString *)aExtra2 andExtra3:(NSString *)aExtra3 andFExtra1:(float)aFExtra1 andFExtra2:(float)aFExtra2 andFExtra3:(float)aFExtra3 andDifficulty:(float)aDifficulty {
    BasePack * basePack = [[BasePack alloc] initWithIdentifier:aIdentifier andTitle:aTitle andLevelId:aLevelId andExtra1:aExtra1 andExtra2:aExtra2 andExtra3:aExtra3 andFExtra1:aFExtra1 andFExtra2:aFExtra2 andFExtra3:aFExtra3 andDifficulty:aDifficulty];
    return basePack;
}

+ (UIColor *)getColorWithDifficulty:(int)difficulty {
    if (difficulty <= 2) {
        return GREEN_COLOR;
    } else if ((difficulty > 2) && (difficulty <= 4)) {
        return BLUE_COLOR;
    } else if ((difficulty > 4) && (difficulty <= 6)) {
        return ORANGE_COLOR;
    } else if ((difficulty > 6) && (difficulty <= 8)) {
        return RED_COLOR;
    } else if (difficulty > 8) {
        return BLUE_GRAY_COLOR;
    } else {
        return WHITE_COLOR;
    }
}

+ (UIColor *)getDarkColorWithDifficulty:(int)difficulty {
    if (difficulty <= 2) {
        return GREEN_DARK_COLOR;
    } else if ((difficulty > 2) && (difficulty <= 4)) {
        return BLUE_DARK_COLOR;
    } else if ((difficulty > 4) && (difficulty <= 6)) {
        return ORANGE_DARK_COLOR;
    } else if ((difficulty > 6) && (difficulty <= 8)) {
        return RED_DARK_COLOR;
    } else if (difficulty > 8) {
        return BLUE_GRAY_DARK_COLOR;
    } else {
        return GRAY_LIGHT_COLOR;
    }
}

- (Boolean)isCompleted {
    //Movie Quizz 1
//    Boolean isMovieQuizz1Completed = [GameDBHelper isPackFinishedInMovieQuizz1:self.fExtra1];
    
    //Check if the user is connected
    Boolean userIsConnected = [[ProgressManager instance] isConnected];
    
    return ((!userIsConnected && m_isCompleted) /*|| isMovieQuizz1Completed*/ || m_isRemoteCompleted);
}

- (void)setIsCompleted:(Boolean)isCompleted {
    m_isCompleted = isCompleted;
}

- (void)refreshCompleted {
//    if (self.identifier == 158) {
//        NSLog(@"158");
//    }
    
    //Local
    Boolean databaseCompleted = [GameDBHelper isPackCompleted:self.identifier];
    [self setIsCompleted:databaseCompleted];
    
    //Remote
    Boolean remoteCompleted = [ProgressManager isPackRemoteCompleted:self.identifier];
    [self setIsRemoteCompleted:remoteCompleted];
}

@end
