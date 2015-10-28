//
//  QAViewController.m
//  QuizzApp
//
//  Created by Baptiste LE GUELVOUIT on 10/26/2015.
//  Copyright (c) 2015 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "QAViewController.h"

#import <QuizzApp/QuizzApp.h>

@interface QAViewController ()

@end

@implementation QAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[QuizzApp instance] setThirdColor:[UIColor redColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
