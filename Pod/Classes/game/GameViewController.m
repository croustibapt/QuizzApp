//
//  GameViewController.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 18/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "GameViewController.h"

#import "Media.h"
#import "GameManager.h"
#import "MediaView.h"
#import "GameDBHelper.h"
#import "Constants.h"
#import "LevelsViewController.h"
#import "UtilsImage.h"
#import "HelpViewController.h"
#import "QuizzApp.h"

@interface GameViewController () {
    GameAnswerView * m_gameAnswerView;
    NSInteger m_currentMediaIndex;
    NSMutableArray * m_posterViews;
    
    UITapGestureRecognizer * m_tapGestureRecognizer;
    UISwipeGestureRecognizer * m_swipeUpGestureRecognizer;
    UISwipeGestureRecognizer * m_swipeDownGestureRecognizer;
    
    MBProgressHUD * HUD;
    
#pragma mark - Sound
    
    AVAudioPlayer * m_audioPlayer;
    
#pragma mark - Ad
    
    ADBannerView * m_bannerView;
    
    Boolean m_ready;
}

@end

@implementation GameViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSString * nibName = ExtensionName(@"GameViewController");
        [QUIZZ_APP_XIB_BUNDLE loadNibNamed:nibName owner:self options:nil];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPack:(Pack *)aPack andLevel:(Level *)aLevel andReplay:(Boolean)aReplay {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setPack:aPack];
        [self setLevel:aLevel];
        [self setReplay:aReplay];
        
        m_posterViews = [[NSMutableArray alloc] init];
        
        m_ready = NO;
    }
    return self;
}

- (Media *)currentMedia {
    Media * media = [self.pack.medias objectAtIndex:m_currentMediaIndex];
    return media;
}

- (void)zoomPoster:(Boolean)animated {
    //Poster view
    MediaView * mediaView = [m_posterViews objectAtIndex:m_currentMediaIndex];
    
    CGRect answerViewFrame = m_gameAnswerView.frame;
    int lettersHeight = m_gameAnswerView.answerView.frame.size.height;
    
    //Destination
    CGRect gameAnswerViewDestinationFrame = CGRectMake(answerViewFrame.origin.x, self.gameView.frame.size.height - lettersHeight, answerViewFrame.size.width, answerViewFrame.size.height);
//    CGRect posterDestinationView = CGRectMake(mediaView.frame.origin.x, mediaView.frame.origin.y, answerViewFrame.size.width, self.gameView.frame.size.height - lettersHeight);
    CGRect posterDestinationView = CGRectMake(mediaView.frame.origin.x, 0, mediaView.frame.size.width, self.gameView.frame.size.height - lettersHeight);

    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:QUIZZ_APP_POSTER_ANIMATION_DURATION];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    }
    
    //Keyboard
    [m_gameAnswerView setFrame:gameAnswerViewDestinationFrame];
    //Poster
    [mediaView setFrame:posterDestinationView];
    
    if (animated) {
        [UIView commitAnimations];
    }
    
    [self setIsZoomed:YES];
}

- (void)zoomPoster {
    if (!self.isZoomed) {
        [self zoomPoster:YES];
    }
}

- (void)showAnswerView:(Boolean)animated {
    NSLog(@"show answer view: %@", (animated ? @"animated" : @"non animated"));
    MediaView * mediaView = [m_posterViews objectAtIndex:m_currentMediaIndex];
    
    CGRect answerViewFrame = m_gameAnswerView.frame;
//    int lettersHeight = m_gameAnswerView.answerView.frame.size.height;
    
    //Destination
    CGRect gameAnswerViewDestinationFrame = CGRectMake(answerViewFrame.origin.x, self.gameView.frame.size.height - answerViewFrame.size.height, answerViewFrame.size.width, answerViewFrame.size.height);
    CGRect posterDestinationView = CGRectMake(mediaView.frame.origin.x, mediaView.frame.origin.y - m_gameAnswerView.keyboardView.frame.size.height, mediaView.frame.size.width, mediaView.frame.size.height);
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:QUIZZ_APP_POSTER_ANIMATION_DURATION];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    }
    
    //Keyboard
    [m_gameAnswerView setFrame:gameAnswerViewDestinationFrame];
    //Poster
    [mediaView setFrame:posterDestinationView];
    
    if (animated) {
        [UIView commitAnimations];
    }
    
    [self setIsZoomed:NO];
}

- (void)showAnswerView {
    if (self.isZoomed) {
        [self showAnswerView:YES];
    }
}

