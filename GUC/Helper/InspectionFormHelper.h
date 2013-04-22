//
//  InspectionFormHelper.h
//  GUC
//
//  Created by Michael Brodeur on 4/15/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InspectionFormHelper : NSObject

@property(nonatomic)NSMutableArray *containerArray;
@property(nonatomic)NSMutableArray *infoArray;

-(id)initWithSections:(NSArray*)sections;

@end
