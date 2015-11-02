//
//  LetterLabel.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 19/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LetterLabel : UILabel

@property (nonatomic, readwrite) Boolean goodString;

@property (nonatomic, retain) NSString * goodLetter;

@property (nonatomic, readwrite) Boolean found;

@property (nonatomic, readwrite) Boolean bad;

- (id)initWithFrame:(CGRect)frame andGoodLetter:(NSString *)goodLetter;

- (void)type:(NSString *)letter;

- (void)highlight;

@end
