//
//  BatteryCharger.h
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BatteryCharger : NSObject

@property(nonatomic)NSString *volts24V;
@property(nonatomic)NSString *amps24V;
@property(nonatomic)NSString *specGravity24V;

@property(nonatomic)NSString *volts48VOne;
@property(nonatomic)NSString *amps48VOne;
@property(nonatomic)NSString *specGravity48VOne;

@property(nonatomic)NSString *volts48VTwo;
@property(nonatomic)NSString *amps48VTwo;
@property(nonatomic)NSString *specGravity48VTwo;

@property(nonatomic)NSString *volts125VOne;
@property(nonatomic)NSString *amps125VOne;
@property(nonatomic)NSString *specGravity125VOne;

@property(nonatomic)NSString *volts125VTwo;
@property(nonatomic)NSString *amps125VTwo;
@property(nonatomic)NSString *specGravity125VTwo;

@end
