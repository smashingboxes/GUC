//
//  SwitchBoard.h
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwitchBoard : NSObject

@property (nonatomic) NSString *maxAmpA;
@property (nonatomic) NSString *maxAmpB;
@property (nonatomic) NSString *maxAmpC;

@property (nonatomic) NSString *presentAmpA;
@property (nonatomic) NSString *presentAmpB;
@property (nonatomic) NSString *presentAmpC;

@property (nonatomic) NSString *minVoltsA;
@property (nonatomic) NSString *minVoltsB;
@property (nonatomic) NSString *minVoltsC;

@property (nonatomic) NSString *presentVoltsA;
@property (nonatomic) NSString *presentVoltsB;
@property (nonatomic) NSString *presentVoltsC;

@property (nonatomic) NSString *maxVoltsA;
@property (nonatomic) NSString *maxVoltsB;
@property (nonatomic) NSString *maxVoltsC;

@property (nonatomic) NSString *targetsAndAlarms;

@end
