//
//  LevelsViewController.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 23/09/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "LevelsViewController.h"

#import "LevelCell.h"
#import "HeaderCell.h"
#import "FooterCell.h"
#import "UtilsColors.h"
#import "PacksViewController.h"
#import "LevelDownloader.h"
#import "GameProvider.h"
#import "Utils.h"
#import "Constants.h"
#import "GameDBHelper.h"
#import "UtilsImage.h"
#import "BackView.h"
#import "MBProgressHUD.h"

@interface LevelsViewController () {
    Boolean m_refreshButtonEnabled;
}

@end

@implementation LevelsViewController

+ (NSMutableDictionary *)getLevelsWithMinId:(int)minId andMaxId:(int)maxId {
    //Get all known levels
    NSString * language = [Utils currentLanguage];
    NSArray * allLevels = [GameProvider getAllLevels:language andMinId:minId andMaxId:maxId];
    
    NSMutableDictionary * levels = [NSMutableDictionary dictionary];
    
    //Loop on each
    for (Level * level in allLevels) {
        [level refreshCompleted];

        //Related difficulty
        NSNumber * difficultyId = [NSNumber numberWithInt:level.difficultyId];
        
        //Check if a level dictionary exists
        NSMutableDictionary * levelsForDifficulty = [levels objectForKey:difficultyId];
        if (levelsForDifficulty == nil) {
            //If not, create it
            levelsForDifficulty = [[NSMutableDictionary alloc] init];
            //And add it
            [levels setObject:levelsForDifficulty forKey:difficultyId];
        }
        
        //Finally add the level to the corresponding difficulty array
        [levelsForDifficulty setObject:level forKey:level.key];
    }
    
    //    NSLog(@"found %lu difficulties", (unsigned long)[m_levels count]);
    
    return levels;
}

+ (NSMutableDictionary *)getLevels {
    return [LevelsViewController getLevelsWithMinId:0 andMaxId:INT16_MAX];
}

- (id)initWithLevels:(NSMutableDictionary *)aLevels andRefreshButtonEnabled:(Boolean)refreshButtonEnabled {
    UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
    self = [super initWithCollectionViewLayout:layout];
    
    if (self) {
        [self setLevels:aLevels];
//        [self refreshCompleted];
        m_refreshButtonEnabled = refreshButtonEnabled;
    }
    return self;
}

- (id)initWithLevels:(NSMutableDictionary *)aLevels {
    return [self initWithLevels:aLevels andRefreshButtonEnabled:YES];
}

//- (void)refreshCompleted {
//    for (NSNumber * difficultyId in m_levels) {
//        NSDictionary * difficulty = [m_levels objectForKey:difficultyId];
//        
//        for (NSNumber * levelId in difficulty) {
//            BaseLevel * level = [difficulty objectForKey:levelId];
//            [level refreshCompleted];
//        }
//    }
//}

- (NSNumber *)getDifficultyId:(NSInteger)section {
    NSMutableArray * keys = [NSMutableArray arrayWithArray:self.levels.allKeys];
    NSSortDescriptor * sorter = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray * sortDescriptors = [NSArray arrayWithObject:sorter];
    
    [keys sortUsingDescriptors:sortDescriptors];
    
    NSNumber * key = nil;
    if ([keys count] >= section) {
        key = [keys objectAtIndex:section];
    }
    return key;
}

- (NSUInteger)getDifficultySection:(int)difficultyId {
    NSMutableArray * keys = [NSMutableArray arrayWithArray:self.levels.allKeys];
    NSSortDescriptor * sorter = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray * sortDescriptors = [NSArray arrayWithObject:sorter];
    
    [keys sortUsingDescriptors:sortDescriptors];
    
    NSUInteger section = [keys indexOfObject:[NSNumber numberWithInt:difficultyId]];
    return section;
}

- (NSNumber *)getLevelIdWithRow:(NSInteger)row andLevels:(NSDictionary *)levels {
    NSMutableArray * keys = [NSMutableArray arrayWithArray:levels.allKeys];
    NSSortDescriptor * sorter = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray * sortDescriptors = [NSArray arrayWithObject:sorter];
    
    [keys sortUsingDescriptors:sortDescriptors];
    
    NSNumber * key = nil;
    
    if ([keys count] >= row) {
        key = [keys objectAtIndex:row];
    }
    
    return key;
}

