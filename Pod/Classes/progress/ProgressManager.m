//
//  ProgressManager.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 21/05/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "ProgressManager.h"

#import "GameDBHelper.h"
#import "Constants.h"
#import "Utils.h"
#import "GameProvider.h"
#import "QuizzApp.h"

@interface ProgressManager()
{
    GKLocalPlayer * _player;
    GKSavedGame * _savedGame;
}

@end

@implementation ProgressManager

USERPREF_IMPL(NSDictionary *, ProgressData, nil);

#pragma mark - Authenticate

- (void)cancel
{
    
}

- (BOOL)isAuthenticated
{
    return _player.isAuthenticated;
}

- (BOOL)hasSavedGame
{
    return (_savedGame != nil);
}

- (void)authenticateWithViewController:(UIViewController *)viewController
                        progressionKey:(NSString *)progressionKey
                                success:(ProgressManagerSignInSuccessHandler)success
                                failure:(ProgressManagerSignInFailureHandler)failure
{
    _isAuthenticating = YES;
    
    [[GKLocalPlayer localPlayer] setAuthenticateHandler:
     ^(UIViewController * gameKitViewController, NSError * error)
    {
        if (gameKitViewController)
        {
            // Present login view controller
            [viewController presentViewController:gameKitViewController animated:YES completion:nil];
        }
        else if ([GKLocalPlayer localPlayer])
        {
            // Store player
            _player = [GKLocalPlayer localPlayer];
            _isAuthenticating = NO;
            
            // Load progression
            [self loadProgressionWithProgressionKey:progressionKey success:success failure:failure];
        }
        else
        {
            _player = nil;
            _isAuthenticating = NO;
            
            QABlock(failure, error);
        }
    }];
}

#pragma mark - Progress

- (void)loadProgressionWithProgressionKey:(NSString *)progressionKey
                                  success:(ProgressManagerSignInSuccessHandler)success
                                  failure:(ProgressManagerSignInFailureHandler)failure
{
    if ([self isAuthenticated])
    {
        _isSyncing = YES;

        [_player fetchSavedGamesWithCompletionHandler:
         ^(NSArray * savedGames, NSError * fetchError)
         {
             if (fetchError)
             {
                 _isSyncing = NO;
                 
                 QABlock(failure, fetchError);
             }
             else
             {
                 for (GKSavedGame * savedGame in savedGames)
                 {
                     if ([savedGame.name isEqualToString:progressionKey])
                     {
                         // Saved game found
                         _savedGame = savedGame;
                         break;
                     }
                 }
                 
                 if (_savedGame)
                 {
                     // Load data
                     [_savedGame loadDataWithCompletionHandler:
                      ^(NSData * _Nullable data, NSError * _Nullable loadError)
                      {
                          if (loadError)
                          {
                              _isSyncing = NO;
                              
                              QABlock(failure, loadError);
                          }
                          else
                          {
                              _savedData = data;
                              _isSyncing = NO;
                              
                              QABlock(success, _player);
                          }
                      }];
                 }
                 else
                 {
                     _isSyncing = NO;
                     
                     // No saved game found
                     QABlock(failure, nil);
                 }
             }
         }];
    }
}

