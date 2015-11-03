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

@property (nonatomic, strong) IBOutlet UIView * postersView;

@property (nonatomic, strong) IBOutlet UIImageView * poster1;

@property (nonatomic, strong) IBOutlet UIImageView * poster2;

@property (nonatomic, strong) IBOutlet UIImageView * poster3;

@property (nonatomic, strong) IBOutlet UILabel * nameLabel;

@property (nonatomic, strong) IBOutlet UILabel * pointsLabel;

@property (nonatomic, strong) IBOutlet UILabel * finishedLabel;

@property (nonatomic, strong) IBOutletCollection(DotView) NSArray * dotsCollection;

@property (nonatomic) Boolean touched;

@property (nonatomic, strong) UIColor * mainColor;

@property (nonatomic, strong) UIColor * secondColor;

- (void)initializeWithPack:(Pack *)pack;

@end
