//
//  HomeViewController.h
//  moviequizz2
//
//  Created by Baptiste LE GUELVOUIT on 20/09/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <gpg/GooglePlayGames.h>
#import <Google/Analytics.h>

typedef void (^HomeViewControllerLoadLevelsCompletionHandler)(void);

#import "BackViewController.h"
#import "Preferences.h"
#import "FlatButton.h"

@interface HomeViewController : BackViewController <UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton * startButton;

@property (nonatomic, strong) IBOutlet FlatButton * scoresButton;

@property (nonatomic, strong) IBOutlet FlatButton * rateButton;

@property (nonatomic, strong) IBOutlet FlatButton * settingsButton;

USERPREF_DECL(NSNumber *, AuthWanted);
USERPREF_DECL(NSNumber *, AuthAlertShown);

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

#pragma mark - Progress

- (void)showProgressViewController;

#pragma mark - Init

- (void)initApplication;

#pragma mark - IBAction

- (IBAction)onRateButtonPush:(id)sender;

- (IBAction)onSettingsButtonPush:(id)sender;

#pragma mark - UI

- (void)reinitLabels;

@end
