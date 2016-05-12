//
//  UtilsImage.m
//  moviequizz
//
//  Created by dev_iphone on 29/03/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//


#import "UtilsImage.h"


#import "Constants.h"
#import "Utils.h"


@implementation UtilsImage


+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 1.0);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


+ (void)blurImageWithBottomRightBlurRect:(CGPoint)bottomRightBlurRect
                      andTopLeftBlurRect:(CGPoint)topLeftBlurRect
                        andOriginalImage:(UIImage *)originalImage
                      andDestinationView:(UIImageView *)destinationView
                                 andFull:(Boolean)full
{
    //Compute blur rect size
    float blurRectWidth = bottomRightBlurRect.x - topLeftBlurRect.x;
    float blurRectHeight = bottomRightBlurRect.y - topLeftBlurRect.y;
    
    //Compute render rect
    CGSize parentViewSize = destinationView.frame.size;
    float renderWidth = parentViewSize.width;
    float renderHeight = parentViewSize.height;
    
    int offsetY = 0;
//    if (full && [Utils isIPhone5Device]) {
//        offsetY += QUIZZ_APP_IPHONE_5_MEDIA_BLUR_OFFSET;
//    }
    
    CGRect renderRect = CGRectMake(topLeftBlurRect.x * renderWidth,
                                   topLeftBlurRect.y * renderHeight + offsetY,
                                   blurRectWidth * renderWidth,
                                   blurRectHeight * renderHeight);
    
    UIImageView * blurImageView = [[UIImageView alloc] initWithFrame:renderRect];
    [blurImageView.layer setMagnificationFilter:kCAFilterNearest];
    
    [blurImageView setImage:[UtilsImage blurImageWithOriginalImage:originalImage
                                            andBottomRightBlurRect:bottomRightBlurRect
                                                andTopLeftBlurRect:topLeftBlurRect]];
//    [blurImageView setContentMode:UIViewContentModeScaleAspectFit];
//    [blurImageView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
    [destinationView addSubview:blurImageView];
    
#warning Create constraints
    
    blurImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary * views = NSDictionaryOfVariableBindings(blurImageView, destinationView);
    
    CGFloat blurHeight = blurRectHeight * renderHeight;
    CGFloat topMargin = topLeftBlurRect.y * renderHeight;
    CGFloat bottomMargin = renderHeight - (topMargin + blurHeight);
    
//    NSString * verticalConstraints = [NSString stringWithFormat:@"V:|-(>=%f)-[blurImageView]-(>=%f)-|", topMargin, bottomMargin];
//    [destinationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalConstraints
//                                                                            options:0
//                                                                            metrics:0
//                                                                              views:views]];
    
    CGFloat vTopMultiplier = (topLeftBlurRect.y == 0.0) ? 1.0 : topLeftBlurRect.y;
    CGFloat vBottomMultiplier = (bottomRightBlurRect.y == 0.0) ? 1.0 : bottomRightBlurRect.y;
    [destinationView addConstraint:[NSLayoutConstraint constraintWithItem:blurImageView
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:destinationView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:vTopMultiplier
                                                                 constant:0.0]];
    [destinationView addConstraint:[NSLayoutConstraint constraintWithItem:blurImageView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:destinationView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:vBottomMultiplier
                                                                 constant:0.0]];
    
    CGFloat hLeftMultiplier = (topLeftBlurRect.x == 0.0) ? 1.0 : topLeftBlurRect.x;
    CGFloat hRightMultiplier = (bottomRightBlurRect.x == 0.0) ? 1.0 : bottomRightBlurRect.x;
    [destinationView addConstraint:[NSLayoutConstraint constraintWithItem:blurImageView
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:destinationView
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:hLeftMultiplier
                                                                 constant:0.0]];
    [destinationView addConstraint:[NSLayoutConstraint constraintWithItem:blurImageView
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:destinationView
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:hRightMultiplier
                                                                 constant:0.0]];
    
//    [destinationView addConstraint:[NSLayoutConstraint constraintWithItem:blurImageView
//                                                                attribute:NSLayoutAttributeBottom
//                                                                relatedBy:NSLayoutRelationEqual
//                                                                   toItem:destinationView
//                                                                attribute:NSLayoutAttributeTop
//                                                               multiplier:(bottomRightBlurRect.y == 0.0) ? 1.0 : bottomRightBlurRect.y
//                                                                 constant:0.0]];
    
//    CGFloat blurWidth = blurRectWidth * renderWidth;
//    CGFloat leftMargin = topLeftBlurRect.x * renderWidth;
//    CGFloat rightMargin = renderWidth - (leftMargin + blurWidth);
//    
//    NSString * horyzontalConstraints = [NSString stringWithFormat:@"H:|-(>=%f)-[blurImageView]-(>=%f)-|", leftMargin, rightMargin];
//    [destinationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horyzontalConstraints
//                                                                            options:0
//                                                                            metrics:0
//                                                                              views:views]];
    
//    CGFloat aspectRatio = blurWidth / blurHeight;
//    [destinationView addConstraint:[NSLayoutConstraint constraintWithItem:blurImageView
//                                                                attribute:NSLayoutAttributeWidth
//                                                                relatedBy:NSLayoutRelationEqual
//                                                                   toItem:blurImageView
//                                                                attribute:NSLayoutAttributeHeight
//                                                               multiplier:aspectRatio //Aspect ratio: 4*height = 3*width
//                                                                 constant:0.0]];
    
//    [destinationView addConstraint:[NSLayoutConstraint constraintWithItem:blurImageView
//                                                                attribute:NSLayoutAttributeWidth
//                                                                relatedBy:NSLayoutRelationLessThanOrEqual
//                                                                   toItem:destinationView
//                                                                attribute:NSLayoutAttributeWidth
//                                                               multiplier:blurRectWidth
//                                                                 constant:0.0]];
//    
//    [destinationView addConstraint:[NSLayoutConstraint constraintWithItem:blurImageView
//                                                                attribute:NSLayoutAttributeHeight
//                                                                relatedBy:NSLayoutRelationLessThanOrEqual
//                                                                   toItem:destinationView
//                                                                attribute:NSLayoutAttributeHeight
//                                                               multiplier:blurRectHeight
//                                                                 constant:0.0]];
}


