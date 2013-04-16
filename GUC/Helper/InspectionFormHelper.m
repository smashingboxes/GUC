//
//  InspectionFormHelper.m
//  GUC
//
//  Created by Michael Brodeur on 4/15/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "InspectionFormHelper.h"

@implementation InspectionFormHelper

@synthesize containerArray;
@synthesize infoArray;

-(id)init{
    if(self == [super init]){
        containerArray = [[NSMutableArray alloc]init];
        infoArray = [[NSMutableArray alloc]init];
        NSArray *sectionHeaders = [[NSArray alloc]initWithObjects:@"General", @"SwitchBoard",@"Battery/Charger",
                          @"Circuit Switcher", @"Transformer", @"LTC/Regulator", @"Breakers", nil];
        NSArray *generalTitles = [[NSArray alloc]initWithObjects:@"Station Name", @"Date/Time", @"Technician",
                                  @"KWH", @"MWD", @"+KVARH", @"-KVARH", @"MAXVARD", @"MINVARD", nil];
        NSArray *switchBoardTitles = [[NSArray alloc]initWithObjects:@"MAX AMP A", @"MAX AMP B", @"MAX AMP C",
                                      @"PRESENT AMP A", @"PRESENT AMP B", @"PRESENT AMP C", @"MIN VOLTS A",
                                      @"MIN VOLTS B", @"MIN VOLTS C", @"PRESENT VOLTS A", @"PRESENT VOLTS B",
                                      @"PRESENT VOLTS C", @"MAX VOLTS A", @"MAX VOLTS B", @"MAX VOLTS C",
                                      @"Targets/Alarms", nil];
        NSArray *batteryChargerTitles = [[NSArray alloc]initWithObjects:@"VOLTS 48V #1", @"AMPS 48V #1",
                                         @"SPEC. GRAVITY 48V #1", nil];
        NSArray *circuitSwitcherTitles = [[NSArray alloc]initWithObjects:@"Gas A", @"Gas B", @"Gas C", nil];
        NSArray *transformerTitles = [[NSArray alloc]initWithObjects:@"Tank Oil Level", @"Pressure", @"Nitrogen Tank",
                                      @"Bushing Oil Level", nil];
        NSArray *ltcRegulatorTitles = [[NSArray alloc]initWithObjects:@"", nil];
        NSArray *breakersTitles = [[NSArray alloc]initWithObjects:@"", nil];
        NSArray *titlesArray = [[NSArray alloc]initWithObjects:generalTitles, switchBoardTitles, batteryChargerTitles,
                                 circuitSwitcherTitles, transformerTitles, ltcRegulatorTitles, breakersTitles, nil];
        for(int i = 0; i < 7; i++){
            NSArray *headerTitlesPair = [[NSArray alloc]initWithObjects:[sectionHeaders objectAtIndex:i], [titlesArray objectAtIndex:i],nil];
            [containerArray addObject:headerTitlesPair];
            NSNumber *openState = [NSNumber numberWithBool:NO];
            [infoArray addObject:openState];
        }
    }
    return self;
}

@end
