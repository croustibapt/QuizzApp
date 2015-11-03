//
//  LevelDownloader.h
//  moviequizz
//
//  Created by dev_iphone on 14/03/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseLevel.h"

@protocol LevelDownloadDelegate <NSObject>

- (void)onDownloadProgressWithProgress:(int)progress andTotal:(int)total andLevel:(BaseLevel *)level;

- (void)onDownloadDoneWithSuccess:(Boolean)success andBaseLevel:(BaseLevel *)baseLevel;

@end

@interface LevelDownloader : NSObject <NSURLConnectionDelegate>

+ (void)downloadLevelWithLevel:(BaseLevel *)level andDelegate:(id<LevelDownloadDelegate>)delegate;

@end
