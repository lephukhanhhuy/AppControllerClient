//
//  ACHouseAdObject.h
//  AppControllerClient
//
//  Created by Le Huy on 2/26/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kParameterKeyHouseAdActive          @"active"
#define kParameterKeyHouseAdBundleId        @"bundle_id"
#define kParameterKeyHouseAdBannerUrlPhone  @"banner_phone_url"
#define kParameterKeyHouseAdBannerUrlPad    @"banner_pad_url"
#define kParameterKeyHouseAdBannerEnableReplaceInterstitial @"enable_replace_interstitial"

@interface ACHouseAdObject : NSObject
{
    NSDictionary* houseAdAppstoreData;// Data got from iTunes API
    NSDictionary* houseAdData;
}
@property BOOL appDataLoaded;
@property BOOL appBannerLoaded;

@property BOOL isActive;
@property NSString* bundleId;
@property NSString* bannerPhoneUrl;
@property NSString* bannerPadUrl;
@property BOOL isReplayInterstitial;

@property UIImage* cachedImage;

- (instancetype) initWithHouseAdData:(NSDictionary*) houseAdData;

- (NSString*) getAppleId;
- (NSString*) getAppName;
@end
