//
//  Utils.m
//  moviequizz
//
//  Created by dev_iphone on 16/12/12.
//  Copyright (c) 2012 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "Utils.h"

#include<unistd.h>
#include<netdb.h>

#import "Constants.h"

@implementation Utils

+ (float)degreesToRadians:(float)degrees {
    return degrees * M_PI / 180;
}

+ (float)radiansToDegrees:(float)radians {
    return radians * 180 / M_PI;
}

+ (NSString *)fileMD5:(NSString *)path {
	NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:path];
	if (handle == nil)
        return @"ERROR GETTING FILE MD5"; // file didnt exist
	
	CC_MD5_CTX md5;
	CC_MD5_Init(&md5);
	
	BOOL done = NO;
	while (!done) {
        @autoreleasepool {
            NSData * fileData = [handle readDataOfLength:512];
            CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
            
            if ([fileData length] == 0){
                done = YES;
            }
        }
	}
    
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5_Final(digest, &md5);
	NSString * s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                    digest[0], digest[1],
                    digest[2], digest[3],
                    digest[4], digest[5],
                    digest[6], digest[7],
                    digest[8], digest[9],
                    digest[10], digest[11],
                    digest[12], digest[13],
                    digest[14], digest[15]];
	return s;
}

+ (NSString *)stringMD5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (int64_t)getMStime {
    struct timeval time;
    gettimeofday(&time, NULL);
    
    int64_t milliSeconds = (int64_t)((int64_t)time.tv_sec * (int64_t)1000);
    int64_t returnValue = milliSeconds + (time.tv_usec / 1000);
    
    return returnValue;
}

+ (Boolean)isRetinaDevice {
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0)) ? YES : NO;
}

+ (Boolean) isIPhone5Device {
    bool isiPhone5 = CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 1136));
    return isiPhone5;
}

////create drawing context
//UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0f);
//CGContextRef context = UIGraphicsGetCurrentContext();
//
////draw pixels
//for (int x = 0; x < width; x++)
//{
//    for (int y = 0; y < height; y++)
//    {
//        CGContextSetFillColor( ... your color here ... );
//        CGContextFillRect(context, CGRectMake(x, y, 1.0f, 1.0f));
//    }
//}
//
////capture resultant image
//UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//UIGraphicsEndImageContext();

+ (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    NSUInteger byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    for (int ii = 0 ; ii < count ; ++ii) {
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += 4;
        
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        [result addObject:acolor];
    }
    
    free(rawData);
    
    return result;
}

+ (void)randomInsertArrayOfValues:(NSArray *)values inArrayOfValues:(NSMutableArray *)valuesSource {
    NSUInteger nbValuesSource = [valuesSource count];
    NSUInteger nbValues = [values count];
    
    for (NSUInteger i = 0; i < nbValues; ++i) {
        //Select a random element between i and end of array to swap with.
        int n = (arc4random() % nbValuesSource);
        
        [valuesSource insertObject:[values objectAtIndex:i] atIndex:n];
    }
}

+ (void)randomArrayOfValues:(NSMutableArray *)values {
    NSUInteger count = [values count];
    
    for (NSUInteger i = 0; i < count; ++i) {
        //Select a random element between i and end of array to swap with.
        NSUInteger nElements = count - i;
        NSUInteger n = (arc4random() % nElements) + i;
        [values exchangeObjectAtIndex:i withObjectAtIndex:n];
    }}

+ (Boolean)isIPad {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

+ (NSString *)defaultLanguage {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * languages = [defaults objectForKey:@"AppleLanguages"];
    NSString * language = [languages objectAtIndex:0];
    
    //Other language
    if (![language isEqualToString:@"fr"]) {
        language = @"en";
    }
    
    return language;
}

+ (NSString *)currentLanguage {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    NSString * language = [prefs stringForKey:QUIZZ_APP_LANGUAGE_KEY];
    return language;
}

+ (NSString *)otherLanguage {
    NSString * currentLanguage = [Utils currentLanguage];
    if ([currentLanguage isEqualToString:@"en"]) {
        return @"fr";
    } else {
        return @"en";
    }
}

+ (void)setCurrentLanguage:(NSString *)language {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:language forKey:QUIZZ_APP_LANGUAGE_KEY];
    [prefs synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObject:language] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (Boolean)isNetworkAvailable {
    struct addrinfo *res = NULL;
    
    int s = getaddrinfo("apple.com", NULL, NULL, &res);
    Boolean network_ok = (s == 0 && res != NULL);
    
    freeaddrinfo(res);
    
    return network_ok;
}

@end
