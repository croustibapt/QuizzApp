//
//  ProgressViewController.h
//  quizzapp
//
//  Created by dev_iphone on 26/05/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QuizzApp.h"
#import "BackViewController.h"
#import "FlatButton.h"

@interface ProgressViewController : BackViewController <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet FlatButton * signInButton;

@property (nonatomic, strong) IBOutlet UILabel * statusLabel;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView * activityIndicatorView;

@property (nonatomic, strong) IBOutlet UILabel * informationLabel;

@property (nonatomic, strong) IBOutlet FlatButton * syncButton;

@property (nonatomic, strong) IBOutlet UIImageView * gameImageView;

@property (nonatomic, strong) NSString * clientId;

@property (nonatomic, strong) NSString * progressionKey;

@property (nonatomic, strong) NSString * leaderBoardId;

@property (nonatomic) BOOL autoSignIn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andClientId:(NSString *)clientId andProgressionKey:(NSString *)progressionKey andAutoSignIn:(BOOL)autoSignIn;

- (void)refreshUI;

@end
