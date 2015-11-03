//
//  QuizzApp.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 11/06/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "QuizzApp.h"

@implementation QuizzApp

+ (QuizzApp *)sharedInstance {
    static QuizzApp * s_sharedQuizzAppInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        s_sharedQuizzAppInstance = [[self alloc] init];
    });
    
    return s_sharedQuizzAppInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.gameManager = [[GameManager alloc] init];
    }
    return self;
}

- (void)initializeWithGameServiceName:(NSString *)gameServiceName appId:(NSString *)appId googlePlayClientId:(NSString *)googlePlayClientId googlePlayProgressionKey:(NSNumber *)googlePlayProgressionKey googlePlayLeaderBoardId:(NSString *)googlePlayLeaderBoardId googleAnalyticsId:(NSString *)googleAnalyticsId mainColor:(UIColor *)mainColor secondColor:(UIColor *)secondColor thirdColor:(UIColor *)thirdColor oppositeMainColor:(UIColor *)oppositeMainColor oppositeSecondColor:(UIColor *)oppositeSecondColor oppositeThirdColor:(UIColor *)oppositeThirdColor {
    [self setGameServiceName:gameServiceName];
    
    [self setAppId:appId];
    [self setGooglePlayClientId:googlePlayClientId];
    [self setGooglePlayProgressionKey:googlePlayProgressionKey];
    [self setGooglePlayLeaderBoardId:googlePlayLeaderBoardId];
    
    [self setGoogleAnalyticsId:googleAnalyticsId];
    
    [self setMainColor:mainColor];
    [self setSecondColor:secondColor];
    [self setThirdColor:thirdColor];
    
    [self setOppositeMainColor:oppositeMainColor];
    [self setOppositeSecondColor:oppositeSecondColor];
    [self setOppositeThirdColor:oppositeThirdColor];
}

@end