- (NSMutableDictionary *)getLevels:(NSInteger)section {
    NSNumber * key = [self getDifficultyId:section];
    return [self.levels objectForKey:key];
}

- (void)refresh {
    //Update levels
    NSMutableDictionary * aLevels = [LevelsViewController getLevels];
    [self setLevels:aLevels];
    
    //And reload collection view
    [self.collectionView reloadData];
}

#pragma mark - PSTCollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return MAX([self.levels count], 1);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.levels count] > 0) {
        NSDictionary * levels = [self getLevels:(int)section];
        return [levels count];
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)aCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LevelCell * cell = [aCollectionView dequeueReusableCellWithReuseIdentifier:@"level_cell" forIndexPath:indexPath];
    NSDictionary * levels = [self getLevels:(int)indexPath.section];
    
    NSNumber * levelId = [self getLevelIdWithRow:indexPath.row andLevels:levels];
    BaseLevel * level = [levels objectForKey:levelId];
    
    [cell initializeWithLevel:level];
    
    return cell;
}

- (int)getNbFinishedLevels:(NSDictionary *)levels {
    int nbFinishedLevels = 0;
    
    for (NSNumber * levelId in levels) {
        BaseLevel * level = [levels objectForKey:levelId];
        
        if (level.isCompleted) {
            nbFinishedLevels++;
        }
    }
    
    return nbFinishedLevels;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	NSString * identifier = nil;
    UICollectionReusableView * supplementaryView = nil;

	if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
		identifier = @"header";
        supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        
        NSString * title = nil;
        if ([self.levels count] > 0) {
            //Difficulty
            NSNumber * difficultyId = [self getDifficultyId:(int)indexPath.section];
            Difficulty * difficulty = [GameProvider getDifficulty:[difficultyId intValue]];
            
            NSString * name = @"";
            if (difficulty != nil) {
                name = difficulty.name;
            } else {
                name = [NSString stringWithFormat:@"%@ %d", QALocalizedString(@"STR_DIFFICULTY"), [difficultyId intValue]];
            }
            
            //Progress
            NSDictionary * levels = [self getLevels:(int)indexPath.section];
            int nbFinishedLevels = [self getNbFinishedLevels:levels];
        
            title = [NSString stringWithFormat:@"%@ (%d/%lu)", name, nbFinishedLevels, (unsigned long)[levels count]];
        } else {
            title = QALocalizedString(@"NO_LEVELS");
        }
        
        [((HeaderCell *)supplementaryView).title setText:title];
	} else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
		identifier = @"footer";
        supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
	}
    
    return supplementaryView;
}

- (void)startLevel:(Level *)level {
    NSString * nibName = ExtensionName(@"PacksViewController");
    
    PacksViewController * packsViewController = [[PacksViewController alloc] initWithNibName:nibName bundle:QUIZZ_APP_XIB_BUNDLE andLevel:level];
    [self.navigationController pushViewController:packsViewController animated:YES];
}

- (void)collectionView:(UICollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [aCollectionView deselectItemAtIndexPath:indexPath animated:YES];

    NSDictionary * levels = [self getLevels:(int)indexPath.section];
    
    NSNumber * levelId = [self getLevelIdWithRow:indexPath.row andLevels:levels];
    BaseLevel * level = [levels objectForKey:levelId];

    //Show level
    if ([level isKindOfClass:[Level class]]) {
        [self startLevel:(Level *)level];
    } else {
        //Download
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
        hud.labelText = QALocalizedString(@"STR_DOWNLOADING");
        
        [LevelDownloader downloadLevelWithLevel:level andDelegate:self];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"shouldHighlightItemAtIndexPath");
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    [((LevelCell *)cell) setTouched:YES];
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"didUnhighlightItemAtIndexPath");
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    [((LevelCell *)cell) setTouched:NO];
}

#pragma mark - PSTCollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float padding = PixelsSize(3.0 * 10.0);
    float width = (self.view.frame.size.width - padding) / 2.0;
    return CGSizeMake(width, PixelsSize(90.0));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return PixelsSize(5.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return PixelsSize(10.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    float height = PixelsSize(40.0);
    return CGSizeMake(self.view.frame.size.width, height);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    return CGSizeMake(320, 5);
//}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(PixelsSize(10.0), PixelsSize(10.0), PixelsSize(10.0), PixelsSize(10.0));
}

#pragma mark - PLevelDownloadDelegate

- (void)onDownloadProgressWithProgress:(int)progress andTotal:(int)total andLevel:(BaseLevel *)level {
    float realProgress = ((float)progress/(float)total);
    
    MBProgressHUD * hud = [MBProgressHUD HUDForView:self.view.window];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.progress = realProgress;
    });
}

