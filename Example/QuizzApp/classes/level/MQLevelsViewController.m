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

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    if (hud) {
        [HUD hide:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
