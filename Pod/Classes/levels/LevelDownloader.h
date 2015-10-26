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

@interface LevelDownloader : NSObject <NSURLConnectionDelegate> {
    BaseLevel * m_level;
    id<PLevelDownloadListener> m_listener;
    
    NSString * m_unzipPath;
    
    NSURLConnection * m_connection;
    NSMutableData * m_data;
    
    int m_currentDownloadSize;
    Boolean m_continue;
}

+ (void)downloadLevelWithLevel:(BaseLevel *)level andListener:(id<PLevelDownloadListener>)listener;

@end
