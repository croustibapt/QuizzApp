//
//  HelpViewController.h
//  moviequizz2
//
//  Created by dev_iphone on 09/04/14.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Onboard/OnboardingViewController.h>

@interface HelpViewController : OnboardingViewController

- (instancetype)initWithContentFrame:(CGRect)contentFrame;

+ (Boolean)doesNeedHelp;

@end
