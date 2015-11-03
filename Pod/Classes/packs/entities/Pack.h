//
//  Pack.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 06/10/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BasePack.h"

@interface Pack : BasePack

@property (nonatomic, strong) NSString * author;

@property (nonatomic, strong) NSString * language;

@property (nonatomic, strong) NSArray * medias;

@property (nonatomic, readonly) int possiblePoints;

+ (Pack *)Pack;

- (NSInteger)getNextPosterIndexWithCurrentIndex:(NSInteger)currentIndex andReplay:(Boolean)replay;

- (NSInteger)getLastCompleteIndex:(Boolean)replay;

- (void)restart;

- (Boolean)isReplayCompleted;

@end
