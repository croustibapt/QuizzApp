//
//  MQSettingsViewController.m
//  moviequizz2
//
//  Created by Baptiste LE GUELVOUIT on 21/10/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "MQSettingsViewController.h"

#import "UtilsImage.h"
#import "MQConstants.h"

@interface MQSettingsViewController ()

@end

@implementation MQSettingsViewController

- (int)nbOtherGames {
    return 2;
}

- (NSString *)titleForOtherGame:(NSInteger)index {
    if (index == 0) {
        return @"TV Show Quizz";
    } else if (index == 1) {
        return @"Add'ict";
    } else {
        return nil;
    }
}

- (NSString *)appIdForOtherGame:(NSInteger)index {
    if (index == 0) {
        return TV_SHOW_QUIZZ_APP_ID;
    } else if (index == 1) {
        return ADDICT_APP_ID;
    } else {
        return nil;
    }
}

- (UIImage *)imageForOtherGame:(NSInteger)index {
    if (index == 0) {
        return [UtilsImage imageNamed:@"tv-show-quizz-icon"];
    } else if (index == 1) {
        return [UtilsImage imageNamed:@"plus-icon"];
    } else {
        return nil;
    }
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
