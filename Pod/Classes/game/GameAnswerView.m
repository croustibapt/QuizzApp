//
//  GameAnswerView.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 18/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "GameAnswerView.h"

#define ANSWER_ELEMENT_SIZE (REAL_QUIZZ_APP_ANSWER_SIZE + REAL_QUIZZ_APP_ANSWER_PADDING)
#define KEYBOARD_ELEMENT_SIZE (REAL_QUIZZ_APP_LETTER_SIZE + REAL_QUIZZ_APP_LETTER_PADDING)

#import "LetterButton.h"
#import "ActionButton.h"
#import "LetterLabel.h"
#import "UtilsColors.h"
#import "UtilsString.h"
#import "GameManager.h"
#import "Constants.h"
#import "QuizzApp.h"

@implementation GameAnswerView

@synthesize answerView = m_answerView;
@synthesize keyboardView = m_keyboardView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        m_letterButtons = [[NSMutableDictionary alloc] init];
        m_letterLabels = [[NSMutableArray alloc] init];
        
//        [self setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin/*|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth*/)];
        
        [self setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth)];
    }
    return self;
}

- (NSArray *)getLinesWithAnswer:(NSString *)answer andNbLettersInRow:(int)nbLettersInRow {
//    NSDate * startDate = [NSDate date];
    
    NSArray * allWords = [answer componentsSeparatedByString:@" "];
    
    NSMutableArray * lines = [NSMutableArray array];
    NSMutableArray * line = [NSMutableArray array];
    
    NSInteger currentLineLetterIndex = 0;
    
    for (NSString * word in allWords) {
        NSInteger wordLength = word.length;

        NSString * currentWord = word;
        if (![currentWord isEqual:[allWords lastObject]]) {
            if (!((currentLineLetterIndex + wordLength) == nbLettersInRow)) {
                currentWord = [currentWord stringByAppendingString:@" "];
                wordLength++;
            }
        }
        
        if ((currentLineLetterIndex + wordLength) > nbLettersInRow) {
            if (wordLength >= nbLettersInRow) {
                NSInteger leftLength = (nbLettersInRow - currentLineLetterIndex) - 1;
                
                //Get prefix
                NSString * prefix = [currentWord substringToIndex:leftLength];
                prefix = [prefix stringByAppendingString:@"\u21B5"];
                wordLength++;
                
                //Add prefix
                [line addObject:prefix];
                
                //Add current line
                [lines addObject:line];
                
                //And reset it
                line = [NSMutableArray array];
                
                //Get suffix
                NSString * suffix = [currentWord substringFromIndex:leftLength];
                NSInteger nbLinesForSuffix = ceil((float)suffix.length / (float)nbLettersInRow);
                
                //Loop on each line
                for (int i = 0; i < nbLinesForSuffix; i++) {
                    //Get current word
                    NSInteger lineWordLength = MIN(nbLettersInRow, suffix.length);
                    NSString * lineWord = [suffix substringWithRange:NSMakeRange(0, lineWordLength)];
                    
                    //Add line word
                    [line addObject:lineWord];
                    
                    //Check line word length
                    if (lineWordLength == nbLettersInRow) {
                        //Add current line
                        [lines addObject:line];
                        
                        //And reset it
                        line = [NSMutableArray array];
                        
                        //Reset line letter index
                        currentLineLetterIndex = 0;
                    } else {
                        //Increment current line letter index
                        currentLineLetterIndex = suffix.length;
                    }
                    
                    //Update suffix
                    suffix = lineWord;
                }
            } else {
                //Add current line
                [lines addObject:line];
                
                //And reset it
                line = [NSMutableArray array];
                
                //Add word
                [line addObject:currentWord];
                
                //Reset line letter index
                currentLineLetterIndex = wordLength;
            }
        } else {
            [line addObject:currentWord];
        
            //Increment current line letter index
            currentLineLetterIndex += wordLength;
        }
    }
    
    //Last line (if needed)
    if ([line count] > 0) {
        [lines addObject:line];
    }
    
//    NSLog(@"get lines in %.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
    
    return lines;
}

