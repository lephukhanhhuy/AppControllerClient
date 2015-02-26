//
//  ACHouseAdClient.h
//  AppControllerClient
//
//  Created by Le Huy on 2/26/15.
//  Copyright (c) 2015 Huy Le. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kAdServiceAdmob = 1,
    kAdServiceIad = 2,
    kAdServiceStartApp = 3
}kAdService;// 1, 2, 3

@interface ACHouseAdClient : NSObject

@end
