//
//  GeneralSettings.h
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralSettings : NSObject

@property (nonatomic) NSString *stationName;
@property (nonatomic) NSString *dateTime;
@property (nonatomic) NSString *technician;

@property (nonatomic) NSInteger kwh;
@property (nonatomic) NSNumber *mwd;

@property (nonatomic) NSInteger positiveKVARH;
@property (nonatomic) NSInteger negativeKVARH;

@property (nonatomic) NSNumber *maxVARD;
@property (nonatomic) NSNumber *minVARD;

@end
