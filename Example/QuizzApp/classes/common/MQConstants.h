//
//  MQConstants.h
//  moviequizz2
//
//  Created by Baptiste LE GUELVOUIT on 19/04/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"
#import "UtilsColors.h"

extern NSString * const MOVIE_QUIZZ_GOOGLE_ANALYTICS_ID;

extern NSString * const MOVIE_QUIZZ_APP_ID;

extern NSString * const MOVIE_QUIZZ_GOOGLE_PLAY_CLIENT_ID;

extern NSString * const MOVIE_QUIZZ_GOOGLE_PLAY_PROGRESSION_KEY;

extern NSString * const MOVIE_QUIZZ_GOOGLE_PLAY_LEADER_BOARD_ID;

extern NSString * const MOVIE_QUIZZ_SERVICE_NAME;

extern int const MOVIE_QUIZZ_IOS_START_ID;

extern NSString * TV_SHOW_QUIZZ_APP_ID;

extern NSString * ADDICT_APP_ID;

#define MOVIE_QUIZZ_MAIN_COLOR UIColorFromRGB(0x03a9f4)
#define MOVIE_QUIZZ_SECOND_COLOR UIColorFromRGB(0x29b6f6)
#define MOVIE_QUIZZ_THIRD_COLOR UIColorFromRGB(0x4fc3f7)

#define MOVIE_QUIZZ_OPPOSITE_MAIN_COLOR UIColorFromRGB(0xffa000)
#define MOVIE_QUIZZ_OPPOSITE_SECOND_COLOR UIColorFromRGB(0xffc107)
#define MOVIE_QUIZZ_OPPOSITE_THIRD_COLOR UIColorFromRGB(0xffd54f)

@interface MQConstants : NSObject

@end
