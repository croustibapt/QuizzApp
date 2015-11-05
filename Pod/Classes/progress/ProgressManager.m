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

@implementation ProgressManager

USERPREF_IMPL(NSNumber *, AuthDeclinedGooglePreviously, [NSNumber numberWithBool:NO]);
USERPREF_IMPL(NSDictionary *, ProgressData, nil);

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)cancel {
    [self setDelegate:nil];
    
    [self setCurrentlySyncing:NO];
//    [self setCurrentlyGamesSigningIn:NO];
//    [self setCurrentlySigningIn:NO];
}

- (BOOL)isConnected {
    return [GPGManager sharedInstance].isSignedIn;
}

#pragma mark - Google+

- (void)setCredentialsWithClientId:(NSString *)aClientId andProgressionKey:(NSNumber *)aProgressionKey {
    //Store client information
    [self setClientId:aClientId];
    [self setProgressionKey:aProgressionKey];
    
#warning TO PORT
//    //Create Google+ sign in instance
//    GIDSignIn * signIn = [GIDSignIn sharedInstance];
//    
//    //Set client information
//    [signIn setClientID:self.clientId];
//    [signIn setScopes:];
//    [signIn setLanguage:[Utils currentLanguage]];
//    [signIn setDelegate:self];
////    [signIn setShouldFetchGoogleUserID:YES];
    
    [[GPGManager sharedInstance] setStatusDelegate:self];
}

- (void)signInWithDelegate:(id<ProgressAuthDelegate>)aDelegate {
    //Set delegate
    [self setDelegate:aDelegate];

#warning TO PORT
    GPGManager * gpgManager = [GPGManager sharedInstance];
    [gpgManager setStatusDelegate:self];
    NSArray * scopes = @[@"https://www.googleapis.com/auth/games", @"https://www.googleapis.com/auth/appstate"];
    
    BOOL silentlySigned = [gpgManager signInWithClientID:self.clientId silently:YES withExtraScopes:scopes];
    
    if (!silentlySigned) {
        [gpgManager signInWithClientID:self.clientId silently:NO withExtraScopes:scopes];
    }
}

- (void)signOutWithDelegate:(id<ProgressAuthDelegate>)aDelegate {
    //Set delegate
    [self setDelegate:aDelegate];

    //Sign out from Google Play Games
    [[GPGManager sharedInstance] signOut];
}

#pragma mark - GPGStatusDelegate

- (void)didFinishGamesSignInWithError:(NSError *)error {
    //Check error
    if (error != nil) {
        NSLog(@"ERROR signing in: %@", [error localizedDescription]);
    }
    
    //Notify delegate
    [self.delegate onGamesSignInDoneWithError:error];
}

- (void)didFinishGamesSignOutWithError:(NSError *)error {
    //Check error
    if (error != nil) {
        NSLog(@"ERROR signing out: %@", [error localizedDescription]);
    }
    
    //Notify delegate
    [self.delegate onGamesSignOutDoneWithError:error];
}



#pragma mark - Progress

- (void)clean {
#warning TO PORT
//    GPGAppStateModel * model = [GPGManager sharedInstance].applicationModel.appState;
//    
//    //    [model clearForKey:self.progressionKey completionHandler:^(GPGAppStateWriteStatus status, NSError * error) {
//    //
//    //    } conflictHandler:^NSData * (NSNumber * key, NSData * localState, NSData * remoteState) {
//    //        //Always load remote state
//    //        return remoteState;
//    //    }];
//    [model deleteForKey:self.progressionKey completionHandler:^(GPGAppStateWriteStatus status, NSError * error) {
//        //
//        NSLog(@"OK");
//    }];
}

- (Boolean)loadProgression:(id<ProgressGameDelegate>)gamesDelegate {
    //    //TEMP DEBUG
    //    [self clean];
    //    return YES;
    
    //Sign test
    if ([GPGManager sharedInstance].isSignedIn) {
        [self setCurrentlySyncing:YES];
        
#warning TO PORT
        //Get app model
//        GPGAppStateModel * model = [GPGManager sharedInstance].applicationModel.appState;
//        
//        [model loadForKey:self.progressionKey completionHandler:^(GPGAppStateLoadStatus status, NSError * error) {
//            //Not found
//            if (status == GPGAppStateLoadStatusNotFound) {
//                //Save the progression for the first time
//                error = nil;
//            } else if (status == GPGAppStateLoadStatusSuccess) {
//                NSLog(@"load ok");
//            }
//            
//            [self setCurrentlySyncing:NO];
//            
//            [gamesDelegate onGamesLoadDoneWithError:error];
//        } conflictHandler:^NSData * (NSNumber * key, NSData * localState, NSData * remoteState) {
//            //Always load remote state
//            return remoteState;
//        }];
        
        return YES;
    }
    
    return NO;
}

