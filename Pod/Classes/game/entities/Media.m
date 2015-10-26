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
#import "ProgressManager.h"

@implementation Media

@synthesize identifier;
@synthesize title = m_title;
@synthesize rects = m_rects;
@synthesize topLeftBlurRects = m_topLeftBlurRects;
@synthesize bottomRightBlurRects = m_bottomRightBlurRects;
@synthesize difficulty;
@synthesize language = m_language;
@synthesize strVariants = m_strVariants;
@synthesize variants = m_variants;
@synthesize isCompleted = m_isCompleted;
@synthesize isRemoteCompleted = m_isRemoteCompleted;

+ (Media *)Media {
    Media * media = [[Media alloc] init];
    return [media autorelease];
}

- (Boolean)isCompleted {
    Boolean userIsConnected = [[ProgressManager instance] isConnected];
    m_isRemoteCompleted = [ProgressManager isMediaRemoteCompleted:self.identifier];
    
    return ((!userIsConnected && m_isCompleted) || m_isRemoteCompleted);
}

- (Boolean)isReplayCompleted {
    return m_isCompleted;
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

- (void)dealloc {
    [m_title release];
    [m_rects release];
    [m_topLeftBlurRects release];
    [m_bottomRightBlurRects release];
    [m_language release];
    [m_strVariants release];
    [m_variants release];
    [super dealloc];
}

@end
