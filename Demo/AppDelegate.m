//
//  AppDelegate.m
//  Demo
//
//  Created by Le Huy on 2/25/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import "AppDelegate.h"
#import "AppControllerClient.h"

@interface AppDelegate ()<ACAppClientDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [ACAPIClient setAppId:@"OqkAYlukr32pMk0HgNNnUWO6QTPBRa5hMvM10EXW"];
    [ACAPIClient setAPIKey:@"o9uBGYXyB2hX2ZtrMv5W1292TeAlvXtIb7D8B3Vw"];
      
//    [ACAPIClient setAppId:@"enter your app id here"];
//    [ACAPIClient setAPIKey:@"enter your api key here"];
    
    // Override point for customization after application launch.    
    ACAppClient* appClient = [ACAppClient sharedInstance];
    appClient.delegate = self;
    [appClient showSplash];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

#pragma mark - ACAppClientDelegate
- (NSString *)startAppAppID {
    return @"202714434";
}
- (NSString *)startAppDeveloperID {
    return @"102281608";
}
- (NSString *)admobBannerId {
    return @"ca-app-pub-9823948949443760/2289079133";
}
- (NSString *)admobInterstitialId {
    return @"ca-app-pub-9823948949443760/3765812331";
}
- (NSArray *)admobTestDevices {
    return @[@"e38eaea637408ebd5464f3721f4cf171"];
}
@end
