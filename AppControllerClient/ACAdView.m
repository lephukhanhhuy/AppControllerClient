//
//  ACAdView.m
//  AppControllerClient
//
//  Created by Le Huy on 2/25/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import "ACAdView.h"
#import "ACAppClient.h"

@interface ACAdView ()<ADBannerViewDelegate>

@end

@implementation ACAdView
- (instancetype)initWithRootViewController:(UIViewController*) rootViewController
{
    self = [super initWithFrame:CGRectMake(0,
                                           rootViewController.view.frame.size.height - kBannerHeight,
                                           rootViewController.view.frame.size.width,
                                           kBannerHeight)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.rootViewController = rootViewController;
    }
    return self;
}
- (void)dealloc
{
    self.iAdBannerView = nil;
    self.startAdBannerView = nil;
    self.admobBannerView = nil;
}
- (void)layoutSubviews {
    [super layoutSubviews];    
    // Update the real banner here
    self.admobBannerView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.iAdBannerView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.startAdBannerView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (void) sizeToFitWidthWithView:(UIView*) view {
    self.frame = CGRectMake(0, view.bounds.size.height - kBannerHeight, view.bounds.size.width, kBannerHeight);
    NSLog(@"%@", NSStringFromCGRect(self.frame));
}

- (void) refreshBanner {
    kAdServiceID adServiceId = [[ACAppClient sharedInstance] adServiceId];
    switch (adServiceId) {
        case kAdServiceIad:
        {
            [self setupIad];
            break;
        }
        case kAdServiceStartApp:
        {
            STAStartAppSDK* sdk = [STAStartAppSDK sharedInstance];
            sdk.appID = [[ACAppClient sharedInstance].delegate startAppAppID];
            sdk.devID = [[ACAppClient sharedInstance].delegate startAppDeveloperID];
            [self setupStartApp];
            break;
        }
        default:// Admob
            [self setupAdmob];
            break;
    }
}
- (void) setupStartApp {
    NSLog(@"setup banner STARTAPP");
    [self cleanAllAds];
    self.startAdBannerView = [[STABannerView alloc] initWithSize:STA_AutoAdSize autoOrigin:STAAdOrigin_Top
                                            withView:self withDelegate:nil];
    [self addSubview:self.startAdBannerView];
}
- (void) setupIad {
    NSLog(@"setup banner iAd");
    [self cleanAllAds];
    if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
        self.iAdBannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    } else {
        self.iAdBannerView = [[ADBannerView alloc] init];
    }
    self.iAdBannerView.delegate = self;
    [self addSubview:self.iAdBannerView];
}
- (void) setupAdmob {
    NSLog(@"setup banner Admob");
    [self cleanAllAds];
    GADAdSize adSize = kGADAdSizeSmartBannerPortrait;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        adSize = kGADAdSizeSmartBannerLandscape;
    }
    self.admobBannerView = [[GADBannerView alloc] initWithAdSize:adSize];
    self.admobBannerView.adUnitID = [[ACAppClient sharedInstance].delegate admobBannerId];
    self.admobBannerView.rootViewController = self.rootViewController;
    [self addSubview:self.admobBannerView];
    GADRequest* request = [GADRequest request];
    request.testDevices = [[ACAppClient sharedInstance].delegate admobTestDevices];
    [self.admobBannerView loadRequest:request];
}
- (void) cleanAllAds {
    [self cleanAdmob];
    [self cleanIad];
    [self cleanStartApp];
}
- (void) cleanStartApp {
    [self.startAdBannerView removeFromSuperview];
    self.startAdBannerView = nil;
}
- (void) cleanAdmob {
    [self.admobBannerView removeFromSuperview];
    self.admobBannerView.delegate = nil;
    self.admobBannerView = nil;
}
- (void) cleanIad {
    [self.iAdBannerView removeFromSuperview];
    self.iAdBannerView.delegate = nil;
    self.iAdBannerView = nil;
}
#pragma mark - iAdBanner
-(void)bannerView:(ADBannerView *)banner
didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"Error loading: %@", error);
    [self cleanAllAds];
    [self setupAdmob];
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"Banner Ad loaded");
}
-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
    NSLog(@"Banner Ad will load");
}
-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    NSLog(@"Banner Ad did finish");
}
@end