- (CGRect)loadCurrentMedia {
    //Change title
    [self updateTitle];
    
    //Get current media
    Media * media = [self currentMedia];
    
    //Tap gesture handling
    Boolean mediaCompleted = self.replay ? media.isReplayCompleted : media.isCompleted;
    [m_tapGestureRecognizer setEnabled:!mediaCompleted];
    [m_swipeUpGestureRecognizer setEnabled:!mediaCompleted];
    [m_swipeDownGestureRecognizer setEnabled:!mediaCompleted];
    
    //Friend item
    if (!mediaCompleted) {
        UIBarButtonItem * friendItem = [[UIBarButtonItem alloc] initWithImage:[UtilsImage imageNamed:@"ic_mail" bundle:QUIZZ_APP_IMAGE_BUNDLE] style:UIBarButtonItemStylePlain target:self action:@selector(onFriendButtonPush:)];
        [self.navigationItem setRightBarButtonItem:friendItem];
    } else {
        [self.navigationItem setRightBarButtonItem:nil];
    }
        
    CGRect frame = [m_gameAnswerView onMediaChangedWithMedia:media andPackId:self.pack.identifier andReset:YES andReplay:self.replay];
    
    return frame;
}

- (void)updateTitle {
    NSString * title = [NSString stringWithFormat:@"%@ %d/%lu", [self.pack.title uppercaseString], (int)(m_currentMediaIndex + 1), (unsigned long)[self.pack.medias count]];
    [self setTitle:title];
}

#pragma mark - Sound

- (void)threadPlaySound:(NSString *)fileName {
    
}

- (void)playSoundWithFileName:(NSString *)fileName {
    if ([Constants isSoundActivated]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            @synchronized(m_audioPlayer) {
                NSURL * wellDoneFile = [NSURL fileURLWithPath:[MAIN_BUNDLE pathForResource:fileName ofType:@"mp3"]];
                m_audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:wellDoneFile error:nil];
                [m_audioPlayer play];
            }
        });
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    MediaView * mediaView = [m_posterViews objectAtIndex:m_currentMediaIndex];
//    UIImageView * oldPoster = mediaView.posterImageView;
//    
//    int mediaIndex = self.scrollView.contentOffset.x/self.scrollView.frame.size.width;
//    if ((mediaIndex != m_currentMediaIndex) && ([self.pack.medias count] > m_currentMediaIndex)) {
//        MediaView * mediaView = [m_posterViews objectAtIndex:m_currentMediaIndex];
//        UIImageView * poster = mediaView.posterImageView;
//        
//        CGRect oldFrame = poster.frame;
//        
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:QUIZZ_APP_POSTER_ANIMATION_DURATION];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//        
//        [poster setFrame:CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, oldPoster.frame.size.height)];
//        
//        [UIView commitAnimations];
//    }
    [self zoomPoster:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [m_gameAnswerView setHidden:NO];

    int mediaIndex = self.scrollView.contentOffset.x/self.scrollView.frame.size.width;
    
    if ((mediaIndex != m_currentMediaIndex) && ([self.pack.medias count] > m_currentMediaIndex)) {
        //Change current media index
        m_currentMediaIndex = mediaIndex;
        
        //Load it
        [self loadCurrentMedia];
    }
    
    [self zoomPoster:NO];
}

#pragma mark - IBAction

- (IBAction)onGameViewTapped:(id)sender {
    if (self.isZoomed) {
        [self showAnswerView:YES];
    } else {
        [self zoomPoster:YES];
    }
}

- (IBAction)onFriendButtonPush:(id)sender {
    if (!self.isZoomed) {
        [self zoomPoster:NO];
    }
    
    UIGraphicsBeginImageContext(self.gameView.frame.size);
	[self.gameView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage * viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    
    MFMailComposeViewController * controller = [[MFMailComposeViewController alloc] init];
    
    if (controller != nil) {
        controller.mailComposeDelegate = self;
        
        NSString * appName = [MAIN_BUNDLE objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        
        NSString * subject = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"STR_HELP_MAIL_TITLE", nil, QUIZZ_APP_STRING_BUNDLE, nil), appName];
        
        NSString * messageBody = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"STR_HELP_MAIL_MESSAGE", nil, QUIZZ_APP_STRING_BUNDLE, nil), NSLocalizedStringFromTableInBundle(@"STR_MOVIE", nil, MAIN_BUNDLE, nil), self.pack.title, appName];
        
        [controller setSubject:subject];
        [controller setMessageBody:messageBody isHTML:NO];
        
        [controller addAttachmentData:UIImageJPEGRepresentation(viewImage, 1.0) mimeType:@"image/jpeg" fileName:@"film"];
        
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark - Mail

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - GameDelegate

- (CGRect)loadIndex:(NSInteger)index animated:(Boolean)animated {
    //Scroll
    [self.scrollView setContentOffset:CGPointMake(index * self.scrollView.frame.size.width, 0) animated:animated];
    
    //Load data
    return [self loadCurrentMedia];
}

