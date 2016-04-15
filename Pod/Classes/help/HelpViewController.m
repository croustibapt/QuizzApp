//
//  HelpViewController.m
//  moviequizz2
//
//  Created by dev_iphone on 09/04/14.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "HelpViewController.h"

#import "UtilsImage.h"
#import "Constants.h"
#import "UtilsColors.h"
#import "QuizzApp.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

@synthesize helpScrollView = _helpScrollView;
@synthesize pageControl = _pageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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

#pragma mark - UIScrollView

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int pageIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    [_pageControl setCurrentPage:pageIndex];
}

#pragma mark - UI

- (void)dismiss {
    //No more help needed
    [HelpViewController noMoreHelp];
    
    //Dimiss
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //Labels
    float labelFontSize = PixelsSize(25.0);
    
    if (!IS_IPHONE_5 && !IS_IOS_7) {
        labelFontSize = PixelsSize(20.0);
    }
    
    float scrollViewWidth = (self.view.frame.size.width * 3);
    UIView * helpContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollViewWidth, self.view.frame.size.height)];
    
    float labelHeight = helpContentView.frame.size.height / 6.0;
    float imageHeight = helpContentView.frame.size.height - labelHeight;
    
    for (int i = 0; i < 3; i++) {
        float labelX = (i * self.view.frame.size.width) + 5;
        
        //Label
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 0, self.view.frame.size.width - (2 * 5), labelHeight)];
        [label setFont:[UIFont fontWithName:@"RobotoCondensed-Bold" size:labelFontSize]];
        [label setNumberOfLines:0];
        [label setAdjustsFontSizeToFitWidth:YES];
        [label setMinimumFontSize:10.0];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        
        NSString * labelName = [NSString stringWithFormat:@"STR_HELP_LABEL%d", (i + 1)];
        [label setText:[QALocalizedString(labelName) uppercaseString]];
        
        [label setTextColor:[QuizzApp sharedInstance].oppositeThirdColor];
        [helpContentView addSubview:label];
        
        //Image
        float imageX = (i * self.view.frame.size.width);
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, labelHeight, self.view.frame.size.width, imageHeight)];
        
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setClipsToBounds:YES];
        
        NSString * imageName = ExtensionName([NSString stringWithFormat:@"help%d", (i + 1)]);
        [imageView setImage:[UtilsImage imageNamed:imageName]];
        [helpContentView addSubview:imageView];
    }
    
    //Scroll view
    [_helpScrollView setContentSize:CGSizeMake(scrollViewWidth, self.view.frame.size.height)];
    [_helpScrollView addSubview:helpContentView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:QALocalizedString(@"STR_HELP_TITLE")];
    
    //Page control
    [_pageControl setCurrentPage:0];
    
    //
    
    UIBarButtonItem * doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
    [self.navigationItem setRightBarButtonItem:doneItem];
}


@end
