//
//  ACHouseAdObject.m
//  AppControllerClient
//
//  Created by Le Huy on 2/26/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import "ACHouseAdObject.h"
#import "ACAPIClient.h"

@implementation ACHouseAdObject
- (instancetype) initWithHouseAdData:(NSDictionary*) _houseAdData
{
    self = [super init];
    if (self) {
        houseAdData = _houseAdData;
        self.isActive = [houseAdData[kParameterKeyHouseAdActive] boolValue];
        self.bundleId = houseAdData[kParameterKeyHouseAdBundleId];
        self.bannerPadUrl = houseAdData[kParameterKeyHouseAdBannerUrlPad];
        self.bannerPhoneUrl = houseAdData[kParameterKeyHouseAdBannerUrlPhone];
        self.isReplayInterstitial = [houseAdData[kParameterKeyHouseAdBannerEnableReplaceInterstitial] boolValue];
        
        if (self.isActive && self.bundleId != nil) {
            // Download appstore data
            [[ACAPIClient sharedInstance] requestBundleID:self.bundleId onCompleted:^(NSDictionary *app) {
                self.appDataLoaded = YES;
                houseAdAppstoreData = app;
                
                // Download banner url
                NSString* bannerURL = self.bannerPadUrl;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                    bannerURL = self.bannerPhoneUrl;
                }
                [[ACAPIClient sharedInstance] downloadImageFromUrl:bannerURL onCompleted:^(UIImage *image) {
                    NSLog(@"Banner house ad downloaded");
                    self.cachedImage = image;
                    self.appBannerLoaded = YES;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidFinishDownloadHouseAd object:nil];
                }];
            }];
        }
    }
    return self;
}
- (NSString*) getAppName {
    NSArray* array = houseAdAppstoreData[@"results"];
    NSDictionary* dict = [array firstObject];
    if (dict != nil) {
        return [NSString stringWithFormat:@"%@", dict[@"trackName"]];
    }
    return nil;
}
- (NSString*) getAppleId {
    NSArray* array = houseAdAppstoreData[@"results"];
    NSDictionary* dict = [array firstObject];
    if (dict != nil) {
        return [NSString stringWithFormat:@"%@", dict[@"trackId"]];
    }
    return nil;
}
@end
