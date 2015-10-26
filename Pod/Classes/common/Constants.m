//
//  Constants.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 16/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "Constants.h"

#pragma mark - Net

int const QUIZZ_APP_INIT_REQUEST_TIMEOUT = 10;
int const QUIZZ_APP_DOWNLOAD_REQUEST_TIMEOUT = 5;

//#if !(TARGET_IPHONE_SIMULATOR)
NSString * const QUIZZ_APP_SERVICE_PATH = @"http://www.quizz-app.com/services/";
//#else
//NSString * const QUIZZ_APP_SERVICE_PATH = @"http://localhost/quizzapp/services/";
//#endif

NSString * const QUIZZ_APP_SERVICE_INFO = @"info";
NSString * const QUIZZ_APP_SERVICE_LEVELS_LIST = @"levels_list";
NSString * const QUIZZ_APP_SERVICE_DOWNLOAD_LEVEL = @"download_level";

int const QUIZZ_APP_MEDIA_POINTS_BASE = 10;
int const QUIZZ_APP_PACK_POINTS_BASE = 50;

NSString * const QUIZZ_APP_SUGGEST_PACK_URL = @"http://www.quizz-app.com/pre_packs/propose";
NSString * const QUIZZ_APP_URL = @"http://www.quizz-app.com";

NSString * const LEVEL_APP_URL = @"http://www.level-app.fr";

#pragma mark - Database

NSString * const QUIZZ_APP_GAME_DATABASE_NAME = @"game";
NSString * const QUIZZ_APP_LEVEL_DIRECTORY_PREFIX = @"level_";

#pragma mark - Prefs

NSString * const QUIZZ_APP_SOUND_ACTIVATED_KEY = @"QUIZZ_APP_SOUND_ACTIVATED_KEY";
NSString * const QUIZZ_APP_LANGUAGE_KEY = @"QUIZZ_APP_LANGUAGE_KEY";

#pragma mark - Game

int const QUIZZ_APP_NB_MEDIAS_IN_PACK = 10;

int const QUIZZ_APP_IPHONE_5_MEDIA_BLUR_OFFSET = 44;

NSString * const QUIZZ_APP_SEPARATOR_CHARACTERS = @" '-";
NSString * const QUIZZ_APP_ALPHABET = @"abcdefghijklmnopqrstuvwxyz";
NSString * const QUIZZ_APP_ALPHABET_AND_NUMBERS = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

int const QUIZZ_APP_ANSWER_SIZE = 18;
int const QUIZZ_APP_ANSWER_PADDING = 4;

int const QUIZZ_APP_ANSWER_MAX_ROWS = 3;

int const QUIZZ_APP_LETTER_SIZE = 35;
int const QUIZZ_APP_LETTER_PADDING = 4;
int const QUIZZ_APP_LETTER_START_X = 6;
int const QUIZZ_APP_DEFAULT_KEYBOARD_ROWS = 2;

float const QUIZZ_APP_POSTER_ANIMATION_DURATION = 0.4;
float const QUIZZ_APP_MEDIA_FOUND_DURATION = 1.0;

int const QUIZZ_APP_END_PACK_ALERT_VIEW = 1;
int const QUIZZ_APP_END_LEVEL_ALERT_VIEW = 2;

int const QUIZZ_APP_MEDIA_PADDING = 10;
int const QUIZZ_APP_MEDIA_FOUND_IMAGE_PADDING = 10;

float const POSTER_SCALE_FACTOR = 0.1;

int const QUIZZ_APP_HELP_LIMIT = 30;

float QUIZZ_APP_LETTER_BUTTON_ANIMATION_DURATION = 0.4;

float const QA_ROUND_RADIUS = 2.0;

#pragma mark - Migration

NSString * const MOVIE_QUIZZ_MIGRATION_1_PACK_IDS_KEY = @"MOVIE_QUIZZ_MIGRATION_1_PACK_IDS_KEY";
NSString * const MOVIE_QUIZZ_MIGRATION_1_PACK_PREFIX = @"pack_";
int const MOVIE_QUIZZ_MIGRATION_1_NB_POSTER_IN_PACK = 10;

#pragma mark - Help

NSString * const QUIZZ_APP_NEED_HELP_KEY = @"QUIZZ_APP_NEED_HELP_KEY";

@implementation Constants

+ (void)toggleSoundPref {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    Boolean soundActivated = [prefs boolForKey:QUIZZ_APP_SOUND_ACTIVATED_KEY];
    
    [prefs setBool:!soundActivated forKey:QUIZZ_APP_SOUND_ACTIVATED_KEY];
    [prefs synchronize];
}

+ (Boolean)isSoundActivated {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    Boolean soundActivated = [prefs boolForKey:QUIZZ_APP_SOUND_ACTIVATED_KEY];
    return soundActivated;
}

@end
