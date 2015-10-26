//
//  UtilsImage.h
//  moviequizz
//
//  Created by dev_iphone on 29/03/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface UtilsImage : NSObject

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+ (void)blurImageWithBottomRightBlurRect:(CGPoint)bottomRightBlurRect andTopLeftBlurRect:(CGPoint)topLeftBlurRect andOriginalImage:(UIImage *)originalImage andDestinationView:(UIImageView *)destinationView andFull:(Boolean)full;

+ (UIImage *)croppIngimageByImageName:(UIImage *)imageToCrop toRect:(CGRect)rect;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithGradientWithStartColor:(UIColor *)startColor andEndColor:(UIColor *)endColor andSize:(CGSize)size;

+ (UIImage *)imageNamed:(NSString *)name bundle:(NSBundle *)bundle;

+ (UIImage *)imageNamed:(NSString *)name;

+ (UIImage *)imageNamed:(NSString *)name bundle:(NSBundle *)bundle andColor:(UIColor *)color;

+ (UIImage *)imageNamed:(NSString *)name  andColor:(UIColor *)color;

+ (UIImage *)rotateImageWithImage:(UIImage *)image andRadians:(float)radians;

@end
