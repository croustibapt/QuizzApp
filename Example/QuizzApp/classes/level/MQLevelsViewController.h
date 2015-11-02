//
//  MQLevelsViewController.h
//  moviequizz2
//
//  Created by Baptiste LE GUELVOUIT on 19/10/2014.
//  Copyright (c) 2014 Baptiste LE GUELVOUIT. All rights reserved.
//

#import "LevelsViewController.h"

#import "Preferences.h"
#import "FlatButton.h"

@interface MQLevelsViewController : LevelsViewController

USERPREF_DECL(NSNumber *, HasLocalLevels);

@end
