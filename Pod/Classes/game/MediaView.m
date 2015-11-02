//
//  MediaView.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 14/12/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "MediaView.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>

#import "UtilsImage.h"
#import "Constants.h"

@implementation MediaView

@synthesize media = m_media;

- (id)initWithFrame:(CGRect)frame andMedia:(Media *)aMedia andLevelId:(int)aLevelId andReplay:(Boolean)replay {
    self = [super initWithFrame:frame];
    if (self) {
        [self setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
//        [self setBackgroundColor:[UIColor blueColor]];
        
        //Set level identifier
        [self setLevelId:aLevelId];
        
        //Initialization code
        float newWidth = MIN(frame.size.width, 600.0 * frame.size.height / 800.0);
        float newHeight = MIN(frame.size.height, 800.0 * frame.size.width / 600.0);
        float offsetX = (frame.size.width - newWidth)/2.0;
        float offsetY = (frame.size.height - newHeight)/2.0;
        
        //Poster
        CGRect posterFrame = CGRectMake(offsetX, offsetY, newWidth, newHeight);
        self.posterImageView = [[UIImageView alloc] initWithFrame:posterFrame];
        [self.posterImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.posterImageView setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin)];
//        [self setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin)];
//        [m_posterImageView setBackgroundColor:[UIColor greenColor]];

        [self addSubview:self.posterImageView];
        
        NSString * text = NSLocalizedStringFromTableInBundle(@"STR_FOUND", nil, QUIZZ_APP_STRING_BUNDLE, nil);
        
        //Status
        CGRect statusFrame = CGRectMake(self.frame.size.width - PixelsSize(60) - QUIZZ_APP_MEDIA_FOUND_IMAGE_PADDING, QUIZZ_APP_MEDIA_FOUND_IMAGE_PADDING, PixelsSize(60), PixelsSize(25));
        m_statusLabel = [[StatusLabel alloc] initWithFrame:statusFrame andText:text andColor:QUIZZ_APP_FOUND_COLOR];
        
        [self addSubview:m_statusLabel];
        
        //Set media image
        [self setMedia:aMedia];
        
        //And check status
        [self checkStatus:replay];
    }
    return self;
}

- (void)setMedia:(Media *)aMedia {
    m_media = aMedia;
    
    UIImage * originalImage = [self.media imageWithLevelId:self.levelId];
    [self.posterImageView setImage:originalImage];
}

- (void)checkStatus:(Boolean)replay {
    Boolean mediaCompleted = replay ? self.media.isReplayCompleted : self.media.isCompleted;
    
    if (mediaCompleted) {
        [m_statusLabel setHidden:NO];
    } else {
        for (UIView * view in self.posterImageView.subviews) {
            [view removeFromSuperview];
        }
        
        if (!mediaCompleted) {
            for (int i=0; i<[self.media.topLeftBlurRects count]; i++) {
                CGPoint topLeftBlurRect = [[self.media.topLeftBlurRects objectAtIndex:i] CGPointValue];
                CGPoint bottomRightBlurRect = [[self.media.bottomRightBlurRects objectAtIndex:i] CGPointValue];
                
                [UtilsImage blurImageWithBottomRightBlurRect:bottomRightBlurRect andTopLeftBlurRect:topLeftBlurRect andOriginalImage:[self.media thumbImageWithLevelId:self.levelId] andDestinationView:self.posterImageView andFull:YES];
            }
        }
//        [UtilsImage blurImageWithBottomRightBlurRect:m_poster.bottomRightBlurRect andTopLeftBlurRect:m_poster.topLeftBlurRect andBlurImageView:m_blurImageView andOriginalImage:m_poster.thumbImage andParentViewSize:self.posterImageView.frame.size];
//        [UtilsImage blurImageWithPoster:m_poster andDestinationImageView:self.posterImageView andOriginalImage:m_poster.thumbImage];
        [m_statusLabel setHidden:YES];
    }
}

- (void)complete {
//    [self.media setIsCompleted:YES];
    
    for (UIView * view in self.posterImageView.subviews) {
        [view removeFromSuperview];
    }
    
    [m_statusLabel setHidden:NO];
}

@end