- (void)createAnswerLetters:(Media *)media andReplay:(Boolean)replay {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSString * answer = media.title;
        
        //Remove old letters
        [m_letterLabels removeAllObjects];
        for (UIView * view in self.answerView.subviews) {
            //UI Thread
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [view removeFromSuperview];
            });
        }
        
        int answerLettersSpace = (m_nbLettersInAnswerRow * ANSWER_ELEMENT_SIZE) - REAL_QUIZZ_APP_ANSWER_PADDING;
        int startX = (self.frame.size.width - answerLettersSpace)/2;
        
        NSArray * lines = [self getLinesWithAnswer:answer andNbLettersInRow:m_nbLettersInAnswerRow];
        
        int row = 0;
        int col = 0;
        
        for (NSArray * line in lines) {
            for (NSString * word in line) {
                NSInteger wordLength = word.length;
                
                for (int letterIndex = 0; (letterIndex < wordLength); letterIndex++) {
                    NSString * letter = [[NSString stringWithFormat:@"%C", [word characterAtIndex:letterIndex]] uppercaseString];
                    
                    LetterLabel * letterView = [[LetterLabel alloc] initWithFrame:CGRectMake(startX + col * ANSWER_ELEMENT_SIZE, REAL_QUIZZ_APP_ANSWER_PADDING + row * ANSWER_ELEMENT_SIZE, REAL_QUIZZ_APP_ANSWER_SIZE, REAL_QUIZZ_APP_ANSWER_SIZE) andGoodLetter:letter];
                    
                    //If it's a good letter
                    if ([UtilsString goodString:letter]) {
                        [m_letterLabels addObject:letterView];
                        
                        Boolean mediaCompleted = replay ? media.isReplayCompleted : media.isCompleted;
                        if (mediaCompleted) {
                            [letterView setFound:YES];
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        //UI Thread
                        [self.answerView addSubview:letterView];
                    });
                    
                    col++;
                }
            }
            
            row++;
            col = 0;
        }
    });
}

- (int)getNbLettersInAnswerRowWithFrameWidth:(int)width {
    int answerBaseWidth = width - REAL_QUIZZ_APP_ANSWER_PADDING;
    int nbLettersInAnswerRow = floor(answerBaseWidth/ANSWER_ELEMENT_SIZE);
    
    return nbLettersInAnswerRow;
}

- (NSInteger)getNbAnswerRowsWithAnswer:(NSString *)answer andWidth:(float)width {
    int nbLettersInAnswerRows = [self getNbLettersInAnswerRowWithFrameWidth:width];
    
    NSArray * lines = [self getLinesWithAnswer:answer andNbLettersInRow:nbLettersInAnswerRows];
    
    return [lines count];
}

- (int)getAnswerHeightWithAnswer:(NSString *)answer andWidth:(float)width {
    NSInteger nbAnswerRows = [self getNbAnswerRowsWithAnswer:answer andWidth:width];
    int answerViewHeight = nbAnswerRows * ANSWER_ELEMENT_SIZE + REAL_QUIZZ_APP_ANSWER_PADDING;
    
//    NSLog(@"avh (%@): %d", answer, answerViewHeight);
    
    return answerViewHeight;
}

- (void)createAnswerView:(Media *)media andReplay:(Boolean)replay {
    [self.answerView removeFromSuperview];
    
    NSString * answer = media.title;
    
    //Answer
    int width = self.frame.size.width;
    m_nbLettersInAnswerRow = [self getNbLettersInAnswerRowWithFrameWidth:width];
    m_nbAnswerRows = [self getNbAnswerRowsWithAnswer:answer andWidth:width];
    
    int answerViewHeight = [self getAnswerHeightWithAnswer:answer andWidth:width];
    
    //Create view
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, answerViewHeight)];
    [view setBackgroundColor:[QuizzApp instance].oppositeMainColor];
    
    [self setAnswerView:view];
    [self addSubview:self.answerView];
    
    //Create answer letters
    [self createAnswerLetters:media andReplay:replay];
}

