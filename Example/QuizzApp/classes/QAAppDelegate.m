//
//  QAAppDelegate.m
//  QuizzApp
//
//  Created by Baptiste LE GUELVOUIT on 10/26/2015.
//  Copyright (c) 2015 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "QAAppDelegate.h"

#import <QuizzApp/QuizzApp.h>
#import <QuizzApp/UtilsImage.h>
#import <QuizzApp/Constants.h>
#import <GoogleSignIn/GoogleSignIn.h>

#import "MQConstants.h"

@implementation QAAppDelegate

- (void)initializeNavigationBar {
    //Background
    UIImage * navBackgroundImage = [UtilsImage imageNamed:@"top_bar_background"];
    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    //Title
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName, [UIFont fontWithName:@"RobotoCondensed-Regular" size:20.0], NSFontAttributeName, nil]];
    
    //UIBarButtonItem
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName, [UIFont fontWithName:@"RobotoCondensed-Bold" size:20.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    if ([_window respondsToSelector:@selector(setTintColor:)]) {
        [_window setTintColor:[UIColor whiteColor]];
    }
}

- (void)initializeQuizzApp {
    QuizzApp * quizzApp = [QuizzApp sharedInstance];
    
    [quizzApp initializeWithGameServiceName:MOVIE_QUIZZ_SERVICE_NAME appId:MOVIE_QUIZZ_APP_ID googlePlayClientId:MOVIE_QUIZZ_GOOGLE_PLAY_CLIENT_ID googlePlayProgressionKey:MOVIE_QUIZZ_GOOGLE_PLAY_PROGRESSION_KEY googlePlayLeaderBoardId:MOVIE_QUIZZ_GOOGLE_PLAY_LEADER_BOARD_ID googleAnalyticsId:MOVIE_QUIZZ_GOOGLE_ANALYTICS_ID mainColor:MOVIE_QUIZZ_MAIN_COLOR secondColor:MOVIE_QUIZZ_SECOND_COLOR thirdColor:MOVIE_QUIZZ_THIRD_COLOR oppositeMainColor:MOVIE_QUIZZ_OPPOSITE_MAIN_COLOR oppositeSecondColor:MOVIE_QUIZZ_OPPOSITE_SECOND_COLOR oppositeThirdColor:MOVIE_QUIZZ_OPPOSITE_THIRD_COLOR];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initializeQuizzApp];
    
    [self initializeNavigationBar];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
