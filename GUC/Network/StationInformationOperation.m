//
//  StationInformationOperation.m
//  GUC
//
//  Created by Michael Brodeur on 4/22/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "StationInformationOperation.h"

@interface StationInformationOperation()

@property(nonatomic)NSURLConnection *theConnection;
@property(nonatomic)NSOperationQueue *delegateQueue;
@property(nonatomic)NSURL *stationURL;
@property(nonatomic)NSString *requestType;
@property(nonatomic)NSDictionary *jsonDictionary;
@property(nonatomic)NSMutableData *stationData;
@property(nonatomic)BOOL executing;
@property(nonatomic)BOOL finished;

@end


@implementation StationInformationOperation

@synthesize delegate;
@synthesize delegateQueue;
@synthesize theConnection;
@synthesize stationURL;
@synthesize requestType;
@synthesize jsonDictionary;
@synthesize stationData;
@synthesize executing;
@synthesize finished;

-(id)initWithURL:(NSURL*)theURL requestType:(NSString*)theType jsonDictionary:(NSDictionary*)theDictionary andDelegate:(id<StationInformationOperationDelegate>)theDelegate{
    if(self == [super init]){
        stationURL = theURL;
        delegate = theDelegate;
        requestType = theType;
        if(theDictionary)
            jsonDictionary = theDictionary;
        if(!delegateQueue)
            delegateQueue = [[NSOperationQueue alloc]init];
        
    }
    return self;
}

-(void)main{
    @autoreleasepool {
        NSLog(@"Beginning request at URL: %@", stationURL);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:stationURL];
        [request setHTTPMethod:requestType];
        
        if([requestType isEqualToString:@"POST"]){
            if(jsonDictionary){
                NSError *error;
                NSData *theData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:NSJSONWritingPrettyPrinted error:&error];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                NSString *postLength = [[NSString alloc]initWithFormat:@"%i",[theData length]];
                [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
                [request setHTTPBody:theData];
            }else{
                [self operationFailed];
            }
        }
        
        stationData = [[NSMutableData alloc]init];
        
        theConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];
        //[theConnection setDelegateQueue:delegateQueue];
        [theConnection start];
        
        if(theConnection){
            NSLog(@"Connected!");
        }else{
            NSLog(@"Station Information Operation Failed!");
            
            [self operationFailed];
        }
        
        [self performSelector:@selector(checkConnection) withObject:nil afterDelay:30.0];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:30.0]];
    }
}

-(void)checkConnection{
    if([stationData length] == 0){
        NSLog(@"Operation failed!");
        if(theConnection){
            [theConnection cancel];
        }
        [self operationFailed];
    }
}

-(void)start{
    if([self isCancelled]){
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }else{
        [self willChangeValueForKey:@"isExecuting"];
        [self main];
        executing = YES;
        [self didChangeValueForKey:@"isExecuting"];
    }
}

-(void)finish{    
    [self willChangeValueForKey:@"isFinished"];
    finished = YES;
    [self didChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    executing = NO;
    [self didChangeValueForKey:@"isExecuting"];
}

-(void)operationFailed{
    if(delegate)
        [delegate operationDidFail];
    
    [self finish];
}

-(BOOL)isConcurrent{
    return YES;
}

-(BOOL)isExecuting{
    return executing;
}

-(BOOL)isFinished{
    return finished;
}


#pragma mark - NSURLConnection Delegate Methods

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [stationData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [stationData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"There was an error! %@", error);
    
    [self operationFailed];
    [self finish];
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection{
    NSLog(@"Got data!");
    
    if(delegate && ![self isCancelled]){
        [delegate operationDidReturnWithData:stationData];
    }
    [self finish];
}


@end
