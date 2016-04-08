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
#import "MBProgressHUD.h"


@interface HomeViewController ()
{
    NSString * m_lastLanguage;
}


@end


@implementation HomeViewController


USERPREF_IMPL(NSNumber *, AuthWanted, [NSNumber numberWithBool:NO]);
USERPREF_IMPL(NSNumber *, AuthAlertShown, [NSNumber numberWithBool:NO]);


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSString * nibName = ExtensionName(@"HomeViewController");
        [QUIZZ_APP_XIB_BUNDLE loadNibNamed:nibName owner:self options:nil];
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        m_lastLanguage = nil;
    }
    return self;
}


#pragma mark - Progress


- (void)showProgressViewController
{
    // Create progress controller
    ProgressViewController * progressViewController = [[ProgressViewController alloc] initWithBundle:QUIZZ_APP_XIB_BUNDLE
                                                                                        authenticate:YES
                                                                                             dismiss:YES];
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:progressViewController];
    
    //Present
    [self presentViewController:navigationController animated:YES completion:nil];
}


#pragma mark - Game


- (void)loadLevels:(HomeViewControllerLoadLevelsCompletionHandler)completionHandler
{
    //Background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSMutableDictionary * levels = [LevelsViewController getLevels];
        
        //Main thread
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            LevelsViewController * levelsViewController = [[LevelsViewController alloc] initWithLevels:levels];
            [self.navigationController pushViewController:levelsViewController animated:YES];
            
            if (completionHandler)
            {
                completionHandler();
            }
        });
    });
}


#pragma mark - Init


- (Boolean)levelExists:(NSString *)levelPath
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    Boolean levelExists = [fileManager fileExistsAtPath:levelPath];
    return levelExists;
}


- (void)unzipLevels
{
    NSString * language = [Utils currentLanguage];
    NSString * directory = [NSString stringWithFormat:@"%@.lproj", language];
    
    NSArray * paths = [MAIN_BUNDLE pathsForResourcesOfType:@"zip" inDirectory:directory];
    
    for (NSString * levelZipPath in paths)
    {
        NSString * fileName = [[levelZipPath lastPathComponent] stringByDeletingPathExtension];
        NSString * levelPath = [NSString stringWithFormat:@"%@/%@", [Level levelsPath], fileName];
        
        if (![self levelExists:levelPath])
        {
            ZipArchive * za = [[ZipArchive alloc] init];
            //Open file
            if ([za UnzipOpenFile:levelZipPath])
            {
                //Unzip
                BOOL ret = [za UnzipFileTo:levelPath overWrite: YES];
                if (NO == ret){} [za UnzipCloseFile];
            }
            
            //Add level to db
            int levelId = [[[levelPath lastPathComponent] stringByReplacingOccurrencesOfString:QUIZZ_APP_LEVEL_DIRECTORY_PREFIX withString:@""] intValue];
            NSString * databasePath = [NSString stringWithFormat:@"%@/level_%d.sqlite", levelPath, levelId];
            
            Level * level = [LevelDBHelper getLevel:databasePath];
            [GameDBHelper addLevel:level];
        }
        else
        {
            NSLog(@"Level already unzipped");
        }
    }
}


- (void)checkLocalLevels
{
    [self unzipLevels];
}


- (void)initPrefs
{
    NSMutableDictionary * defaults = [NSMutableDictionary dictionary];
    
    //Sound
    [defaults setObject:[NSNumber numberWithBool:!TARGET_IPHONE_SIMULATOR] forKey:QUIZZ_APP_SOUND_ACTIVATED_KEY];
    
    //Language
    [defaults setObject:[Utils defaultLanguage] forKey:QUIZZ_APP_LANGUAGE_KEY];
    
    //Help
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:QUIZZ_APP_NEED_HELP_KEY];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}


- (void)initApplication
{
    //Prefs
    [self initPrefs];
    
    //Check local levels
    [self checkLocalLevels];
    
    //Init game information
    if (![GameProvider start])
    {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self showInitErrorAlertView];
        });
    }
    
    m_lastLanguage = [Utils currentLanguage];
    
    //Analytics
//#if !(TARGET_IPHONE_SIMULATOR)
//    QuizzApp * quizzApp = [QuizzApp instance];
//    [self initAnalytics:quizzApp.googleAnalyticsId];
//#endif
}


#pragma mark - UIAlertView


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == AUTH_ALERT_VIEW)
    {
        Boolean authWanted = (buttonIndex != alertView.cancelButtonIndex);
        
        if (authWanted)
        {
            //Show progress view controller
            [self showProgressViewController];
        }
        
        //Save prefs
        [HomeViewController setAuthWanted:@( authWanted )];
        
        //No more alert
        [HomeViewController setAuthAlertShown:@YES];
    }
}


