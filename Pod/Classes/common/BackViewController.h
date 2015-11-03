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

@property (nonatomic, strong) IBOutlet UIImageView * headerLeftImageView;

@property (nonatomic, strong) IBOutlet UIImageView * headerRightImageView;

@property (nonatomic, strong) IBOutlet UIImageView * footerLeftImageView;

@property (nonatomic, strong) IBOutlet UIImageView * footerRightImageView;

@end