// Return YES is a progression (with data) is found, otherwise NO
- (BOOL)saveProgressionWithProgressionKey:(NSString *)progressionKey
                       instantProgression:(NSDictionary *)instantProgression
                                  success:(ProgressManagerLoadProgressionSuccessHandler)success
                                  failure:(ProgressManagerLoadProgressionFailureHandler)failure
{
    if ([self isAuthenticated] && [self hasSavedGame])
    {
        // Get all completed medias (remote U local)
        NSDictionary * progression = [ProgressManager getProgression];
        progression = [ProgressManager mergeProgressionWithProgression1:progression
                                                           progression2:instantProgression];
        
        NSData * data = nil;
        NSError * error = nil;
        
        // Check nullity
        if (progression) {
            // Format data to save
            data = [NSJSONSerialization dataWithJSONObject:progression options:NSJSONWritingPrettyPrinted error:&error];
            
            if (data)
            {
                //First save it in UsersPref
                NSMutableDictionary * prefsProgression = [NSMutableDictionary dictionaryWithDictionary:[ProgressManager getProgressData]];
                [prefsProgression setObject:data forKey:_player.playerID];
                [ProgressManager setProgressData:prefsProgression];
                
                // Save in GameKit
                [_player saveGameData:data
                             withName:progressionKey
                    completionHandler:
                 ^(GKSavedGame * _Nullable savedGame, NSError * _Nullable error)
                {
                    // Does an error occured?
                    if (error)
                    {
                        // Notify end to delegate
                        failure(error);
                    }
                    else
                    {
                        // Store new data
                        _savedData = data;

                        // And notify listener
                        success(savedGame);
                    }
                }];
                
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)cleanWithCompletionHandler:(ProgressManagerCleanProgressionCompletionHandler)completionHandler
{
    if ([self isAuthenticated] && [self hasSavedGame])
    {
        [_player deleteSavedGamesWithName:_savedGame.name completionHandler:
         ^(NSError * _Nullable error)
        {
            if (!error)
            {
                // Reset saved game
                _savedGame = nil;
                //And corresponding data
                _savedData = nil;
            }
            QABlock(completionHandler, error);
        }];
        
        return YES;
    }
    
    return NO;
}

- (NSData *)getPrefsProgressionData
{
    NSData * progressData = nil;

    if ([self isAuthenticated])
    {
        NSDictionary * prefsProgression = [ProgressManager getProgressData];
        progressData = [prefsProgression objectForKey:_player.playerID];
    }
    
    return progressData;
}

- (NSData *)resolveState:(NSData *)localState andSecondState:(NSData *)remoteState
{
    //Local progression
    NSDictionary * localProgression = [NSJSONSerialization JSONObjectWithData:localState
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:nil];
    
    //Remote progression
    NSDictionary * remoteProgression = [NSJSONSerialization JSONObjectWithData:remoteState
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:nil];
    
    //Merge both
    NSDictionary * mergedProgression = [ProgressManager mergeProgressionWithProgression1:localProgression
                                                                            progression2:remoteProgression];
    
    return [NSJSONSerialization dataWithJSONObject:mergedProgression
                                           options:NSJSONWritingPrettyPrinted
                                             error:nil];
}

#pragma mark - Static

+ (NSArray *)extractRemoteCompletedMediasWithProgression:(NSDictionary *)progression
{
    NSMutableArray * remoteCompletedMedias = nil;
    
    for (NSNumber * packId in progression)
    {
        if (remoteCompletedMedias == nil)
        {
            remoteCompletedMedias = [NSMutableArray array];
        }
        
        NSSet * medias = [progression objectForKey:packId];
        [remoteCompletedMedias addObjectsFromArray:[medias allObjects]];
    }
    
    return remoteCompletedMedias;
}

+ (NSArray *)getRemoteCompletedMedias
{
    NSArray * remoteCompletedMedias = nil;
    
    //
    NSDictionary * mergedProgression = [ProgressManager getRemoteCompletedPacks];
    
    //Check nullity
    if (mergedProgression != nil)
    {
        remoteCompletedMedias = [ProgressManager extractRemoteCompletedMediasWithProgression:mergedProgression];
    }
    
    return remoteCompletedMedias;
}

+ (Boolean)isMediaRemoteCompleted:(int)mediaId
{
    NSArray * remoteCompletedMedias = [ProgressManager getRemoteCompletedMedias];
    return [remoteCompletedMedias containsObject:[NSNumber numberWithInt:mediaId]];
}

+ (NSDictionary *)getRemoteProgression
{
    NSDictionary * remoteCompletedPacks = nil;
    NSData * progressData = [QuizzApp sharedInstance].progressManager.savedData;
    
    if (progressData != nil) {
        remoteCompletedPacks = [NSJSONSerialization JSONObjectWithData:progressData options:NSJSONReadingMutableContainers error:nil];
    }
    
    return remoteCompletedPacks;
}

+ (NSDictionary *)getPrefsProgression
{
    NSDictionary * remoteCompletedPacks = nil;
    NSData * progressData = [[QuizzApp sharedInstance].progressManager getPrefsProgressionData];
    
    if (progressData != nil)
    {
        remoteCompletedPacks = [NSJSONSerialization JSONObjectWithData:progressData options:NSJSONReadingMutableContainers error:nil];
    }
    
    return remoteCompletedPacks;
}

+ (NSDictionary *)getRemoteCompletedPacks
{
    //Remote progression
    NSDictionary * remoteProgression = [ProgressManager getRemoteProgression];
    
    //Prefs progression
    NSDictionary * prefsProgression = [ProgressManager getPrefsProgression];
    
    //Merge both
    NSDictionary * remotePacks = [ProgressManager mergeProgressionWithProgression1:remoteProgression
                                                                      progression2:prefsProgression];
    
    return remotePacks;
}

+ (Boolean)isPackRemoteCompleted:(int)packId
{
    NSDictionary * remoteCompletedPacks = [ProgressManager getRemoteCompletedPacks];
    
    NSString * packKey = [NSString stringWithFormat:@"%d", packId];
    NSArray * medias = [remoteCompletedPacks objectForKey:packKey];
    
    return ([medias count] == QUIZZ_APP_NB_MEDIAS_IN_PACK);
}

+ (NSDictionary *)mergeProgressionWithProgression1:(NSDictionary *)progression1
                                      progression2:(NSDictionary *)progression2
{
    NSMutableDictionary * progression = nil;
    
    NSMutableArray * allPacksIds = [NSMutableArray arrayWithArray:progression1.allKeys];
    [allPacksIds addObjectsFromArray:progression2.allKeys];
    
    NSSet * packIds = [NSSet setWithArray:allPacksIds];
    for (NSNumber * packId in packIds)
    {
        if (progression == nil)
        {
            progression = [NSMutableDictionary dictionary];
        }
        
        //Get all found medias identifiers
        NSArray * packs1 = [progression1 objectForKey:packId];
        NSSet * packs1Set = [NSSet setWithArray:packs1];
        
        NSArray * packs2 = [progression2 objectForKey:packId];
        NSSet * packs2Set = [NSSet setWithArray:packs2];
        
        NSMutableSet * completedPacks = nil;
        if (packs1Set)
        {
            completedPacks = [NSMutableSet setWithSet:packs1Set];
            [completedPacks unionSet:packs2Set];
        }
        else
        {
            completedPacks = [NSMutableSet setWithSet:packs2Set];
        }
        
        //Check nullity
        if ([completedPacks count] > 0)
        {
            [progression setObject:[completedPacks allObjects] forKey:packId];
        }
    }
    
    return progression;
}

+ (NSDictionary *)getProgression
{
    //Get local progression
    NSDictionary * localProgression = nil;
    
    //Only the first time
    if ([ProgressManager getProgressData] == nil) {
        localProgression = [GameDBHelper getLocalProgression];
    }
    
    //Remote progression
    NSDictionary * remoteProgression = [ProgressManager getRemoteProgression];
    
    //Prefs progression
    NSDictionary * prefsProgression = [ProgressManager getPrefsProgression];
    
    //Merge progression
    NSDictionary * mergedProgression = [ProgressManager mergeProgressionWithProgression1:localProgression
                                                                            progression2:remoteProgression];
    
    //Re-merge
    mergedProgression = [ProgressManager mergeProgressionWithProgression1:mergedProgression
                                                             progression2:prefsProgression];
    
    return mergedProgression;
}

#pragma mark - Score

+ (float)getScore
{
    //Local score
    float score = 0.0;
    
    //Compute score
    NSString * language = [Utils currentLanguage];
    NSArray * allLevels = [GameProvider getAllLevels:language];
    
    for (BaseLevel * level in allLevels)
    {
        for (NSNumber * packId in level.basePacks)
        {
            BasePack * basePack = [level.basePacks objectForKey:packId];
            
            if (basePack.isCompleted)
            {
                float addScore = (basePack.difficulty * QUIZZ_APP_PACK_POINTS_BASE);
                score += addScore;
            }
        }
    }
    
    return score;
}

@end
