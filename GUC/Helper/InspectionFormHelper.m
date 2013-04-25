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

-(id)initWithSections:(NSArray *)sections{
    if(self == [super init]){
        containerArray = [[NSMutableArray alloc]init];
        infoArray = [[NSMutableArray alloc]init];
        NSMutableArray *sectionHeaders = [[NSMutableArray alloc]init];
        NSMutableArray *generalFields = [[NSMutableArray alloc]init];
        NSMutableArray *switchBoardFields = [[NSMutableArray alloc]init];
        NSMutableArray *batteryChargerFields = [[NSMutableArray alloc]init];
        NSMutableArray *circuitSwitcherFields = [[NSMutableArray alloc]init];
        NSMutableArray *transformerFields = [[NSMutableArray alloc]init];
        NSMutableArray *ltcRegulatorFields = [[NSMutableArray alloc]init];
        NSMutableArray *breakersFields = [[NSMutableArray alloc]init];
        
        for(int i = 0; i < [sections count]; i++){
            NSDictionary *sectionDictionary = [sections objectAtIndex:i];
            
            [sectionHeaders addObject:[sectionDictionary objectForKey:@"name"]];
            switch(i){
                case 0:
                    [generalFields addObjectsFromArray:[sectionDictionary objectForKey:@"fields"]];
                    break;
                case 1:
                    [switchBoardFields addObjectsFromArray:[sectionDictionary objectForKey:@"fields"]];
                    break;
                case 2:
                    [batteryChargerFields addObjectsFromArray:[sectionDictionary objectForKey:@"fields"]];
                    break;
                case 3:
                    [circuitSwitcherFields addObjectsFromArray:[sectionDictionary objectForKey:@"fields"]];
                    break;
                case 4:
                    [transformerFields addObjectsFromArray:[sectionDictionary objectForKey:@"fields"]];
                    break;
                case 5:
                    [ltcRegulatorFields addObjectsFromArray:[sectionDictionary objectForKey:@"fields"]];
                    break;
                case 6:
                    [breakersFields addObjectsFromArray:[sectionDictionary objectForKey:@"fields"]];
                    break;
            }
        }
        
        NSArray *fieldsArray = [[NSArray alloc]initWithObjects:generalFields, switchBoardFields, batteryChargerFields,
                                 circuitSwitcherFields, transformerFields, ltcRegulatorFields, breakersFields, nil];
        
        for(int i = 0; i < [sections count]; i++){
            NSArray *headerFieldsPair = [[NSArray alloc]initWithObjects:[sectionHeaders objectAtIndex:i], [fieldsArray objectAtIndex:i],nil];
            [containerArray addObject:headerFieldsPair];
            NSNumber *openState = [NSNumber numberWithBool:NO];
            [infoArray addObject:openState];
        }
    }
    return self;
}

@end
