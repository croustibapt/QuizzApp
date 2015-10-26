//
//  Media.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 08/10/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Media : NSObject {
    NSString * m_title;
    NSString * m_rects;
    NSArray * m_topLeftBlurRects;
    NSArray * m_bottomRightBlurRects;
    NSString * m_language;
    NSString * m_strVariants;
    NSArray * m_variants;
    Boolean m_isCompleted;
    Boolean m_isRemoteCompleted;
}

@property (nonatomic, readwrite) int identifier;

@property (nonatomic, retain) NSString * title;

@property (nonatomic, retain) NSString * rects;

@property (nonatomic, retain) NSArray * topLeftBlurRects;

@property (nonatomic, retain) NSArray * bottomRightBlurRects;

@property (nonatomic, readwrite) int difficulty;

@property (nonatomic, retain) NSString * language;

@property (nonatomic, retain) NSString * strVariants;

@property (nonatomic, retain) NSArray * variants;

@property (nonatomic, readwrite) Boolean isCompleted;

@property (nonatomic, readwrite) Boolean isRemoteCompleted;

+ (Media *)Media;

+ (void)thumbImageWithMedia:(Media *)media andImageView:(UIImageView *)imageView andRadians:(float)radians andOriginalImage:(UIImage *)originalImage;

- (UIImage *)imageWithLevelId:(int)levelId;

- (UIImage *)thumbImageWithLevelId:(int)levelId;

- (Boolean)isReplayCompleted;

@end
