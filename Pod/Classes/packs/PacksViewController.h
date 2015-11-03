//
//  PacksViewController.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 26/09/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Level.h"
#import "BackViewController.h"
#import "Pack.h"

@interface PacksViewController : BackViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView * tableView;

@property (nonatomic, strong) Level * level;

@property (nonatomic, strong) NSArray * packs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLevel:(Level *)level;

- (void)onStartPackWithPack:(Pack *)pack andLevel:(Level *)level andReplay:(Boolean)replay;

@end
