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
#import "MBProgressHUD.h"
#import "BackViewController.h"
#import "Level.h"
#import "GameManager.h"

@interface GameViewController : BackViewController <UIScrollViewDelegate, GameDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, MBProgressHUDDelegate, MFMailComposeViewControllerDelegate, ADBannerViewDelegate>

@property (nonatomic, strong) IBOutlet UIView * adView;

@property (nonatomic, strong) IBOutlet UIView * gameView;

@property (nonatomic, strong) IBOutlet UIScrollView * scrollView;

@property (nonatomic, strong) Pack * pack;

@property (nonatomic, strong) Level * level;

@property (nonatomic) Boolean isZoomed;

@property (nonatomic) Boolean replay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPack:(Pack *)pack andLevel:(Level *)level andReplay:(Boolean)replay;

- (CGRect)loadCurrentMedia;

@end