- (void)createKeyboardLetters {
    //Remove old buttons
    [m_letterButtons removeAllObjects];
    for (UIView * view in self.keyboardView.subviews) {
        [view removeFromSuperview];
    }
    
    //Get the n first letters
    NSMutableArray * startLetters = [GameManager instance].startLetters;
    
    //Loop for each button
    for (int row = 0; row < m_nbKeyboardRows; row++) {
        int nbCols = (m_nbLettersInKeyboardRow + 1);
        
        for (int column = 0; column < nbCols; column++) {
            //Boolean used to know if it's the last row button
            Boolean lastRowButton = (column == m_nbLettersInKeyboardRow);
            
//            float paddingX = REAL_QUIZZ_APP_LETTER_PADDING;
            float paddingX = MAX(REAL_QUIZZ_APP_LETTER_PADDING, ((self.frame.size.width - 2 * REAL_QUIZZ_APP_LETTER_START_X) - nbCols * REAL_QUIZZ_APP_LETTER_SIZE) / (nbCols - 1));
            float elementSize = (REAL_QUIZZ_APP_LETTER_SIZE + paddingX);
            
            //Create the button frame
            CGRect letterButtonFrame = CGRectMake(REAL_QUIZZ_APP_LETTER_START_X + column * elementSize, REAL_QUIZZ_APP_LETTER_PADDING + row * KEYBOARD_ELEMENT_SIZE, REAL_QUIZZ_APP_LETTER_SIZE, REAL_QUIZZ_APP_LETTER_SIZE);
            
            UIButton * button = nil;
            
            //If it's not the last row button
            if (!lastRowButton) {
                //Create the related key @"row_column"
                NSString * key = [NSString stringWithFormat:@"%d_%d", row, column];
                
                //Finally add the UI button
                if ([m_letterButtons objectForKey:key] == nil) {
                    //Get the current letter to display
                    NSString * letter = [[startLetters objectAtIndex:0] uppercaseString];
                    
                    //Remove from start letters
                    [startLetters removeObjectAtIndex:0];
                    
                    //Create the button
                    button = [[LetterButton alloc] initWithFrame:letterButtonFrame andKey:key andGameAnswerView:self];
                    [button setTitle:letter forState:UIControlStateNormal];
                    
                    [m_letterButtons setObject:button forKey:key];
                }
            } else {
//                letterButtonFrame = CGRectMake(self.frame.size.width - (REAL_QUIZZ_APP_LETTER_SIZE + REAL_QUIZZ_APP_LETTER_START_X), REAL_QUIZZ_APP_LETTER_PADDING + row * KEYBOARD_ELEMENT_SIZE, REAL_QUIZZ_APP_LETTER_SIZE, REAL_QUIZZ_APP_LETTER_SIZE);
                
                //It's an action button
                if (row == 0) {
                    //Delete button
                    button = [[ActionButton alloc] initWithFrame:letterButtonFrame andAction:QuizzAppActionDelete andGameAnswerView:self];
                } else {
                    //Shuffle button
                    button = [[ActionButton alloc] initWithFrame:letterButtonFrame andAction:QuizzAppActionHelp andGameAnswerView:self];
                }
            }
            
            //Finally add the keyboard to its parent view
            if (button != nil) {
                [self.keyboardView addSubview:button];
            }
        }
    }
}

- (void)createKeyboardView {
    //Remove old
    [self.keyboardView removeFromSuperview];
    
    //Compute new height
    int keyboardViewHeight = 4 + m_nbKeyboardRows * KEYBOARD_ELEMENT_SIZE;
    
    //Create keyboard UI
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, self.answerView.frame.size.height, self.frame.size.width, keyboardViewHeight)];
    [view setBackgroundColor:[QuizzApp instance].oppositeSecondColor];
    
    [self setKeyboardView:view];
    [self addSubview:self.keyboardView];
    
    //Reset the keyboard for the current answer
    [self createKeyboardLetters];
}

- (CGRect)initializeWithMedia:(Media *)media andPackId:(int)packId andParentView:(UIView *)parentView andReset:(Boolean)reset andReplay:(Boolean)replay {
    //Constants
    m_nbKeyboardRows = QUIZZ_APP_DEFAULT_KEYBOARD_ROWS;
    int keyboardBaseWidth = parentView.frame.size.width - REAL_QUIZZ_APP_LETTER_START_X;
    
    m_nbLettersInKeyboardRow = floor(keyboardBaseWidth/KEYBOARD_ELEMENT_SIZE) - 1;
    
    //Reset the GameManager
    [[GameManager instance] resetWithMedia:media andPackId:packId andNbRows:m_nbKeyboardRows andNbColumns:m_nbLettersInKeyboardRow];
    
    //Create answer view
    [self createAnswerView:media andReplay:replay];
    
    //Create custom keyboard
    [self createKeyboardView];
    
    //Adjust parent frame
    int height = self.answerView.frame.size.height + self.keyboardView.frame.size.height;
    int y = parentView.frame.size.height - self.answerView.frame.size.height;

//    CGRect oldFrame = self.frame;
//    [self setFrame:CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, height)];
    
    CGRect frame = CGRectMake(0, y, self.frame.size.width, height);
    
    if (reset) {
        [self setFrame:frame];
    }
    
    return frame;
}

#pragma mark - IBAction

- (CGRect)onMediaChangedWithMedia:(Media *)media andPackId:(int)packId andReset:(Boolean)reset andReplay:(Boolean)replay {
    return [self initializeWithMedia:media andPackId:packId andParentView:self.superview andReset:reset andReplay:replay];
}

- (void)revealCurrentWord {
    for (int i = 0; i < [GameManager instance].nbLettersFound; i++) {
        LetterLabel * letterLabel = [m_letterLabels objectAtIndex:i];
        [letterLabel setFound:YES];
    }
}

