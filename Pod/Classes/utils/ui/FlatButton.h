//
//  FlatButton.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 28/05/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlatButton : UIButton

@property (nonatomic) Boolean isTouched;

@property (nonatomic, strong) UIColor * frontColor;

@property (nonatomic, strong) UIColor * backColor;

@end
