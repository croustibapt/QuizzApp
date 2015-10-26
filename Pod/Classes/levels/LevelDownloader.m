//
//  LevelDownloader.m
//  moviequizz
//
//  Created by dev_iphone on 14/03/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "LevelDownloader.h"

#import "ZipArchive.h"
#import "Utils.h"
#import "Constants.h"
#import "Level.h"
#import "LevelDBHelper.h"
#import "GameDBHelper.h"

@implementation LevelDownloader

- (id)initWithLevel:(BaseLevel *)level andListener:(id<PLevelDownloadListener>)listener {
    self = [super init];
    if (self) {
        m_level = level;
        m_listener = listener;
        m_data = [[NSMutableData alloc] init];
        m_currentDownloadSize = 0;
        
        //Create unzip path
        m_unzipPath = [[NSString alloc] initWithFormat:@"%@/level_%d", [Level levelsPath], m_level.identifier];
    }
    return self;
}

+ (void)downloadLevelWithLevel:(BaseLevel *)level andListener:(id<PLevelDownloadListener>)listener {
    LevelDownloader * levelDownloader = [[LevelDownloader alloc] initWithLevel:level andListener:listener];
    [levelDownloader downloadLevel];
}

- (Boolean)unzipLevelWithPath:(NSString *)path {
    ZipArchive * za = [[ZipArchive alloc] init];
    Boolean success = NO;
    
    //Open file
    if ([za UnzipOpenFile:path]) {
        //Unzip
        success = [za UnzipFileTo:m_unzipPath overWrite:YES];
        [za UnzipCloseFile];
    }
    
    return success;
}

- (void)downloadLevel {
    NSString * strUrl = [NSString stringWithFormat:@"%@%@/%d", QUIZZ_APP_SERVICE_PATH, QUIZZ_APP_SERVICE_DOWNLOAD_LEVEL, m_level.identifier];
    NSURL * url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:QUIZZ_APP_DOWNLOAD_REQUEST_TIMEOUT];

    m_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (Boolean)checkLevelMd5WithPath:(NSString *)path {
    NSString * fileMd5 = [Utils fileMD5:path];
    return [fileMd5 isEqualToString:m_level.md5];
}

#pragma mark - NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    NSInteger statusCode = [response statusCode];
    if (statusCode != 403) {
        m_continue = YES;
    } else {
        m_continue = NO;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (m_continue) {
        [m_data appendData:data];
        m_currentDownloadSize += [data length];
        
        //Notify listener
        [m_listener onDownloadProgressWithProgress:m_currentDownloadSize andTotal:m_level.zipSize andLevel:m_level];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	m_connection = nil;
    
    Boolean errorOccured = YES;
    
    if (m_continue) {
        //Create temp dir if not exists
        NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString * tempDirPath = [documentsDirectory stringByAppendingPathComponent:@"/Caches/temp"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:tempDirPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:tempDirPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString * tempPath = [NSString stringWithFormat:@"%@/%d_%lld.zip", tempDirPath, m_level.identifier, [Utils getMStime]];
        
        //Write data
        if ([m_data writeToFile:tempPath atomically:YES]) {
            //Check size and MD5
            if ((m_data.length == m_level.zipSize) && [self checkLevelMd5WithPath:tempPath]) {
                //Unzip level
                if ([self unzipLevelWithPath:tempPath]) {
                    //No error
                    errorOccured = NO;
                }
            } else {
                [[NSFileManager defaultManager] removeItemAtPath:tempPath error:nil];
            }
            
            //Delete old zip file
            [[NSFileManager defaultManager] removeItemAtPath:tempPath error:nil];
        }
        
        m_data = nil;
    }
    
    if (errorOccured) {
        [m_listener onDownloadDoneWithSuccess:NO andBaseLevel:m_level];
    } else {
        NSString * databasePath = [NSString stringWithFormat:@"%@/level_%d.sqlite", m_unzipPath, m_level.identifier];
        
        Level * level = [LevelDBHelper getLevel:databasePath];
        [GameDBHelper addLevel:level];
        
        [m_listener onDownloadDoneWithSuccess:YES andBaseLevel:m_level];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    [m_listener onDownloadDoneWithSuccess:NO andBaseLevel:m_level];
}

- (void)dealloc {
    [m_connection cancel];
}

@end
