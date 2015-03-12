//
//  ACHouseAdView.m
//  AppControllerClient
//
//  Created by Le Huy on 2/25/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import "ACHouseAdView.h"
#import "MarqueeLabel.h"
#import "ACAppClient.h"
#import <StoreKit/StoreKit.h>

@interface ACHouseAdView()<SKStoreProductViewControllerDelegate>
{
    MarqueeLabel* appName;
    UIButton* buttonLinkApp;
    
    NSString* trackName;
    NSString* trackId;
}

@end
@implementation ACHouseAdView
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupAd];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAd];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    buttonLinkApp.frame = self.bounds;
    appName.frame = self.bounds;
}
- (void) setButtonColor:(UIColor*) color {
    appName.textColor = color;
}

- (void) setupAd {
    buttonLinkApp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonLinkApp.backgroundColor = [UIColor clearColor];
    [buttonLinkApp setTintColor:[UIColor blackColor]];
    [buttonLinkApp sizeToFit];
    [self addSubview:buttonLinkApp];
    
    [buttonLinkApp addTarget:self action:@selector(btnLinkAppSelected) forControlEvents:UIControlEventTouchUpInside];

    // Animation label
    appName = [[MarqueeLabel alloc] initWithFrame:self.bounds];
    [self addSubview:appName];
    appName.font = [UIFont systemFontOfSize:16];
//    appName.textAlignment = NSTextAlignmentCenter;
    appName.marqueeType = MLLeftRight;
    appName.scrollDuration = 2.0;
    appName.fadeLength = 5.0f;
    appName.leadingBuffer = 20.0f;
    
    [self updateHouseAdText];
}
- (void) updateHouseAdText {
    if (![ACAppClient sharedInstance].isEnableHouseAd) {
        NSLog(@"This app disable house ad");
        appName.text = @"";
        [self performSelector:@selector(updateHouseAdText) withObject:nil afterDelay:5];
        return;
    }
    ACHouseAdObject* houseAdObject = [ACAppClient sharedInstance].houseAdObject;
    if (!houseAdObject.isActive) {
        // show nothing
         appName.text = @"";
        [self performSelector:@selector(updateHouseAdText) withObject:nil afterDelay:5];
        return;
    }
    if (houseAdObject.appDataLoaded) {
        trackName = [houseAdObject getAppName];
        trackId = [houseAdObject getAppleId];
        appName.text = [NSString stringWithFormat:@"Play '%@'", trackName];
    } else {
        appName.text = @"";
    }
    [self performSelector:@selector(updateHouseAdText) withObject:nil afterDelay:5];
}
- (void) btnLinkAppSelected {
    if (self.rootViewController == nil) {
        NSLog(@"This view need root view controller");
        return;
    }
    if (trackId == nil) {
        return;
    }
    NSLog(@"Go to APP: %@", trackId);
    NSDictionary *appParameters = [NSDictionary dictionaryWithObject:trackId
                                                              forKey:SKStoreProductParameterITunesItemIdentifier];
    
    SKStoreProductViewController *productViewController = [[SKStoreProductViewController alloc] init];
    [productViewController setDelegate:self];
    [productViewController loadProductWithParameters:appParameters
                                     completionBlock:^(BOOL result, NSError *error)
     {
         
     }];
    [self.rootViewController presentViewController:productViewController
                       animated:YES
                     completion:^{
                         
                     }];
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    if (viewController)
    { [self.rootViewController dismissViewControllerAnimated:YES completion:nil]; }
}
@end
