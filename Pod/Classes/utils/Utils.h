//
//  Utils.h
//  moviequizz
//
//  Created by dev_iphone on 16/12/12.
//  Copyright (c) 2012 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>
#import <sys/time.h>

@interface Utils : NSObject

+ (float)degreesToRadians:(float)degrees;

+ (float)radiansToDegrees:(float)radians;

+ (NSString *)fileMD5:(NSString *)path;

+ (NSString *)stringMD5:(NSString *)str;

+ (int64_t)getMStime;

+ (Boolean)isRetinaDevice;

+ (Boolean) isIPhone5Device;

+ (void)randomInsertArrayOfValues:(NSArray *)values inArrayOfValues:(NSMutableArray *)valuesSource;

+ (void)randomArrayOfValues:(NSMutableArray *)values;

+ (Boolean)isIPad;

+ (NSString *)defaultLanguage;

+ (NSString *)currentLanguage;

+ (NSString *)otherLanguage;

+ (void)setCurrentLanguage:(NSString *)language;

+ (Boolean)isNetworkAvailable;

@end

static inline float
PixelsSize(float pixelsSize) {
    return [Utils isIPad] ? (pixelsSize * 2.0) : pixelsSize;
}

static inline NSString *
ExtensionName(NSString * nibName) {
    return [Utils isIPad] ? [nibName stringByAppendingString:@"_iPad"] : nibName;
}
