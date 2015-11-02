//
//  GameManager.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 27/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Media.h"
#import "PGameListener.h"
#import "PProgressGamesListener.h"

typedef enum {
    EQuizzAppCheckWordFound = 1,
    EQuizzAppCheckWordWrong,
    EQuizzAppCheckWordNone,
} EQuizzAppCheckWord;

@interface GameManager : NSObject <PProgressGamesListener> {
    NSMutableArray * m_randomLetters;
    NSInteger m_currentRandomLetterIndex;
    NSMutableArray * m_chosenLetterButtonsKeys;
}

@property (nonatomic, retain) id<PGameListener> listener;

@property (nonatomic, readwrite) int currentPackId;

@property (nonatomic, retain) Media * currentMedia;

@property (nonatomic, retain) NSArray * words;

@property (nonatomic, readwrite) int currentWordIndex;

@property (nonatomic, readwrite) NSInteger nbLettersFound;

@property (nonatomic, retain) NSString * currentWord;

@property (nonatomic, retain) NSString * normalizedAnswer;

@property (nonatomic, retain) NSString * currentAnswer;

@property (nonatomic, retain) NSMutableArray * startLetters;

@property (nonatomic, retain) NSDate * lastHelpDate;

+ (GameManager *)instance;

- (void)resetWithMedia:(Media *)media andPackId:(int)packId andNbRows:(int)nbRows andNbColumns:(int)nbColums;

- (Boolean)canType;

- (NSInteger)onLetterPressed:(NSString *)key andLetter:(NSString *)letter;

- (NSString *)getNextRandomLetter;

- (Boolean)canDelete;

- (NSInteger)onDelete;

- (EQuizzAppCheckWord)checkWord;

- (NSString *)getLastKey;

@end
