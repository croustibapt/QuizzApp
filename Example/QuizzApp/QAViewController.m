//
//  QAViewController.m
//  QuizzApp
//
//  Created by Baptiste LE GUELVOUIT on 10/26/2015.
//  Copyright (c) 2015 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "QAViewController.h"

#import <QuizzApp/QuizzApp.h>
#import <QuizzApp/HomeViewController.h>
#import <QuizzApp/Constants.h>

@interface QAViewController ()

@end

@implementation QAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[QuizzApp instance] setThirdColor:[UIColor redColor]];
    
//    NSString * nibName = ExtensionName(@"HomeViewController");
//    NSBundle * bundle = QUIZZ_APP_BUNDLE;
    
    HomeViewController * hvc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:QUIZZ_APP_XIB_BUNDLE];
    [self.navigationController pushViewController:hvc animated:YES];
}

- (IBAction)onButtonPushed:(id)sender {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
