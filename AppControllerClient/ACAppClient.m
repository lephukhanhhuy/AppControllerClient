//
//  ACHouseAdClient.m
//  AppControllerClient
//
//  Created by Le Huy on 2/26/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import "ACAppClient.h"
#import "ACAPIClient.h"

@interface ACAppClient () <GADInterstitialDelegate, ADInterstitialAdDelegate>
{
    BOOL isSplashInterstitial;// Use when need splash ad with iAd or Admob
}
@end

@implementation ACAppClient

static ACAppClient* _sharedInstance = nil;
+ (instancetype) sharedInstance{
    if (_sharedInstance == nil) {
        _sharedInstance = [ACAppClient new];        
    }
    return _sharedInstance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        // Call and update config as soon as possible
        [[ACAPIClient sharedInstance] requestConfigOnCompleted:^(NSDictionary *app) {
            NSDictionary* params = app[@"params"];
            if (params[kParameterKeyAdServiceID] != nil) {
                [[NSUserDefaults standardUserDefaults] setObject:params[kParameterKeyAdServiceID] forKey:kACAppUserKeyAdServiceID];
            }
            if (params[kParameterKeyEnableHouseAd] != nil) {
                [[NSUserDefaults standardUserDefaults] setObject:params[kParameterKeyEnableHouseAd] forKey:kACAppUserKeyEnableHouseAd];
            }
            if (params[kParameterKeyEnableSplash] != nil) {
                [[NSUserDefaults standardUserDefaults] setObject:params[kParameterKeyEnableSplash] forKey:kACAppUserKeyEnableSplash];
            }
            // Save this config
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }];
    }
    return self;
}
#pragma mark - Ad cotrol
- (void) setupInterstitial {
    kAdServiceID adServiceId = [self adServiceId];
    switch (adServiceId) {
        case kAdServiceStartApp:
        {
            STAStartAppSDK* sdk = [STAStartAppSDK sharedInstance];
            sdk.appID = [self.delegate startAppAppID];
            sdk.devID = [self.delegate startAppDeveloperID];
            [self setupStartApp];
            break;
        }
        case kAdServiceIad:
        {
            [self setupIad];
            break;
        }
        default:// Admob is default
        {
            [self setupAdmob];
            break;
        }
    }
}
- (void) showSplash {
    if ([self isEnableSplash]) {
        kAdServiceID adServiceId = [self adServiceId];
        switch (adServiceId) {
            case kAdServiceStartApp:
            {
                STAStartAppSDK* sdk = [STAStartAppSDK sharedInstance];
                sdk.appID = [self.delegate startAppAppID];
                sdk.devID = [self.delegate startAppDeveloperID];
                [[STAStartAppSDK sharedInstance] showSplashAd];
                break;
            }
            case kAdServiceIad:
            {
                isSplashInterstitial = YES;
                [self setupIad];
                break;
            }
            default:// Admob is default
            {
                isSplashInterstitial = YES;
                [self setupAdmob];
                break;
            }
        }
    }
}
- (void) showInterstitial {
    kAdServiceID adServiceId = [self adServiceId];
    switch (adServiceId) {
        case kAdServiceStartApp:
        {
            [self showStartAppInterstitial];
            break;
        }
        case kAdServiceIad:
        {
            [self showIAdInterstitial];
            break;
        }
        default:// Admob is default
        {
            [self showAdmobInterstitial];
            break;
        }
    }
}

- (void) showStartAppInterstitial {
    NSLog(@"showInterstitial STARTAPP");
    [self.startAppInterstitial showAd];
    [self.startAppInterstitial loadAd];// Load when show, so next time you will have another ad
}
- (void) showIAdInterstitial {
    if (self.iAdInterstitial.loaded)
    {
        NSLog(@"showInterstitial IAD");
        [self.iAdInterstitial presentFromViewController:[self topMostController]];
    } else {
        [self showAdmobInterstitial];
    }
}
- (void) showAdmobInterstitial {
    if ([self.admobInterstitial isReady]) {
        NSLog(@"showInterstitial ADMOB");
        [self.admobInterstitial presentFromRootViewController:[self topMostController]];
    }
}
- (void) setupStartApp {
     NSLog(@"setup STARTAPP");
    [self cleanAllAds];
    self.startAppInterstitial = [[STAStartAppAd alloc] init];
    [self.startAppInterstitial loadAd];
}
- (void) setupIad {
    NSLog(@"setup iAd");
    [self cleanAllAds];
    self.iAdInterstitial = [[ADInterstitialAd alloc] init];
    self.iAdInterstitial.delegate = self;
}
- (void) setupAdmob {
    NSLog(@"setup Admob");
    [self cleanAllAds];
    self.admobInterstitial = [[GADInterstitial alloc] init];
    self.admobInterstitial.adUnitID = [self.delegate admobInterstitialId];
    self.admobInterstitial.delegate = self;
    GADRequest* request = [GADRequest request];
    request.testDevices = [self.delegate admobTestDevices];
    [self.admobInterstitial loadRequest:request];
}
- (void) cleanAllAds {
    [self cleanAdmob];
    [self cleanIad];
    [self cleanStartApp];
}
- (void) cleanStartApp {
    self.startAppInterstitial = nil;
}
- (void) cleanAdmob {
    self.admobInterstitial.delegate = nil;
    self.admobInterstitial = nil;
}
- (void) cleanIad {
    self.iAdInterstitial.delegate = nil;
    self.iAdInterstitial = nil;
}
#pragma mark - Service ID
// All kACAppKey default is nil, this mean the BOOL value default is NO and NUMBER value defalt is 0
- (kAdServiceID) adServiceId {
    int serviceId = [[[NSUserDefaults standardUserDefaults] objectForKey:kACAppUserKeyAdServiceID] intValue];
    if (serviceId > kMaxAdServiceId) {
        return kAdServiceAdmob;
    }
    return (kAdServiceID)serviceId;
}
- (BOOL) isEnableHouseAd {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kACAppUserKeyEnableHouseAd] boolValue];
}
- (BOOL) isEnableSplash {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kACAppUserKeyEnableSplash] boolValue];
}
#pragma mark - Interstitial iAD
- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    NSLog(@"iAd did fail");
    [self setupAdmob];
}
- (void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd {
    NSLog(@"iAd did load");
    if (isSplashInterstitial) {
        [self showIAdInterstitial];
    }
    isSplashInterstitial = NO;
}
- (void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd {
    NSLog(@"iAd did finish");
}
- (void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd {
    NSLog(@"iAd did unload");
}
#pragma mark - Interstitial adMob
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    if (isSplashInterstitial) {
        [self showAdmobInterstitial];
    }
    isSplashInterstitial = NO;
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self setupInterstitial];
    
}
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"%@ %@", NSStringFromSelector(_cmd), error);
}
#pragma mark - Helper
- (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}
@end
