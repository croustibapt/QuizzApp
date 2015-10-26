//
//  LetterLabel.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 19/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "LetterLabel.h"

#import "UtilsColors.h"
#import "UtilsString.h"
#import "Utils.h"
#import "Constants.h"
#import "QuizzApp.h"

@implementation LetterLabel

@synthesize goodString;
@synthesize goodLetter = m_goodLetter;
@synthesize found = m_found;
@synthesize bad = m_bad;

- (id)initWithFrame:(CGRect)frame andGoodLetter:(NSString *)aGoodLetter {
    self = [super initWithFrame:frame];
    if (self) {
        [self setGoodLetter:aGoodLetter];
        [self setGoodString:[UtilsString goodString:aGoodLetter]];
        
        [self setTextColor:[UIColor whiteColor]];

        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (!goodString || [aGoodLetter isEqualToString:@" "]) {
    //            [self setBackgroundColor:[QuizzApp instance].oppositeSecondColor];
                [self setBackgroundColor:[UIColor clearColor]];
                [self setText:aGoodLetter];
            } else {
                [self setText:@""];
                [self setBackgroundColor:[QuizzApp instance].oppositeThirdColor];
            }
        });
        
        // Initialization code
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self setTextAlignment:NSTextAlignmentCenter];
        
        float font = PixelsSize(16.0);
        [self setFont:[UIFont fontWithName:@"Roboto-Black" size:font]];
    }
    return self;
}

- (void)setFound:(Boolean)found {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        m_found = found;
        
        if (m_found) {
            [self setText:self.goodLetter];
            [self setBackgroundColor:QUIZZ_APP_GREEN_MAIN_COLOR];
        } else {
            [self setBackgroundColor:[QuizzApp instance].oppositeThirdColor];
        }
    });
}

- (void)setBad:(Boolean)bad {
    m_bad = bad;
    
    if (m_bad) {
        [self setBackgroundColor:QUIZZ_APP_RED_MAIN_COLOR];
    } else {
        [self setBackgroundColor:[QuizzApp instance].oppositeThirdColor];
    }
}

- (void)type:(NSString *)letter {
    [self setText:letter];
}

- (void)highlight {
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    [animation setFromValue:[NSNumber numberWithFloat:1.0]];
    [animation setToValue:[NSNumber numberWithFloat:0.0]];
    [animation setDuration:QUIZZ_APP_LETTER_BUTTON_ANIMATION_DURATION];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:3];
    
    [[self layer] addAnimation:animation forKey:@"opacity"];
}

@end
