//
//  UtilsString.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 23/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilsString : NSObject

+ (NSString *)getRandomStringWithLength:(int)length;

+ (NSString *)randomizeString:(NSString *)text;

+ (NSString *)normalizeString:(NSString *)string;

+ (NSString *)normalizeStringWithString:(NSString *)string andSeparators:(NSString *)separators;

+ (Boolean)goodString:(NSString *)string;

@end
