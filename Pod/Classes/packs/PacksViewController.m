//
//  PacksViewController.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 26/09/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "PacksViewController.h"


#import "UtilsColors.h"
#import "PackCell.h"
#import "GameDBHelper.h"
#import "Utils.h"
#import "UtilsImage.h"
#import "Constants.h"
#import "GameViewController.h"

@interface PacksViewController ()

@end

@implementation PacksViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSString * nibName = ExtensionName(@"PacksViewController");
        [QUIZZ_APP_XIB_BUNDLE loadNibNamed:nibName owner:self options:nil];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLevel:(Level *)aLevel {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setLevel:aLevel];
        
        NSDictionary * levelPacks = [GameDBHelper getPacksForLevel:self.level.identifier];
        
        NSSortDescriptor * sorter = [NSSortDescriptor sortDescriptorWithKey:@"difficulty" ascending:YES];
        NSArray * sortDescriptors = [NSArray arrayWithObject:sorter];
        
        NSMutableArray * allPacks = [NSMutableArray arrayWithArray:[levelPacks allValues]];
        [allPacks sortUsingDescriptors:sortDescriptors];
        
        [self setPacks:allPacks];
    }
    return self;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.packs count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"PackCell";
    PackCell * cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSString * cellNib = ExtensionName(@"PackCell");
        
        NSArray * nibViews = [QUIZZ_APP_XIB_BUNDLE loadNibNamed:cellNib owner:nil options:nil];
        cell = [nibViews objectAtIndex:0];
        
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    Pack * pack = [self.packs objectAtIndex:indexPath.section];
    [cell initializeWithPack:pack];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PixelsSize(100);
}

- (void)onStartPackWithPack:(Pack *)pack andLevel:(Level *)level andReplay:(Boolean)replay {
    NSString * nibName = ExtensionName(@"GameViewController");
    
    GameViewController * gameViewController = [[GameViewController alloc] initWithNibName:nibName bundle:QUIZZ_APP_XIB_BUNDLE andPack:pack andLevel:level andReplay:(Boolean)replay];
    [self.navigationController pushViewController:gameViewController animated:YES];
}

- (void)startPackWithIndexPath:(NSIndexPath *)indexPath andReplay:(Boolean)replay {
    Pack * pack = [self.packs objectAtIndex:indexPath.section];
    
    //    NSArray * medias = [GameDBHelper getMediasForPack:pack];
    //    [pack setMedias:medias];
    
    [self onStartPackWithPack:pack andLevel:self.level andReplay:replay];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //Start pack
    [self startPackWithIndexPath:indexPath andReplay:NO];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return @"Vous avez fini 5 pack(s) sur 14 :";
//    } else {
//        return nil;
//    }
//}

- (BOOL)tableView:(UITableView *)aTableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [aTableView cellForRowAtIndexPath:indexPath];
    [((PackCell *)cell) setTouched:YES];
    
    return YES;
}

- (void)tableView:(UITableView *)aTableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [aTableView cellForRowAtIndexPath:indexPath];
    [((PackCell *)cell) setTouched:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return PixelsSize(35);
    } else {
        return 0;
    }
}

- (int)getNbFinishedPacks {
    int finishedPacks = 0;
    
    for (Pack * pack in self.packs) {
        if (pack.isCompleted) {
            finishedPacks++;
        }
    }
    
    return finishedPacks;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
        [header setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
        
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 35)];
        [title setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
        
        float font = PixelsSize(20.0);
        [title setFont:[UIFont fontWithName:@"RobotoCondensed-Regular" size:font]];
        
        int nbFinishedPacks = [self getNbFinishedPacks];
        [title setText:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"STR_PACK_FINISH_STATUS", nil, QUIZZ_APP_STRING_BUNDLE, nil), nbFinishedPacks, ((nbFinishedPacks > 1) ? NSLocalizedStringFromTableInBundle(@"STR_PACKS", nil, QUIZZ_APP_STRING_BUNDLE, nil) : NSLocalizedStringFromTableInBundle(@"STR_PACK", nil, QUIZZ_APP_STRING_BUNDLE, nil)), [self.packs count]]];
        [title setTextColor:[UIColor whiteColor]];
        [title setBackgroundColor:[UIColor clearColor]];
        
        [header addSubview:title];
        
        return header;
    } else {
        return nil;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.tableView setEditing:NO animated:YES];
    
    if (buttonIndex != alertView.cancelButtonIndex) {
        NSInteger sectionId = alertView.tag;
        Pack * pack = [self.packs objectAtIndex:sectionId];
        [pack restart];
        
        [self.level setIsCompleted:NO];
        
        //        [pack refreshCompleted];
        
        //        [self.tableView reloadData];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:sectionId];
        [self startPackWithIndexPath:indexPath andReplay:YES];
    }
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"STR_INFORMATION", nil, QUIZZ_APP_STRING_BUNDLE, nil) message:NSLocalizedStringFromTableInBundle(@"STR_REPLAY_PACK_MESSAGE", nil, QUIZZ_APP_STRING_BUNDLE, nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"STR_CANCEL", nil, QUIZZ_APP_STRING_BUNDLE, nil) otherButtonTitles:NSLocalizedStringFromTableInBundle(@"STR_CONTINUE", nil, QUIZZ_APP_STRING_BUNDLE, nil), nil];
    [alertView setTag:indexPath.section];
    [alertView show];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NSLocalizedStringFromTableInBundle(@"STR_REPLAY", nil, QUIZZ_APP_STRING_BUNDLE, nil);
}

#pragma mark - UI

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:[NSString stringWithFormat:@"%@ %d", NSLocalizedStringFromTableInBundle(@"STR_LEVEL", nil, QUIZZ_APP_STRING_BUNDLE, nil), self.level.value]];
    
    if ([Utils isIPad])
    {
        [self.tableView setBackgroundView:nil];
        [self.tableView setBackgroundView:[[UIView alloc] init]];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
