//
//  QuizzApp.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 11/06/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "QuizzApp.h"

QuizzApp * s_quizzAppInstance;

@implementation QuizzApp

@synthesize appId = m_appId;
@synthesize googlePlayClientId = m_googlePlayClientId;
@synthesize googlePlayProgressionKey = m_googlePlayProgressionKey;
@synthesize googlePlayLeaderBoardId = m_googlePlayLeaderBoardId;
@synthesize googleAnalyticsId = m_googleAnalyticsId;
@synthesize mainColor = m_mainColor;
@synthesize secondColor = m_secondColor;
@synthesize thirdColor = m_thirdColor;
@synthesize oppositeMainColor = m_oppositeMainColor;
@synthesize oppositeSecondColor = m_oppositeSecondColor;
@synthesize oppositeThirdColor = m_oppositeThirdColor;
@synthesize gameServiceName = m_gameServiceName;

+ (QuizzApp *)instance {
    if (s_quizzAppInstance == nil) {
        s_quizzAppInstance = [[QuizzApp alloc] init];
    }
    
    return s_quizzAppInstance;
}

@end
