//
//  Media.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 08/10/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "Media.h"

#import "Level.h"
#import "UtilsImage.h"
#import "Utils.h"
#import "QuizzApp.h"

@implementation Media

@synthesize isCompleted = m_isCompleted;

+ (Media *)Media {
    Media * media = [[Media alloc] init];
    return media;
}

- (Boolean)isCompleted {
#warning TO PORT
    Boolean userIsConnected = NO;//[[QuizzApp sharedInstance].progressManager isConnected];
    self.isRemoteCompleted = [ProgressManager isMediaRemoteCompleted:self.identifier];
    
    return ((!userIsConnected && m_isCompleted) || self.isRemoteCompleted);
}

- (Boolean)isReplayCompleted {
    return self.isCompleted;
}

+ (void)thumbImageWithMedia:(Media *)media andImageView:(UIImageView *)imageView andRadians:(float)radians andOriginalImage:(UIImage *)originalImage {
    imageView.transform = CGAffineTransformMakeRotation(0);
    
    for (UIView * view in imageView.subviews) {
        [view removeFromSuperview];
    }
    
    //Resize image
    [imageView setImage:originalImage];
    
    if (!media.isCompleted) {
        for (int i=0; i<[media.topLeftBlurRects count]; i++) {
            CGPoint topLeftBlurRect = [[media.topLeftBlurRects objectAtIndex:i] CGPointValue];
            CGPoint bottomRightBlurRect = [[media.bottomRightBlurRects objectAtIndex:i] CGPointValue];
            
            [UtilsImage blurImageWithBottomRightBlurRect:bottomRightBlurRect andTopLeftBlurRect:topLeftBlurRect andOriginalImage:originalImage andDestinationView:imageView andFull:NO];
        }
    }
        
    imageView.transform = CGAffineTransformMakeRotation(radians);
}

- (UIImage *)imageWithLevelId:(int)levelId {
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/level_%d/img/media_%d.jpg", [Level levelsPath], levelId, self.identifier]];
}

- (UIImage *)thumbImageWithLevelId:(int)levelId {
    NSString * thumbPath = [NSString stringWithFormat:@"%@/level_%d/img/thumb_media_%d.jpg", [Level levelsPath], levelId, self.identifier];
    UIImage * returnImage = [UIImage imageWithContentsOfFile:thumbPath];
    
    if (returnImage == nil) {
//        NSDate * startDate = [NSDate date];
        UIImage * originalImage = [self imageWithLevelId:levelId];
//        NSLog(@"load original %.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
        
//        startDate = [NSDate date];
        int width = 150;
        int height = 200;
        if ([Utils isRetinaDevice]) {
            width *= 2;
            height *= 2;
        }
        
        returnImage = [UtilsImage imageWithImage:originalImage scaledToSize:CGSizeMake(width, height)];

//        NSLog(@"thumb %.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
        [self saveThumbImageInCache:returnImage andThumbPath:thumbPath];
    }
    
    return returnImage;
}

- (void)saveThumbImageInCache:(UIImage *)aThumbImage andThumbPath:(NSString *)thumbPath {
    NSData * thumbImageData = UIImageJPEGRepresentation(aThumbImage, 0.1);
    [thumbImageData writeToFile:thumbPath atomically:YES];
}

////TEMP DEBUG
//- (NSString *)title {
//    return @"ABCDEFGHIJKLMNOPQR ABCDEFGHIJKLMNO PQRST UV W XYZ 123456";
//}

@end
