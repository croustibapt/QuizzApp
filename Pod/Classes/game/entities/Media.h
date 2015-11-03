//
//  Media.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 08/10/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Media : NSObject

@property (nonatomic) int identifier;

@property (nonatomic, strong) NSString * title;

@property (nonatomic, strong) NSString * rects;

@property (nonatomic, strong) NSArray * topLeftBlurRects;

@property (nonatomic, strong) NSArray * bottomRightBlurRects;

@property (nonatomic) int difficulty;

@property (nonatomic, strong) NSString * language;

@property (nonatomic, strong) NSString * strVariants;

@property (nonatomic, strong) NSArray * variants;

@property (nonatomic) Boolean isCompleted;

@property (nonatomic) Boolean isRemoteCompleted;

+ (Media *)Media;

+ (void)thumbImageWithMedia:(Media *)media andImageView:(UIImageView *)imageView andRadians:(float)radians andOriginalImage:(UIImage *)originalImage;

- (UIImage *)imageWithLevelId:(int)levelId;

- (UIImage *)thumbImageWithLevelId:(int)levelId;

- (Boolean)isReplayCompleted;

@end
