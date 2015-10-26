//
//  PPackDownloadListener.h
//  moviequizz
//
//  Created by dev_iphone on 14/03/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseLevel.h"

@protocol PLevelDownloadListener <NSObject>

- (void)onDownloadProgressWithProgress:(int)progress andTotal:(int)total andLevel:(BaseLevel *)level;

- (void)onDownloadDoneWithSuccess:(Boolean)success andBaseLevel:(BaseLevel *)baseLevel;

@end
