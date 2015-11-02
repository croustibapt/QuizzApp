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

- (void)addHeader {
    NSString * headerLeftImageName = ExtensionName(@"header_left");
    NSString * headerRightImageName = ExtensionName(@"header_right");
    
    [self.headerLeftImageView setImage:[UtilsImage imageNamed:headerLeftImageName]];
    [self.headerRightImageView setImage:[UtilsImage imageNamed:headerRightImageName]];
}

- (void)addFooter {
    NSString * footerLeftImageName = ExtensionName(@"footer_left");
    NSString * footerRightImageName = ExtensionName(@"footer_right");
    
    [self.footerLeftImageView setImage:[UtilsImage imageNamed:footerLeftImageName]];
    [self.footerRightImageView setImage:[UtilsImage imageNamed:footerRightImageName]];
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Header
    [self addHeader];
    
    //Footer
    [self addFooter];
}

@end
