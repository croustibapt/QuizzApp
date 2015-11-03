//
//  MQHomeViewController.m
//  moviequizz2
//
//  Created by Baptiste LE GUELVOUIT on 19/10/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "MQHomeViewController.h"

#import "MQLevelsViewController.h"
#import "MQConstants.h"
#import "MQSettingsViewController.h"
#import "PacksViewController.h"
#import "GameProvider.h"
#import "QuizzApp.h"

@interface MQHomeViewController () {
    UIButton * m_tvShowQuizzButton;
}

@end

@implementation MQHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    m_tvShowQuizzButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0, self.view.frame.size.width, PixelsSize(40.0))];
    [m_tvShowQuizzButton setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
    [m_tvShowQuizzButton.titleLabel setFont:[UIFont fontWithName:@"RobotoCondensed-Regular" size:PixelsSize(16.0)]];
    [m_tvShowQuizzButton setTitle:NSLocalizedStringFromTableInBundle(@"STR_TV_SHOW_QUIZZ_LINK", nil, QUIZZ_APP_STRING_BUNDLE, nil) forState:UIControlStateNormal];
    [m_tvShowQuizzButton setTitleColor:GRAY_LIGHT_COLOR forState:UIControlStateHighlighted];
    [m_tvShowQuizzButton addTarget:self action:@selector(onTvShowQuizzButtonPush:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_tvShowQuizzButton];
}

- (void)onTvShowQuizzButtonPush:(id)sender {
    [SettingsViewController showOtherGame:TV_SHOW_QUIZZ_APP_ID];
}

- (void)loadLevels:(HomeViewControllerLoadLevelsCompletionHandler)completionHandler {
    NSMutableDictionary * levels = [LevelsViewController getLevelsWithMinId:MOVIE_QUIZZ_IOS_START_ID andMaxId:INT16_MAX];
            
    //Main thread
    dispatch_async(dispatch_get_main_queue(), ^(void){
        MQLevelsViewController * levelsViewController = [[MQLevelsViewController alloc] initWithLevels:levels];
        [self.navigationController pushViewController:levelsViewController animated:YES];
        
        if (completionHandler) {
            completionHandler();
        }
    });
}

- (void)reinitLabels {
    [super reinitLabels];
    
    [m_tvShowQuizzButton setTitle:NSLocalizedStringFromTableInBundle(@"STR_TV_SHOW_QUIZZ_LINK", nil, QUIZZ_APP_STRING_BUNDLE, nil) forState:UIControlStateNormal];
}

- (IBAction)onSettingsButtonPush:(id)sender {
    //Show settings
    MQSettingsViewController * settingsViewController = [[MQSettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:QUIZZ_APP_XIB_BUNDLE];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
