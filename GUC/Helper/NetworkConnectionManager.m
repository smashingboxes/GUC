//
//  NetworkConnectionManager.m
//  GUC
//
//  Created by Michael Brodeur on 4/22/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "NetworkConnectionManager.h"
#import "StationNetworkFactory.h"

@interface NetworkConnectionManager()

@property(nonatomic)NSOperationQueue *networkQueue;
@property(nonatomic)AsyncRequest *currentRequest;

@end


@implementation NetworkConnectionManager

@synthesize networkQueue;
@synthesize currentRequest;

+(NetworkConnectionManager*)sharedManager{
    static NetworkConnectionManager* sharedManager;
    
    @synchronized(self){
        if(!sharedManager){
            sharedManager = [[NetworkConnectionManager alloc]init];
        }

        return sharedManager;
    }
}

-(void)initializeNetworkQueue{
    networkQueue = [[NSOperationQueue alloc]init];
}

-(void)beginConnectionWithStation:(NSString *)stationName forCaller:(id<AsyncResponseDelegate>)theDelegate{
    if(!networkQueue){
        [self initializeNetworkQueue];
        [self beginConnectionWithStation:stationName forCaller:theDelegate];
    }else{
        NSURL *connectionURL = [StationNetworkFactory generateURLForStation:stationName];
        
        currentRequest = [[AsyncRequest alloc]init];
        currentRequest.delegate = theDelegate;
        
        StationInformationOperation *theOperation = [[StationInformationOperation alloc]initWithURL:connectionURL andDelegate:self];
        [networkQueue addOperation:theOperation];
    }
}

-(void)beginConnectionWithPurpose:(NSString*)thePurpose forCaller:(id<AsyncResponseDelegate>)theDelegate{
    if(!networkQueue){
        [self initializeNetworkQueue];
        [self beginConnectionWithPurpose:thePurpose forCaller:theDelegate];
    }else{
        NSURL *connectionURL;
        if([thePurpose isEqualToString:@"Names"]){
            connectionURL = [StationNetworkFactory generateURLForTechnicianNames];
        }
        currentRequest = [[AsyncRequest alloc]init];
        currentRequest.delegate = theDelegate;
        
        StationInformationOperation *theOperation = [[StationInformationOperation alloc]initWithURL:connectionURL andDelegate:self];
        [networkQueue addOperation:theOperation];
    }
}

-(void)operationDidReturnWithData:(NSMutableData *)theData{
    if(currentRequest){
        NSError *error;
        NSArray *jsonInfo = [NSJSONSerialization JSONObjectWithData:theData options:kNilOptions error:&error];
        [currentRequest.delegate asyncResponseDidReturnObjects:jsonInfo];
    }
}

-(void)operationDidFail{
    if(currentRequest){
        [currentRequest.delegate asyncResponseDidFailWithError];
    }
}

@end
