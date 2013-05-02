//
//  LTCRegulator.h
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTCRegulator : NSObject

@property(nonatomic)NSString *minStepA;
@property(nonatomic)NSString *pressureStepA;
@property(nonatomic)NSString *maxStepA;
@property(nonatomic)BOOL pressureA;
@property(nonatomic)NSString *counterA;
@property(nonatomic)NSString *voltageA;
@property(nonatomic)BOOL oilLevelA;
@property(nonatomic)BOOL testOperationA;

@property(nonatomic)NSString *minStepB;
@property(nonatomic)NSString *pressureStepB;
@property(nonatomic)NSString *maxStepB;
@property(nonatomic)BOOL pressureB;
@property(nonatomic)NSString *counterB;
@property(nonatomic)NSString *voltageB;
@property(nonatomic)BOOL oilLevelB;
@property(nonatomic)BOOL testOperationB;

@property(nonatomic)NSString *minStepC;
@property(nonatomic)NSString *pressureStepC;
@property(nonatomic)NSString *maxStepC;
@property(nonatomic)BOOL pressureC;
@property(nonatomic)NSString *counterC;
@property(nonatomic)NSString *voltageC;
@property(nonatomic)BOOL oilLevelC;
@property(nonatomic)BOOL testOperationC;

@end
