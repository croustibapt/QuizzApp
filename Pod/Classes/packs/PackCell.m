//
//  PackCell.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 07/10/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "PackCell.h"

#import "UtilsColors.h"
#import "Media.h"
#import "Utils.h"
#import "Constants.h"
#import "UtilsImage.h"

@implementation PackCell

@synthesize postersView = m_postersView;
@synthesize poster1 = m_poster1;
@synthesize poster2 = m_poster2;
@synthesize poster3 = m_poster3;
@synthesize nameLabel = m_nameLabel;
@synthesize pointsLabel = m_pointsLabel;
@synthesize finishedLabel = m_finishedLabel;
@synthesize dotsCollection = m_dotsCollection;
@synthesize touched = m_touched;
@synthesize mainColor = m_mainColor;
@synthesize secondColor = m_secondColor;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setTouched:(Boolean)touched {
    if (!m_contentViewInitialized) {
        m_originFrame = self.contentView.frame;
        m_contentViewInitialized = YES;
    }
    
    m_touched = touched;
    [self setNeedsDisplay];
}

- (void)awakeFromNib {
    m_contentViewInitialized = NO;
    
    float labelFont = PixelsSize(25.0);
    [self.nameLabel setFont:[UIFont fontWithName:@"RobotoCondensed-Regular" size:labelFont]];
    
    if (IS_IOS_5) {
        [self setSelectionStyle:UITableViewCellSelectionStyleBlue];
    } else {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundView:[[UIView alloc] initWithFrame:CGRectZero]];
    }
}

- (void)setColors:(Pack *)pack {
    float difficulty = pack.difficulty;
    
    UIColor * mainColor = [BasePack getColorWithDifficulty:difficulty];
    [self setMainColor:mainColor];
    
    UIColor * secondColor = [BasePack getDarkColorWithDifficulty:difficulty];
    [self setSecondColor:secondColor];
    
    if (IS_IOS_5) {
        [self setBackgroundColor:self.mainColor];
    }
}

- (void)setPosters:(Pack *)pack {
    if ([pack isKindOfClass:[Pack class]]) {
        int levelId = pack.levelId;
        
        if ([pack.medias count] > 0) {
            Media * media1 = [pack.medias objectAtIndex:0];
            
            UIImage * thumbImage1 = [media1 thumbImageWithLevelId:levelId];
            [Media thumbImageWithMedia:media1 andImageView:self.poster1 andRadians:[Utils degreesToRadians:-10.0] andOriginalImage:thumbImage1];
            [self.poster1.layer setBorderWidth:1.0];
            [self.poster1.layer setBorderColor:[UIColor whiteColor].CGColor];
            
            [self.poster1 setClipsToBounds:NO];
            
            if ([pack.medias count] > 1) {
                Media * media2 = [pack.medias objectAtIndex:1];
                
                UIImage * thumbImage2 = [media2 thumbImageWithLevelId:levelId];
                [Media thumbImageWithMedia:media2 andImageView:self.poster2 andRadians:[Utils degreesToRadians:0.0] andOriginalImage:thumbImage2];
                [self.poster2.layer setBorderWidth:1.0];
                [self.poster2.layer setBorderColor:[UIColor whiteColor].CGColor];
                
                [self.poster2 setClipsToBounds:NO];
            }
            
            if ([pack.medias count] > 2) {
                Media * media3 = [pack.medias objectAtIndex:2];
                
                UIImage * thumbImage3 = [media3 thumbImageWithLevelId:levelId];
                [Media thumbImageWithMedia:media3 andImageView:self.poster3 andRadians:[Utils degreesToRadians:10.0] andOriginalImage:thumbImage3];
                [self.poster3.layer setBorderWidth:1.0];
                [self.poster3.layer setBorderColor:[UIColor whiteColor].CGColor];
                
                [self.poster3 setClipsToBounds:NO];
            }
        }
    }
}

- (void)setProgress:(Pack *)pack {
    if ([pack isKindOfClass:[Pack class]]) {
        int i = 0;
        
        for (DotView * dotView in self.dotsCollection) {
            if (i >= [pack.medias count]) {
                break;
            }
            
            Media * media = [pack.medias objectAtIndex:i];
            if (media.isCompleted) {
                [dotView setAlpha:1.0];
                [dotView setColor:GOLD_COLOR];
            } else {
                [dotView setAlpha:0.5];
                [dotView setColor:WHITE_COLOR];
            }
            
            i++;
        }
    }
}

- (void)initializeWithPack:(Pack *)pack {
    //Colors
    [self setColors:pack];
    
    //Title
    [self.nameLabel setText:[pack.title uppercaseString]];
    
    //Points
    float pointsFont = PixelsSize(15.0);
    
    //Font
    if (pack.isCompleted) {
        [self.pointsLabel setFont:[UIFont fontWithName:@"RobotoCondensed-Bold" size:pointsFont]];
    } else {
        [self.pointsLabel setFont:[UIFont fontWithName:@"RobotoCondensed-Regular" size:pointsFont]];
    }
    
    //Text color
    [self.pointsLabel setTextColor:[UIColor colorWithWhite:1.0 alpha:(pack.isCompleted ? 1.0 : 0.3)]];
    
    //Text
    if ([pack respondsToSelector:@selector(possiblePoints)]) {
        [self.pointsLabel setText:[NSString stringWithFormat:@"%d %@", pack.possiblePoints, NSLocalizedStringFromTableInBundle(@"STR_POINTS", nil, QUIZZ_APP_LANGUAGE_BUNDLE, nil)]];
    }
    
    //Finished image    
    [m_finishedLabel setText:NSLocalizedStringFromTableInBundle(@"STR_FINISHED", nil, QUIZZ_APP_LANGUAGE_BUNDLE, nil)];
    [m_finishedLabel setHidden:!pack.isCompleted];
    [m_finishedLabel setBackgroundColor:QUIZZ_APP_FOUND_COLOR];
    
    //Images
    [self setPosters:pack];
    
    //Progress
    [self setProgress:pack];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    float radius = PixelsSize(QA_ROUND_RADIUS);
    float offset = PixelsSize(5.0);
    
    if (!IS_IOS_5) {
        CGRect boundingRect = CGRectMake(rect.origin.x + offset, rect.origin.y, rect.size.width - (offset * 2), rect.size.height);
        
        if (!m_touched) {
            UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:boundingRect cornerRadius:radius];
            [self.secondColor setFill];
            [path fill];
            
            UIBezierPath * path2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(boundingRect.origin.x, boundingRect.origin.y, boundingRect.size.width, boundingRect.size.height - offset) cornerRadius:radius];
            [self.mainColor setFill];
            [path2 fill];
            
            if (m_contentViewInitialized) {
                [self.contentView setFrame:m_originFrame];
            }
        } else {
            float pressedOffset = PixelsSize(3.0);
            
            UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(boundingRect.origin.x, boundingRect.origin.y + pressedOffset, boundingRect.size.width, boundingRect.size.height - pressedOffset) cornerRadius:radius];
            [self.secondColor setFill];
            [path fill];
            
            UIBezierPath * path2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(boundingRect.origin.x, boundingRect.origin.y + pressedOffset, boundingRect.size.width, boundingRect.size.height - offset) cornerRadius:radius];
            [self.mainColor setFill];
            [path2 fill];
            
            [self.contentView setFrame:CGRectOffset(m_originFrame, 0, pressedOffset)];
        }
    }
}

@end
