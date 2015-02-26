//
//  ACAPIClient.h
//  AppControllerClient
//
//  Created by Le Huy on 2/25/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ACAPIClient : NSObject

// Global init, used for Parse Server
+ (void) setAppId:(NSString*) appId;// This is App ID on Parse Settings
+ (void) setAPIKey:(NSString*) apiKey;// This is REST API KEYS on Parse Settings

// TODO:
// Change to AppControllerServer later

// Singleton instance
+ (instancetype) sharedInstance;

// Get config from server
- (void) requestConfigOnCompleted:(void (^)(NSDictionary* app)) onCompleted;

/* 
 Get house ad data
 This will be on parse for temporary
 When change to AppControllerServer, this need to call to another api after check
 */
- (void) requestHouseAdOnCompleted:(void (^)(NSDictionary* app)) onCompleted;

/*
 Get detail of app from Appstore with Bundle ID
 */
- (void) requestBundleID:(NSString*) bundleId onCompleted:(void (^)(NSDictionary* app)) onCompleted;

/* Use for tracking on AppControllerServer
- (void) postTrackingClickToHouseAdOnCompleted:(void (^)(NSDictionary* app)) onCompleted;
*/
// Download image, used for download banner
- (void) downloadImageFromUrl:(NSString*) imageUrl onCompleted:(void (^)(UIImage* image)) onCompleted;

@end
