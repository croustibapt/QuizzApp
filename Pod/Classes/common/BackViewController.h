//
//  BackViewController.h
//  quizzapp
//
//  Created by dev_iphone on 12/06/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/Analytics.h>

@interface BackViewController : GAITrackedViewController

@property (nonatomic, retain) IBOutlet UIImageView * headerLeftImageView;

@property (nonatomic, retain) IBOutlet UIImageView * headerRightImageView;

@property (nonatomic, retain) IBOutlet UIImageView * footerLeftImageView;

@property (nonatomic, retain) IBOutlet UIImageView * footerRightImageView;

@end
