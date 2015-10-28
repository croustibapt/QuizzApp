//
//  Pack.m
//  quizzapp
//
//  Created by Baptiste LE GUELVOUIT on 06/10/13.
//  Copyright (c) 2013 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "Pack.h"

#import "Media.h"
#import "Constants.h"
#import "GameDBHelper.h"

@implementation Pack

@synthesize author = m_author;
@synthesize language = m_language;
@synthesize medias = m_medias;
@synthesize possiblePoints;

+ (Pack *)Pack {
    Pack * pack = [[Pack alloc] init];
    return pack;
}

- (void)setMedias:(NSArray *)aMedias {
    m_medias = aMedias;
    
    [self refreshCompleted];
}

- (Boolean)isReplayCompleted {
    Boolean allCompleted = YES;
    
    for (Media * media in self.medias) {
        if (!media.isReplayCompleted) {
            allCompleted = NO;
            break;
        }
    }
    
    return allCompleted;
}

- (int)possiblePoints {
    //Get possible score
    float totalPoints = self.difficulty * QUIZZ_APP_PACK_POINTS_BASE;
    return round(totalPoints);
}

- (NSInteger)getNextPosterIndexWithCurrentIndex:(NSInteger)currentIndex andReplay:(Boolean)replay {
    NSInteger index = currentIndex;
    Boolean packCompleted = replay ? self.isReplayCompleted : self.isCompleted;
    
    if (!packCompleted) {
        for (int i = 0; i < [self.medias count]; i++) {
            index++;
            
            if (index > ([self.medias count]-1)) {
                index = 0;
            }
            
            Media * media = [self.medias objectAtIndex:index];
            Boolean mediaCompleted = replay ? media.isReplayCompleted : media.isCompleted;

            if (!mediaCompleted) {
                break;
            }
        }
        
        if (index >= [self.medias count]) {
            index = ([self.medias count] - 1);
        }
    }
    
    return index;
}

- (NSInteger)getLastCompleteIndex:(Boolean)replay {
    NSInteger index = 0;
    Boolean packCompleted = replay ? self.isReplayCompleted : self.isCompleted;

    if (!packCompleted) {
        for (Media * media in self.medias) {
            Boolean mediaCompleted = replay ? media.isReplayCompleted : media.isCompleted;

            if (mediaCompleted) {
                index++;
            } else {
                break;
            }
        }
        
        if (index >= [self.medias count]) {
            index = ([self.medias count] - 1);
        }
    }
    
    return index;
}

- (void)restart {
    [self setIsCompleted:NO];
    
    for (Media * media in self.medias) {
        [media setIsCompleted:NO];
    }
}

@end
