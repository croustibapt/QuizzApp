//
//  LevelsViewController.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 23/09/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/Analytics.h>

#import "PSTCollectionView.h"
#import "PSTCollectionViewController.h"
#import "PLevelDownloadListener.h"
#import "MBProgressHUD.h"
#import "Level.h"

@interface LevelsViewController : PSUICollectionViewController <PLevelDownloadListener, MBProgressHUDDelegate>

@property (nonatomic, retain) NSMutableDictionary * levels;

+ (NSMutableDictionary *)getLevelsWithMinId:(int)minId andMaxId:(int)maxId;

+ (NSMutableDictionary *)getLevels;

- (id)initWithLevels:(NSMutableDictionary *)levels andRefreshButtonEnabled:(Boolean)refreshButtonEnabled;

- (id)initWithLevels:(NSMutableDictionary *)levels;

- (void)startLevel:(Level *)level;

@end