- (void)showInitErrorAlertView
{
    //Popup connectivity
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:QALocalizedString(@"STR_INFORMATION")
                                                         message:QALocalizedString(@"STR_NO_CONNECTIVITY_MESSAGE")
                                                        delegate:nil
                                               cancelButtonTitle:QALocalizedString(@"STR_OK")
                                               otherButtonTitles:nil];
    [alertView show];
}


- (void)showAuthAlertView
{
    //Popup connectivity
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:QALocalizedString(@"STR_ASK_AUTH_TITLE")
                                                         message:QALocalizedString(@"STR_ASK_AUTH_MESSAGE")
                                                        delegate:self
                                               cancelButtonTitle:QALocalizedString(@"STR_NO")
                                               otherButtonTitles:QALocalizedString(@"STR_YES"), nil];
    [alertView setTag:AUTH_ALERT_VIEW];
    [alertView show];
}


#pragma mark - IBAction


- (IBAction)onMainButtonPush:(id)sender
{
    //TEMP DEBUG
    //    NSArray * array = [NSArray arrayWithObject:nil];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = QALocalizedString(@"STR_LOADING");

    //Load levels
    [self loadLevels:
     ^(void)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
}


- (IBAction)onScoresButtonPush:(id)sender
{
    //Check if we have a game authorizer
#warning TO PORT
//    if ([QuizzApp sharedInstance].progressManager.isConnected) {
//        //Get score
//        float score = [ProgressManager getScore];
//        
//        QuizzApp * quizzApp = [QuizzApp sharedInstance];
//        
//        //Prepare saving
//        GPGScore * remoteScore = [GPGScore scoreWithLeaderboardId:quizzApp.googlePlayLeaderBoardId];
//        remoteScore.value = score;
//        
//        //Submit score
//        [remoteScore submitScoreWithCompletionHandler: ^(GPGScoreReport * report, NSError * error) {
//            if (error != nil) {
//                // Handle the error
//                NSLog(@"score error");
//            } else {
//                [[GPGLauncherController sharedInstance] presentLeaderboardWithLeaderboardId:quizzApp.googlePlayLeaderBoardId];
//            }
//        }];
//    } else {
//        //Show alert
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:QALocalizedString(@"STR_SCORES_ERROR_TITLE") message:QALocalizedString(@"STR_SCORES_ERROR_MESSAGE") delegate:nil cancelButtonTitle:QALocalizedString(@"STR_OK") otherButtonTitles:nil];
//        [alertView show];
//    }
}


- (IBAction)onRateButtonPush:(id)sender
{
    //Rate URL
    NSString * appId = [QuizzApp sharedInstance].appId;
    
    NSString * url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appId];
    NSURL * appURL = [NSURL URLWithString:url];
    [[UIApplication sharedApplication] openURL:appURL];
}


- (IBAction)onSettingsButtonPush:(id)sender
{
    //Show settings    
    SettingsViewController * settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController"
                                                                                               bundle:QUIZZ_APP_XIB_BUNDLE];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}


#pragma mark - UI


- (void)reinitLabels
{
    //Title
    [self setTitle:QALocalizedString(@"STR_HOME_TITLE")];
        
    //Buttons
    [self.rateButton setTitle:QALocalizedString(@"STR_HOME_RATE_BUTTON") forState:UIControlStateNormal];
    [self.scoresButton setTitle:QALocalizedString(@"STR_HOME_SCORES_BUTTON") forState:UIControlStateNormal];
    [self.settingsButton setTitle:QALocalizedString(@"STR_HOME_SETTINGS_BUTTON") forState:UIControlStateNormal];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ((m_lastLanguage == nil) || ![m_lastLanguage isEqualToString:[Utils currentLanguage]])
    {
        // Init game
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setLabelText:QALocalizedString(@"STR_INITIALIZATION")];
        
        // Background job
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            // Super initialization
            [self initApplication];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                // Labels
                [self reinitLabels];

                // Show only if not authenticated
                if ([[HomeViewController getAuthWanted] boolValue] &&
                    ![[QuizzApp sharedInstance].progressManager isAuthenticated])
                {
                    // Show progress view controller
                    [self showProgressViewController];
                }
                else
                {
                    // Check if we can notify the user
                    if (![[HomeViewController getAuthAlertShown] boolValue])
                    {
                        [self showAuthAlertView];
                    }
                }
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    }
    
    [self reinitLabels];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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


@end
