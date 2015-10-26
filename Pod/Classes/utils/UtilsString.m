//
//  UtilsString.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 23/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "UtilsString.h"

#import "Constants.h"

@implementation UtilsString

+ (NSString *)getRandomStringWithLength:(int)length {
    NSMutableString * randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        [randomString appendFormat: @"%C", [QUIZZ_APP_ALPHABET characterAtIndex:arc4random() % [QUIZZ_APP_ALPHABET length]]];
    }
    
    return randomString;
}

+ (NSString *)randomizeString:(NSString *)text {
    NSMutableString * randomizedText = [NSMutableString stringWithString:text];
    
    NSString * buffer;
    for (NSInteger i = randomizedText.length - 1, j; i >= 0; i--) {
        j = arc4random() % (i + 1);
        
        buffer = [randomizedText substringWithRange:NSMakeRange(i, 1)];
        [randomizedText replaceCharactersInRange:NSMakeRange(i, 1) withString:[randomizedText substringWithRange:NSMakeRange(j, 1)]];
        [randomizedText replaceCharactersInRange:NSMakeRange(j, 1) withString:buffer];
    }
    
    return randomizedText;
}

+ (NSString *)normalizeString:(NSString *)string {
    return [[[[string componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""] stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]] lowercaseString];
}

+ (NSString *)normalizeStringWithString:(NSString *)string andSeparators:(NSString *)separators {
    NSMutableCharacterSet * set1 = [NSMutableCharacterSet alphanumericCharacterSet];
    NSCharacterSet * separatorsSet = [NSCharacterSet characterSetWithCharactersInString:separators];
    
//    [set1 formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    [set1 formUnionWithCharacterSet:separatorsSet];
    
    NSCharacterSet * set2 = [set1 invertedSet];
    
    NSString * str1 = [[string componentsSeparatedByCharactersInSet:set2] componentsJoinedByString:@""];
    NSString * str2 = [str1 stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    
    return [str2 lowercaseString];
}

+ (Boolean)goodString:(NSString *)string {
    return ![[UtilsString normalizeString:string] isEqualToString:@""];
}

@end
