//
//  Station.h
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Station : NSObject

@property(nonatomic) NSString *stationIdentifier;
@property(nonatomic) NSString *stationName;
@property(nonatomic) NSInteger stationNumber;
@property(nonatomic) NSNumber *stationLatitude;
@property(nonatomic) NSNumber *stationLongitude;

@end
