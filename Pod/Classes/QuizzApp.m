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
        self.progressManager = [[ProgressManager alloc] init];
    }
    return self;
}

- (void)initializeWithAppId:(NSString *)appId
            gameServiceName:(NSString *)gameServiceName
                  mainColor:(UIColor *)mainColor
                secondColor:(UIColor *)secondColor
                 thirdColor:(UIColor *)thirdColor
          oppositeMainColor:(UIColor *)oppositeMainColor
        oppositeSecondColor:(UIColor *)oppositeSecondColor
         oppositeThirdColor:(UIColor *)oppositeThirdColor
{
    _appId = appId;
    [self setGameServiceName:gameServiceName];
    
    [self setMainColor:mainColor];
    [self setSecondColor:secondColor];
    [self setThirdColor:thirdColor];
    
    [self setOppositeMainColor:oppositeMainColor];
    [self setOppositeSecondColor:oppositeSecondColor];
    [self setOppositeThirdColor:oppositeThirdColor];
}

@end
