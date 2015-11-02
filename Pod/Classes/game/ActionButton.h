//
//  ActionButton.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 24/11/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameAnswerView;

typedef enum {
    QuizzAppActionDelete = 1,
    QuizzAppActionShuffle,
    QuizzAppActionHelp,
} EQuizzAppAction;

@interface ActionButton : UIButton

@property (nonatomic, readwrite) EQuizzAppAction action;

@property (assign) GameAnswerView * gameAnswerView;

- (id)initWithFrame:(CGRect)frame andAction:(EQuizzAppAction)action andGameAnswerView:(GameAnswerView *)gameAnswerView;

@end