- (void)nextPoster {
    //Update index
    m_currentMediaIndex = [self.pack getNextPosterIndexWithCurrentIndex:m_currentMediaIndex andReplay:self.replay];
    
    //Load poster
    [self loadIndex:m_currentMediaIndex animated:YES];
    
    [HUD hide:YES];
    
    //Enable user interaction
    [self.view setUserInteractionEnabled:YES];
}

- (void)onMediaFound:(Media *)media {
    //Unblur
    MediaView * mediaView = [m_posterViews objectAtIndex:m_currentMediaIndex];
    [mediaView complete];
    
    //Zoom on media
    [self zoomPoster:YES];
    
    //Disable zoom
    [m_tapGestureRecognizer setEnabled:NO];
    [m_swipeUpGestureRecognizer setEnabled:NO];
    [m_swipeDownGestureRecognizer setEnabled:NO];
    
    //Check pack finished
    [self.pack refreshCompleted];
    
    Boolean packCompleted = self.replay ? [self.pack isReplayCompleted] : self.pack.isCompleted;

    //If pack is completed
    if (packCompleted) {
        //Check level completed
        [self.level refreshCompleted];
        
        //If no replay and level just finished
        if (!self.replay && self.level.isCompleted) {
            //Play sound
            [self playSoundWithFileName:@"finish"];
            
            //Popup
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"STR_LEVEL_FINISHED_TITLE", nil, QUIZZ_APP_STRING_BUNDLE, nil) message:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"STR_LEVEL_FINISHED_MESSAGE", nil, QUIZZ_APP_STRING_BUNDLE, nil), self.pack.possiblePoints] delegate:self cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"STR_OK", nil, QUIZZ_APP_STRING_BUNDLE, nil) otherButtonTitles:NSLocalizedStringFromTableInBundle(@"STR_BACK_TO_LEVELS", nil, QUIZZ_APP_STRING_BUNDLE, nil), nil];
            [alertView setTag:QUIZZ_APP_END_LEVEL_ALERT_VIEW];
            [alertView show];
        } else {
            //Play sound
            [self playSoundWithFileName:@"success"];
            
            //Popup
            NSString * message = nil;
            if (self.replay) {
                message = NSLocalizedStringFromTableInBundle(@"STR_REPLAY_PACK_FINISHED_MESSAGE", nil, QUIZZ_APP_STRING_BUNDLE, nil);
            } else {
                message = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"STR_PACK_FINISHED_MESSAGE", nil, QUIZZ_APP_STRING_BUNDLE, nil), self.pack.possiblePoints];
            }
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"STR_PACK_FINISHED_TITLE", nil, QUIZZ_APP_STRING_BUNDLE, nil) message:message delegate:self cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"STR_OK", nil, QUIZZ_APP_STRING_BUNDLE, nil) otherButtonTitles:NSLocalizedStringFromTableInBundle(@"STR_BACK_TO_PACKS", nil, QUIZZ_APP_STRING_BUNDLE, nil), nil];
            [alertView setTag:QUIZZ_APP_END_PACK_ALERT_VIEW];
            [alertView show];
        }
    } else {
        //Play sound
        [self playSoundWithFileName:@"success"];

        //Show message
        HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:HUD];
        HUD.customView = [[UIImageView alloc] initWithImage:[UtilsImage imageNamed:@"media_success" bundle:QUIZZ_APP_IMAGE_LOCALIZED_BUNDLE]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.delegate = self;
        [HUD show:YES];
        
        //Disable user interaction
        [self.view setUserInteractionEnabled:NO];
        
        //Else go to next uncompleted media
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, QUIZZ_APP_MEDIA_FOUND_DURATION * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self nextPoster];
        });
    }
}

- (void)onGoodWord:(NSString *)word {
    //Play sound
//    [self playSoundWithFileName:@"good"];
}

- (void)onBadWord {
    //Play sound
    [self playSoundWithFileName:@"wrong"];
}

- (void)onLetterPressed:(Boolean)back {
    if (back) {
        [self playSoundWithFileName:@"undo"];
    } else {
        [self playSoundWithFileName:@"pop"];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:m_gameAnswerView.keyboardView];
    if ([m_gameAnswerView.keyboardView pointInside:point withEvent:nil]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (alertView.tag == QUIZZ_APP_END_PACK_ALERT_VIEW) {
            [self.navigationController popViewControllerAnimated:YES];
        } else if (alertView.tag == QUIZZ_APP_END_LEVEL_ALERT_VIEW) {
            //Back to levels
            for (UIViewController * viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass:[LevelsViewController class]]) {
                    [self.navigationController popToViewController:viewController animated:YES];
                    return;
                }
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - MBProgressHUD

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

#pragma mark - iAd

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
}

- (void)bannerViewWillLoadAd:(ADBannerView *)banner {
    
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    
}

- (void)initAd {
    NSString * imageName = ExtensionName(@"ad_background");
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UtilsImage imageNamed:imageName bundle:QUIZZ_APP_IMAGE_LOCALIZED_BUNDLE]];
    [imageView setFrame:self.adView.frame];
    [self.view addSubview:imageView];
    
    [self.view bringSubviewToFront:self.adView];
    
