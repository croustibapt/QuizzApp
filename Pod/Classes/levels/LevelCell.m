//
//  LevelCell.m
//  moviequizz2
//
//  Created by Baptiste LE GUELVOUIT on 20/09/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "LevelCell.h"

#import "UtilsColors.h"
#import "Utils.h"
#import "Constants.h"
#import "BasePack.h"
#import "QuizzApp.h"

@implementation LevelCell

@synthesize touched = m_touched;
@synthesize label = m_label;
@synthesize frontColor = m_frontColor;
@synthesize backColor = m_backColor;
@synthesize progression;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        m_originFrame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
        
        float padding = PixelsSize(5.0);
        float cellHeight = (m_originFrame.size.height - (3 * padding));
        float cellWidth = (m_originFrame.size.width - (2 * padding));
        float quarterHeight = (cellHeight / 4.0);

        //Title
        m_label = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, cellWidth, quarterHeight)];
        [m_label setUserInteractionEnabled:NO];
        [m_label setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [m_label setTextAlignment:NSTextAlignmentRight];
        [m_label setBackgroundColor:[UIColor clearColor]];

        float fontSize = PixelsSize(24.0);
        [m_label setFont:[UIFont fontWithName:@"Roboto-Bold" size:fontSize]];
        
        [self.contentView addSubview:m_label];
        
        float packLabelHeight = ((cellHeight - quarterHeight - padding) / 3.0);
        
        //Pack label 1
        float y = (padding * 2) + quarterHeight;
        m_pack1Label = [[UILabel alloc] initWithFrame:CGRectMake(padding, y, cellWidth, packLabelHeight)];
        [self stylePackLabel:m_pack1Label];
        [self.contentView addSubview:m_pack1Label];
        
        //Pack label 2
        y += packLabelHeight;
        m_pack2Label = [[UILabel alloc] initWithFrame:CGRectMake(padding, y, cellWidth, packLabelHeight)];
        [self stylePackLabel:m_pack2Label];
        [self.contentView addSubview:m_pack2Label];
        
        //Pack label 3
        y += packLabelHeight;
        m_pack3Label = [[UILabel alloc] initWithFrame:CGRectMake(padding, y, cellWidth, packLabelHeight)];
        [self stylePackLabel:m_pack3Label];
        [self.contentView addSubview:m_pack3Label];
    }
    return self;
}

