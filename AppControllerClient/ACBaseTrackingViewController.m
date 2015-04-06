//
//  ACBaseTrackingViewController.m
//  AppControllerClient
//
//  Created by Le Huy on 2/28/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import "ACBaseTrackingViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAITracker.h"

@interface ACBaseTrackingViewController ()

@end

@implementation ACBaseTrackingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self trackScreenName:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Google Analytics
- (void) trackEventButtonPress:(NSString*) buttonName {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"button"
                                                          action:@"press"
                                                           label:buttonName
                                                           value:nil] build]];
}

- (void) trackEventBestScore:(NSString*) score {
    [self trackEventBestScore:score withGameMode:@"Default"];
}
- (void) trackEventBestScore:(NSString*) score withGameMode:(NSString*) gameMode {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:[NSString stringWithFormat: @"%@ - %@", gameMode, score]
                                                          action:@"Best Score"
                                                           label:score
                                                           value:nil] build]];
}
- (void)trackScreenName:(NSString *)screen {
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:screen];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}
@end
