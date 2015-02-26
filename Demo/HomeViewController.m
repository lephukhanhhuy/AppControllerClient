//
//  HomeViewController.m
//  AppControllerClient
//
//  Created by Le Huy on 2/26/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import "HomeViewController.h"
#import "ACHouseAdView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ACHouseAdView* adView = [[ACHouseAdView alloc] initWithFrame:self.houseAdView.bounds];
    adView.rootViewController = self;
    [self.houseAdView addSubview:adView];
}


@end
