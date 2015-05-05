//
//  ACBaseViewController.h
//  AppControllerClient
//
//  Created by Le Huy on 2/25/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACAdView.h"

// If ad removed, set this key to YES
#define kUserKeyRemovedAd @"kUserKeyRemovedAd"

@interface ACBaseViewController : UIViewController
@property (nonatomic, retain) ACAdView *bannerView_;

// Call this when purchase success
- (void) removeAd;

- (void) refreshBanner;
- (void) refreshInterstital;
- (void) showInterstitial;

- (void) moveBannerToTop;

- (BOOL) shouldShowInterstitial;
@end
