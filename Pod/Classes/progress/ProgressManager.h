//
//  ProgressManager.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 21/05/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <gpg/GooglePlayGames.h>

static int const kErrorCodeFromUserDecliningSignIn = -1;
#define ApplicationOpenGoogleAuthNotification @"ApplicationOpenGoogleAuthNotification"

#import "Constants.h"

@protocol ProgressGameDelegate <NSObject>

- (void)onGamesSaveDoneWithError:(NSError *)error;

- (void)onGamesLoadDoneWithError:(NSError *)error;

@end

@protocol ProgressAuthDelegate <NSObject>

- (void)onSignInDoneWithError:(NSError *)error;

- (void)onSignOutDoneWithError:(NSError *)error;

- (void)onGamesSignInDoneWithError:(NSError *)error;

- (void)onGamesSignOutDoneWithError:(NSError *)error;

- (void)onAuthDeclined;

@end

@interface ProgressManager : NSObject <GPGStatusDelegate>

USERPREF_DECL(NSNumber *, AuthDeclinedGooglePreviously);
USERPREF_DECL(NSDictionary *, ProgressData);

//@property (nonatomic) Boolean currentlySigningIn;
//
//@property (nonatomic) Boolean currentlyGamesSigningIn;

@property (nonatomic) Boolean currentlySyncing;

@property (nonatomic, weak) id<ProgressAuthDelegate> delegate;

- (void)cancel;

- (BOOL)isConnected;

#pragma mark - GooglePlayGames

- (void)signInWithClientId:(NSString *)clientId delegate:(id<ProgressAuthDelegate>)delegate;

- (void)signOutWithDelegate:(id<ProgressAuthDelegate>)delegate;

#pragma mark - Progress

- (Boolean)loadProgression:(id<ProgressGameDelegate>)delegate;

- (Boolean)saveProgressionWithProgressionKey:(NSNumber *)progressionKey delegate:(id<ProgressGameDelegate>)gamesDelegate andInstantProgression:(NSDictionary *)instantProgression;

+ (NSDictionary *)getRemoteProgression;

+ (Boolean)isPackRemoteCompleted:(int)packId;

+ (Boolean)isMediaRemoteCompleted:(int)mediaId;

#pragma mark - Score

+ (float)getScore;

@end
