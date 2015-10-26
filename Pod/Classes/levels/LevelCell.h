//
//  LevelCell.h
//  moviequizz2
//
//  Created by Baptiste LE GUELVOUIT on 20/09/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PSTCollectionView.h"
#import "Level.h"

@interface LevelCell : PSUICollectionViewCell {
    Boolean m_downloaded;
    Boolean m_touched;
    CGRect m_originFrame;
    
    UILabel * m_label;
    UIColor * m_frontColor;
    UIColor * m_backColor;
    
    UILabel * m_pack1Label;
    UILabel * m_pack2Label;
    UILabel * m_pack3Label;
}

@property (nonatomic, readwrite) Boolean touched;

@property (nonatomic, retain) UILabel * label;

@property (nonatomic, retain) UIColor * frontColor;

@property (nonatomic, retain) UIColor * backColor;

@property (nonatomic, readwrite) float progression;

- (void)initializeWithLevel:(BaseLevel *)level;

@end
