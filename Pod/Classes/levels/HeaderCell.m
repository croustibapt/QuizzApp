//
//  HeaderCell.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 24/09/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "HeaderCell.h"

#import "Utils.h"

@implementation HeaderCell

@synthesize title = m_title;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setBackgroundColor:[UIColor clearColor]];

        //Title
        m_title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width-20, frame.size.height)];
        [m_title setTextColor:[UIColor whiteColor]];
        [m_title setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        
        float fontSize = PixelsSize(20.0);
        
        [m_title setFont:[UIFont fontWithName:@"RobotoCondensed-Regular" size:fontSize]];
        [m_title setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:m_title];
    }
    return self;
}

@end
