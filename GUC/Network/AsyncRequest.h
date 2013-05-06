//
//  AsyncRequest.h
//  GUC
//
//  Created by Michael Brodeur on 4/22/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AsyncRequest;

@protocol AsyncResponseDelegate <NSObject>

-(void)asyncResponseDidReturnObjects:(NSArray*)theObjects;
-(void)asyncResponseDidFailWithError;

@end


@interface AsyncRequest : NSObject

@property(nonatomic,weak)id<AsyncResponseDelegate> delegate;

@end
