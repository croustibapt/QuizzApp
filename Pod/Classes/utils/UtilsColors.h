//
//  UtilsColors.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 26/09/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define WHITE_COLOR UIColorFromRGB(0xFFFFFF)

#define GREEN_COLOR UIColorFromRGB(0x8BC34A)
#define GREEN_DARK_COLOR UIColorFromRGB(0x689F38)

#define BLUE_COLOR UIColorFromRGB(0x2196F3)
#define BLUE_DARK_COLOR UIColorFromRGB(0x1976D2)

#define ORANGE_COLOR UIColorFromRGB(0xFF9800)
#define ORANGE_DARK_COLOR UIColorFromRGB(0xF57C00)

#define RED_COLOR UIColorFromRGB(0xF44336)
#define RED_DARK_COLOR UIColorFromRGB(0xD32F2F)

#define BLUE_GRAY_COLOR UIColorFromRGB(0x607D8B)
#define BLUE_GRAY_DARK_COLOR UIColorFromRGB(0x455A64)

#define GOLD_COLOR UIColorFromRGB(0xFFDB31)
#define GOLD_DARK_COLOR UIColorFromRGB(0xb78727)

#define GRAY_COLOR UIColorFromRGB(0x9E9E9E)
#define GRAY_DARK_COLOR UIColorFromRGB(0x616161)
#define GRAY_LIGHT_COLOR UIColorFromRGB(0xCFD8DC)

@interface UtilsColors : NSObject

+ (UIColor *)changeColorAlphaWithColor:(UIColor *)color andAlpha:(float)alpha;

@end
