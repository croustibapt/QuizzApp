//
//  ProgressManager.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 21/05/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

typedef void (^ProgressManagerSignInSuccessHandler)(GKLocalPlayer * player);
typedef void (^ProgressManagerSignInFailureHandler)(NSError * error);

#import "Constants.h"

@protocol ProgressGameDelegate <NSObject>

- (void)onGamesSaveDoneWithError:(NSError *)error;

- (void)onGamesLoadDoneWithError:(NSError *)error;

@end

@interface ProgressManager : NSObject

USERPREF_DECL(NSDictionary *, ProgressData);

//@property (nonatomic, strong) UIViewController * gameKitViewController;

- (void)cancel;

- (BOOL)isConnected;

#pragma mark - SignIn

- (void)signInWithViewController:(UIViewController *)viewController success:(ProgressManagerSignInSuccessHandler)success failure:(ProgressManagerSignInFailureHandler)failure;

- (void)signOut;

#pragma mark - Progress

- (Boolean)loadProgression:(id<ProgressGameDelegate>)delegate;

- (Boolean)saveProgressionWithProgressionKey:(NSNumber *)progressionKey delegate:(id<ProgressGameDelegate>)gamesDelegate andInstantProgression:(NSDictionary *)instantProgression;

+ (NSDictionary *)getRemoteProgression;

+ (Boolean)isPackRemoteCompleted:(int)packId;

+ (Boolean)isMediaRemoteCompleted:(int)mediaId;

#pragma mark - Score

+ (float)getScore;

@end
