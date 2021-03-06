//
//  SettingsViewController.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 16/12/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//


#import "SettingsViewController.h"


#import "ProgressManager.h"
#import "HelpViewController.h"
#import "ProgressViewController.h"
#import "QuizzApp.h"


typedef enum
{
    ESettingsSectionActions = 0,
    ESettingsSectionGame,
    ESettingsSectionOtherGames,
    ESettingsSectionMore,
    ESettingsSectionLast
}
ESettingsSection;


typedef enum
{
    ESettingsParametersRowLanguage = 0,
    ESettingsParametersRowSound,
    ESettingsParametersRowLast
}
ESettingsParametersRow;


typedef enum {
    ESettingsGameRowLogin = 0,
    ESettingsGameRowHelp,
    ESettingsGameRowLast
}
ESettingsGameRow;


typedef enum
{
    ESettingsMoreRowSuggest = 0,
    ESettingsMoreRowWebsite,
    ESettingsMoreRowLast
}
ESettingsMoreRow;


int const QUIZZ_APP_SUGGEST_ALERT = 1;
int const QUIZZ_APP_WEBSITE_ALERT = 2;
int const QUIZZ_APP_LANGUAGE_ALERT = 3;
int const QUIZZ_APP_OTHER_GAME_ALERT = 4;


#import "Constants.h"
#import "UtilsImage.h"


@interface SettingsViewController ()


@end


@implementation SettingsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}


#pragma mark - Progress


- (void)showProgressViewController
{
    NSString * nibName = ExtensionName(@"ProgressViewController");

    //Create progress controller
    BOOL isAuthenticated = [[QuizzApp sharedInstance].progressManager isAuthenticated];
    ProgressViewController * progressViewController = [[ProgressViewController alloc] initWithBundle:QUIZZ_APP_XIB_BUNDLE
                                                                                        authenticate:!isAuthenticated
                                                                                             dismiss:NO];

    [self.navigationController pushViewController:progressViewController animated:YES];
}


#pragma mark - Help


- (void)showHelp
{
    [HelpViewController showHelpWithNibName:ExtensionName(@"HelpViewController")
                             viewController:self];
}


- (int)nbOtherGames
{
    return 0;
}


- (NSString *)titleForOtherGame:(NSInteger)index
{
    return nil;
}


- (NSString *)appIdForOtherGame:(NSInteger)index
{
    return nil;
}


- (UIImage *)imageForOtherGame:(NSInteger)index
{
    return nil;
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ESettingsSectionLast;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == ESettingsSectionActions) {
        return ESettingsParametersRowLast;
    } else if (section == ESettingsSectionGame) {
        return ESettingsGameRowLast;
    } else if (section == ESettingsSectionOtherGames) {
        return [self nbOtherGames];
    } else if (section == ESettingsSectionMore) {
        return ESettingsMoreRowLast;
    } else {
        return 0;
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == ESettingsSectionActions)
    {
        return QALocalizedString(@"STR_SETTINGS_PARAMETERS");
    }
    else if (section == ESettingsSectionGame)
    {
        return QALocalizedString(@"STR_SETTINGS_GAME");
    }
    else if (section == ESettingsSectionOtherGames)
    {
        return QALocalizedString(@"STR_SETTINGS_OTHER_GAMES");
    }
    else if (section == ESettingsSectionMore)
    {
        return QALocalizedString(@"STR_SETTINGS_MORE");
    }
    else
    {
        return nil;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    [cell.detailTextLabel setText:nil];
    [cell setAccessoryType:UITableViewCellAccessoryNone];

    if (indexPath.section == ESettingsSectionActions)
    {
        if (indexPath.row == ESettingsParametersRowLanguage)
        {
            //Language
            [cell.imageView setImage:[UtilsImage imageNamed:@"ic_flag"
                                                     bundle:QUIZZ_APP_IMAGE_BUNDLE
                                                   andColor:[QuizzApp sharedInstance].secondColor]];
            
            [cell.textLabel setText:QALocalizedString(@"STR_SETTINGS_CHANGE_LANGUAGE")];
            [cell.detailTextLabel setText:QALocalizedString([Utils currentLanguage])];
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        else if (indexPath.row == ESettingsParametersRowSound)
        {
            //Sound
            if ([Constants isSoundActivated])
            {
                [cell.imageView setImage:[UtilsImage imageNamed:@"ic_sound"
                                                         bundle:QUIZZ_APP_IMAGE_BUNDLE
                                                       andColor:[QuizzApp sharedInstance].secondColor]];
                [cell.textLabel setText:QALocalizedString(@"STR_DISABLE_SOUND")];
            }
            else
            {
                [cell.imageView setImage:[UtilsImage imageNamed:@"ic_mute" bundle:QUIZZ_APP_IMAGE_BUNDLE andColor:[QuizzApp sharedInstance].secondColor]];
                [cell.textLabel setText:QALocalizedString(@"STR_SETTINGS_ENABLE_SOUND")];
            }
        }
    }
    else if (indexPath.section == ESettingsSectionGame)
    {
        if (indexPath.row == ESettingsGameRowLogin)
        {
            //Login
            [cell.imageView setImage:[UtilsImage imageNamed:@"ic_google_plus" bundle:QUIZZ_APP_IMAGE_BUNDLE andColor:[QuizzApp sharedInstance].secondColor]];
            
            if ([[QuizzApp sharedInstance].progressManager isAuthenticated])
            {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                [cell.textLabel setText:QALocalizedString(@"STR_SETTINGS_GAME_CENTER")];
            }
            else
            {
                [cell.textLabel setText:QALocalizedString(@"STR_SETTINGS_LOGIN_GAME_CENTER")];
            }
        } else if (indexPath.row == ESettingsGameRowHelp) {
            //Website
            [cell.imageView setImage:[UtilsImage imageNamed:@"ic_how_to" bundle:QUIZZ_APP_IMAGE_BUNDLE andColor:[QuizzApp sharedInstance].secondColor]];
            [cell.textLabel setText:QALocalizedString(@"STR_SETTINGS_HOW_TO_PLAY")];
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    } else if (indexPath.section == ESettingsSectionOtherGames) {
        //Other game
        [cell.imageView setImage:[self imageForOtherGame:indexPath.row]];
        [cell.textLabel setText:[self titleForOtherGame:indexPath.row]];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else if (indexPath.section == ESettingsSectionMore) {
        if (indexPath.row == ESettingsMoreRowSuggest) {
            //Propose
            [cell.imageView setImage:[UtilsImage imageNamed:@"ic_suggest_pack" bundle:QUIZZ_APP_IMAGE_BUNDLE andColor:[QuizzApp sharedInstance].secondColor]];
            [cell.textLabel setText:QALocalizedString(@"STR_SETTINGS_SUGGEST_PACK")];
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        } else if (indexPath.row == ESettingsMoreRowWebsite) {
            //Website
            [cell.imageView setImage:[UtilsImage imageNamed:@"ic_levelapp" bundle:QUIZZ_APP_IMAGE_BUNDLE]];
            [cell.textLabel setText:QALocalizedString(@"STR_SETTINGS_OUR_WEBSITE")];
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }
    
    return cell;
}

- (void)changeLanguage {
    [Utils setCurrentLanguage:[Utils otherLanguage]];
    [self.navigationController popViewControllerAnimated:YES];
    
#warning TO MOVE?
//    PFInstallation * currentInstallation = [PFInstallation currentInstallation];
//    
//    NSString * currentLanguage = [Utils currentLanguage];
//    [currentInstallation addUniqueObject:currentLanguage forKey:@"channels"];
//    [currentInstallation saveInBackground];
//    
//    NSString * oldLanguage = [Utils otherLanguage];
//    [currentInstallation removeObject:oldLanguage forKey:@"channels"];
//    [currentInstallation saveInBackground];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (alertView.tag == QUIZZ_APP_SUGGEST_ALERT) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:QUIZZ_APP_SUGGEST_PACK_URL]];
        } else if (alertView.tag == QUIZZ_APP_WEBSITE_ALERT) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LEVEL_APP_URL]];
        } else if (alertView.tag == QUIZZ_APP_LANGUAGE_ALERT) {
            [self changeLanguage];
        }
    }
}


