//
//  Application.m
//  moviequizz2
//
//  Created by Baptiste LE GUELVOUIT on 06/01/2015.
//  Copyright (c) 2015 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "Application.h"

#import "ProgressManager.h"

@implementation Application

- (BOOL)openURL:(NSURL *)url {
    if ([[url absoluteString] hasPrefix:@"googlechrome-x-callback:"]) {
        return NO;
    } else if ([[url absoluteString] hasPrefix:@"https://accounts.google.com/o/oauth2/auth"]) {
        //Register for Google + requests
        [[NSNotificationCenter defaultCenter] postNotificationName:ApplicationOpenGoogleAuthNotification object:url];
        
        return NO;
    }
    
    return [super openURL:url];
}

@end
