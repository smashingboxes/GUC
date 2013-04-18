//
//  Inspection.m
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "Inspection.h"

@implementation Inspection

@synthesize generalSettings;
@synthesize switchBoard;
@synthesize batteryCharger;
@synthesize circuitSwitcher;
@synthesize transformer;
@synthesize ltcRegulator;
@synthesize breakers;

-(id)init{
    if(self == [super init]){
        generalSettings = [[GeneralSettings alloc]init];
        switchBoard = [[SwitchBoard alloc]init];
        batteryCharger = [[BatteryCharger alloc]init];
        circuitSwitcher = [[CircuitSwitcher alloc]init];
        transformer = [[Transformer alloc]init];
        ltcRegulator = [[LTCRegulator alloc]init];
        breakers = [[Breakers alloc]init];
    }
    
    return self;
}

@end
