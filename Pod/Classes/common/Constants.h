//
//  Constants.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 16/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Utils.h"
#import "Preferences.h"
#import "UtilsColors.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_IOS_7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#define IS_IOS_6 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")
#define IS_IOS_5 (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0") && SYSTEM_VERSION_LESS_THAN(@"6.0"))

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0)

#define QUIZZ_APP_FOUND_COLOR UIColorFromRGB(0xff0000)

#define QABlock(block, ...) block ? block(__VA_ARGS__) : nil

#pragma mark - Net

extern int const QUIZZ_APP_INIT_REQUEST_TIMEOUT;
extern int const QUIZZ_APP_DOWNLOAD_REQUEST_TIMEOUT;

extern NSString * const QUIZZ_APP_SERVICE_PATH;

extern NSString * const QUIZZ_APP_SERVICE_INFO;
extern NSString * const QUIZZ_APP_SERVICE_LEVELS_LIST;
extern NSString * const QUIZZ_APP_SERVICE_DOWNLOAD_LEVEL;

extern int const QUIZZ_APP_MEDIA_POINTS_BASE;
extern int const QUIZZ_APP_PACK_POINTS_BASE;

extern NSString * const QUIZZ_APP_SUGGEST_PACK_URL;
extern NSString * const QUIZZ_APP_URL;
extern NSString * const LEVEL_APP_URL;

#pragma mark - Database

extern NSString * const QUIZZ_APP_GAME_DATABASE_NAME;
extern NSString * const QUIZZ_APP_LEVEL_DIRECTORY_PREFIX;

#pragma mark - Prefs

extern NSString * const QUIZZ_APP_SOUND_ACTIVATED_KEY;
extern NSString * const QUIZZ_APP_LANGUAGE_KEY;

#pragma mark - Game

extern int const QUIZZ_APP_NB_MEDIAS_IN_PACK;

extern int const QUIZZ_APP_IPHONE_5_MEDIA_BLUR_OFFSET;

extern NSString * const QUIZZ_APP_SEPARATOR_CHARACTERS;
extern NSString * const QUIZZ_APP_ALPHABET;
extern NSString * const QUIZZ_APP_ALPHABET_AND_NUMBERS;

extern int const QUIZZ_APP_ANSWER_SIZE;
#define REAL_QUIZZ_APP_ANSWER_SIZE PixelsSize(QUIZZ_APP_ANSWER_SIZE)
extern int const QUIZZ_APP_ANSWER_PADDING;
#define REAL_QUIZZ_APP_ANSWER_PADDING PixelsSize(QUIZZ_APP_ANSWER_PADDING)

extern int const QUIZZ_APP_ANSWER_MAX_ROWS;

extern int const QUIZZ_APP_LETTER_SIZE;
#define REAL_QUIZZ_APP_LETTER_SIZE ([Utils isIPad] ? ((QUIZZ_APP_LETTER_SIZE * 2) - 1) : QUIZZ_APP_LETTER_SIZE)

extern int const QUIZZ_APP_LETTER_PADDING;
#define REAL_QUIZZ_APP_LETTER_PADDING ([Utils isIPad] ? ((QUIZZ_APP_LETTER_PADDING * 2) - 1) : QUIZZ_APP_LETTER_PADDING)

extern int const QUIZZ_APP_LETTER_START_X;
#define REAL_QUIZZ_APP_LETTER_START_X ([Utils isIPad] ? (QUIZZ_APP_LETTER_START_X + 1) : QUIZZ_APP_LETTER_START_X)

extern int const QUIZZ_APP_DEFAULT_KEYBOARD_ROWS;

extern float const QUIZZ_APP_POSTER_ANIMATION_DURATION;
extern float const QUIZZ_APP_MEDIA_FOUND_DURATION;

extern int const QUIZZ_APP_END_PACK_ALERT_VIEW;
extern int const QUIZZ_APP_END_LEVEL_ALERT_VIEW;

