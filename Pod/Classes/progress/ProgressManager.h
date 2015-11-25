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

typedef void (^ProgressManagerSaveProgressionSuccessHandler)(NSData * data);
typedef void (^ProgressManagerSaveProgressionFailureHandler)(NSError * error);

typedef void (^ProgressManagerLoadProgressionSuccessHandler)(GKSavedGame * savedGame);
typedef void (^ProgressManagerLoadProgressionFailureHandler)(NSError * error);

typedef void (^ProgressManagerCleanProgressionCompletionHandler)(NSError * error);

#import "Constants.h"

@interface ProgressManager : NSObject

USERPREF_DECL(NSDictionary *, ProgressData);

@property (nonatomic, strong) NSData * savedData;

@property (nonatomic, readonly) BOOL isAuthenticating;

@property (nonatomic, readonly) BOOL isSyncing;

#pragma mark - Authenticate

- (void)cancel;

- (BOOL)isAuthenticated;

- (BOOL)hasSavedGame;

- (void)authenticateWithViewController:(UIViewController *)viewController
                               success:(ProgressManagerSignInSuccessHandler)success
                               failure:(ProgressManagerSignInFailureHandler)failure;
#pragma mark - Progress

- (BOOL)saveProgressionWithInstantProgression:(NSDictionary *)instantProgression
                                      success:(ProgressManagerLoadProgressionSuccessHandler)success
                                      failure:(ProgressManagerLoadProgressionFailureHandler)failure;

#pragma mark - Static

+ (NSDictionary *)getRemoteProgression;

+ (Boolean)isPackRemoteCompleted:(int)packId;

+ (Boolean)isMediaRemoteCompleted:(int)mediaId;

#pragma mark - Score

+ (float)getScore;

@end
