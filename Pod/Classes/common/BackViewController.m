//
//  BackViewController.m
//  quizzapp
//
//  Created by dev_iphone on 12/06/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "BackViewController.h"

#import "Utils.h"
#import "UtilsImage.h"

@interface BackViewController ()

@end

@implementation BackViewController

@synthesize headerLeftImageView = m_headerLeftImageView;
@synthesize headerRightImageView = m_headerRightImageView;
@synthesize footerLeftImageView = m_footerLeftImageView;
@synthesize footerRightImageView = m_footerRightImageView;

- (void)addHeader {
    NSString * headerLeftImageName = ExtensionName(@"header_left");
    NSString * headerRightImageName = ExtensionName(@"header_right");
    
    [m_headerLeftImageView setImage:[UtilsImage imageNamed:headerLeftImageName]];
    [m_headerRightImageView setImage:[UtilsImage imageNamed:headerRightImageName]];
}

- (void)addFooter {
    NSString * footerLeftImageName = ExtensionName(@"footer_left");
    NSString * footerRightImageName = ExtensionName(@"footer_right");
    
    [m_footerLeftImageView setImage:[UtilsImage imageNamed:footerLeftImageName]];
    [m_footerRightImageView setImage:[UtilsImage imageNamed:footerRightImageName]];
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Header
    [self addHeader];
    
    //Footer
    [self addFooter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
