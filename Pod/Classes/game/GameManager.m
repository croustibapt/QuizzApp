//
//  GameManager.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 27/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "GameManager.h"

#import "Utils.h"
#import "UtilsString.h"
#import "GameDBHelper.h"
#import "Constants.h"
#import "QuizzApp.h"

@interface GameManager() {
    NSMutableArray * m_randomLetters;
    NSInteger m_currentRandomLetterIndex;
    NSMutableArray * m_chosenLetterButtonsKeys;
}

@end

@implementation GameManager

- (id)init {
    self = [super init];
    if (self) {
        m_randomLetters = [[NSMutableArray alloc] init];
        m_chosenLetterButtonsKeys = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)resetWithMedia:(Media *)media andPackId:(int)packId andNbRows:(int)nbRows andNbColumns:(int)nbColums {
    //Reset letters structures
    [self resetLetters:media andPackId:packId andNbRows:nbRows andNbColumns:nbColums];
    
    //Reset index
    [m_chosenLetterButtonsKeys removeAllObjects];
    [self setCurrentAnswer:nil];
    m_currentRandomLetterIndex = [self.startLetters count] - 1;
    [self setNbLettersFound:0];
}

- (NSArray *)createRealLetters:(NSString *)letters {
    NSMutableArray * realLetters = [[NSMutableArray alloc] init];
    NSRange range = {0, 1};
    
    for (int i = 0; i < letters.length; i++) {
        range.location = i;
        [realLetters addObject:[letters substringWithRange:range]];
    }
    
    return realLetters;
}

- (NSArray *)createFakeLettersWithNbRows:(int)nbRows andNbColumns:(int)nbColums {
    NSMutableArray * fakeLetters = [[NSMutableArray alloc] init];
    int nbRandomLetters = floor(self.normalizedAnswer.length / 4);
    
    int nbTotalLetters = (nbRows * nbColums);
    NSInteger nbChosenLetters = (self.normalizedAnswer.length + nbRandomLetters);
    
    if (nbChosenLetters < nbTotalLetters) {
        nbRandomLetters += (nbTotalLetters - nbChosenLetters);
    }
    
    for (int i = 0; i < nbRandomLetters; i++) {
        [fakeLetters addObject:[UtilsString getRandomStringWithLength:1]];
    }
    
    return fakeLetters;
}

- (void)resetLetters:(Media *)media andPackId:(int)packId andNbRows:(int)nbRows andNbColumns:(int)nbColums {
    [self setCurrentMedia:media];
    [self setCurrentPackId:packId];
    [self setNormalizedAnswer:[UtilsString normalizeString:self.currentMedia.title]];
    
    NSString * wordsString = [UtilsString normalizeStringWithString:self.currentMedia.title andSeparators:QUIZZ_APP_SEPARATOR_CHARACTERS];
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:QUIZZ_APP_SEPARATOR_CHARACTERS];
    
    NSMutableArray * components = [NSMutableArray arrayWithArray:[wordsString componentsSeparatedByCharactersInSet:set]];
    [components removeObject:@" "];
    [components removeObject:@""];
    
    [self setWords:components];
    
    [self setCurrentWordIndex:0];
    if ([self.words count] > 0) {
        [self setCurrentWord:[self.words objectAtIndex:0]];
    }
    
    //Create letters sets
    NSArray * realLetters = [self createRealLetters:self.normalizedAnswer];
    NSArray * fakeLetters = [self createFakeLettersWithNbRows:nbRows andNbColumns:nbColums];
    
    [m_randomLetters removeAllObjects];
    [m_randomLetters addObjectsFromArray:realLetters];
    [Utils randomInsertArrayOfValues:fakeLetters inArrayOfValues:m_randomLetters];
    
    [self setStartLetters:[self startLettersWithNbRows:nbRows andNbColumns:nbColums]];
}

- (NSMutableArray *)startLettersWithNbRows:(int)nbRows andNbColumns:(int)nbColums {
    int nbLetters = nbRows * nbColums;
    
    NSInteger rangeMax = MIN(nbLetters, [m_randomLetters count]);
    NSRange range = NSMakeRange(0, rangeMax);
    
    NSMutableArray * currentLetters = [NSMutableArray arrayWithArray:[m_randomLetters subarrayWithRange:range]];
    [Utils randomArrayOfValues:currentLetters];
    
    return currentLetters;
}

