//
//  HomeViewController.m
//  moviequizz2
//
//  Created by Baptiste LE GUELVOUIT on 20/09/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "HomeViewController.h"

int const AUTH_ALERT_VIEW = 0;

#import "LevelsViewController.h"
#import "Difficulty.h"
#import "Level.h"
#import "Pack.h"
#import "DBHelper.h"
#import "GameDBHelper.h"
#import "Utils.h"
#import "Constants.h"
#import "GameProvider.h"
#import "ZipArchive.h"
#import "LevelDBHelper.h"
#import "ProgressManager.h"
#import "QuizzApp.h"
#import "ProgressViewController.h"
#import "SettingsViewController.h"
#import "UtilsImage.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

USERPREF_IMPL(NSNumber *, AuthWanted, [NSNumber numberWithBool:NO]);
USERPREF_IMPL(NSNumber *, AuthAlertShown, [NSNumber numberWithBool:NO]);

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSString * nibName = ExtensionName(@"HomeViewController");
        [QUIZZ_APP_XIB_BUNDLE loadNibNamed:nibName owner:self options:nil];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        m_lastLanguage = nil;
    }
    return self;
}

#pragma mark - Progress

- (void)showProgressViewController {
    NSString * nibName = ExtensionName(@"ProgressViewController");
    
    //Create progress controller
    QuizzApp * quizzApp = [QuizzApp sharedInstance];
    
    ProgressViewController * progressViewController = [[ProgressViewController alloc] initWithNibName:nibName bundle:QUIZZ_APP_XIB_BUNDLE andClientId:quizzApp.googlePlayClientId andProgressionKey:quizzApp.googlePlayProgressionKey andAutoSignIn:YES];
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:progressViewController];
    
    //Present
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Game

- (void)loadLevels:(HomeViewControllerLoadLevelsCompletionHandler)completionHandler {
    //Background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSMutableDictionary * levels = [LevelsViewController getLevels];
        
        //Main thread
        dispatch_async(dispatch_get_main_queue(), ^(void){
            LevelsViewController * levelsViewController = [[LevelsViewController alloc] initWithLevels:levels];
            [self.navigationController pushViewController:levelsViewController animated:YES];
            
            if (completionHandler) {
                completionHandler();
            }
        });
    });
}

#pragma mark - Init

- (Boolean)levelExists:(NSString *)levelPath {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    Boolean levelExists = [fileManager fileExistsAtPath:levelPath];
    return levelExists;
}

- (void)unzipLevels {
    NSString * language = [Utils currentLanguage];
    NSString * directory = [NSString stringWithFormat:@"%@.lproj", language];
    
    NSArray * paths = [MAIN_BUNDLE pathsForResourcesOfType:@"zip" inDirectory:directory];
    
    for (NSString * levelZipPath in paths) {
        NSString * fileName = [[levelZipPath lastPathComponent] stringByDeletingPathExtension];
        NSString * levelPath = [NSString stringWithFormat:@"%@/%@", [Level levelsPath], fileName];
        
        if (![self levelExists:levelPath]) {
            ZipArchive * za = [[ZipArchive alloc] init];
            //Open file
            if ([za UnzipOpenFile:levelZipPath]) {
                //Unzip
                BOOL ret = [za UnzipFileTo:levelPath overWrite: YES];
                if (NO == ret){} [za UnzipCloseFile];
            }
            
            //Add level to db
            int levelId = [[[levelPath lastPathComponent] stringByReplacingOccurrencesOfString:QUIZZ_APP_LEVEL_DIRECTORY_PREFIX withString:@""] intValue];
            NSString * databasePath = [NSString stringWithFormat:@"%@/level_%d.sqlite", levelPath, levelId];
            
            Level * level = [LevelDBHelper getLevel:databasePath];
            [GameDBHelper addLevel:level];
        } else {
            NSLog(@"Level already unzipped");
        }
    }
}

- (void)checkLocalLevels {
    [self unzipLevels];
}

