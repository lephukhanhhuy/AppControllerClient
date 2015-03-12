//
//  ACBaseTrackingViewController.h
//  AppControllerClient
//
//  Created by Le Huy on 2/28/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import "ACBaseViewController.h"

@interface ACBaseTrackingViewController : ACBaseViewController

- (void) trackEventButtonPress:(NSString*) buttonName;
- (void) trackEventBestScore:(NSString*) score;
- (void) trackEventBestScore:(NSString*) score withGameMode:(NSString*) gameMode;
- (void)trackScreenName:(NSString *)screen;

@end
