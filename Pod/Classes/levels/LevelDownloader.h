//
//  LevelDownloader.h
//  moviequizz
//
//  Created by dev_iphone on 14/03/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseLevel.h"
#import "PLevelDownloadListener.h"

@interface LevelDownloader : NSObject <NSURLConnectionDelegate>

+ (void)downloadLevelWithLevel:(BaseLevel *)level andListener:(id<PLevelDownloadListener>)listener;

@end
