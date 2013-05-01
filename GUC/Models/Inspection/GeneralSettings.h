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

@property (nonatomic) NSString *kwh;
@property (nonatomic) NSString *mwd;

@property (nonatomic) NSString *positiveKVARH;
@property (nonatomic) NSString *negativeKVARH;

@property (nonatomic) NSString *maxVARD;
@property (nonatomic) NSString *minVARD;

@property(nonatomic)NSString *rainGauge;
@property(nonatomic)NSString *detentionBasinComments;

@end
