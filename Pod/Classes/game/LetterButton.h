//
//  LetterButton.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 18/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class GameAnswerView;

@interface LetterButton : UIButton

@property (nonatomic, strong) NSString * key;

@property (assign) GameAnswerView * gameAnswerView;

@property (nonatomic) Boolean touched;

- (id)initWithFrame:(CGRect)frame andKey:(NSString *)key andGameAnswerView:(GameAnswerView *)gameAnswerView;

- (void)showLetter:(NSString *)letter;

- (void)highlight;

@end
