//
//  ACHouseAdView.h
//  AppControllerClient
//
//  Created by Le Huy on 2/25/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 When the house ads is available, this view will show a small button with text content "Play <house ads app name>".
 Add this view to where you want, it mays be at your Home screen
 */

@interface ACHouseAdView : UIView
@property(weak) UIViewController* rootViewController;

- (void) setButtonColor:(UIColor*) color;

@end
