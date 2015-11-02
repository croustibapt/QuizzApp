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

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setBackgroundColor:[UIColor clearColor]];

        //Title
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width-20, frame.size.height)];
        [self.title setTextColor:[UIColor whiteColor]];
        [self.title setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        
        float fontSize = PixelsSize(20.0);
        
        [self.title setFont:[UIFont fontWithName:@"RobotoCondensed-Regular" size:fontSize]];
        [self.title setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:self.title];
    }
    return self;
}

@end
