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

#import "Constants.h"

@interface ProgressManager : NSObject

USERPREF_DECL(NSDictionary *, ProgressData);

//@property (nonatomic, strong) UIViewController * gameKitViewController;

- (void)cancel;

- (BOOL)isAuthenticated;

#pragma mark - SignIn

- (void)authenticateWithViewController:(UIViewController *)viewController success:(ProgressManagerSignInSuccessHandler)success failure:(ProgressManagerSignInFailureHandler)failure;

#pragma mark - Progress

- (BOOL)saveProgressionWithProgressionKey:(NSString *)progressionKey
                       instantProgression:(NSDictionary *)instantProgression
                                  success:(ProgressManagerLoadProgressionSuccessHandler)success
                                  failure:(ProgressManagerLoadProgressionFailureHandler)failure;

+ (NSDictionary *)getRemoteProgression;

+ (Boolean)isPackRemoteCompleted:(int)packId;

+ (Boolean)isMediaRemoteCompleted:(int)mediaId;

#pragma mark - Score

+ (float)getScore;

@end
