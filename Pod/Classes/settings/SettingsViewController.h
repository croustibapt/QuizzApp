//
//  SettingsViewController.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 16/12/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Parse/Parse.h>

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    UITableView * m_tableView;
}

@property (nonatomic, retain) IBOutlet UITableView * tableView;

#pragma mark - Progress

- (void)showProgress;

#pragma mark - Help

- (void)showHelp;

#pragma mark - Language

- (void)changeLanguage;

- (int)nbOtherGames;

+ (void)showOtherGame:(NSString *)appId;

- (NSString *)titleForOtherGame:(NSInteger)index;

- (UIImage *)imageForOtherGame:(NSInteger)index;

- (NSString *)appIdForOtherGame:(NSInteger)index;

@end