- (void)showBadAnswer {
    for (int i = 0; i < [GameManager instance].currentWord.length; i++) {
        LetterLabel * letterLabel = [m_letterLabels objectAtIndex:i + [GameManager instance].nbLettersFound];
        [letterLabel setBad:YES];
    }
}

- (void)hideBadAnswer {
    for (int i = 0; i < [GameManager instance].currentAnswer.length; i++) {
        LetterLabel * letterLabel = [m_letterLabels objectAtIndex:i + [GameManager instance].nbLettersFound];
        [letterLabel setBad:NO];
    }
}

- (IBAction)onLetterPressed:(id)sender {
    if ([[GameManager instance] canType]) {
        //Get the corresponding LetterButton
        LetterButton * letterButton = (LetterButton *)sender;
        
        //
        NSString * chosenLetter = letterButton.titleLabel.text;
        NSInteger letterLabelIndex = [[GameManager instance] onLetterPressed:letterButton.key andLetter:chosenLetter];
        
        //Check letter
        if (letterLabelIndex < [m_letterLabels count]) {
            LetterLabel * letterLabel = [m_letterLabels objectAtIndex:letterLabelIndex];
            [letterLabel type:chosenLetter];
            
            NSString * letter = [[GameManager instance] getNextRandomLetter];
            if (letter != nil) {                
                [letterButton showLetter:letter];
            } else {
                [letterButton setHidden:YES];
            }
        }
        
        //Check current word
        EQuizzAppCheckWord checkWord = [[GameManager instance] checkWord];
        if (checkWord == EQuizzAppCheckWordFound) {
            [self revealCurrentWord];
        } else if (checkWord == EQuizzAppCheckWordWrong) {
            [self showBadAnswer];
        }
    }
}

- (IBAction)onDelete:(id)sender {
    if ([[GameManager instance] canDelete]) {
        //Hide bad answer
        [self hideBadAnswer];
        
        NSInteger letterLabelIndex = [[GameManager instance] onDelete];
        
        //Get the last filled label
        LetterLabel * label = [m_letterLabels objectAtIndex:letterLabelIndex];
        NSString * letter = label.text;
        
        //Get the last chosen letter key
        NSString * key = [[GameManager instance] getLastKey];
        
        //Get the related LetterButton
        LetterButton * lastLetterButton = [m_letterButtons objectForKey:key];
        [lastLetterButton showLetter:letter];
        
        //Clear the answer label
        [label setText:@""];
    }
}

- (void)highlightGoodLetters {
    NSString * word = [GameManager instance].currentWord;
    
    for (NSString * key in m_letterButtons) {
        LetterButton * letterButton = [m_letterButtons objectForKey:key];
        NSString * letter = [letterButton.titleLabel.text lowercaseString];
        
        if ([word rangeOfString:letter].location != NSNotFound) {
            [letterButton highlight];
        }
    }
    
    NSInteger start = [GameManager instance].nbLettersFound;
    NSInteger end = start + [[GameManager instance].currentWord length];
    
    for (NSInteger i = start; i < end; i++) {
        LetterLabel * letterLabel = [m_letterLabels objectAtIndex:i];
        [letterLabel highlight];
    }
}

- (IBAction)onShuffle:(id)sender {
    [self onMediaChangedWithMedia:[GameManager instance].currentMedia andPackId:[GameManager instance].currentPackId andReset:NO andReplay:NO];
}

- (IBAction)onHelp:(id)sender {
    int timeInterval = INT_MAX;
    
    NSDate * lastHelpDate = [GameManager instance].lastHelpDate;
    if (lastHelpDate != nil) {
        timeInterval = (int)round([[NSDate date] timeIntervalSinceDate:lastHelpDate]);
    }
    
    if (timeInterval >= QUIZZ_APP_HELP_LIMIT) {
        [[GameManager instance] setLastHelpDate:[NSDate date]];
        [self highlightGoodLetters];
    } else {
        //Popup
        NSBundle * bundle = QUIZZ_APP_STRING_BUNDLE;
        NSString * message = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"STR_HELP_LIMIT_MESSAGE", nil, bundle, nil), (QUIZZ_APP_HELP_LIMIT - timeInterval)];
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"STR_HELP_LIMIT_TITLE", nil, QUIZZ_APP_STRING_BUNDLE, nil) message:message delegate:nil cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"STR_OK", nil, QUIZZ_APP_STRING_BUNDLE, nil) otherButtonTitles:nil];
        [alertView show];
    }
}

@end
