//
//  PProgressGamesListener.h
//  quizzapp
//
//  Created by dev_iphone on 27/05/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PProgressGamesListener <NSObject>

- (void)onGamesSaveDoneWithError:(NSError *)error;

- (void)onGamesLoadDoneWithError:(NSError *)error;

@end
