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

-(void)beginConnectionWithPurpose:(NSString*)thePurpose withJSONDictionary:(NSDictionary*)theDictionary forCaller:(id<AsyncResponseDelegate>)theDelegate{
    if(!networkQueue){
        [self initializeNetworkQueue];
        [self beginConnectionWithPurpose:thePurpose withJSONDictionary:theDictionary forCaller:theDelegate];
    }else{
        NSURL *connectionURL;
        if([thePurpose isEqualToString:@"Names"]){
            connectionURL = [StationNetworkFactory generateURLForTechnicianNames];
        }else if([thePurpose isEqualToString:@"PDF"]){
            connectionURL = [StationNetworkFactory generateURLForPDF];
        }else{
            // For getting station data.
            connectionURL = [StationNetworkFactory generateURLForStation:thePurpose];
        }
        currentRequest = [[AsyncRequest alloc]init];
        currentRequest.delegate = theDelegate;
        
        NSString *requestType;
        if(theDictionary){
            requestType = @"POST";
        }else{
            requestType = @"GET";
        }
        
        StationInformationOperation *theOperation = [[StationInformationOperation alloc]initWithURL:connectionURL requestType:requestType jsonDictionary:theDictionary andDelegate:self];
        [networkQueue addOperation:theOperation];
    }
}

-(void)operationDidReturnWithData:(NSMutableData *)theData{
    if(currentRequest){
        NSError *error;
        NSString *jsonInfo = [[NSString alloc]initWithFormat:@"%@",[NSJSONSerialization JSONObjectWithData:theData options:kNilOptions error:&error]];
        if([jsonInfo rangeOfString:@"("].location == 0){
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:theData options:kNilOptions error:&error];
            [currentRequest.delegate asyncResponseDidReturnObjects:jsonArray];
        }else if([jsonInfo rangeOfString:@"{"].location == 0){
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:theData options:kNilOptions error:&error];
            NSArray *dataArray = [[NSArray alloc]initWithObjects:jsonDictionary, nil];
            [currentRequest.delegate asyncResponseDidReturnObjects:dataArray];
        }
    }
}

-(void)operationDidFail{
    if(currentRequest)
        [currentRequest.delegate asyncResponseDidFailWithError];
}

-(void)cancelAllRequests{
    [networkQueue cancelAllOperations];
    if(currentRequest)
        currentRequest.delegate = nil;
}

@end
