//
//  QuizzApp.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 11/06/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GameManager.h"

@interface QuizzApp : NSObject

@property (nonatomic, strong) NSString * gameServiceName;

@property (nonatomic, strong) NSString * appId;

@property (nonatomic, strong) NSString * googlePlayClientId;

@property (nonatomic, strong) NSNumber * googlePlayProgressionKey;

@property (nonatomic, strong) NSString * googlePlayLeaderBoardId;

@property (nonatomic, strong) NSString * googleAnalyticsId;

@property (nonatomic, strong) UIColor * mainColor;

@property (nonatomic, strong) UIColor * secondColor;

@property (nonatomic, strong) UIColor * thirdColor;

@property (nonatomic, strong) UIColor * oppositeMainColor;

@property (nonatomic, strong) UIColor * oppositeSecondColor;

@property (nonatomic, strong) UIColor * oppositeThirdColor;

#pragma mark - Game

@property (nonatomic, strong) GameManager * gameManager;

+ (QuizzApp *)sharedInstance;

- (void)initializeWithGameServiceName:(NSString *)gameServiceName appId:(NSString *)appId googlePlayClientId:(NSString *)googlePlayClientId googlePlayProgressionKey:(NSNumber *)googlePlayProgressionKey googlePlayLeaderBoardId:(NSString *)googlePlayLeaderBoardId googleAnalyticsId:(NSString *)googleAnalyticsId mainColor:(UIColor *)mainColor secondColor:(UIColor *)secondColor thirdColor:(UIColor *)thirdColor oppositeMainColor:(UIColor *)oppositeMainColor oppositeSecondColor:(UIColor *)oppositeSecondColor oppositeThirdColor:(UIColor *)oppositeThirdColor;

@end
