//
//  ProgressManager.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 21/05/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "ProgressManager.h"

NSString * const QA_PROGRESS_KEY = @"QA_PROGRESS_KEY";

#import "GameDBHelper.h"
#import "Constants.h"
#import "Utils.h"
#import "GameProvider.h"

ProgressManager * s_progressManagerInstance;

@implementation ProgressManager

USERPREF_IMPL(NSNumber *, AuthDeclinedGooglePreviously, [NSNumber numberWithBool:NO]);
USERPREF_IMPL(NSDictionary *, ProgressData, nil);

@synthesize currentlySigningIn;
@synthesize currentlyGamesSigningIn;
@synthesize currentlySyncing;
@synthesize clientId = m_clientId;
@synthesize progressionKey = m_progressionKey;
@synthesize listener;
@synthesize userId = m_userId;

+ (ProgressManager *)instance {
    if (s_progressManagerInstance == nil) {
        s_progressManagerInstance = [[ProgressManager alloc] init];
    }
    
    return s_progressManagerInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (Boolean)isConnected {
    if (IS_IOS_7) {
        Boolean isSigningIn = self.currentlySigningIn;
        Boolean isGamesSigningIn = self.currentlyGamesSigningIn;
        
        Boolean isSignedIn = [GPGManager sharedInstance].isSignedIn;
        
        return isSignedIn && !isSigningIn && !isGamesSigningIn;
    } else {
        //Never connected
        return NO;
    }
}

- (void)cancel {
    [self setListener:nil];
    
    [self setCurrentlySyncing:NO];
    [self setCurrentlyGamesSigningIn:NO];
    [self setCurrentlySigningIn:NO];
}

#pragma mark - Google+

- (void)setCredentialsWithClientId:(NSString *)aClientId andProgressionKey:(NSNumber *)aProgressionKey {
    //Store client information
    [self setClientId:aClientId];
    [self setProgressionKey:aProgressionKey];
    
#warning TO PORT
    //Create Google+ sign in instance
//    GPPSignIn * signIn = [GPPSignIn sharedInstance];
//    
//    //Set client information
//    [signIn setClientID:self.clientId];
//    [signIn setScopes:[NSArray arrayWithObjects:@"https://www.googleapis.com/auth/games", @"https://www.googleapis.com/auth/appstate", nil]];
//    [signIn setLanguage:[Utils currentLanguage]];
//    [signIn setDelegate:self];
//    [signIn setShouldFetchGoogleUserID:YES];
//    
//    [[GPGManager sharedInstance] setStatusDelegate:self];
}

- (void)signInWithListener:(id<PProgressAuthListener>)aListener {
    //Set listener
    [self setListener:aListener];

#warning TO PORT
//    GPPSignIn * signIn = [GPPSignIn sharedInstance];
//    self.currentlySigningIn = [signIn trySilentAuthentication];
    
    if (!self.currentlySigningIn) {
        //Have we tried signing the user in before?
        Boolean previouslyDeclined = [[ProgressManager getAuthDeclinedGooglePreviously] boolValue];
        if (previouslyDeclined) {
            //Notify listener
            [self.listener onAuthDeclined];
        } else {
            //Re-authenticate
            [self authenticateWithListener:aListener];
        }
    }
}

- (void)authenticateWithListener:(id<PProgressAuthListener>)aListener {
    self.currentlySigningIn = YES;
    
    //Set listener
    [self setListener:aListener];

#warning TO PORT
//    GPPSignIn * signIn = [GPPSignIn sharedInstance];
//    [signIn authenticate];
}

- (void)signOutWithListener:(id<PProgressAuthListener>)aListener {
    //Set listener
    [self setListener:aListener];

#warning TO PORT
//    GPPSignIn * signIn = [GPPSignIn sharedInstance];
//    [signIn disconnect];
}

#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    NSLog(@"Finished with auth.");
    self.currentlySigningIn = NO;
    
    //Check error
    if (error == nil && auth) {
#warning TO PORT
//        GPPSignIn * signIn = [GPPSignIn sharedInstance];
//        [self setUserId:signIn.userID];
        
        NSLog(@"Success signing in to Google! Auth object is %@", auth);
    } else {
        [self setUserId:nil];
        
        //If its a declination error
        if ([error code] == kErrorCodeFromUserDecliningSignIn) {
            //Remember decline
            [ProgressManager setAuthDeclinedGooglePreviously:[NSNumber numberWithBool:YES]];
        }
    }
    
    [self.listener onSignInDoneWithError:error];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error == nil) {
        [self setUserId:nil];
        
        NSLog(@"Success signing out from Google!");
    } else {
        //???
    }
    
    [self.listener onSignOutDoneWithError:error];
}

