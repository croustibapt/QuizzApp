//
//  HelpViewController.h
//  moviequizz2
//
//  Created by dev_iphone on 09/04/14.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface HelpViewController : UIViewController <UIScrollViewDelegate>
{
    UIScrollView * _helpScrollView;
    UIPageControl * _pageControl;
}


@property (nonatomic, retain) IBOutlet UIScrollView * helpScrollView;


@property (nonatomic, retain) IBOutlet UIPageControl * pageControl;


#pragma mark - Cocoa


- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
                pages:(NSArray *)pages;


#pragma mark - Public


+ (Boolean)doesNeedHelp;


+ (void)showHelpWithNibName:(NSString *)nibName viewController:(UIViewController *)viewController;


@end
