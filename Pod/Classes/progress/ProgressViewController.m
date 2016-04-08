//
//  ProgressViewController.m
//  quizzapp
//
//  Created by dev_iphone on 26/05/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//


#import "ProgressViewController.h"


typedef enum
{
    EProgressSectionHeader = 0,
    EProgressSectionProfile,
    EProgressSectionLast
}
EProgressSection;


typedef enum
{
    EProgressProfileRowLogin = 0,
    EProgressProfileRowLast
}
EProgressProfileRow;

//typedef enum {
//    EProgressScoresRowRank = 0,
//    EProgressScoresRowLast
//} EProgressScoresRow;


#import "UtilsImage.h"
#import "HomeViewController.h"


@interface ProgressViewController ()


@end


@implementation ProgressViewController


#pragma mark - Cocoa


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSString * nibName = ExtensionName(NSStringFromClass([self class]));
        [QUIZZ_APP_XIB_BUNDLE loadNibNamed:nibName owner:self options:nil];
    }
    return self;
}


- (id)initWithBundle:(NSBundle *)bundle
        authenticate:(BOOL)authenticate
             dismiss:(BOOL)dismiss
{
    NSString * nibName = ExtensionName(NSStringFromClass([self class]));
    self = [super initWithNibName:nibName bundle:bundle];
    if (self)
    {
        _authenticate = authenticate;
        _dismiss = dismiss;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Refresh UI if needed
    [self refreshUI];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:QALocalizedString(@"STR_PROGRESS_TITLE")];
    
    // Game image
    NSString * gameImageName = ExtensionName(@"game_header");
    
    [self.gameImageView setImage:[UtilsImage imageNamed:gameImageName
                                                 bundle:QUIZZ_APP_IMAGE_BUNDLE]];
    
    float labelFont = PixelsSize(15.0);
    
    // Status label
    [self.statusLabel setFont:[UIFont fontWithName:@"RobotoCondensed-Regular" size:labelFont]];
    
    // Information label
    [self.informationLabel setFont:[UIFont fontWithName:@"RobotoCondensed-Regular" size:labelFont]];
    [self.informationLabel setText:QALocalizedString(@"STR_PROGRESS_INFORMATION")];
    
    // Sync button
    [self.syncButton setTitle:QALocalizedString(@"STR_SYNC_PROGRESS")
                     forState:UIControlStateNormal];
    
    // Sync button
    [self.syncButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.syncButton setFrontColor:QUIZZ_APP_BLUE_MAIN_COLOR];
    [self.syncButton setBackColor:QUIZZ_APP_BLUE_SECOND_COLOR];
    
    // Authenticate user if needed
    if (_authenticate)
    {
        // Save auth wanted state
        [HomeViewController setAuthWanted:@YES];
        
        // Done item
        UIBarButtonItem * doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                   target:self
                                                                                   action:@selector(dismiss)];
        [self.navigationItem setRightBarButtonItem:doneItem];
        
        // And start authentication
        [self authenticate];
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Progress


- (void)authenticate {
    //Show loading
    [self showHideIndicator:YES];
    
    //Sign in user
    [[QuizzApp sharedInstance].progressManager authenticateWithViewController:self
                                                                      success:
     ^(GKLocalPlayer * player)
    {
        [self refreshUI];
        
        [self showHideIndicator:NO];
        
        // Automatically dismiss
        if (_dismiss)
        {
            [self dismiss];
        }
    }
                                                                      failure:
     ^(NSError * error)
    {
        [self refreshUI];
        
        [self showHideIndicator:NO];
        
        // Show alert error
        [self showAuthenticateErrorAlertView];
        
        // Automatically dismiss
        if (_dismiss)
        {
            [self dismiss];
        }
    }];
    
    [self refreshUI];
}


- (void)logout
{
    [[QuizzApp sharedInstance].progressManager logout];
    
    // No more auto login
    [HomeViewController setAuthWanted:@NO];
    
    [self dismiss];
}


- (void)sync
{
    [self showHideIndicator:YES];
    
    //Synchronize progression
    BOOL syncing = [[QuizzApp sharedInstance].progressManager saveProgressionWithInstantProgression:nil
                                                                                            success:
     ^(GKSavedGame * savedGame)
    {
        // ???
        [self showHideIndicator:NO];
        
        [self refreshUI];
    }
                                                                                            failure:
     ^(NSError * error)
    {
        // ???
        [self showHideIndicator:NO];
        
        [self refreshUI];
    }];
    
    if (!syncing)
    {
        [self showHideIndicator:NO];
    }
    
    [self refreshUI];
}

#pragma mark - UIAlertView

- (void)showAuthenticateErrorAlertView
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:QALocalizedString(@"STR_SIGN_IN_ERROR_TITLE")
                                                         message:QALocalizedString(@"STR_SIGN_IN_ERROR_MESSAGE")
                                                        delegate:nil
                                               cancelButtonTitle:QALocalizedString(@"STR_OK")
                                               otherButtonTitles:nil];
    [alertView show];
}

- (void)showGamesSyncErrorAlertView
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:QALocalizedString(@"STR_PROGRESS_SYNC_ERROR_TITLE")
                                                         message:QALocalizedString(@"STR_PROGRESS_SYNC_ERROR_MESSAGE")
                                                        delegate:nil
                                               cancelButtonTitle:QALocalizedString(@"STR_OK")
                                               otherButtonTitles:nil];
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
    Boolean isSigningIn = [QuizzApp sharedInstance].progressManager.isAuthenticating;
    if (isSigningIn)
    {
        [self.statusLabel setText:QALocalizedString(@"STR_SIGNING_IN")];
    }
    
    //Check syncing
    Boolean isSyncing = [QuizzApp sharedInstance].progressManager.isSyncing;
    if (isSyncing)
    {
        [self.statusLabel setText:QALocalizedString(@"STR_SYNCING")];
    }
    
    //Is connected ?
    Boolean canInteract = (!isSigningIn && !isSyncing);
    
    //Button title
    Boolean isConnected = [[QuizzApp sharedInstance].progressManager isAuthenticated];
    
    //Sync button
    [self.syncButton setEnabled:(isConnected && canInteract)];
}

#pragma mark - ProgressGameDelegate

- (void)onGamesSaveDoneWithError:(NSError *)error {
    
    
    //Check error
    if (error) {
        
    } else {
        
    }
    
    //Refresh sign in button state
    [self refreshUI];
}

- (void)onGamesLoadDoneWithError:(NSError *)error {
    //Stop loading
    [self showHideIndicator:NO];
    
    //Check error
    if (error) {
        //Show alert
        [self showGamesSyncErrorAlertView];
    } else {
        //Show loading
        [self showHideIndicator:YES];
        
        //Try to save progression
        if (![[QuizzApp sharedInstance].progressManager saveProgressionWithInstantProgression:nil success:^(GKSavedGame * savedGame) {
            //Save succeeded: dismiss
            [self dismiss];
        } failure:^(NSError *error) {
            //Show alert
            [self showGamesSyncErrorAlertView];
        }]) {
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


//- (IBAction)onSignInButtonPush:(id)sender
//{
//    if ([[QuizzApp sharedInstance].progressManager isAuthenticated])
//    {
//        [self logout];
//    }
//    else
//    {
//        [self authenticate];
//    }
//}

- (IBAction)onSyncButtonPush:(id)sender
{
    [self sync];
}


#pragma mark - UI


- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //Cancel sign in
    [[QuizzApp sharedInstance].progressManager cancel];
}


@end
