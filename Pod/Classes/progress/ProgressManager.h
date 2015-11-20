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

- (BOOL)isAuthenticated;

#pragma mark - SignIn

- (void)authenticateWithViewController:(UIViewController *)viewController success:(ProgressManagerSignInSuccessHandler)success failure:(ProgressManagerSignInFailureHandler)failure;

#pragma mark - Progress

- (BOOL)loadProgression:(id<ProgressGameDelegate>)delegate;

- (BOOL)saveProgressionWithProgressionKey:(NSString *)progressionKey delegate:(id<ProgressGameDelegate>)gamesDelegate andInstantProgression:(NSDictionary *)instantProgression;

+ (NSDictionary *)getRemoteProgression;

+ (Boolean)isPackRemoteCompleted:(int)packId;

+ (Boolean)isMediaRemoteCompleted:(int)mediaId;

#pragma mark - Score

+ (float)getScore;

@end