#pragma mark - GooglePlayGames

- (void)signInGamesWithListener:(id<PProgressAuthListener>)aListener {
    self.currentlyGamesSigningIn = YES;
    
    //Set listener
    [self setListener:aListener];

#warning TO PORT
    //The GPPSignIn object has an auth token now. Pass it to the GPGManager.
//    [[GPGManager sharedInstance] signIn:[GPPSignIn sharedInstance] reauthorizeHandler:^(BOOL requiresKeychainWipe, NSError * error) {
//        //If you hit this, auth has failed and you need to authenticate.
//        self.currentlyGamesSigningIn = NO;
//        
//        //Most likely you can refresh behind the scenes
//        if (requiresKeychainWipe) {
//            [self signOutWithListener:aListener];
//        }
//        
//        [self authenticateWithListener:aListener];
//    }];
}

- (void)signOutGamesWithListener:(id<PProgressAuthListener>)aListener {
    //Set listener
    [self setListener:aListener];
    
    //Sign out games
    [[GPGManager sharedInstance] signOut];
}

#pragma mark - GPGStatusDelegate

- (void)didFinishGamesSignInWithError:(NSError *)error {
    self.currentlyGamesSigningIn = NO;
    
    //Check error
    if (error != nil) {
        NSLog(@"ERROR signing in: %@", [error localizedDescription]);
    }
    
    //Notify listener
    [self.listener onGamesSignInDoneWithError:error];
}

- (void)didFinishGamesSignOutWithError:(NSError *)error {
    //Check error
    if (error != nil) {
        NSLog(@"ERROR signing out: %@", [error localizedDescription]);
    }
    
    //Notify listener
    [self.listener onGamesSignOutDoneWithError:error];
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

- (Boolean)loadProgression:(id<PProgressGamesListener>)gamesListener {
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
//            [gamesListener onGamesLoadDoneWithError:error];
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
    
    if (IS_IOS_7 && [GPGManager sharedInstance].isSignedIn) {
#warning TO PORT
//        GPGAppStateModel * model = [GPGManager sharedInstance].applicationModel.appState;
//        progressData = [model stateDataForKey:self.progressionKey];
    }
    
    return progressData;
}

- (NSData *)getPrefsProgressionData {
    NSData * progressData = nil;
    
    if (m_userId != nil) {
        NSDictionary * prefsProgression = [ProgressManager getProgressData];
        progressData = [prefsProgression objectForKey:m_userId];
    }
    
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
    NSData * progressData = [[ProgressManager instance] getRemoteProgressionData];
    
    if (progressData != nil) {
        remoteCompletedPacks = [NSJSONSerialization JSONObjectWithData:progressData options:NSJSONReadingMutableContainers error:nil];
    }
    
    return remoteCompletedPacks;
}

+ (NSDictionary *)getPrefsProgression {
    NSDictionary * remoteCompletedPacks = nil;
    NSData * progressData = [[ProgressManager instance] getPrefsProgressionData];
    
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

- (Boolean)saveProgressionWithListener:(id<PProgressGamesListener>)gamesListener andInstantProgression:(NSDictionary *)instantProgression {
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
        
        if ((data != nil) && (m_userId != nil)) {
            //First save it in UsersPref
            NSMutableDictionary * prefsProgression = [NSMutableDictionary dictionaryWithDictionary:[ProgressManager getProgressData]];
            [prefsProgression setObject:data forKey:m_userId];
            [ProgressManager setProgressData:prefsProgression];

#warning TO PORT
            //Get app model
//            GPGAppStateModel * model = [GPGManager sharedInstance].applicationModel.appState;
//            
//            //Set progression data
//            [model setStateData:data forKey:self.progressionKey];
//            
//            //And try to save online
//            [model updateForKey:self.progressionKey completionHandler:^(GPGAppStateWriteStatus status, NSError * error) {
//                [self setCurrentlySyncing:NO];
//                
//                //Notify end to listener
//                [gamesListener onGamesSaveDoneWithError:error];
//            } conflictHandler:^NSData * (NSNumber * key, NSData * localState, NSData * remoteState) {
//                //Conflict handling
//                return [self resolveState:localState andSecondState:remoteState];
//            }];
        } else {
            [self setCurrentlySyncing:NO];
            
            //Notify end to listener
            [gamesListener onGamesSaveDoneWithError:nil];
        }
        
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
