//
//  ACHouseAdViewController.h
//  AppControllerClient
//
//  Created by Le Huy on 2/25/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 This view controller is only show a full screen image, is the banner of the house ad you want.
 If the house ads is available, the library will replace the interstitial ad by this view controller.
 */
@interface ACHouseAdViewController : UIViewController

@property UIImage* bannerImage;
@property NSString* appleId;
@property BOOL shouldHideStatusBar;

@end
