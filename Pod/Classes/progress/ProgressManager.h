//
//  ProgressManager.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 21/05/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <gpg/GooglePlayGames.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

static int const kErrorCodeFromUserDecliningSignIn = -1;
#define ApplicationOpenGoogleAuthNotification @"ApplicationOpenGoogleAuthNotification"

#import "PProgressAuthListener.h"
#import "PProgressGamesListener.h"
#import "Constants.h"

@interface ProgressManager : NSObject <GIDSignInDelegate, GPGStatusDelegate> {
    NSString * m_clientId;
    NSNumber * m_progressionKey;
        
    NSString * m_userId;
}

USERPREF_DECL(NSNumber *, AuthDeclinedGooglePreviously);
USERPREF_DECL(NSDictionary *, ProgressData);

@property (nonatomic, readwrite) Boolean currentlySigningIn;

@property (nonatomic, readwrite) Boolean currentlyGamesSigningIn;

@property (nonatomic, readwrite) Boolean currentlySyncing;

@property (nonatomic, retain) NSString * clientId;

@property (nonatomic, retain) NSNumber * progressionKey;

@property (assign) id<PProgressAuthListener> listener;

@property (nonatomic, retain) NSString * userId;

+ (ProgressManager *)instance;

- (Boolean)isConnected;

- (void)cancel;

#pragma mark - Google+

- (void)setCredentialsWithClientId:(NSString *)clientId andProgressionKey:(NSNumber *)progressionKey;

- (void)signInWithListener:(id<PProgressAuthListener>)listener;

- (void)authenticateWithListener:(id<PProgressAuthListener>)listener;

- (void)signOutWithListener:(id<PProgressAuthListener>)listener;

#pragma mark - GooglePlayGames

- (void)signInGamesWithListener:(id<PProgressAuthListener>)listener;

- (void)signOutGamesWithListener:(id<PProgressAuthListener>)listener;

#pragma mark - Progress

- (Boolean)loadProgression:(id<PProgressGamesListener>)gamesListener;

- (Boolean)saveProgressionWithListener:(id<PProgressGamesListener>)gamesListener andInstantProgression:(NSDictionary *)instantProgression;

+ (NSDictionary *)getRemoteProgression;

+ (Boolean)isPackRemoteCompleted:(int)packId;

+ (Boolean)isMediaRemoteCompleted:(int)mediaId;

#pragma mark - Score

+ (float)getScore;

@end
