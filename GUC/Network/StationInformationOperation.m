//
//  StationInformationOperation.m
//  GUC
//
//  Created by Michael Brodeur on 4/22/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "StationInformationOperation.h"

@interface StationInformationOperation()

@property(nonatomic,retain)NSURLConnection *theConnection;
@property(nonatomic,retain)NSURL *stationURL;
@property(nonatomic,retain)NSMutableData *stationData;
@property(nonatomic)BOOL executing;
@property(nonatomic)BOOL finished;

@end

@implementation StationInformationOperation

@synthesize delegate;
@synthesize theConnection;
@synthesize stationURL;
@synthesize stationData;
@synthesize executing;
@synthesize finished;

-(id)initWithURL:(NSURL*)theURL andDelegate:(id<StationInformationOperationDelegate>)theDelegate{
    if(self == [super init]){
        stationURL = theURL;
        delegate = theDelegate;
    }
    return self;
}

-(void)main{
    @autoreleasepool {
        NSLog(@"Beginning request at URL: %@", stationURL);
        
        NSURLRequest *request = [NSURLRequest requestWithURL:stationURL];
        
        self.stationData = [[NSMutableData alloc]init];
        
        theConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
        
        if(theConnection){
            NSLog(@"Connected!");
        }else{
            NSLog(@"Station Information Operation Failed!");
            
            if(delegate)
                [delegate operationDidFail];
            
            [self finish];
        }
    }
}

- (void)start
{
    if([self isCancelled]){
        [self willChangeValueForKey:@"isFinished"];
        self.finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }else{
        [self willChangeValueForKey:@"isExecuting"];
        if (![NSThread isMainThread])
        {
            [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        }
        [self main];
        self.executing = YES;
        [self didChangeValueForKey:@"isExecuting"];
    }
}

-(void)finish
{    
    [self willChangeValueForKey:@"isFinished"];
    self.finished = YES;
    [self didChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    self.executing = NO;
    [self didChangeValueForKey:@"isExecuting"];
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
    
    if(delegate)
        [delegate operationDidFail];
    
    [self finish];
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection{
    
    if(delegate && ![self isCancelled]){
        [delegate operationDidReturnWithData:stationData];
    }
    
    [self finish];
}


@end
