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

#import "MQConstants.h"

@implementation QAAppDelegate

- (void)initializeNavigationBar {
    //Background
    UIImage * navBackgroundImage = [UtilsImage imageNamed:@"top_bar_background"];
    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    //Title
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], UITextAttributeTextColor, [UIFont fontWithName:@"RobotoCondensed-Regular" size:20.0], UITextAttributeFont, nil]];
    
    //UIBarButtonItem
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], UITextAttributeTextColor, [UIFont fontWithName:@"RobotoCondensed-Bold" size:20.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
    
    if (!IS_IOS_7) {
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UtilsImage imageNamed:@"button_back"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackgroundImage:[UtilsImage imageNamed:@"button_normal"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        NSDictionary * navigationBarTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor],
                                                       UITextAttributeTextShadowColor : [UIColor clearColor],
                                                       UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0, 0)]};
        [[UINavigationBar appearance] setTitleTextAttributes:navigationBarTextAttributes];
        [[UIBarButtonItem appearance] setTitleTextAttributes:navigationBarTextAttributes forState:UIControlStateNormal];
        
        NSDictionary * highlightNavigationBarTextAttributes = @{UITextAttributeTextColor : UIColorFromRGB(0x888888),
                                                                UITextAttributeTextShadowColor : [UIColor clearColor],
                                                                UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0, 0)]};
        [[UIBarButtonItem appearance] setTitleTextAttributes:highlightNavigationBarTextAttributes forState:UIControlStateHighlighted];
        
    }
    
    if ([_window respondsToSelector:@selector(setTintColor:)]) {
        [_window setTintColor:[UIColor whiteColor]];
    }
}

- (void)initializeQuizzApp {
    QuizzApp * quizzApp = [QuizzApp sharedInstance];
    [quizzApp setAppId:MOVIE_QUIZZ_APP_ID];
    [quizzApp setGooglePlayClientId:MOVIE_QUIZZ_GOOGLE_PLAY_CLIENT_ID];
    [quizzApp setGooglePlayProgressionKey:MOVIE_QUIZZ_GOOGLE_PLAY_PROGRESSION_KEY];
    [quizzApp setGooglePlayLeaderBoardId:MOVIE_QUIZZ_GOOGLE_PLAY_LEADER_BOARD_ID];
    [quizzApp setGoogleAnalyticsId:MOVIE_QUIZZ_GOOGLE_ANALYTICS_ID];
    [quizzApp setMainColor:MOVIE_QUIZZ_MAIN_COLOR];
    [quizzApp setSecondColor:MOVIE_QUIZZ_SECOND_COLOR];
    [quizzApp setThirdColor:MOVIE_QUIZZ_THIRD_COLOR];
    [quizzApp setOppositeMainColor:MOVIE_QUIZZ_OPPOSITE_MAIN_COLOR];
    [quizzApp setOppositeSecondColor:MOVIE_QUIZZ_OPPOSITE_SECOND_COLOR];
    [quizzApp setOppositeThirdColor:MOVIE_QUIZZ_OPPOSITE_THIRD_COLOR];
    [quizzApp setGameServiceName:MOVIE_QUIZZ_SERVICE_NAME];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initializeQuizzApp];
    
    [self initializeNavigationBar];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
