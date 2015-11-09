//
//  ProgressViewController.m
//  quizzapp
//
//  Created by dev_iphone on 26/05/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "ProgressViewController.h"

#import <GoogleSignIn/GoogleSignIn.h>

typedef enum {
    EProgressSectionHeader = 0,
    EProgressSectionProfile,
    EProgressSectionLast
} EProgressSection;

typedef enum {
    EProgressProfileRowLogin = 0,
    EProgressProfileRowLast
} EProgressProfileRow;

//typedef enum {
//    EProgressScoresRowRank = 0,
//    EProgressScoresRowLast
//} EProgressScoresRow;

#import "UtilsImage.h"
#import "HomeViewController.h"

@interface ProgressViewController ()

@end

@implementation ProgressViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSString * nibName = ExtensionName(@"ProgressViewController");
        [QUIZZ_APP_XIB_BUNDLE loadNibNamed:nibName owner:self options:nil];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andClientId:(NSString *)aClientId andProgressionKey:(NSNumber *)aProgressionKey andAutoSignIn:(Boolean)aAutoSignIn {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setClientId:aClientId];
        [self setProgressionKey:aProgressionKey];
        [self setAutoSignIn:aAutoSignIn];
        
        //Add observer for internal web view
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationOpenGoogleAuthNotification:) name:ApplicationOpenGoogleAuthNotification object:nil];
    }
    return self;
}

- (void)onApplicationOpenGoogleAuthNotification:(id)sender {
    NSNotification * notification = (NSNotification *)sender;
    
    UIViewController * viewController = [[UIViewController alloc] init];
    [viewController setTitle:NSLocalizedStringFromTableInBundle(@"STR_GOOGLE_PLUS", nil, QUIZZ_APP_STRING_BUNDLE, nil)];
    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [webView setDelegate:self];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:notification.object];
    [webView loadRequest:request];
    
    [viewController setView:webView];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UIWebView

#warning TO CHECK
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    //Application prefix to check
//    NSString * appPrefix = [NSString stringWithFormat:@"%@:/oauth2callback", [MAIN_BUNDLE bundleIdentifier]];
//    
//    if ([[[request URL] absoluteString] hasPrefix:appPrefix]) {
////        [GPPURLHandler handleURL:request.URL sourceApplication:@"com.google.chrome.ios" annotation:nil];
//        
//        //Looks like we did log in (onhand of the url), we are logged in, the Google APi handles the rest
//        [self.navigationController popViewControllerAnimated:YES];
//        
//        return NO;
//    }
//    
//    return YES;
//}

#pragma mark - Progress

- (void)signIn {
    //Show loading
    [self showHideIndicator:YES];
    
    //Sign in user
    [[QuizzApp sharedInstance].progressManager signInWithClientId:self.clientId delegate:self];
    
}

- (void)signOut {
    //Show loading
    [self showHideIndicator:YES];
    
    //Sign out user
    [[QuizzApp sharedInstance].progressManager signOutWithDelegate:self];
}

- (void)initProgression {
    //Show loading
    [self showHideIndicator:YES];
    
    //Sign in user
    [[QuizzApp sharedInstance].progressManager signInWithClientId:self.clientId delegate:self];
}

#pragma mark - UIAlertView

- (void)showSignInErrorAlertView {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"STR_SIGN_IN_ERROR_TITLE", nil, QUIZZ_APP_STRING_BUNDLE, nil) message:NSLocalizedStringFromTableInBundle(@"STR_SIGN_IN_ERROR_MESSAGE", nil, QUIZZ_APP_STRING_BUNDLE, nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"STR_OK", nil, QUIZZ_APP_STRING_BUNDLE, nil) otherButtonTitles:nil];
    [alertView show];
}

- (void)showSignOutErrorAlertView {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"STR_SIGN_OUT_ERROR_TITLE", nil, QUIZZ_APP_STRING_BUNDLE, nil) message:NSLocalizedStringFromTableInBundle(@"STR_SIGN_OUT_ERROR_MESSAGE", nil, QUIZZ_APP_STRING_BUNDLE, nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"STR_OK", nil, QUIZZ_APP_STRING_BUNDLE, nil) otherButtonTitles:nil];
    [alertView show];
}

- (void)showGamesSyncErrorAlertView {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"STR_PROGRESS_SYNC_ERROR_TITLE", nil, QUIZZ_APP_STRING_BUNDLE, nil) message:NSLocalizedStringFromTableInBundle(@"STR_PROGRESS_SYNC_ERROR_MESSAGE", nil, QUIZZ_APP_STRING_BUNDLE, nil) delegate:nil cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"STR_OK", nil, QUIZZ_APP_STRING_BUNDLE, nil) otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - ProgressAuthDelegate