- (NSData *)getRemoteProgressionData {
    NSData * progressData = nil;
    
    if ([GPGManager sharedInstance].isSignedIn) {
#warning TO PORT
//        GPGAppStateModel * model = [GPGManager sharedInstance].applicationModel.appState;
//        progressData = [model stateDataForKey:self.progressionKey];
    }
    
    return progressData;
}

- (NSData *)getPrefsProgressionData {
    NSData * progressData = nil;

#warning TO FIX
//    if (self.userId != nil) {
//        NSDictionary * prefsProgression = [ProgressManager getProgressData];
//        progressData = [prefsProgression objectForKey:self.userId];
//    }
    
    return progressData;
}

+ (NSArray *)extractRemoteCompletedMediasWithProgression:(NSDictionary *)progression {
    NSMutableArray * remoteCompletedMedias = nil;
    
    for (NSNumber * packId in progression) {
        if (remoteCompletedMedias == nil) {
            remoteCompletedMedias = [NSMutableArray array];
        }
        
        NSSet * medias = [progression objectForKey:packId];
        [remoteCompletedMedias addObjectsFromArray:[medias allObjects]];
    }
    
    return remoteCompletedMedias;
}

+ (NSArray *)getRemoteCompletedMedias {
    NSArray * remoteCompletedMedias = nil;
    
    //
    NSDictionary * mergedProgression = [ProgressManager getRemoteCompletedPacks];
    
    //Check nullity
    if (mergedProgression != nil) {
        remoteCompletedMedias = [ProgressManager extractRemoteCompletedMediasWithProgression:mergedProgression];
    }
    
    return remoteCompletedMedias;
}

+ (Boolean)isMediaRemoteCompleted:(int)mediaId {
    NSArray * remoteCompletedMedias = [ProgressManager getRemoteCompletedMedias];
    return [remoteCompletedMedias containsObject:[NSNumber numberWithInt:mediaId]];
}

+ (NSDictionary *)getRemoteProgression {
    NSDictionary * remoteCompletedPacks = nil;
    NSData * progressData = [[QuizzApp sharedInstance].progressManager getRemoteProgressionData];
    
    if (progressData != nil) {
        remoteCompletedPacks = [NSJSONSerialization JSONObjectWithData:progressData options:NSJSONReadingMutableContainers error:nil];
    }
    
    return remoteCompletedPacks;
}

+ (NSDictionary *)getPrefsProgression {
    NSDictionary * remoteCompletedPacks = nil;
    NSData * progressData = [[QuizzApp sharedInstance].progressManager getPrefsProgressionData];
    
    if (progressData != nil) {
        remoteCompletedPacks = [NSJSONSerialization JSONObjectWithData:progressData options:NSJSONReadingMutableContainers error:nil];
    }
    
    return remoteCompletedPacks;
}

+ (NSDictionary *)getRemoteCompletedPacks {
    //Remote progression
    NSDictionary * remoteProgression = [ProgressManager getRemoteProgression];
    
    //Prefs progression
    NSDictionary * prefsProgression = [ProgressManager getPrefsProgression];
    
    //Merge both
    NSDictionary * remotePacks = [ProgressManager mergeProgressionWithProgression1:remoteProgression andProgression2:prefsProgression];
    
    return remotePacks;
}

+ (Boolean)isPackRemoteCompleted:(int)packId {
    NSDictionary * remoteCompletedPacks = [ProgressManager getRemoteCompletedPacks];
    
    NSString * packKey = [NSString stringWithFormat:@"%d", packId];
    NSArray * medias = [remoteCompletedPacks objectForKey:packKey];
    
    return ([medias count] == QUIZZ_APP_NB_MEDIAS_IN_PACK);
}

+ (NSDictionary *)mergeProgressionWithProgression1:(NSDictionary *)progression1 andProgression2:(NSDictionary *)progression2 {
    NSMutableDictionary * progression = nil;
    
    NSMutableArray * allPacksIds = [NSMutableArray arrayWithArray:progression1.allKeys];
    [allPacksIds addObjectsFromArray:progression2.allKeys];
    
    NSSet * packIds = [NSSet setWithArray:allPacksIds];
    for (NSNumber * packId in packIds) {
        if (progression == nil) {
            progression = [NSMutableDictionary dictionary];
        }
        
        //Get all found medias identifiers
        NSArray * packs1 = [progression1 objectForKey:packId];
        NSSet * packs1Set = [NSSet setWithArray:packs1];
        
        NSArray * packs2 = [progression2 objectForKey:packId];
        NSSet * packs2Set = [NSSet setWithArray:packs2];
        
        NSMutableSet * completedPacks = nil;
        if (packs1Set == nil) {
            completedPacks = [NSMutableSet setWithSet:packs2Set];
        } else {
            completedPacks = [NSMutableSet setWithSet:packs1Set];
            [completedPacks unionSet:packs2Set];
        }
        
        //Check nullity
        if ([completedPacks count] > 0) {
            [progression setObject:[completedPacks allObjects] forKey:packId];
        }
    }
    
    return progression;
}

