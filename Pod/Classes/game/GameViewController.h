//
//  GameViewController.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 18/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <iAd/iAd.h>

#import "GameAnswerView.h"
#import "Pack.h"
#import "PGameListener.h"
#import "MBProgressHUD.h"
#import "BackViewController.h"
#import "Level.h"

@interface GameViewController : BackViewController <UIScrollViewDelegate, PGameListener, UIGestureRecognizerDelegate, UIAlertViewDelegate, MBProgressHUDDelegate, MFMailComposeViewControllerDelegate, ADBannerViewDelegate> {
    Pack * m_pack;
    Level * m_level;
    
    GameAnswerView * m_gameAnswerView;
    NSInteger m_currentMediaIndex;
    NSMutableArray * m_posterViews;
    
    UITapGestureRecognizer * m_tapGestureRecognizer;
    UISwipeGestureRecognizer * m_swipeUpGestureRecognizer;
    UISwipeGestureRecognizer * m_swipeDownGestureRecognizer;
    
    MBProgressHUD * HUD;
    UIView * m_adView;
    UIView * m_gameView;
    UIScrollView * m_scrollView;
    
#pragma mark - Sound
    
    AVAudioPlayer * m_audioPlayer;
    
#pragma mark - Ad
    
    ADBannerView * m_bannerView;
    
    Boolean m_ready;
}

@property (nonatomic, retain) IBOutlet UIView * adView;

@property (nonatomic, retain) IBOutlet UIView * gameView;

@property (nonatomic, retain) IBOutlet UIScrollView * scrollView;

@property (nonatomic, retain) Pack * pack;

@property (nonatomic, retain) Level * level;

@property (nonatomic, readwrite) Boolean isZoomed;

@property (nonatomic, readwrite) Boolean replay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPack:(Pack *)pack andLevel:(Level *)level andReplay:(Boolean)replay;

- (CGRect)loadCurrentMedia;

@end
