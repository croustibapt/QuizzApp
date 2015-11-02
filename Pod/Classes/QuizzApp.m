//
//  QuizzApp.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 11/06/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "QuizzApp.h"

@implementation QuizzApp

+ (QuizzApp *)sharedInstance {
    static QuizzApp * s_sharedQuizzAppInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        s_sharedQuizzAppInstance = [[self alloc] init];
    });
    
    return s_sharedQuizzAppInstance;
}

@end