+ (NSDictionary *)getProgression {
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
    NSDictionary * mergedProgression = [ProgressManager mergeProgressionWithProgression1:localProgression andProgression2:remoteProgression];
    
    //Re-merge
    mergedProgression = [ProgressManager mergeProgressionWithProgression1:mergedProgression andProgression2:prefsProgression];
    
    return mergedProgression;
}

- (Boolean)saveProgressionWithDelegate:(id<ProgressGameDelegate>)gamesDelegate andInstantProgression:(NSDictionary *)instantProgression {
    //Check if the user is connected and if we have a progression key
    if ((self.progressionKey != nil) && [GPGManager sharedInstance].isSignedIn) {
        //Notify we are syncing
        [self setCurrentlySyncing:YES];
        
        //Get all completed medias (remote U local)
        NSDictionary * progression = [ProgressManager getProgression];
        progression = [ProgressManager mergeProgressionWithProgression1:progression andProgression2:instantProgression];
        
        NSData * data = nil;
        NSError * error = nil;
        
        //Check nullity
        if (progression != nil) {
            //Format data to save
            data = [NSJSONSerialization dataWithJSONObject:progression options:NSJSONWritingPrettyPrinted error:&error];
//            data = [progression JSONDataWithOptions:JKSerializeOptionNone error:&error];
        }

#warning TO PORT
//        if ((data != nil) && (self.userId != nil)) {
//            //First save it in UsersPref
//            NSMutableDictionary * prefsProgression = [NSMutableDictionary dictionaryWithDictionary:[ProgressManager getProgressData]];
//            [prefsProgression setObject:data forKey:self.userId];
//            [ProgressManager setProgressData:prefsProgression];
//
//            //Get app model
//            GPGAppStateModel * model = [GPGManager sharedInstance].applicationModel.appState;
//            
//            //Set progression data
//            [model setStateData:data forKey:self.progressionKey];
//            
//            //And try to save online
//            [model updateForKey:self.progressionKey completionHandler:^(GPGAppStateWriteStatus status, NSError * error) {
//                [self setCurrentlySyncing:NO];
//                
//                //Notify end to delegate
//                [gamesDelegate onGamesSaveDoneWithError:error];
//            } conflictHandler:^NSData * (NSNumber * key, NSData * localState, NSData * remoteState) {
//                //Conflict handling
//                return [self resolveState:localState andSecondState:remoteState];
//            }];
//        } else {
//            [self setCurrentlySyncing:NO];
//            
//            //Notify end to delegate
//            [gamesDelegate onGamesSaveDoneWithError:nil];
//        }
        
        return YES;
    }
    
    return NO;
}

- (NSData *)resolveState:(NSData *)localState andSecondState:(NSData *)remoteState {
    //Local progression
    NSDictionary * localProgression = [NSJSONSerialization JSONObjectWithData:localState options:NSJSONReadingMutableContainers error:nil];
    
    //Remote progression
    NSDictionary * remoteProgression = [NSJSONSerialization JSONObjectWithData:remoteState options:NSJSONReadingMutableContainers error:nil];
    
    //Merge both
    NSDictionary * mergedProgression = [ProgressManager mergeProgressionWithProgression1:localProgression andProgression2:remoteProgression];
    
    return [NSJSONSerialization dataWithJSONObject:mergedProgression options:NSJSONWritingPrettyPrinted error:nil];
}

#pragma mark - Score

+ (float)getScore {
    //Local score
    float score = 0.0;
    
    //Compute score
    NSString * language = [Utils currentLanguage];
    NSArray * allLevels = [GameProvider getAllLevels:language];
    
    for (BaseLevel * level in allLevels) {
        for (NSNumber * packId in level.basePacks) {
            BasePack * basePack = [level.basePacks objectForKey:packId];
            
            if (basePack.isCompleted) {
                float addScore = (basePack.difficulty * QUIZZ_APP_PACK_POINTS_BASE);
                score += addScore;
            }
        }
    }
    
    return score;
}

@end