- (void)stylePackLabel:(UILabel *)packLabel {
    float fontSize = PixelsSize(12.0);
    
    [packLabel setBackgroundColor:[UIColor clearColor]];
    [packLabel setFont:[UIFont fontWithName:@"RobotoCondensed-Bold" size:fontSize]];
    [packLabel setUserInteractionEnabled:NO];
    [packLabel setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [packLabel setTextAlignment:NSTextAlignmentLeft];
}

- (void)stylePackLabelWithPackLabel:(UILabel *)packLabel andBasePack:(BasePack *)basePack andIsCompleted:(Boolean)isCompleted {
    UIColor * textColor = GOLD_DARK_COLOR;
    if (!isCompleted) {
        textColor = [BasePack getColorWithDifficulty:basePack.difficulty];
    }
    
    [packLabel setTextColor:textColor];
    [packLabel setText:[basePack.title uppercaseString]];
}

- (void)setTouched:(Boolean)touched {
    m_touched = touched;
    [self setNeedsDisplay];
}

- (void)initializeWithLevel:(BaseLevel *)level {
    //Label
    [m_label setText:[NSString stringWithFormat:@"%d", level.value]];
    
    //Colors
    m_downloaded = [level isKindOfClass:[Level class]];
    float alpha = (m_downloaded ? 1.0 : 0.5);
    [self.contentView setAlpha:alpha];
    
    //Progression
    float progress = level.progression;
    [self setProgression:progress];
    
    //Packs
    NSMutableArray * basePacks = [NSMutableArray arrayWithArray:[level.basePacks allValues]];
    
    NSSortDescriptor * sorter = [NSSortDescriptor sortDescriptorWithKey:@"difficulty" ascending:YES];
    NSArray * sortDescriptors = [NSArray arrayWithObject:sorter];
    [basePacks sortUsingDescriptors:sortDescriptors];
    
    UIColor * cellBackColor = [UtilsColors changeColorAlphaWithColor:GRAY_LIGHT_COLOR andAlpha:alpha];
    UIColor * cellFrontColor = [UtilsColors changeColorAlphaWithColor:WHITE_COLOR andAlpha:alpha];
    UIColor * textColor = [UtilsColors changeColorAlphaWithColor:GRAY_COLOR andAlpha:alpha];
    
    if ([basePacks count] > 0) {
        [self stylePackLabelWithPackLabel:m_pack1Label andBasePack:[basePacks objectAtIndex:0] andIsCompleted:level.isCompleted];
    }
    if ([basePacks count] > 1) {
        [self stylePackLabelWithPackLabel:m_pack2Label andBasePack:[basePacks objectAtIndex:1] andIsCompleted:level.isCompleted];
    }
    if ([basePacks count] > 2) {
        [self stylePackLabelWithPackLabel:m_pack3Label andBasePack:[basePacks objectAtIndex:2] andIsCompleted:level.isCompleted];
    }
    
    //Title
    if (level.isCompleted) {
        //Rect colors
        cellBackColor = [UtilsColors changeColorAlphaWithColor:GOLD_DARK_COLOR andAlpha:alpha];
        cellFrontColor = [UtilsColors changeColorAlphaWithColor:GOLD_COLOR andAlpha:alpha];
        textColor = [UtilsColors changeColorAlphaWithColor:GOLD_DARK_COLOR andAlpha:alpha];
    }
    
    //Set colors
    [self setBackColor:cellBackColor];
    [self setFrontColor:cellFrontColor];
    [m_label setTextColor:textColor];
    
    //Background
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    float radius = PixelsSize(QA_ROUND_RADIUS);
    float offset = PixelsSize(5.0);
    
    float alpha = (m_downloaded ? 1.0 : 0.5);
    UIColor * backColor = [UtilsColors changeColorAlphaWithColor:GOLD_DARK_COLOR andAlpha:alpha];
    UIColor * frontColor = [UtilsColors changeColorAlphaWithColor:GOLD_COLOR andAlpha:alpha];

    if (!m_touched) {
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
        [self.backColor setFill];
        [path fill];
        
        //Progression
        float width = rect.size.width * self.progression;
        
        if (self.progression < 1.0) {
            UIBezierPath * backProgressionPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height) byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft) cornerRadii:CGSizeMake(radius, radius)];
            [backColor setFill];
            [backProgressionPath fill];
        }
        
        UIBezierPath * path2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - offset) cornerRadius:radius];
        [self.frontColor setFill];
        [path2 fill];
        
        //Progression
        if (self.progression < 1.0) {
            UIBezierPath * progressionPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height - offset) byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft) cornerRadii:CGSizeMake(radius, radius)];
            [frontColor setFill];
            [progressionPath fill];
        }
        
        [self.contentView setFrame:m_originFrame];
    } else {
        float pressedOffset = PixelsSize(3.0);
        
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x, rect.origin.y + pressedOffset, rect.size.width, rect.size.height - pressedOffset) cornerRadius:radius];
        [self.backColor setFill];
        [path fill];
        
        //Progression
        float width = rect.size.width * self.progression;
        
        if (self.progression < 1.0) {
            UIBezierPath * backProgressionPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x, rect.origin.y + pressedOffset, width, rect.size.height - pressedOffset) byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft) cornerRadii:CGSizeMake(radius, radius)];
            [backColor setFill];
            [backProgressionPath fill];
        }
        
        UIBezierPath * path2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x, rect.origin.y + pressedOffset, rect.size.width, rect.size.height - offset) cornerRadius:radius];
        [self.frontColor setFill];
        [path2 fill];
        
        //Progression
        if (self.progression < 1.0) {
            UIBezierPath * progressionPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x, rect.origin.y + pressedOffset, width, rect.size.height - offset) byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft) cornerRadii:CGSizeMake(radius, radius)];
            [frontColor setFill];
            [progressionPath fill];
        }
        
        [self.contentView setFrame:CGRectOffset(m_originFrame, 0, pressedOffset)];
    }
}

@end
