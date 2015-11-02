//
//  MediaView.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 14/12/2013.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Media.h"
#import "StatusLabel.h"

@interface MediaView : UIView {
    Media * m_media;
    StatusLabel * m_statusLabel;
}

@property (nonatomic, readwrite) int levelId;

@property (nonatomic, retain) Media * media;

@property (nonatomic, retain) UIImageView * posterImageView;

- (id)initWithFrame:(CGRect)frame andMedia:(Media *)media andLevelId:(int)levelId andReplay:(Boolean)replay;

- (void)complete;

@end
