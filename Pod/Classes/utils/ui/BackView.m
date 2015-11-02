//
//  BackView.m
//  quizzapp
//
//  Created by dev_iphone on 12/06/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "BackView.h"

#import "QuizzApp.h"

@implementation BackView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
//    NSLog(@"afn");
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    float width = rect.size.width;
    float height = rect.size.height;
    
    float middle1 = width / 4.0;
    float middle2 = width / 2.0;
    
    CGPoint topLeft = CGPointMake(0.0, -40.0);
    CGPoint topMiddle1 = CGPointMake(middle1, -40.0);
    CGPoint topMiddle2 = CGPointMake(middle2, -40.0);
    CGPoint topRight = CGPointMake(width, -40.0);
    
    CGPoint bottomLeft = CGPointMake(0.0, height);
    CGPoint bottomMiddle = CGPointMake(middle2, height);
    CGPoint bottomRight = CGPointMake(width, height);
    
    QuizzApp * quizzApp = [QuizzApp sharedInstance];
    
    //Background
    CGContextBeginPath(ctx);
    CGContextMoveToPoint   (ctx, topLeft.x, topLeft.y);
    CGContextAddLineToPoint(ctx, topRight.x, topRight.y);
    CGContextAddLineToPoint(ctx, bottomRight.x, bottomRight.y);
    CGContextAddLineToPoint(ctx, bottomLeft.x, bottomLeft.y);
    CGContextClosePath(ctx);
    
    UIColor * thirdColor = quizzApp.thirdColor;
    CGFloat tr, tg, tb, ta;
    [thirdColor getRed:&tr green:&tg blue:&tb alpha:&ta];
    
    CGContextSetRGBFillColor(ctx, tr, tg, tb, ta);
    CGContextFillPath(ctx);
    
    //First triangle
    CGContextBeginPath(ctx);
    CGContextMoveToPoint   (ctx, topLeft.x, topLeft.y);
    CGContextAddLineToPoint(ctx, topMiddle2.x, topMiddle2.y);
    CGContextAddLineToPoint(ctx, bottomRight.x, bottomRight.y);
    CGContextAddLineToPoint(ctx, bottomLeft.x, bottomLeft.y);
    CGContextClosePath(ctx);
    
    UIColor * secondColor = quizzApp.secondColor;
    CGFloat sr, sg, sb, sa;
    [secondColor getRed:&sr green:&sg blue:&sb alpha:&sa];
    
    CGContextSetRGBFillColor(ctx, sr, sg, sb, sa);
    CGContextFillPath(ctx);
    
    //Second triangle
    CGContextBeginPath(ctx);
    CGContextMoveToPoint   (ctx, topLeft.x, topLeft.y);
    CGContextAddLineToPoint(ctx, topMiddle1.x, topMiddle1.y);
    CGContextAddLineToPoint(ctx, bottomMiddle.x, bottomMiddle.y);
    CGContextAddLineToPoint(ctx, bottomLeft.x, bottomLeft.y);
    CGContextClosePath(ctx);
    
    UIColor * mainColor = quizzApp.mainColor;
    CGFloat mr, mg, mb, ma;
    [mainColor getRed:&mr green:&mg blue:&mb alpha:&ma];
    
    CGContextSetRGBFillColor(ctx, mr, mg, mb, ma);
    CGContextFillPath(ctx);
}

@end