//- (void)resetLetters:(Media *)media andPackId:(int)packId andNbRows:(int)nbRows andNbColumns:(int)nbColums {
//    [self setCurrentMedia:media];
//    [self setCurrentPackId:packId];
//    
//    NSString * normString = [UtilsString normalizeString:self.currentMedia.title/*@"Shoot Kill"*/];
//    [self setNormalizedAnswer:normString];
//
//    NSMutableArray * repeatedCharacterIndexes = [[NSMutableArray alloc] init];
//    NSMutableArray * realIndexes = [[NSMutableArray alloc] init];
//    NSString * normStringWithoutDuplicates = nil;
//    
//    if (normString.length > 1) {
//        int finalIndex = 0;
//        NSString * oldLetter = [[NSString stringWithFormat:@"%c", [normString characterAtIndex:0]] lowercaseString];
//        normStringWithoutDuplicates = oldLetter;
//        [realIndexes addObject:[NSNumber numberWithInt:0]];
//
//        for (int i = 1; i < normString.length; i++) {
//            NSString * letter = [[NSString stringWithFormat:@"%c", [normString characterAtIndex:i]] lowercaseString];
//            
//            if ([oldLetter isEqualToString:letter]) {
//                //Repeat found
//                [repeatedCharacterIndexes addObject:[NSNumber numberWithInt:finalIndex]];
//            } else {
//                //Different letters
//                normStringWithoutDuplicates = [normStringWithoutDuplicates stringByAppendingString:letter];
//                finalIndex++;
//                [realIndexes addObject:[NSNumber numberWithInt:finalIndex]];
//            }
//            
//            oldLetter = letter;
//        }
//    }
//    
//    NSString * wordsString = [UtilsString normalizeSpacesString:self.currentMedia.title];
//    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@" '"];
//    [self setWords:[wordsString componentsSeparatedByCharactersInSet:set]];
//    
//    [self setCurrentWordIndex:0];
//    [self setNbLettersFound:0];
//    if ([self.words count] > 0) {
//        [self setCurrentWord:[self.words objectAtIndex:0]];
//    }
//    
//    //Create letters sets
//    NSArray * realLetters = [self createRealLetters:/*self.normalizedAnswer*/normStringWithoutDuplicates];
//    NSArray * fakeLetters = [self createFakeLettersWithNbRows:nbRows andNbColumns:nbColums];
//    
//    NSMutableArray * fakeIndexes = [[NSMutableArray alloc] init];
//    for (int i = 0; i < [fakeLetters count]; i++) {
//        int index = [realLetters count] + i;
//        [fakeIndexes addObject:[NSNumber numberWithInt:index]];
//    }
//    
//    
//    [Utils randomInsertArrayOfValues:fakeIndexes inArrayOfValues:realIndexes];
//    
//    //Random indexes
//    int nbLetters = nbRows * nbColums;
//    
//    int rangeMax = MIN(nbLetters, [realIndexes count]);
//    NSRange range = NSMakeRange(0, rangeMax);
//    
//    NSMutableArray * indexesToRandom = [NSMutableArray arrayWithArray:[realIndexes subarrayWithRange:range]];
//    NSMutableArray * otherIndexes = [NSMutableArray arrayWithArray:realIndexes];
//    [otherIndexes removeObjectsInRange:range];
//    
//    [Utils randomArrayOfValues:indexesToRandom];
//    [indexesToRandom addObjectsFromArray:otherIndexes];
//    
//    [m_randomLetters removeAllObjects];
//    NSArray * allLetters = [[NSMutableArray arrayWithArray:realLetters] arrayByAddingObjectsFromArray:fakeLetters];
//    for (NSNumber * letterIndex in indexesToRandom) {
//        NSString * letter = [allLetters objectAtIndex:[letterIndex intValue]];
//        [m_randomLetters addObject:letter];
//        
//        if ([repeatedCharacterIndexes containsObject:letterIndex]) {
//            [m_randomLetters addObject:letter];
//        }
//    }
//    
//    //Start letters
//    NSMutableArray * letters = [NSMutableArray arrayWithArray:[m_randomLetters subarrayWithRange:range]];
//    [self setStartLetters:letters];
//    
//    [repeatedCharacterIndexes release];
//    [realIndexes release];
//    [fakeIndexes release];
//}

