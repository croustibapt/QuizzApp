//
//  DotView.m
//  quizzapp
//
//  Created by dev_iphone on 10/12/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "DotView.h"

@implementation DotView

@synthesize color = m_color;

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)setColor:(UIColor *)color {
    m_color = color;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextAddEllipseInRect(context, rect);
    CGContextSetFillColor(context, CGColorGetComponents([m_color CGColor]));
    CGContextFillPath(context);
}

@end