- (void)showSuggestPack
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:QALocalizedString(@"STR_SETTINGS_SUGGEST_PACK_TITLE")
                                                         message:QALocalizedString(@"STR_SETTINGS_SUGGEST_PACK_MESSAGE")
                                                        delegate:self
                                               cancelButtonTitle:QALocalizedString(@"STR_CANCEL")
                                               otherButtonTitles:QALocalizedString(@"STR_OK"), nil];
    [alertView setTag:QUIZZ_APP_SUGGEST_ALERT];
    [alertView show];
}


+ (void)showOtherGame:(NSString *)appId
{
    NSString * url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appId];
    NSURL * appURL = [NSURL URLWithString:url];
    [[UIApplication sharedApplication] openURL:appURL];
}


- (void)showWebsite
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:QALocalizedString(@"STR_INFORMATION")
                                                         message:QALocalizedString(@"STR_SETTINGS_WEBSITE_MESSAGE")
                                                        delegate:self
                                               cancelButtonTitle:QALocalizedString(@"STR_CANCEL")
                                               otherButtonTitles:QALocalizedString(@"STR_OK"), nil];
    [alertView setTag:QUIZZ_APP_WEBSITE_ALERT];
    [alertView show];
}


- (void)showLanguage
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:QALocalizedString(@"STR_SETTINGS_CHANGE_LANGUAGE_TITLE")
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:QALocalizedString([Utils currentLanguage])
                                               otherButtonTitles:QALocalizedString([Utils otherLanguage]), nil];
    [alertView setTag:QUIZZ_APP_LANGUAGE_ALERT];
    [alertView show];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ESettingsSectionActions)
    {
        if (indexPath.row == ESettingsParametersRowLanguage)
        {
            //Language
            [self showLanguage];
        }
        else if (indexPath.row == ESettingsParametersRowSound)
        {
            //Sound
            [Constants toggleSoundPref];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:ESettingsParametersRowSound inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else if (indexPath.section == ESettingsSectionGame)
    {
        if (indexPath.row == ESettingsGameRowLogin)
        {
            //Login
            [self showProgressViewController];
        }
        else if (indexPath.row == ESettingsGameRowHelp)
        {
            //Website
            [self showHelp];
        }
    }
    else if (indexPath.section == ESettingsSectionOtherGames)
    {
        [SettingsViewController showOtherGame:[self appIdForOtherGame:indexPath.row]];
    }
    else if (indexPath.section == ESettingsSectionMore)
    {
        if (indexPath.row == ESettingsMoreRowSuggest)
        {
            // Propose
            [self showSuggestPack];
        }
        else if (indexPath.row == ESettingsMoreRowWebsite)
        {
            // Website
            [self showWebsite];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == ESettingsSectionMore) {
        //App version label
        NSString * versionString = [NSString stringWithFormat:@"v%@", [[MAIN_BUNDLE infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        return versionString;
    } else {
        return nil;
    }
}

#pragma mark - UI

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:QALocalizedString(@"STR_SETTINGS_TITLE")];
    
    //Table view tint color
    if ([self.tableView respondsToSelector:@selector(setTintColor:)])
    {
        [self.tableView setTintColor:QUIZZ_APP_BLUE_SECOND_COLOR];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
