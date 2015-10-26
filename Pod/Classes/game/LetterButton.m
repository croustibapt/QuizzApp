//
//  LetterButton.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 18/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "LetterButton.h"

#import <QuartzCore/QuartzCore.h>

#import "UtilsImage.h"
#import "GameAnswerView.h"
#import "Utils.h"
#import "Constants.h"

@implementation LetterButton

@synthesize key = m_key;
@synthesize gameAnswerView;
@synthesize touched;

- (id)initWithFrame:(CGRect)frame andKey:(NSString *)aKey andGameAnswerView:(GameAnswerView *)aGameAnswerView {
    m_startFrame = CGRectMake(frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2, 0, 0);
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setKey:aKey];
        [self setGameAnswerView:aGameAnswerView];
        
        [self setBackgroundImage:[UtilsImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self setBackgroundImage:[UtilsImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        
        [self.layer setCornerRadius:2.0];
        [self setClipsToBounds:YES];
//        [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//        [self.layer setBorderWidth:1.0];

        m_destinationFrame = frame;
        
//        m_label = [[UILabel alloc] initWithFrame:m_originFrame];
//        [m_label setTextColor:[UIColor blackColor]];
//        [m_label setUserInteractionEnabled:NO];
//        
//        // Initialization code
//        [m_label setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
//        [m_label setTextAlignment:NSTextAlignmentCenter];
//        [m_label setFont:[UIFont fontWithName:@"Roboto-Black" size:26.0]];

//        [self.titleLabel setFrame:m_originFrame];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        float font = PixelsSize(26.0);
        [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Black" size:font]];
        
        [self addTarget:self action:@selector(onTouchUpDown:) forControlEvents:UIControlEventTouchDown];
        
//        [self showLetter];
    }
    return self;
}

- (void)showLetter:(NSString *)letter {
    [self setTitle:letter forState:UIControlStateNormal];
    [self setHidden:NO];
    
    [self setFrame:m_startFrame];
    [self.titleLabel setAlpha:0.0];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:QUIZZ_APP_LETTER_BUTTON_ANIMATION_DURATION];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [self setFrame:m_destinationFrame];
    [self.titleLabel setAlpha:1.0];
    
    [UIView commitAnimations];
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

#pragma mark - IBAction

- (IBAction)onTouchUpDown:(id)sender {
    [self.gameAnswerView onLetterPressed:sender];
}

@end
