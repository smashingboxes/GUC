//
//  Inspection.h
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GeneralSettings.h"
#import "SwitchBoard.h"
#import "BatteryCharger.h"
#import "CircuitSwitcher.h"
#import "Transformer.h"
#import "LTCRegulator.h"
#import "Breakers.h"

@interface Inspection : NSObject

@property (nonatomic) NSString *stationIdentifier;
@property (nonatomic) GeneralSettings *generalSettings;
@property (nonatomic) SwitchBoard *switchBoard;
@property (nonatomic) BatteryCharger *batteryCharger;
@property (nonatomic) CircuitSwitcher *circuitSwitcher;
@property (nonatomic) Transformer *transformer;
@property (nonatomic) LTCRegulator *ltcRegulator;
@property (nonatomic) Breakers *breakers;


@end
