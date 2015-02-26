//
//  ACBaseViewController.m
//  AppControllerClient
//
//  Created by Le Huy on 2/25/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import "ACBaseViewController.h"
#import "ACAppClient.h"

@interface ACBaseViewController ()

@end

@implementation ACBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.bannerView_ sizeToFitWidthWithView:self.view];
}

- (void) removeAd {
    if (self.bannerView_ != nil) {
        [self.bannerView_ removeFromSuperview];
        self.bannerView_ = nil;
    }
}
- (void) moveBannerToTop {
    [self.view bringSubviewToFront:self.bannerView_];
}
- (void) refreshInterstital {
    [[ACAppClient sharedInstance] setupInterstitial];
}
- (void) showInterstitial {
    [[ACAppClient sharedInstance] showInterstitial];
}
- (void) refreshBanner {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kUserKeyRemovedAd] boolValue] == YES) {
        if (self.bannerView_ != nil) {
            [self.bannerView_ removeFromSuperview];
            self.bannerView_ = nil;
        }
        return;
    }
    if (self.bannerView_ == nil) {
        self.bannerView_ = [[ACAdView alloc] initWithRootViewController:self];
        [self.view addSubview:self.bannerView_];
        CGRect frame = self.bannerView_.frame;
        frame.origin.y = self.view.frame.size.height - frame.size.height;
        self.bannerView_.frame = frame;
    }
    [self.view bringSubviewToFront:self.bannerView_];
}


- (void)dealloc
{
    self.bannerView_ = nil;
}

@end