//    [self.adView setBackgroundColor:[UIColor colorWithPatternImage:[UtilsImage imageNamed:imageName bundle:QUIZZ_APP_STRING_BUNDLE]]];
    
#if !(TARGET_IPHONE_SIMULATOR)
    m_bannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 0, self.adView.frame.size.width, self.adView.frame.size.height)];
    [m_bannerView setDelegate:self];
    //Optional to set background color to clear color
    [m_bannerView setBackgroundColor:[UIColor clearColor]];
    [self.adView addSubview:m_bannerView];
#endif
}

#pragma mark - Help

- (void)showHelp {
    NSString * nibName = ExtensionName(@"HelpViewController");    
    
    HelpViewController * helpViewController = [[HelpViewController alloc] initWithNibName:nibName bundle:QUIZZ_APP_XIB_BUNDLE];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:helpViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - UI

- (void)initializeScrollView {
    NSInteger nbMedias = [self.pack.medias count];
    int baseWidth = self.gameView.frame.size.width;
    int baseHeight = self.gameView.frame.size.height;
    
//    [self.scrollView setBackgroundColor:[UIColor redColor]];
    
    CGRect scrollViewFrame = CGRectMake(0, 0, baseWidth, baseHeight);
    [self.scrollView setFrame:scrollViewFrame];
    [self.scrollView setContentSize:CGSizeMake(baseWidth * nbMedias, baseHeight)];
    [self.scrollView setDelegate:self];
    
    for (int i = 0; i < nbMedias; i++) {
        Media * media = [self.pack.medias objectAtIndex:i];

        int width = baseWidth;
        int answerViewHeight = [m_gameAnswerView getAnswerHeightWithAnswer:media.title andWidth:scrollViewFrame.size.width];
        int height = baseHeight - answerViewHeight;
        
        MediaView * mediaView = [[MediaView alloc] initWithFrame:CGRectMake(i*width, 0, width, height) andMedia:media andLevelId:self.level.identifier andReplay:self.replay];
//        [mediaView setBackgroundColor:[UIColor colorWithRed:(rand()%255)/255.0 green:(rand()%255)/255.0 blue:(rand()%255)/255.0 alpha:1.0]];
        
        [self.scrollView addSubview:mediaView];
        [m_posterViews addObject:mediaView];
    }
}

- (void)threadInitView {
//    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    //Game delegate
    GameManager * gameManager = [QuizzApp sharedInstance].gameManager;
    [gameManager setDelegate:self];
    
    //Tap
    m_tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onGameViewTapped:)];
    [m_tapGestureRecognizer setDelegate:self];
    [m_tapGestureRecognizer setCancelsTouchesInView:NO];
    [m_tapGestureRecognizer setDelaysTouchesBegan:NO];
    [m_tapGestureRecognizer setDelaysTouchesEnded:NO];
    [m_tapGestureRecognizer setNumberOfTapsRequired:1];
    [self.gameView addGestureRecognizer:m_tapGestureRecognizer];
    
    //Answer view
    m_gameAnswerView = [[GameAnswerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0) andGameManager:gameManager];
    [self.gameView addSubview:m_gameAnswerView];
    
    //Up
    m_swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showAnswerView)];
    [m_swipeUpGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:m_swipeUpGestureRecognizer];
    
    //Down
    m_swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(zoomPoster)];
    [m_swipeDownGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:m_swipeDownGestureRecognizer];
    
    //Scroll view
    [self initializeScrollView];

    CGRect frame = CGRectZero;
    if ([self.pack.medias count] > 0) {
        //Get last uncompleted index
        m_currentMediaIndex = [self.pack getLastCompleteIndex:self.replay];
        
        //And load related media
        frame = [self loadIndex:m_currentMediaIndex animated:YES];
    }

    //Start poster
    [self zoomPoster:NO];
    
    //Update answer view frame
    [m_gameAnswerView setFrame:frame];
    [m_gameAnswerView setHidden:NO];
    
//    [pool release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!m_ready) {
        //Init view
        [self threadInitView];
    
        //Ad
        [self initAd];
        
        m_ready = YES;
    }
    
    if (!self.pack.isCompleted && [HelpViewController doesNeedHelp]) {
        [self showHelp];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setScreenName:@"Game screen"];
    
    [self updateTitle];
    [m_gameAnswerView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
