//
//  PProgressAuthListener.h
//  quizzapp
//
//  Created by dev_iphone on 21/05/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PProgressAuthListener <NSObject>

- (void)onSignInDoneWithError:(NSError *)error;

- (void)onSignOutDoneWithError:(NSError *)error;

- (void)onGamesSignInDoneWithError:(NSError *)error;

- (void)onGamesSignOutDoneWithError:(NSError *)error;

- (void)onAuthDeclined;

@end