- (void)showHideIndicator:(Boolean)start {
    [self.activityIndicatorView setHidden:!start];
    
    if (start) {
        [self.activityIndicatorView startAnimating];
    } else {
        [self.activityIndicatorView stopAnimating];
    }
}

- (void)refreshUI {
    //Clear status
    [self.statusLabel setText:@""];
    
    //Check signing in
#warning TO PORT
    Boolean isSigningIn = NO;//[ProgressManager instance].currentlySigningIn;
    if (isSigningIn) {
        [self.statusLabel setText:NSLocalizedStringFromTableInBundle(@"STR_SIGNING_IN", nil, QUIZZ_APP_STRING_BUNDLE, nil)];
    }
    
    //Check signing in games
#warning TO PORT
    Boolean isGamesSigningIn = NO;//[ProgressManager instance].currentlyGamesSigningIn;
    if (isGamesSigningIn) {
        [self.statusLabel setText:NSLocalizedStringFromTableInBundle(@"STR_SIGNING_IN_GAMES", nil, QUIZZ_APP_STRING_BUNDLE, nil)];
    }
    
    //Check syncing
#warning TO PORT
    Boolean isSyncing = NO;//[ProgressManager instance].currentlySyncing;
    if (isSyncing) {
        [self.statusLabel setText:NSLocalizedStringFromTableInBundle(@"STR_SYNCING", nil, QUIZZ_APP_STRING_BUNDLE, nil)];
    }
    
    //Is connected ?
    Boolean canInteract = (!isSigningIn && !isGamesSigningIn && !isSyncing);
    
    //Enabled only if not signing in (auth or games)
    [self.signInButton setEnabled:canInteract];
    
    //Button title
    Boolean isSignedIn = [GPGManager sharedInstance].isSignedIn;
    NSString * buttonTitle = (isSignedIn ? NSLocalizedStringFromTableInBundle(@"STR_SIGN_OUT", nil, QUIZZ_APP_STRING_BUNDLE, nil) : NSLocalizedStringFromTableInBundle(@"STR_SIGN_IN", nil, QUIZZ_APP_STRING_BUNDLE, nil));
    
    [self.signInButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.signInButton setTitle:buttonTitle forState:UIControlStateDisabled];
    
    //Sync button
    [self.syncButton setEnabled:(isSignedIn && canInteract)];
    
    if (isSignedIn) {
        [self.signInButton setFrontColor:QUIZZ_APP_RED_MAIN_COLOR];
        [self.signInButton setBackColor:QUIZZ_APP_RED_SECOND_COLOR];
    } else {
        [self.signInButton setFrontColor:QUIZZ_APP_GREEN_MAIN_COLOR];
        [self.signInButton setBackColor:QUIZZ_APP_GREEN_SECOND_COLOR];
    }
}

- (void)onSignInDoneWithError:(NSError *)error {
    //Stop loading
    [self showHideIndicator:NO];
    
    //Check error
    if (error != nil) {
        //Show alert
        [self showSignInErrorAlertView];
    } else {
        //Auth is now wanted
        [HomeViewController setAuthWanted:[NSNumber numberWithBool:YES]];
        
        //Show loading
        [self showHideIndicator:YES];
        
        //Sign in scores
#warning TO PORT
//        [[QuizzApp sharedInstance].progressManager signInGamesWithDelegate:self];
    }
    
    //Refresh sign in button state
    [self refreshUI];
}

- (void)onSignOutDoneWithError:(NSError *)error {
    //Stop loading
    [self showHideIndicator:NO];
    
    //Check error
    if (error != nil) {
        //Show alert
        [self showSignOutErrorAlertView];
    } else {
        //No more auto sign in
        [HomeViewController setAuthWanted:[NSNumber numberWithBool:NO]];
    }
    
    //Refresh sign in button state
    [self refreshUI];
}

- (void)synchronizeProgress {
    //Show loading
    [self showHideIndicator:YES];
    
    //Load progression
    if (![[QuizzApp sharedInstance].progressManager loadProgression:self]) {
        //Stop loading
        [self showHideIndicator:NO];
        
        //Show alert
        [self showGamesSyncErrorAlertView];
    }
}

- (void)onGamesSignInDoneWithError:(NSError *)error {
    //Stop loading
    [self showHideIndicator:NO];
    
    //Check error
    if (error != nil) {
        //Show alert
        [self showSignInErrorAlertView];
    } else {
        //Synchronize progress
        [self synchronizeProgress];
    }
    
    //Refresh sign in button state
    [self refreshUI];
}

