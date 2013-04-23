//
//  NetworkConnectionManager.h
//  GUC
//
//  Created by Michael Brodeur on 4/22/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StationInformationOperation.h"
#import "AsyncRequest.h"

@interface NetworkConnectionManager : NSObject <StationInformationOperationDelegate>

+(NetworkConnectionManager*)sharedManager;
-(void)beginConnectionWithStation:(NSString*)stationName forCaller:(id<AsyncResponseDelegate>)theDelegate;

@end