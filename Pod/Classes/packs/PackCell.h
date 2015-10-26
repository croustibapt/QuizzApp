//
//  PackCell.h
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 07/10/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Pack.h"
#import "DotView.h"

@interface PackCell : UITableViewCell {
    Boolean m_contentViewInitialized;
    Boolean m_touched;
    CGRect m_originFrame;
    
    UIView * m_postersView;
    UIImageView * m_poster1;
    UIImageView * m_poster2;
    UIImageView * m_poster3;
    UILabel * m_nameLabel;
    UILabel * m_pointsLabel;
    UILabel * m_finishedLabel;
    NSArray * m_dotsCollection;
    
    UIColor * m_mainColor;
    UIColor * m_secondColor;
}

@property (nonatomic, retain) IBOutlet UIView * postersView;

@property (nonatomic, retain) IBOutlet UIImageView * poster1;

@property (nonatomic, retain) IBOutlet UIImageView * poster2;

@property (nonatomic, retain) IBOutlet UIImageView * poster3;

@property (nonatomic, retain) IBOutlet UILabel * nameLabel;

@property (nonatomic, retain) IBOutlet UILabel * pointsLabel;

@property (nonatomic, retain) IBOutlet UILabel * finishedLabel;

@property (nonatomic, retain) IBOutletCollection(DotView) NSArray * dotsCollection;

@property (nonatomic, readwrite) Boolean touched;

@property (nonatomic, retain) UIColor * mainColor;

@property (nonatomic, retain) UIColor * secondColor;

- (void)initializeWithPack:(Pack *)pack;

@end
