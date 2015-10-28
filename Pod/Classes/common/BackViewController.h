//
//  BackViewController.h
//  quizzapp
//
//  Created by dev_iphone on 12/06/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/Analytics.h>

@interface BackViewController : GAITrackedViewController {
    UIImageView * m_headerLeftImageView;
    UIImageView * m_headerRightImageView;
    UIImageView * m_footerLeftImageView;
    UIImageView * m_footerRightImageView;
}

@property (nonatomic, retain) IBOutlet UIImageView * headerLeftImageView;

@property (nonatomic, retain) IBOutlet UIImageView * headerRightImageView;

@property (nonatomic, retain) IBOutlet UIImageView * footerLeftImageView;

@property (nonatomic, retain) IBOutlet UIImageView * footerRightImageView;

@end
