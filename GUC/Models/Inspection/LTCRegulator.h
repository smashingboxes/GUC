//
//  LTCRegulator.h
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTCRegulator : NSObject

@property(nonatomic)NSInteger minStepA;
@property(nonatomic)NSInteger presStepA;
@property(nonatomic)NSInteger maxStepA;
@property(nonatomic)BOOL pressureA;
@property(nonatomic)NSInteger counterA;
@property(nonatomic)NSInteger voltageA;
@property(nonatomic)BOOL oilLevelA;
@property(nonatomic)BOOL testOperationA;

@property(nonatomic)NSInteger minStepB;
@property(nonatomic)NSInteger presStepB;
@property(nonatomic)NSInteger maxStepB;
@property(nonatomic)BOOL pressureB;
@property(nonatomic)NSInteger counterB;
@property(nonatomic)NSInteger voltageB;
@property(nonatomic)BOOL oilLevelB;
@property(nonatomic)BOOL testOperationB;

@property(nonatomic)NSInteger minStepC;
@property(nonatomic)NSInteger presStepC;
@property(nonatomic)NSInteger maxStepC;
@property(nonatomic)BOOL pressureC;
@property(nonatomic)NSInteger counterC;
@property(nonatomic)NSInteger voltageC;
@property(nonatomic)BOOL oilLevelC;
@property(nonatomic)BOOL testOperationC;

@end
