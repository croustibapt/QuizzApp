//
//  ProgressViewController.h
//  quizzapp
//
//  Created by dev_iphone on 26/05/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProgressManager.h"
#import "PProgressAuthListener.h"
#import "BackViewController.h"
#import "FlatButton.h"

@interface ProgressViewController : BackViewController <PProgressAuthListener, PProgressGamesListener, UIWebViewDelegate> {
    NSString * m_clientId;
    NSNumber * m_progressionKey;
    NSString * m_leaderBoardId;
    
    FlatButton * m_signInButton;
    UILabel * m_statusLabel;
    UIActivityIndicatorView * m_activityIndicatorView;
    UILabel * m_informationLabel;
    
    FlatButton * m_syncButton;
    
    UIImageView * m_gameImageView;
    
    UINavigationController * m_loginNavigationController;
}

@property (nonatomic, retain) IBOutlet FlatButton * signInButton;

@property (nonatomic, retain) IBOutlet UILabel * statusLabel;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * activityIndicatorView;

@property (nonatomic, retain) IBOutlet UILabel * informationLabel;

@property (nonatomic, retain) IBOutlet FlatButton * syncButton;

@property (nonatomic, retain) IBOutlet UIImageView * gameImageView;

@property (nonatomic, retain) NSString * clientId;

@property (nonatomic, retain) NSNumber * progressionKey;

@property (nonatomic, retain) NSString * leaderBoardId;

@property (nonatomic, readwrite) Boolean autoSignIn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andClientId:(NSString *)clientId andProgressionKey:(NSNumber *)progressionKey andAutoSignIn:(Boolean)autoSignIn;

- (void)initProgression;

- (void)refreshUI;

@end
