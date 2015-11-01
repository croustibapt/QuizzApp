//
//  MQLevelsViewController.m
//  moviequizz2
//
//  Created by Baptiste LE GUELVOUIT on 19/10/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "MQLevelsViewController.h"

int const MQ_RELEASE_DATE = 1415612737;
//int const MQ_RELEASE_DATE = 1413887068;

#import "MQConstants.h"
#import "GameDBHelper.h"

@interface MQLevelsViewController ()

@end

@implementation MQLevelsViewController

USERPREF_IMPL(NSNumber *, HasLocalLevels, [NSNumber numberWithBool:NO]);

- (void)checkLocalLevels {
    Boolean hasLocalLevels = [GameDBHelper hasLevelsWithMaxId:MOVIE_QUIZZ_IOS_START_ID];
    NSInteger nbLevels = [self.levels count];
    
    //Only 1 level in "new" local
    if ((nbLevels <= 1) && ![[MQLevelsViewController getHasLocalLevels] boolValue]) {
        NSDate * releaseDate = [[NSDate alloc] initWithTimeIntervalSince1970:MQ_RELEASE_DATE];
        NSDate * date = [NSDate date];
        
        float timeInterval = [date timeIntervalSinceDate:releaseDate];
        
        hasLocalLevels = (timeInterval > 0);
    } else {
        [MQLevelsViewController setHasLocalLevels:[NSNumber numberWithBool:YES]];
    }
    
    if (hasLocalLevels) {
        [m_flatButton setHidden:NO];
    } else {
        [m_flatButton setHidden:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    CGRect oldFrame = self.collectionView.frame;
    m_startCollectionViewFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height - 40);
    
    [self.collectionView setFrame:m_startCollectionViewFrame];
//    [self.collectionView setBackgroundColor:[UIColor redColor]];
    
    float widthPart = m_startCollectionViewFrame.size.width / 6.0;
    CGRect buttonFrame = CGRectMake(widthPart, m_startCollectionViewFrame.size.height + 4, 4 * widthPart, 32);
    
    //Local levels button
    m_flatButton = [[FlatButton alloc] initWithFrame:buttonFrame];
    [m_flatButton setHidden:YES];
    
    [m_flatButton setFrontColor:QUIZZ_APP_ORANGE_MAIN_COLOR];
    [m_flatButton setBackColor:QUIZZ_APP_ORANGE_SECOND_COLOR];
    
    [m_flatButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [m_flatButton setTitle:NSLocalizedStringFromTableInBundle(@"STR_OLD_LEVELS", nil, QUIZZ_APP_STRING_BUNDLE, nil) forState:UIControlStateNormal];
    
    [m_flatButton addTarget:self action:@selector(onLocalLevelsButtonPush:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_flatButton];
    
    //
    [self checkLocalLevels];
}

- (void)threadLoadLocalLevels {
    @autoreleasepool {
        NSMutableDictionary * aLevels = [LevelsViewController getLevelsWithMinId:0 andMaxId:MOVIE_QUIZZ_IOS_START_ID];
        LevelsViewController * levelsViewController = [[LevelsViewController alloc] initWithLevels:aLevels andRefreshButtonEnabled:NO];
        
        [self.navigationController pushViewController:levelsViewController animated:YES];
        
        [HUD hide:YES];
    }
}

- (void)onLocalLevelsButtonPush:(id)sender {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = NSLocalizedStringFromTableInBundle(@"STR_LOADING", nil, QUIZZ_APP_STRING_BUNDLE, nil);
    [HUD show:YES];
    
    [NSThread detachNewThreadSelector:@selector(threadLoadLocalLevels) toTarget:self withObject:nil];
}

- (void)refresh:(Boolean)hud {
    if (hud) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = NSLocalizedStringFromTableInBundle(@"STR_LOADING", nil, QUIZZ_APP_STRING_BUNDLE, nil);
        [HUD show:YES];
    }
    
    //Update levels
    NSMutableDictionary * aLevels = [LevelsViewController getLevelsWithMinId:MOVIE_QUIZZ_IOS_START_ID andMaxId:INT16_MAX];
    [self setLevels:aLevels];
    
    //And reload collection view
    [self.collectionView reloadData];
    
    //
    [self checkLocalLevels];
    
    if (hud) {
        [HUD hide:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
