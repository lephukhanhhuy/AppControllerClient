//
//  ACAPIClient.m
//  AppControllerClient
//
//  Created by Le Huy on 2/25/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import "ACAPIClient.h"

@interface ACAPIClient()
@property NSString* appId;
@property NSString* apiKey;
@end

@implementation ACAPIClient
static NSString* appId = nil;
static NSString* apiKey = nil;
+ (void) setAppId:(NSString*) appId_ {
    appId = appId_;
}
+ (void) setAPIKey:(NSString*) apiKey_ {
    apiKey = apiKey_;
}

static ACAPIClient* _sharedInstance = nil;
+ (instancetype) sharedInstance {
    NSAssert(appId != nil, @"Please use setAppId first, it may on your AppDelegate");
    NSAssert(apiKey != nil, @"Please use setAPIKey first, it may on your AppDelegate");
    if (_sharedInstance == nil) {
        _sharedInstance = [ACAPIClient new];
        // This is Class App on Parse admin
        _sharedInstance.appId = appId;
        _sharedInstance.apiKey = apiKey;
    }
    return _sharedInstance;
}

- (void) requestConfigOnCompleted:(void (^)(NSDictionary* app)) onCompleted {
    NSString* serverAddress = @"https://api.parse.com/1/config";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverAddress]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    [request addValue:self.appId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request addValue:self.apiKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([data length] > 0 && error == nil) {
                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"receivedData (NSDictionary): %@", dict);
                if (onCompleted) {
                    onCompleted(dict);
                    return;
                }
            }
            else if ([data length] == 0 && error == nil)
                NSLog(@"Empty reply");
            else if (error != nil && error.code == NSURLErrorTimedOut)
                NSLog(@"Timeout");
            else if (error != nil)
                NSLog(@"Error: %@", error);
            onCompleted(nil);
        });
    }];
}

- (void) requestHouseAdOnCompleted:(void (^)(NSDictionary* app)) onCompleted {
    NSString* houseAdAppID = @"enter your house ad app id here";
    NSString* houseAdRestAPIKey = @"enter your house ad rest api key here";
    
    NSString* serverAddress = @"https://api.parse.com/1/config";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverAddress]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    [request addValue:houseAdAppID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request addValue:houseAdRestAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([data length] > 0 && error == nil) {
                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"receivedData (NSDictionary): %@", dict);
                if (onCompleted) {
                    onCompleted(dict);
                    return;
                }
            }
            else if ([data length] == 0 && error == nil)
                NSLog(@"Empty reply");
            else if (error != nil && error.code == NSURLErrorTimedOut)
                NSLog(@"Timeout");
            else if (error != nil)
                NSLog(@"Error: %@", error);
            onCompleted(nil);
        });
    }];
}

- (void) downloadImageFromUrl:(NSString*) imageUrlString onCompleted:(void (^)(UIImage * image))onCompleted {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
                   ^{
                       NSURL *imageURL = [NSURL URLWithString:imageUrlString];
                       NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                       dispatch_sync(dispatch_get_main_queue(), ^{
                           UIImage* image = [UIImage imageWithData:imageData];
                           onCompleted(image);
                       });
                   });
}
@end
