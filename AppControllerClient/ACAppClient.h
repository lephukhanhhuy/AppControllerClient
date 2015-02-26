//
//  ACHouseAdClient.h
//  AppControllerClient
//
//  Created by Le Huy on 2/26/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StartApp/StartApp.h>
#import <iAd/iAd.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "ACHouseAdObject.h"

#define kParameterKeyEnableSplash   @"enable_splash_ad"
#define kParameterKeyEnableHouseAd  @"enable_house_ad"
#define kParameterKeyAdServiceID    @"ad_service_id"

#define kACAppUserKeyEnableSplash   @"kACAppUserKeyEnableSplash"
#define kACAppUserKeyEnableHouseAd  @"kACAppUserKeyEnableHouseAd"
#define kACAppUserKeyAdServiceID    @"kACAppUserKeyAdServiceID"

typedef enum {
    kAdServiceAdmob = 0,
    kAdServiceIad = 1,
    kAdServiceStartApp = 2
}kAdServiceID;// 1, 2, 3

#define kMaxAdServiceId kAdServiceStartApp// Change here when you have more ad service

@protocol ACAppClientDelegate <NSObject>

- (NSString*) startAppDeveloperID;
- (NSString*) startAppAppID;
- (NSString*) admobBannerId;
- (NSString*) admobInterstitialId;
- (NSArray*)  admobTestDevices;

@end

@interface ACAppClient : NSObject
@property (weak) id<ACAppClientDelegate> delegate;
@property ACHouseAdObject* houseAdObject;

@property (nonatomic, retain) STAStartAppAd     *startAppInterstitial;
@property (nonatomic, retain) GADInterstitial   *admobInterstitial;
@property (nonatomic, retain) ADInterstitialAd  *iAdInterstitial;

@property (nonatomic, copy) void (^didRecievedInterstitial)();

+ (instancetype) sharedInstance;

// Ads control
- (void) showSplash;

- (void) setupInterstitial;
- (void) showInterstitial;

// Properties
- (kAdServiceID) adServiceId;
- (BOOL) isEnableHouseAd;
- (BOOL) isEnableSplash;

@end
