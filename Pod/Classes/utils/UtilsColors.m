//
//  UtilsColors.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 26/09/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "UtilsColors.h"

@implementation UtilsColors

+ (UIColor *)changeColorAlphaWithColor:(UIColor *)color andAlpha:(float)alpha {
    if (color != nil) {
        CGFloat r, g, b, a;
        [color getRed:&r green:&g blue: &b alpha: &a];
        
        return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
    }
    
    return nil;
}

@end
