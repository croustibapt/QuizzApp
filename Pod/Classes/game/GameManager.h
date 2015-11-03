//
//  GameManager.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 27/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Media.h"
#import "ProgressManager.h"

typedef enum {
    EQuizzAppCheckWordFound = 1,
    EQuizzAppCheckWordWrong,
    EQuizzAppCheckWordNone,
} EQuizzAppCheckWord;

@protocol GameDelegate <NSObject>

- (void)onMediaFound:(Media *)media;

- (void)onGoodWord:(NSString *)word;

- (void)onBadWord;

- (void)onLetterPressed:(Boolean)back;

@end

@interface GameManager : NSObject <ProgressGameDelegate>

@property (nonatomic, weak) id<GameDelegate> delegate;

@property (nonatomic) int currentPackId;

@property (nonatomic, strong) Media * currentMedia;

@property (nonatomic, strong) NSArray * words;

@property (nonatomic) int currentWordIndex;

@property (nonatomic) NSInteger nbLettersFound;

@property (nonatomic, strong) NSString * currentWord;

@property (nonatomic, strong) NSString * normalizedAnswer;

@property (nonatomic, strong) NSString * currentAnswer;

@property (nonatomic, strong) NSMutableArray * startLetters;

@property (nonatomic, strong) NSDate * lastHelpDate;

- (void)resetWithMedia:(Media *)media andPackId:(int)packId andNbRows:(int)nbRows andNbColumns:(int)nbColums;

- (Boolean)canType;

- (NSInteger)onLetterPressed:(NSString *)key andLetter:(NSString *)letter;

- (NSString *)getNextRandomLetter;

- (Boolean)canDelete;

- (NSInteger)onDelete;

- (EQuizzAppCheckWord)checkWord;

- (NSString *)getLastKey;

@end
