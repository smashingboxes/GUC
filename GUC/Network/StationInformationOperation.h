//
//  StationInformationOperation.h
//  GUC
//
//  Created by Michael Brodeur on 4/22/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StationInformationOperationDelegate <NSObject>

-(void)operationDidReturnWithData:(NSMutableData*)theData;
-(void)operationDidFail;

@end


@interface StationInformationOperation : NSOperation <NSURLConnectionDelegate>

@property(nonatomic,weak)id<StationInformationOperationDelegate> delegate;

-(id)initWithURL:(NSURL*)theURL andDelegate:(id<StationInformationOperationDelegate>)theDelegate;

@end
