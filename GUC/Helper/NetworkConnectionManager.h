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
-(void)beginConnectionWithPurpose:(NSString*)thePurpose withParameters:(NSDictionary *)parameters withJSONDictionary:(NSDictionary*)theDictionary forCaller:(id<AsyncResponseDelegate>)theDelegate;
-(void)cancelAllRequests;

@end