- (void)onGamesSignOutDoneWithError:(NSError *)error {
    //Stop loading
    [self showHideIndicator:NO];
    
    //Check error
    if (error != nil) {
        //Show alert
        [self showSignOutErrorAlertView];
    } else {
        //Show loading
        [self showHideIndicator:YES];
        
        //Google+ sign out
        [[QuizzApp sharedInstance].progressManager signOutWithDelegate:self];
    }
    
    //Refresh sign in button state
    [self refreshUI];
}

- (void)onAuthDeclined {
    //Stop loading
    [self showHideIndicator:NO];
}

#pragma mark - ProgressGameDelegate

- (void)onGamesSaveDoneWithError:(NSError *)error {
    //Stop loading
    [self showHideIndicator:NO];
    
    //Check error
    if (error != nil) {
        //Show alert
        [self showGamesSyncErrorAlertView];
    } else {
        //Save succeeded: dismiss
        [self dismiss];
    }
    
    //Refresh sign in button state
    [self refreshUI];
}

- (void)onGamesLoadDoneWithError:(NSError *)error {
    //Stop loading
    [self showHideIndicator:NO];
    
    //Check error
    if (error != nil) {
        //Show alert
        [self showGamesSyncErrorAlertView];
    } else {
        //Show loading
        [self showHideIndicator:YES];
        
        //Try to save progression
        if (![[QuizzApp sharedInstance].progressManager saveProgressionWithProgressionKey:self.progressionKey delegate:self andInstantProgression:nil]) {
            //Show loading
            [self showHideIndicator:NO];
            
            //Show alert
            [self showGamesSyncErrorAlertView];
        }
    }
    
    //Refresh sign in button state
    [self refreshUI];
}

#pragma mark - IBAction

- (IBAction)onSignInButtonPush:(id)sender {
    Boolean isSignedIn = [GPGManager sharedInstance].isSignedIn;
    
    if (isSignedIn) {
        [self signOut];
    } else {
        [GIDSignIn sharedInstance].uiDelegate = self;
        [self signIn];
    }
    
    [self refreshUI];
}

- (IBAction)onSyncButtonPush:(id)sender {
    //
    [self synchronizeProgress];
    
    [self refreshUI];
}

#pragma mark - UI

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"REMOVE OBSERVER");
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        [center removeObserver:self name:ApplicationOpenGoogleAuthNotification object:nil];
    }];
    
    //Cancel sign in
    [[QuizzApp sharedInstance].progressManager cancel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Refresh UI if needed
    [self refreshUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:NSLocalizedStringFromTableInBundle(@"STR_PROGRESS_TITLE", nil, QUIZZ_APP_STRING_BUNDLE, nil)];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Progress Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    //Game image
    NSString * gameImageName = ExtensionName(@"game_header");
    
    [self.gameImageView setImage:[UtilsImage imageNamed:gameImageName bundle:QUIZZ_APP_IMAGE_BUNDLE]];
    
    float labelFont = PixelsSize(15.0);
    
    //Status label
    [self.statusLabel setFont:[UIFont fontWithName:@"RobotoCondensed-Regular" size:labelFont]];
    
    //Information label
    [self.informationLabel setFont:[UIFont fontWithName:@"RobotoCondensed-Regular" size:labelFont]];
    [self.informationLabel setText:NSLocalizedStringFromTableInBundle(@"STR_PROGRESS_INFORMATION", nil, QUIZZ_APP_STRING_BUNDLE, nil)];
    
    //Done item
    UIBarButtonItem * doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
    [self.navigationItem setRightBarButtonItem:doneItem];
    
    if (self.autoSignIn) {
        //If auth wanted
        if ([HomeViewController getAuthWanted]) {
            //Init progression
            [self initProgression];
        }
        
        //Refresh UI
        [self refreshUI];
    }
    
    //Sync button
    [self.syncButton setTitle:NSLocalizedStringFromTableInBundle(@"STR_SYNC_PROGRESS", nil, QUIZZ_APP_STRING_BUNDLE, nil) forState:UIControlStateNormal];
    
    //Sign in button
    [self.signInButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.signInButton setFrontColor:QUIZZ_APP_GREEN_MAIN_COLOR];
    [self.signInButton setBackColor:QUIZZ_APP_GREEN_SECOND_COLOR];
    
    //Sync button
    [self.syncButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.syncButton setFrontColor:QUIZZ_APP_BLUE_MAIN_COLOR];
    [self.syncButton setBackColor:QUIZZ_APP_BLUE_SECOND_COLOR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
