//
//  GameAnswerView.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 18/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Media.h"

@interface GameAnswerView : UIView {
    //UI
    NSMutableArray * m_letterLabels;
    NSMutableDictionary * m_letterButtons;
    
    //Answer
    NSInteger m_nbAnswerRows;
    int m_nbLettersInAnswerRow;
    
    //Keyboard
    int m_nbKeyboardRows;
    int m_nbLettersInKeyboardRow;
    
    UIView * m_answerView;
    UIView * m_keyboardView;
}

@property (nonatomic, retain) UIView * answerView;

@property (nonatomic, retain) UIView * keyboardView;

- (CGRect)initializeWithMedia:(Media *)media andPackId:(int)packId andParentView:(UIView *)parentView andReset:(Boolean)reset andReplay:(Boolean)replay;

- (CGRect)onMediaChangedWithMedia:(Media *)media andPackId:(int)packId andReset:(Boolean)reset andReplay:(Boolean)replay;

- (IBAction)onLetterPressed:(id)sender;

- (IBAction)onDelete:(id)sender;

- (IBAction)onShuffle:(id)sender;

- (IBAction)onHelp:(id)sender;

- (int)getAnswerHeightWithAnswer:(NSString *)answer andWidth:(float)width;

@end