- (void)initPrefs {
    NSMutableDictionary * defaults = [NSMutableDictionary dictionary];
    
    //Sound
    [defaults setObject:[NSNumber numberWithBool:!TARGET_IPHONE_SIMULATOR] forKey:QUIZZ_APP_SOUND_ACTIVATED_KEY];
    
    //Language
    [defaults setObject:[Utils defaultLanguage] forKey:QUIZZ_APP_LANGUAGE_KEY];
    
    //Help
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:QUIZZ_APP_NEED_HELP_KEY];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (void)initAnalytics:(NSString *)analyticsId {
    //Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    //Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    //Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    //Initialize tracker.
    /*id<GAITracker> tracker = */[[GAI sharedInstance] trackerWithTrackingId:analyticsId];
}

- (void)initApplication {
    //Prefs
    [self initPrefs];
    
    //Check local levels
    [self checkLocalLevels];
    
    //Init game information
    if (![GameProvider start]) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self showInitErrorAlertView];
        });
    }
    
    m_lastLanguage = [Utils currentLanguage];
    
    //Analytics
#if !(TARGET_IPHONE_SIMULATOR)
    QuizzApp * quizzApp = [QuizzApp instance];
    [self initAnalytics:quizzApp.googleAnalyticsId];
#endif
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AUTH_ALERT_VIEW) {
        Boolean authWanted = (buttonIndex != alertView.cancelButtonIndex);
        
        if (authWanted) {
            //Show progress view controller
            [self showProgressViewController];
        }
        
        //Save prefs
        [HomeViewController setAuthWanted:[NSNumber numberWithBool:authWanted]];
        
        //No more alert
        [HomeViewController setAuthAlertShown:[NSNumber numberWithBool:YES]];
    }
}

- (void)showInitErrorAlertView {
    //Popup connectivity
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"STR_INFORMATION", nil, QUIZZ_APP_STRING_BUNDLE, nil) message:NSLocalizedStringFromTableInBundle(@"STR_NO_CONNECTIVITY_MESSAGE", nil, QUIZZ_APP_STRING_BUNDLE, nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"STR_OK", nil, QUIZZ_APP_STRING_BUNDLE, nil) otherButtonTitles:nil];
    [alertView show];
}

- (void)showAuthAlertView {
    //Popup connectivity
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"STR_ASK_AUTH_TITLE", nil, QUIZZ_APP_STRING_BUNDLE, nil) message:NSLocalizedStringFromTableInBundle(@"STR_ASK_AUTH_MESSAGE", nil, QUIZZ_APP_STRING_BUNDLE, nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"STR_NO", nil, QUIZZ_APP_STRING_BUNDLE, nil) otherButtonTitles:NSLocalizedStringFromTableInBundle(@"STR_YES", nil, QUIZZ_APP_STRING_BUNDLE, nil), nil];
    [alertView setTag:AUTH_ALERT_VIEW];
    [alertView show];
}

#pragma mark - IBAction

- (IBAction)onMainButtonPush:(id)sender {
    //TEMP DEBUG
    //    NSArray * array = [NSArray arrayWithObject:nil];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = NSLocalizedStringFromTableInBundle(@"STR_LOADING", nil, QUIZZ_APP_STRING_BUNDLE, nil);
    [HUD show:YES];

    [self loadLevels:^{
        [HUD hide:YES];
    }];
}

- (IBAction)onScoresButtonPush:(id)sender {
    if (IS_IOS_7) {
        //Check if we have a game authorizer
        if ([GPGManager sharedInstance].isSignedIn) {
            //Get score
            float score = [ProgressManager getScore];
            
            QuizzApp * quizzApp = [QuizzApp sharedInstance];
            
            //Prepare saving
            GPGScore * remoteScore = [GPGScore scoreWithLeaderboardId:quizzApp.googlePlayLeaderBoardId];
            remoteScore.value = score;
            
            //Submit score
            [remoteScore submitScoreWithCompletionHandler: ^(GPGScoreReport * report, NSError * error) {
                if (error != nil) {
                    // Handle the error
                    NSLog(@"score error");
                } else {
                    [[GPGLauncherController sharedInstance] presentLeaderboardWithLeaderboardId:quizzApp.googlePlayLeaderBoardId];
                }
            }];
        } else {
            //Show alert
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"STR_SCORES_ERROR_TITLE", nil, QUIZZ_APP_STRING_BUNDLE, nil) message:NSLocalizedStringFromTableInBundle(@"STR_SCORES_ERROR_MESSAGE", nil, QUIZZ_APP_STRING_BUNDLE, nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"STR_OK", nil, QUIZZ_APP_STRING_BUNDLE, nil) otherButtonTitles:nil];
            [alertView show];
        }
    } else {
        //Show alert
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"STR_PROGRESS_ERROR_TITLE", nil, QUIZZ_APP_STRING_BUNDLE, nil) message:NSLocalizedStringFromTableInBundle(@"STR_PROGRESS_ERROR_MESSAGE", nil, QUIZZ_APP_STRING_BUNDLE, nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"STR_OK", nil, QUIZZ_APP_STRING_BUNDLE, nil) otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)onRateButtonPush:(id)sender {
    //Rate URL
    NSString * appId = [QuizzApp sharedInstance].appId;
    
    NSString * url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appId];
    NSURL * appURL = [NSURL URLWithString:url];
    [[UIApplication sharedApplication] openURL:appURL];
}