- (Boolean)canType {
    return (self.currentAnswer.length < self.currentWord.length);
}

- (NSInteger)onLetterPressed:(NSString *)key andLetter:(NSString *)letter {
    //Add its key to the chosen letter array
    [m_chosenLetterButtonsKeys addObject:key];
    
    //Update typed answer
    if (self.currentAnswer == nil) {
        [self setCurrentAnswer:letter];
    } else {
        [self setCurrentAnswer:[self.currentAnswer stringByAppendingString:letter]];
    }
    
    m_currentRandomLetterIndex++;
    
    [self.delegate onLetterPressed:NO];
    
    NSInteger letterLabelIndex = (self.currentAnswer.length - 1) + self.nbLettersFound;
    return letterLabelIndex;
}

- (NSString *)getNextRandomLetter {
    NSString * letter = nil;
    
    if (m_currentRandomLetterIndex < [m_randomLetters count]) {
        letter = [[m_randomLetters objectAtIndex:m_currentRandomLetterIndex] uppercaseString];
    }
    return letter;
}

- (Boolean)canDelete {
    return (self.currentAnswer.length > 0);
}

- (NSInteger)onDelete {
    //Decremente the random letter index
    m_currentRandomLetterIndex--;
    
    NSInteger letterLabelIndex = (self.currentAnswer.length - 1) + self.nbLettersFound;
    
    //Update current answer
    [self setCurrentAnswer:[self.currentAnswer substringToIndex:(self.currentAnswer.length - 1)]];
    
    [self.delegate onLetterPressed:YES];
    
    return letterLabelIndex;
}

- (void)completeMedia:(Media *)media {
    //Found media
    [media setIsCompleted:YES];
    [GameDBHelper completeMedia:media.identifier inPack:self.currentPackId];
    
    //Create instant progression
    int mediaId = media.identifier;
    int packId = self.currentPackId;
    
    NSString * packKey = [NSString stringWithFormat:@"%d", packId];
    NSDictionary * instantProgression = [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:[NSNumber numberWithInt:mediaId]] forKey:packKey];
    
    //And save progression online
    if ([[QuizzApp sharedInstance].progressManager saveProgressionWithProgressionKey:nil instantProgression:instantProgression success:^(GKSavedGame * savedGame) {
        // ???
    } failure:^(NSError * error) {
        // ???
    }]) {
        // ???
    }
    
    [self.delegate onMediaFound:media];
}

- (EQuizzAppCheckWord)checkWord {
//#if (TARGET_IPHONE_SIMULATOR)
//    [self completeMedia:self.currentMedia];
//    return EQuizzAppCheckWordFound;
//#endif
    
    EQuizzAppCheckWord returnValue = EQuizzAppCheckWordNone;
    
    //Check length
    if (self.currentAnswer.length == self.currentWord.length) {
        returnValue = EQuizzAppCheckWordWrong;
        
        if ([[self.currentAnswer lowercaseString] isEqualToString:self.currentWord]) {
            returnValue = EQuizzAppCheckWordFound;
            self.nbLettersFound += self.currentWord.length;
            
            //Reset current answer
            [self setCurrentAnswer:nil];
            self.currentWordIndex++;
            
            //Go to next word
            if (self.currentWordIndex < [self.words count]) {
                //Notify delegate
                [self.delegate onGoodWord:self.currentWord];
                
                [self setCurrentWord:[self.words objectAtIndex:self.currentWordIndex]];
            } else {
                //Found media
                [self completeMedia:self.currentMedia];
            }
        }
    }
    
    if (returnValue == EQuizzAppCheckWordWrong) {
        //Notify delegate
        [self.delegate onBadWord];
    }
    
    return returnValue;
}

- (NSString *)getLastKey {
    NSString * key = [m_chosenLetterButtonsKeys lastObject];
    [m_chosenLetterButtonsKeys removeLastObject];
    
    return key;
}

@end
