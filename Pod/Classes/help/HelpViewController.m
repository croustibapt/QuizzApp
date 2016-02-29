 //
//  HelpViewController.m
//  moviequizz2
//
//  Created by dev_iphone on 09/04/14.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "HelpViewController.h"


#import "Constants.h"
#import "QuizzApp.h"
#import "BackView.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

+ (OnboardingContentViewController *)createPage:(int)index {
    NSString * imageName = [NSString stringWithFormat:@"help%d", index];
    NSString * labelName = [NSString stringWithFormat:@"STR_HELP_LABEL%d", index];
    
    UIImage * image = [UIImage imageNamed:imageName];
    NSString * body = [NSLocalizedStringFromTableInBundle(labelName, nil, QUIZZ_APP_STRING_BUNDLE, nil) uppercaseString];
    
    OnboardingContentViewController * page = [OnboardingContentViewController contentWithTitle:nil body:body image:image buttonText:nil action:nil];
    page.iconHeight = 200;
    
    page.bodyTextColor = [QuizzApp sharedInstance].oppositeThirdColor;
    page.buttonFontName = @"RobotoCondensed-Bold";
    
    return page;
}

+ (NSArray *)getPages {
    OnboardingContentViewController * firstPage = [HelpViewController createPage:1];
    OnboardingContentViewController * secondPage = [HelpViewController createPage:2];
    OnboardingContentViewController * thirdPage = [HelpViewController createPage:3];
    
    return @[firstPage, secondPage, thirdPage];
}

- (instancetype)initWithContentFrame:(CGRect)contentFrame {
    UIImage * backViewImage = [BackView backViewImage:contentFrame];
    NSArray * contents = [HelpViewController getPages];
    
    self = [super initWithBackgroundImage:backViewImage contents:contents];
    if (self) {
        self.topPadding = 16;
        self.underIconPadding = 16;
        self.underTitlePadding = 0;
        self.shouldFadeTransitions = YES;
        self.fadePageControlOnLastPage = YES;
        self.fadeSkipButtonOnLastPage = YES;
        
        // If you want to allow skipping the onboarding process, enable skipping and set a block to be executed
        // when the user hits the skip button.
        self.allowSkipping = YES;
        self.skipHandler = ^{
//            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return self;
}

#pragma mark - Prefs

+ (void)noMoreHelp {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:NO forKey:QUIZZ_APP_NEED_HELP_KEY];
    [prefs synchronize];
}

+ (Boolean)doesNeedHelp {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    Boolean needHelp = [prefs boolForKey:QUIZZ_APP_NEED_HELP_KEY];
    return needHelp;
}

#pragma mark - UI

- (void)dismiss {
    //No more help needed
    [HelpViewController noMoreHelp];

    //Dimiss
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:NSLocalizedStringFromTableInBundle(@"STR_HELP_TITLE", nil, QUIZZ_APP_STRING_BUNDLE, nil)];
}

@end
