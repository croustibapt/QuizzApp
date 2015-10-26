//
//  FlatButton.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 28/05/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "FlatButton.h"

float const QA_FLAT_BUTTON_DISABLED_ALPHA = 0.25;

#import "Utils.h"
#import "UtilsColors.h"
#import "Constants.h"

@implementation FlatButton

@synthesize isTouched = m_isTouched;
@synthesize frontColor = m_frontColor;
@synthesize backColor = m_backColor;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIColor *)backColor {
    if (self.enabled) {
        return m_backColor;
    } else {
        return [UtilsColors changeColorAlphaWithColor:m_backColor andAlpha:QA_FLAT_BUTTON_DISABLED_ALPHA];
    }
}

- (UIColor *)frontColor {
    if (self.enabled) {
        return m_frontColor;
    } else {
        return [UtilsColors changeColorAlphaWithColor:m_frontColor andAlpha:QA_FLAT_BUTTON_DISABLED_ALPHA];
    }
}

- (void)setIsTouched:(Boolean)isTouched {
    m_isTouched = isTouched;
    [self setNeedsDisplay];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    title = [title uppercaseString];
    [super setTitle:title forState:state];
    
    [self setNeedsDisplay];
}

- (void)awakeFromNib {
    [self setIsTouched:NO];
    
    float buttonFont = PixelsSize(22.0);

    [self.titleLabel setFont:[UIFont fontWithName:@"RobotoCondensed-Bold" size:buttonFont]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self setIsTouched:YES];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    [self setIsTouched:self.touchInside];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    [self setIsTouched:NO];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    
    [self setIsTouched:NO];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //Radius
    float radius = PixelsSize(QA_ROUND_RADIUS);
    float offset = PixelsSize(5.0);
    
    if (!m_isTouched) {
        self.titleEdgeInsets = UIEdgeInsetsMake(-offset, 0, 0, 0);
        
        //Back
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
        [self.backColor setFill];
        [path fill];
        
        //Front
        UIBezierPath * path2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - offset) cornerRadius:radius];
        [self.frontColor setFill];
        [path2 fill];
    } else {
        float pressedOffset = PixelsSize(3.0);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        //Back
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x, rect.origin.y + pressedOffset, rect.size.width, rect.size.height - pressedOffset) cornerRadius:radius];
        [self.backColor setFill];
        [path fill];
        
        //Front
        UIBezierPath * path2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x, rect.origin.y + pressedOffset, rect.size.width, rect.size.height - offset) cornerRadius:radius];
        [self.frontColor setFill];
        [path2 fill];
    }
}

@end