extern int const QUIZZ_APP_MEDIA_PADDING;
extern int const QUIZZ_APP_MEDIA_FOUND_IMAGE_PADDING;

extern float const POSTER_SCALE_FACTOR;

extern int const QUIZZ_APP_HELP_LIMIT;

extern float QUIZZ_APP_LETTER_BUTTON_ANIMATION_DURATION;

extern float const QA_ROUND_RADIUS;

#pragma mark - Migration

extern NSString * const MOVIE_QUIZZ_MIGRATION_1_PACK_IDS_KEY;
extern NSString * const MOVIE_QUIZZ_MIGRATION_1_PACK_PREFIX;
extern int const MOVIE_QUIZZ_MIGRATION_1_NB_POSTER_IN_PACK;

#pragma mark - Help

extern NSString * const QUIZZ_APP_NEED_HELP_KEY;

#pragma mark - Color

#define QUIZZ_APP_BLUE_MAIN_COLOR UIColorFromRGB(0x33b5e5)
#define QUIZZ_APP_BLUE_SECOND_COLOR UIColorFromRGB(0x0099cc)

#define QUIZZ_APP_RED_MAIN_COLOR UIColorFromRGB(0xff4444)
#define QUIZZ_APP_RED_SECOND_COLOR UIColorFromRGB(0xcc0000)

#define QUIZZ_APP_ORANGE_MAIN_COLOR UIColorFromRGB(0xffbb33)
#define QUIZZ_APP_ORANGE_SECOND_COLOR UIColorFromRGB(0xff8800)

#define QUIZZ_APP_GRAY_MAIN_COLOR UIColorFromRGB(0x8d8d8d)
#define QUIZZ_APP_GRAY_SECOND_COLOR UIColorFromRGB(0x696969)

#define QUIZZ_APP_GREEN_MAIN_COLOR UIColorFromRGB(0x99CC00)
#define QUIZZ_APP_GREEN_SECOND_COLOR UIColorFromRGB(0x669900)

#pragma mark  - Bundle

//Main
#define MAIN_BUNDLE                             [NSBundle mainBundle]

#define QUIZZ_APP_NAMED_BUNDLE(name) [NSBundle bundleWithPath:[MAIN_BUNDLE pathForResource:name ofType:@"bundle"]]

//Xib
#define QUIZZ_APP_XIB_BUNDLE                    QUIZZ_APP_NAMED_BUNDLE(@"QuizzAppXib")

//Image
#define QUIZZ_APP_IMAGE_BUNDLE                  QUIZZ_APP_NAMED_BUNDLE(@"QuizzAppImage")
#define QUIZZ_APP_IMAGE_LOCALIZED_BUNDLE_NAME   [NSString stringWithFormat:@"QuizzApp%@Image", [[Utils currentLanguage] uppercaseString]]
#define QUIZZ_APP_IMAGE_LOCALIZED_BUNDLE        QUIZZ_APP_NAMED_BUNDLE(QUIZZ_APP_IMAGE_LOCALIZED_BUNDLE_NAME)

//Database
#define QUIZZ_APP_DATABASE_BUNDLE               QUIZZ_APP_NAMED_BUNDLE(@"QuizzAppDatabase")

//String
#define QUIZZ_APP_STRING_BUNDLE_NAME            [NSString stringWithFormat:@"QuizzApp%@String", [[Utils currentLanguage] uppercaseString]]
#define QUIZZ_APP_STRING_BUNDLE                 QUIZZ_APP_NAMED_BUNDLE(QUIZZ_APP_STRING_BUNDLE_NAME)

#define QALocalizedString(key)                  NSLocalizedStringFromTableInBundle(key, nil, QUIZZ_APP_STRING_BUNDLE, nil)

@interface Constants : NSObject

+ (void)toggleSoundPref;

+ (Boolean)isSoundActivated;

@end
