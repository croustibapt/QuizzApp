//
//  LevelCell.h
//  moviequizz2
//
//  Created by Baptiste LE GUELVOUIT on 20/09/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Level.h"

@interface LevelCell : UICollectionViewCell

@property (nonatomic) Boolean touched;

@property (nonatomic, strong) UILabel * label;

@property (nonatomic, strong) UIColor * frontColor;

@property (nonatomic, strong) UIColor * backColor;

@property (nonatomic) float progression;

- (void)initializeWithLevel:(BaseLevel *)level;

@end
