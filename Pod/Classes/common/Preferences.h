//
//  Preferences.h
//  quizzapp
//
//  Created by dev_iphone on 22/05/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <Foundation/Foundation.h>

//Macros to declare a preference key (as a string)
#define USERPREF_STR_ROOT               @"USERPREF_"
#define DECL_USERPREF_STR(n)            NSString * const n = USERPREF_STR_ROOT#n

//Macros to build the getters (prototype and implementation)
#define GET_USERPREF_DECL(t, n)         +(t) get##n
#define GET_USERPREF_IMPL(t, n, v)      GET_USERPREF_DECL(t, n) { \
t const USERPREF_DEFAULT_##n = v; \
NSUserDefaults * p = [NSUserDefaults standardUserDefaults]; \
t ret = [p objectForKey:USERPREF_STR_ROOT#n]; \
return (ret == nil) ? USERPREF_DEFAULT_##n : ret; \
}

//Macros to build the setters (prototype and implementation)
#define SET_USERPREF_DECL(t, n)         +(void) set##n:(t)v
#define SET_USERPREF_IMPL(t, n)         SET_USERPREF_DECL(t, n) { \
NSUserDefaults * p = [NSUserDefaults standardUserDefaults]; \
[p setValue:v forKey:n]; \
[p synchronize]; \
}

//
#define RESET_USERPREF_DECL(n)          +(void) reset##n
#define RESET_USERPREF_IMPL(n, v)       RESET_USERPREF_DECL(n) { \
NSUserDefaults * p = [NSUserDefaults standardUserDefaults]; \
[p setValue:v forKey:n]; \
[p synchronize]; \
}

//Macro to build all the declarations for a given preference key
#define USERPREF_DECL(t, n)             SET_USERPREF_DECL(t, n); \
GET_USERPREF_DECL(t, n); \
RESET_USERPREF_DECL(n)

//Macro to build all the implementations for a given preference key (t : type, n : name, v : default value)
#define USERPREF_IMPL(t, n, v)          DECL_USERPREF_STR(n); \
SET_USERPREF_IMPL(t, n) \
GET_USERPREF_IMPL(t, n, v) \
RESET_USERPREF_IMPL(n, v)

//How to declare:
//in MY_CLASS.h: USERPREF_DECL(NSNumber *, MeasureTime);

//How to implement:
//in MY_CLASS.m: USERPREF_IMPL(NSNumber *, MeasureTime, [NSNumber numberWithInt:2]);

//How to set/get: [MY_CLASS getMeasureTime] and [MY_CLASS setMeasureTime]

@interface Preferences : NSObject

@end
