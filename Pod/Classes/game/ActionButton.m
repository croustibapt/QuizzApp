
//
//  ActionButton.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 24/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "ActionButton.h"

#import "UtilsImage.h"
#import "GameAnswerView.h"
#import "Utils.h"
#import "Constants.h"

@implementation ActionButton

@synthesize action;
@synthesize gameAnswerView;

- (id)initWithFrame:(CGRect)frame andAction:(EQuizzAppAction)aAction andGameAnswerView:(GameAnswerView *)aGameAnswerView; {
    self = [super initWithFrame:frame];
    if (self) {
        [self setAction:aAction];
        [self setGameAnswerView:aGameAnswerView];
        
        NSBundle * bundle = QUIZZ_APP_BUNDLE;

        if (self.action == QuizzAppActionDelete) {
            NSString * deleteNameOff = ExtensionName(@"btn_delete_off");
            NSString * deleteNameOn = ExtensionName(@"btn_delete_on");
            
            [self setBackgroundImage:[UtilsImage imageNamed:deleteNameOff bundle:bundle] forState:UIControlStateNormal];
            [self setBackgroundImage:[UtilsImage imageNamed:deleteNameOn bundle:bundle] forState:UIControlStateHighlighted];
        } else if (self.action == QuizzAppActionDelete) {
            NSString * shuffleNameOff = ExtensionName(@"btn_shuffle_off");
            NSString * shuffleNameOn = ExtensionName(@"btn_shuffle_on");
            
            [self setBackgroundImage:[UtilsImage imageNamed:shuffleNameOff bundle:bundle] forState:UIControlStateNormal];
            [self setBackgroundImage:[UtilsImage imageNamed:shuffleNameOn bundle:bundle] forState:UIControlStateHighlighted];
        } else if (self.action == QuizzAppActionHelp) {
            NSString * shuffleNameOff = ExtensionName(@"btn_help_off");
            NSString * shuffleNameOn = ExtensionName(@"btn_help_on");
            
            [self setBackgroundImage:[UtilsImage imageNamed:shuffleNameOff bundle:bundle] forState:UIControlStateNormal];
            [self setBackgroundImage:[UtilsImage imageNamed:shuffleNameOn bundle:bundle] forState:UIControlStateHighlighted];
        }
        
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
        
        [self.layer setCornerRadius:2.0];
        [self setClipsToBounds:YES];
        
        [self addTarget:self action:@selector(onTouchUpDown:) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}

- (IBAction)onTouchUpDown:(id)sender {
    if (self.action == QuizzAppActionDelete) {
        [self.gameAnswerView onDelete:sender];
    } else if (self.action == QuizzAppActionShuffle) {
        [self.gameAnswerView onShuffle:sender];
    } else if (self.action == QuizzAppActionHelp) {
        [self.gameAnswerView onHelp:sender];
    }
}

@end
