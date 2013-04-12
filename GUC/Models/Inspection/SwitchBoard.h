//
//  SwitchBoard.h
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwitchBoard : NSObject

@property (nonatomic) NSInteger maxAmpA;
@property (nonatomic) NSInteger maxAmpB;
@property (nonatomic) NSInteger maxAmpC;

@property (nonatomic) NSInteger presentAmpA;
@property (nonatomic) NSInteger presentAmpB;
@property (nonatomic) NSInteger presentAmpC;

@property (nonatomic) NSNumber *minVoltsA;
@property (nonatomic) NSNumber *minVoltsB;
@property (nonatomic) NSNumber *minVoltsC;

@property (nonatomic) NSNumber *presentVoltsA;
@property (nonatomic) NSNumber *presentVoltsB;
@property (nonatomic) NSNumber *presentVoltsC;

@property (nonatomic) NSNumber *maxVoltsA;
@property (nonatomic) NSNumber *maxVoltsB;
@property (nonatomic) NSNumber *maxVoltsC;

@property (nonatomic) NSArray *targetsAlarms;

@end
