//
//  HelpViewController.h
//  moviequizz2
//
//  Created by dev_iphone on 09/04/14.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/Analytics.h>

@interface HelpViewController : GAITrackedViewController <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView * helpScrollView;

@property (nonatomic, strong) IBOutlet UIPageControl * pageControl;

+ (Boolean)doesNeedHelp;

@end
