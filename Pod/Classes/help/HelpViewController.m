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


@implementation HelpViewController


+ (OnboardingContentViewController *)createPage:(int)index buttonText:(NSString *)buttonText action:(dispatch_block_t)action
{
    NSString * imageName = [NSString stringWithFormat:@"help%d", index];
    NSString * labelName = [NSString stringWithFormat:@"STR_HELP_LABEL%d", index];
    
    UIImage * image = [UIImage imageNamed:imageName];
    NSString * body = [QALocalizedString(labelName) uppercaseString];
    
    OnboardingContentViewController * page = [OnboardingContentViewController contentWithTitle:body
                                                                                          body:nil
                                                                                         image:image
                                                                                    buttonText:buttonText
                                                                                        action:action];
    page.iconHeight = 50;
    
    page.titleTextColor = [QuizzApp sharedInstance].oppositeThirdColor;
    page.titleFontName = @"RobotoCondensed-Bold";
    
    return page;
}


+ (NSArray *)getPages
{
    OnboardingContentViewController * firstPage = [HelpViewController createPage:1
                                                                      buttonText:nil
                                                                          action:nil];
    
    OnboardingContentViewController * secondPage = [HelpViewController createPage:2
                                                                       buttonText:nil
                                                                           action:nil];
    
    OnboardingContentViewController * thirdPage = [HelpViewController createPage:3
                                                                      buttonText:@"OK"
                                                                          action:
     ^(void)
    {
//        [self dismiss];
    }];
    
    return @[ firstPage, secondPage, thirdPage ];
}


- (instancetype)initWithContentFrame:(CGRect)contentFrame
{
    UIImage * backViewImage = [BackView backViewImage:contentFrame];
    NSArray * contents = [HelpViewController getPages];
    
    self = [super initWithBackgroundImage:backViewImage contents:contents];
    if (self)
    {
        self.topPadding = 8;
        self.underIconPadding = 8;
        self.underTitlePadding = 8;
        self.shouldFadeTransitions = YES;
        self.fadePageControlOnLastPage = YES;
        self.fadeSkipButtonOnLastPage = YES;
        
        // If you want to allow skipping the onboarding process, enable skipping and set a block to be executed
        // when the user hits the skip button.
        self.allowSkipping = YES;
        self.skipHandler = ^(void) {
            [self dismiss];
        };
    }
    return self;
}


#pragma mark - Prefs


+ (void)noMoreHelp
{
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:NO forKey:QUIZZ_APP_NEED_HELP_KEY];
    [prefs synchronize];
}


+ (Boolean)doesNeedHelp
{
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    Boolean needHelp = [prefs boolForKey:QUIZZ_APP_NEED_HELP_KEY];
    return needHelp;
}


#pragma mark - UI


- (void)dismiss
{
    //No more help needed
    [HelpViewController noMoreHelp];

    //Dimiss
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:QALocalizedString(@"STR_HELP_TITLE")];
}


@end