- (IBAction)onSettingsButtonPush:(id)sender {
    //Show settings    
    SettingsViewController * settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:QUIZZ_APP_XIB_BUNDLE];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

#pragma mark - MBProgressHUD

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

#pragma mark - UI

- (void)reinitLabels {
    //Title
    [self setTitle:NSLocalizedStringFromTableInBundle(@"STR_HOME_TITLE", nil, QUIZZ_APP_STRING_BUNDLE, nil)];
        
    //Buttons
    [self.rateButton setTitle:NSLocalizedStringFromTableInBundle(@"STR_HOME_RATE_BUTTON", nil, QUIZZ_APP_STRING_BUNDLE, nil) forState:UIControlStateNormal];
    [self.scoresButton setTitle:NSLocalizedStringFromTableInBundle(@"STR_HOME_SCORES_BUTTON", nil, QUIZZ_APP_STRING_BUNDLE, nil) forState:UIControlStateNormal];
    [self.settingsButton setTitle:NSLocalizedStringFromTableInBundle(@"STR_HOME_SETTINGS_BUTTON", nil, QUIZZ_APP_STRING_BUNDLE, nil) forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ((m_lastLanguage == nil) || ![m_lastLanguage isEqualToString:[Utils currentLanguage]]) {
        //Init game
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.delegate = self;
        [HUD setLabelText:NSLocalizedStringFromTableInBundle(@"STR_INITIALIZATION", nil, QUIZZ_APP_STRING_BUNDLE, nil)];
        
        [HUD show:YES];
        
        //Background job
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //Super initialization
            [self initApplication];
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Labels
                [self reinitLabels];
                
                if (IS_IOS_7) {
                    if ([[HomeViewController getAuthWanted] boolValue]) {
                        //Show progress view controller
                        [self showProgressViewController];
                    } else {
                        
                        //Check if we can notify the user
                        if (![[HomeViewController getAuthAlertShown] boolValue]) {
                            [self showAuthAlertView];
                        }
                    }
                }
                
                [HUD hide:YES];
            });
        });
    }
    
    [self reinitLabels];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScreenName:@"Home screen"];
    
    //Start button
    NSString * btnOffImageName = ExtensionName(@"btn_icon_off");
    NSString * btnOnImageName = ExtensionName(@"btn_icon_on");
    
    //    [self.startLabel setTextColor:[QuizzApp instance].oppositeMainColor];
    
    [self.startButton setImage:[UtilsImage imageNamed:btnOffImageName] forState:UIControlStateNormal];
    [self.startButton setImage:[UtilsImage imageNamed:btnOnImageName] forState:UIControlStateHighlighted];
    
    //Other buttons
    [self.rateButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.rateButton setFrontColor:QUIZZ_APP_RED_MAIN_COLOR];
    [self.rateButton setBackColor:QUIZZ_APP_RED_SECOND_COLOR];
    
    [self.scoresButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.scoresButton setFrontColor:QUIZZ_APP_ORANGE_MAIN_COLOR];
    [self.scoresButton setBackColor:QUIZZ_APP_ORANGE_SECOND_COLOR];
    
    [self.settingsButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.settingsButton setFrontColor:QUIZZ_APP_GRAY_MAIN_COLOR];
    [self.settingsButton setBackColor:QUIZZ_APP_GRAY_SECOND_COLOR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
