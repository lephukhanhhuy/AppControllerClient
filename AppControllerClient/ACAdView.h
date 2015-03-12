//
//  ACAdView.h
//  AppControllerClient
//
//  Created by Le Huy on 2/25/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <StartApp/StartApp.h>

#define kBannerHeight ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?90:50)// Used the admob size

/*
 Add this view to anywhere you want, or use ACBaseViewController with the default banner is at bottom
 */
@interface ACAdView : UIView
@property (nonatomic, retain) GADBannerView *admobBannerView;
@property (nonatomic, retain) ADBannerView *iAdBannerView;
@property (nonatomic, retain) STABannerView *startAdBannerView;

@property UIViewController* rootViewController;

- (instancetype)initWithRootViewController:(UIViewController*) rootViewController;

- (void) sizeToFitWidthWithView:(UIView*) view;

- (void) refreshBanner;

@end
