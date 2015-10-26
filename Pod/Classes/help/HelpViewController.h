//
//  HelpViewController.h
//  moviequizz2
//
//  Created by dev_iphone on 09/04/14.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAITrackedViewController.h"

@interface HelpViewController : GAITrackedViewController <UIScrollViewDelegate> {
    UIScrollView * m_helpScrollView;
    UIPageControl * m_pageControl;
}

@property (nonatomic, retain) IBOutlet UIScrollView * helpScrollView;

@property (nonatomic, retain) IBOutlet UIPageControl * pageControl;

+ (Boolean)doesNeedHelp;

@end
