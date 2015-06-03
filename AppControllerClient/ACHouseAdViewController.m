//
//  ACHouseAdViewController.m
//  AppControllerClient
//
//  Created by Le Huy on 2/25/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import "ACHouseAdViewController.h"
#import <StoreKit/StoreKit.h>

@interface ACHouseAdViewController ()<SKStoreProductViewControllerDelegate>
{
    UIImageView* imageView;
    
    UIButton* buttonGo;// Overlay full screen, tap anywhere mean open store screen
    UIButton* buttonClose;// Close button on top right
}
@end

@implementation ACHouseAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    imageView = [[UIImageView alloc] initWithImage:self.bannerImage];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    buttonGo = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonGo.backgroundColor = [UIColor clearColor];
    [buttonGo addTarget:self action:@selector(btnGoSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonGo];
    
    buttonClose = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonClose.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [buttonClose setTitle:@"X" forState:UIControlStateNormal];
    
    [buttonClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonClose setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [buttonClose setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    buttonClose.layer.cornerRadius = 22;
    buttonClose.layer.borderWidth = 2;
    buttonClose.layer.borderColor = [buttonClose titleColorForState:UIControlStateNormal].CGColor;
    
    [buttonClose addTarget:self action:@selector(btnCloseSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonClose];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    imageView.frame = self.view.bounds;
    buttonGo.frame = self.view.bounds;
    buttonClose.frame = CGRectMake(self.view.frame.size.width - 44 - 20, 20, 44, 44);
}

- (void)dealloc
{
    imageView = nil;
    self.bannerImage = nil;
}

#define DEVICE_SCREEN_HAS_LENGTH__X(_frame, _length) ( fabsf( MAX(CGRectGetHeight(_frame), CGRectGetWidth(_frame)) - _length) < FLT_EPSILON )

#define DEVICE_IS_IPHONE_3_5_In__X DEVICE_SCREEN_HAS_LENGTH__X([UIScreen mainScreen].bounds, 480.f)

- (void) btnGoSelected {
    NSLog(@"Go to APP: %@", self.appleId);
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (DEVICE_IS_IPHONE_3_5_In__X && (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft)) {
        NSString* url = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%@", self.appleId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    } else {
        NSDictionary *appParameters = [NSDictionary dictionaryWithObject:self.appleId
                                                                  forKey:SKStoreProductParameterITunesItemIdentifier];
        
        SKStoreProductViewController *productViewController = [[SKStoreProductViewController alloc] init];
        [productViewController setDelegate:self];
        [productViewController loadProductWithParameters:appParameters
                                         completionBlock:^(BOOL result, NSError *error)
         {
             
         }];
        [self presentViewController:productViewController
                           animated:YES
                         completion:^{
                             
                         }];
    }
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    if (viewController)
    { [self dismissViewControllerAnimated:YES completion:nil]; }
}

- (void) btnCloseSelected {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (BOOL)prefersStatusBarHidden {
    return self.shouldHideStatusBar;
}
@end
