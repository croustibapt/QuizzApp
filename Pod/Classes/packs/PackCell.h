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

@interface PackCell : UITableViewCell

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