- (void)onDownloadDoneWithSuccess:(Boolean)success andBaseLevel:(BaseLevel *)baseLevel {
    if (success) {
        //Refresh levels
        NSInteger difficultyIndex = [self getDifficultySection:baseLevel.difficultyId];
        
        if (difficultyIndex != NSNotFound) {
            //Get levels
            NSMutableDictionary * levels = [self getLevels:difficultyIndex];
            
            //Get back Level from database
            Level * level = [GameDBHelper getLevel:baseLevel.identifier];
            [levels setObject:level forKey:baseLevel.key];
            
            //Reload collection view
            [self.collectionView reloadData];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view.window animated:YES];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view.window animated:YES];
        });

        //Popup connectivity
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:QALocalizedString(@"STR_INFORMATION")
                                                             message:QALocalizedString(@"STR_DOWNLOAD_LEVEL_ERROR_MESSAGE")
                                                            delegate:nil
                                                   cancelButtonTitle:QALocalizedString(@"STR_OK")
                                                   otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - IBAction

- (void)mainShowRefreshError {
    
}

- (IBAction)onRefreshButtonPush:(id)sender {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.labelText = QALocalizedString(@"STR_LOADING");

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //Update levels from servers
        if ([GameProvider requestLevels]) {
            //Refresh list
            [self refresh];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Popup connectivity
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:QALocalizedString(@"STR_INFORMATION")
                                                                     message:QALocalizedString(@"STR_NO_CONNECTIVITY_MESSAGE")
                                                                    delegate:nil
                                                           cancelButtonTitle:QALocalizedString(@"STR_OK")
                                                           otherButtonTitles:nil];
                [alertView show];
            });
        }
        
        //Finally hide HUD
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view.window animated:YES];
        });
    });
}

#pragma mark - UI

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Set icon badge number to zero
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

#warning TO MOVE?
    //Parse stuff
//    PFInstallation * currentInstallation = [PFInstallation currentInstallation];
//    [currentInstallation setBadge:0];
//    [currentInstallation saveEventually];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:QALocalizedString(@"STR_LEVELS_TITLE")];
    
    //Refresh button
    if (m_refreshButtonEnabled) {
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onRefreshButtonPush:)];
        [self.navigationItem setRightBarButtonItem:rightItem];
    }
    
    //Collection view
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
    [self.collectionView registerClass:[LevelCell class] forCellWithReuseIdentifier:@"level_cell"];
    [self.collectionView registerClass:[HeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[FooterCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    //Background
    BackView * backgroundImageView = [[BackView alloc] initWithFrame:self.view.frame];
    [backgroundImageView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:backgroundImageView];
    
    //Footer
    NSString * footerLeftImageName = ExtensionName(@"footer_left");
    NSString * footerRightImageName = ExtensionName(@"footer_right");
    
    float halfWidth = self.view.frame.size.width / 2.0;
    
    //Left
    UIImageView * footerLeftImageView = [[UIImageView alloc] initWithImage:[UtilsImage imageNamed:footerLeftImageName]];
    [footerLeftImageView setFrame:CGRectMake(0, self.view.frame.size.height - footerLeftImageView.frame.size.height, halfWidth, footerLeftImageView.frame.size.height)];
    [footerLeftImageView setContentMode:UIViewContentModeLeft];
    [footerLeftImageView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [footerLeftImageView setAlpha:0.25];
    [self.view addSubview:footerLeftImageView];
    
    //Right
    UIImageView * footerRightImageView = [[UIImageView alloc] initWithImage:[UtilsImage imageNamed:footerRightImageName]];
    [footerRightImageView setFrame:CGRectMake(halfWidth, self.view.frame.size.height - footerRightImageView.frame.size.height, halfWidth, footerRightImageView.frame.size.height)];
    [footerRightImageView setContentMode:UIViewContentModeRight];
    [footerRightImageView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [footerRightImageView setAlpha:0.25];
    [self.view addSubview:footerRightImageView];
    
    //Levels to front
    [self.view bringSubviewToFront:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
