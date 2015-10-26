//
//  PGameListener.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 10/12/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Media;

@protocol PGameListener <NSObject>

- (void)onMediaFound:(Media *)media;

- (void)onGoodWord:(NSString *)word;

- (void)onBadWord;

- (void)onLetterPressed:(Boolean)back;

@end
