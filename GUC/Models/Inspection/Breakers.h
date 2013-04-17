//
//  Breakers.h
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Breakers : NSObject

@property(nonatomic)NSInteger busOneCounter;
@property(nonatomic)NSInteger busOneTarget;
@property(nonatomic)NSInteger busOneOperation;
@property(nonatomic)NSInteger cktOneCounter;
@property(nonatomic)NSInteger cktOneTarget;
@property(nonatomic)NSInteger cktOneOperation;

@end
