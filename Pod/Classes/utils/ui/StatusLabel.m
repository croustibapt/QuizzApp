//
//  StatusLabel.m
//  quizzapp
//
//  Created by dev_iphone on 04/06/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "StatusLabel.h"

#import "Utils.h"

@implementation StatusLabel

- (id)initWithFrame:(CGRect)frame andText:(NSString *)text andColor:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        //Text
        [self setText:text];
        
        //Color
        [self setBackgroundColor:color];
        
        [self initialize];
    }
    return self;
}

- (void)setText:(NSString *)text {
    [super setText:[text uppercaseString]];
}

- (void)initialize {
    [self setTextAlignment:NSTextAlignmentCenter];
    [self setTextColor:[UIColor whiteColor]];
    
    //Font
    float labelFont = PixelsSize(16.0);
    [self setFont:[UIFont fontWithName:@"RobotoCondensed-Regular" size:labelFont]];
}

- (void)awakeFromNib {
    [self initialize];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
