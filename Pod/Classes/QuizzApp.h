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

@property (nonatomic, retain) NSString * appId;

@property (nonatomic, retain) NSString * googlePlayClientId;

@property (nonatomic, retain) NSNumber * googlePlayProgressionKey;

@property (nonatomic, retain) NSString * googlePlayLeaderBoardId;

@property (nonatomic, retain) NSString * googleAnalyticsId;

@property (nonatomic, retain) UIColor * mainColor;

@property (nonatomic, retain) UIColor * secondColor;

@property (nonatomic, retain) UIColor * thirdColor;

@property (nonatomic, retain) UIColor * oppositeMainColor;

@property (nonatomic, retain) UIColor * oppositeSecondColor;

@property (nonatomic, retain) UIColor * oppositeThirdColor;

@property (nonatomic, retain) NSString * gameServiceName;

#pragma mark - Game

@property (nonatomic, retain) GameManager * gameManager;

+ (QuizzApp *)sharedInstance;

@end