+ (UIImage *)blurImageWithOriginalImage:(UIImage *)originalImage
                 andBottomRightBlurRect:(CGPoint)bottomRightBlurRect
                     andTopLeftBlurRect:(CGPoint)topLeftBlurRect
{
    int originalWidth = originalImage.size.width;
    int originalHeight = originalImage.size.height;
    
    float scaleFactor = POSTER_SCALE_FACTOR;
    if ([Utils isRetinaDevice])
    {
        scaleFactor /= 2.0;
    }
    
    //Compute blur rect size
    float blurRectWidth = bottomRightBlurRect.x - topLeftBlurRect.x;
    float blurRectHeight = bottomRightBlurRect.y - topLeftBlurRect.y;

    CGRect blurRect = CGRectMake(topLeftBlurRect.x*originalWidth,
                                 topLeftBlurRect.y*originalHeight,
                                 blurRectWidth*originalWidth,
                                 blurRectHeight*originalHeight);
    
    UIImage * beforeImage = [UtilsImage croppIngimageByImageName:originalImage toRect:blurRect];
    
    beforeImage = [UtilsImage imageWithImage:beforeImage
                                scaledToSize:CGSizeMake((blurRect.size.width * scaleFactor),
                                                        (blurRect.size.height * scaleFactor))];
    
    return beforeImage;
}


+ (UIImage *)croppIngimageByImageName:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage * cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}


//+ (UIImage *) addImageToImage:(UIImage *)img withImage2:(UIImage *)img2 andRect:(CGRect)cropRect andSize:(CGSize)size {
//    UIGraphicsBeginImageContext(size);
//    
//    if (!CGSizeEqualToSize(img2.size, cropRect.size)) {
//        img2 = [UtilsImage imageWithImage:img2 scaledToSize:cropRect.size];
//    }
//    
//    CGPoint pointImg1 = CGPointMake(0,0);
//    [img drawAtPoint:pointImg1];
//    
//    CGPoint pointImg2 = cropRect.origin;
//    [img2 drawAtPoint: pointImg2];
//    
//    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return result;
//}


+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (UIImage *)imageWithGradientWithStartColor:(UIColor *)startColor
                                 andEndColor:(UIColor *)endColor
                                     andSize:(CGSize)size
{
    CGFloat r0;
    CGFloat g0;
    CGFloat b0;
    CGFloat a0;
    [startColor getRed:&r0 green:&g0 blue:&b0 alpha:&a0];
    
    CGFloat r1;
    CGFloat g1;
    CGFloat b1;
    CGFloat a1;
    [endColor getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    size_t gradientNumberOfLocations = 2;
    CGFloat gradientLocations[2] = { 0.0, 1.0 };
    CGFloat gradientComponents[8] = { r0, g0, b0, a0,     // Start color
        r1, g1, b1, a1, };  // End color
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents (colorspace, gradientComponents, gradientLocations, gradientNumberOfLocations);
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageNamed:(NSString *)name bundle:(NSBundle *)bundle {
    NSString * path = [bundle pathForResource:name ofType:@"png"];
    UIImage * image = [[UIImage alloc] initWithContentsOfFile:path];
    
    return image;
}

+ (UIImage *)imageNamed:(NSString *)name {
    return [UIImage imageNamed:name];
//    return [UtilsImage imageNamed:name bundle:MAIN_BUNDLE];
}

+ (UIImage *)imageNamed:(NSString *)name bundle:(NSBundle *)bundle andColor:(UIColor *)color {
    //Load the image
    UIImage * img = [UtilsImage imageNamed:name bundle:bundle];
    
    //Begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContextWithOptions(img.size, NO, 2.0);
    
    //Get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Set the fill color
    [color setFill];
    
    //Translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //Set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    //Set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    //Generate a new UIImage from the graphics context we drew onto
    UIImage * coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Return the color-burned image
    return coloredImg;
}

+ (UIImage *)imageNamed:(NSString *)name  andColor:(UIColor *)color {
    return [UtilsImage imageNamed:name bundle:MAIN_BUNDLE andColor:color];
}

//+ (UIImage *)rotateImageWithImage:(UIImage *)image andRadians:(float)radians {
//    UIGraphicsBeginImageContext(image.size);
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextRotateCTM (context, radians);
//    
//    [image drawAtPoint:CGPointMake(0, 0)];
//    
//    return UIGraphicsGetImageFromCurrentImageContext();
//}

+ (UIImage *)rotateImageWithImage:(UIImage *)image andRadians:(float)radians {
    // calculate the size of the rotated view's containing box for our drawing space
    UIView * rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0, image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, radians);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
